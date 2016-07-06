//
//  QCHFChatGroupDetailVC.m
//  MyQOOCOO
//
//  Created by Wind on 15/12/16.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCHFChatGroupDetailVC.h"
#import "MyQRViewController.h"
#import "EaseMobHeaders.h"
#import "GroupSettingViewController.h"

#import "EMGroup.h"
#import "QCGroupModel.h"
#import "QCHFUserModel.h"
#import "QCFriendListVC.h"
#import "QCHFGroupCallVC.h"
#import "QCUserViewController2.h"

@interface QCHFChatGroupDetailVC ()<UITableViewDataSource, UITableViewDelegate, QCHFGroupUserDelegate, UITextViewDelegate, IChatManagerDelegate>
{
    UITableView * tableViews;
    /**是否进入删除状态*/
    BOOL isDelete;
    /**详情每个 cell*/
    UIView * groupTitleView;
    UILabel * label1;
    /**处分那几个 cell*/
    NSInteger indexS;
    /**退出并删除*/
    UIView * delGroupView;
    /**新增组员的 id*/
    NSString * HFDestUids;
    /**登陆的 uid*/
    NSString * userUids;
    /**环信创建者的 uid*/
    NSString * creatUids;
    /**是否屏蔽信息*/
    BOOL isNotMessage;
    /**屏蔽开关*/
    UISwitch *_blockSwitch;
    BOOL _isOwner;
    
    kFriendGroupTpye _type;
    UIView * groupNameV;
    UITextView * textViews;
    UIView * titleView;
    
    NSString * groupNames;
    
    int joinFlag;
}
- (void)unregisterNotifications;
- (void)registerNotifications;
/**群组信息*/
@property (strong, nonatomic) QCGroupModel * HFGroupDataModel;
/**组员数组*/
@property (strong, nonatomic) NSMutableArray * addGroupUserArr;
/**新添加的组员*/
@property (strong, nonatomic) NSMutableArray * newsGroupUserArr;
/**组员 ID*/
@property (strong, nonatomic) NSMutableArray * HFDestUidsArray;

@property (nonatomic) GroupOccupantTypes occupantType;
@property (strong, nonatomic) EMGroup *chatGroup;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) NSUserDefaults * blockMessage;
@property (strong, nonatomic) NSDictionary * blockDic;
@property (strong, nonatomic) NSMutableArray * blockArray;
@property (strong, nonatomic) LoginSession *session;
@end

@implementation QCHFChatGroupDetailVC

- (void)registerNotifications {
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unregisterNotifications {
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc {
    [self unregisterNotifications];
}

-(instancetype)initWithType:(kFriendGroupTpye)type{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (instancetype)initWithGroup:(EMGroup *)chatGroup
{
    self = [super init];
    if (self) {
        // Custom initialization
        _chatGroup = chatGroup;
        _dataSource = [NSMutableArray array];
        _occupantType = GroupOccupantTypeMembers;
        [self registerNotifications];
    }
    return self;
}

- (instancetype)initWithGroupId:(NSString *)chatGroupId
{
    EMGroup *chatGroup = nil;
    NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
    for (EMGroup *group in groupArray) {
        if ([group.groupId isEqualToString:chatGroupId]) {
            chatGroup = group;
            break;
        }
    }
    
    if (chatGroup == nil) {
        chatGroup = [EMGroup groupWithId:chatGroupId];
    }
    
    self = [self initWithGroup:chatGroup];
    if (self) {
        //
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        _isOwner = [chatGroup.owner isEqualToString:loginUsername];
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _session = [[ApplicationContext sharedInstance] getLoginSession];
    userUids = [NSString stringWithFormat:@"%ld", _session.user.uid];
    _blockMessage = [NSUserDefaults standardUserDefaults];
    _blockDic = [NSDictionary new];
    
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"F1F1F1"];
    self.addGroupUserArr = [NSMutableArray array];
    self.HFDestUidsArray = [NSMutableArray array];
    isDelete = NO;
    isNotMessage = NO;
    
    [self initChatGroupDetail];
    [self initTableView];
    [self initGroupName];
    groupNameV.hidden = YES;
    
    //监听键盘弹出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowNotificationded:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardRemoveed:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyBoardWillShowNotificationded:(NSNotification *)not
{
    //获取键盘高度
    NSDictionary *dic = not.userInfo;
    //获取坐标
    CGRect rc = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //键盘高度
    CGFloat f = rc.size.height;
    
        //调整输入框的位置
    [UIView animateWithDuration:0.5 animations:^{
            titleView.frame = CGRectMake(X(titleView), HEIGHT(groupNameV)-f-HEIGHT(titleView), WIDTH(titleView), HEIGHT(titleView));
        }];
}

//键盘消失的方法
-(void)keyBoardRemoveed:(NSNotification *)not
{
    //调整输入框的位置
    [UIView animateWithDuration:0.5 animations:^{
        titleView.frame = CGRectMake(30, (HEIGHT(groupNameV)-HEIGHT(groupNameV)/3)/2, WIDTH(groupNameV)-60, HEIGHT(groupNameV)/3);
    }];
}

- (void)initTableView
{
    tableViews = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view)) style:UITableViewStylePlain];
    tableViews.delegate = self;
    tableViews.dataSource = self;
    tableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViews.backgroundColor = [UIColor colorWithHexString:@"F1F1F1"];
    
    [self.view addSubview:tableViews];
}

#pragma -mark 通过环信id获取群详情
- (void)initChatGroupDetail
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"hids"] = self.hids;
    
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:GETGROUPSBYHIDS parameter:dic success:^(id response) {
        
        NSMutableArray * array = [QCGroupModel mj_objectArrayWithKeyValuesArray:response];
        
        if (array.count > 0) {
            NSArray * arr = response;
            NSDictionary * dic = arr[0];
            self.HFGroupDataModel = array[0];
            self.HFGroupDataModel.Id = dic[@"id"];
            self.addGroupUserArr = [QCHFUserModel mj_objectArrayWithKeyValuesArray:self.HFGroupDataModel.members];
            
            creatUids = self.HFGroupDataModel.membership[@"uid"];
            for (QCHFUserModel * model in self.addGroupUserArr) {
                [self.HFDestUidsArray addObject:model.uid];
            }
            
            [self initHeaderView];
            [MBProgressHUD hideHUD];
            [tableViews reloadData];
        }
        else
        {
            [MBProgressHUD hideHUD];
            [tableViews reloadData];
            return ;
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}


#pragma -tableViewHeaderView
- (void)initHeaderView
{
    int HFHeight;
    if(self.addGroupUserArr.count == 0)
    {
        HFHeight = 1;
    }
    else
    {
        if ([creatUids isEqualToString:userUids]) {
            if (((int)self.addGroupUserArr.count + 1)%6 == 0) {
                HFHeight = (int)self.addGroupUserArr.count/6+2;
            }
            else
            {
                HFHeight = (int)self.addGroupUserArr.count/6+1;
            }
        }
        else
        {
            if ((int)self.addGroupUserArr.count%6 == 0) {
                HFHeight = (int)self.addGroupUserArr.count/6;
            }
            else
            {
                HFHeight = (int)self.addGroupUserArr.count/6+1;
            }
            
        }
        
    }
    
    UIView * userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), (WIDTH(self.view)/6-6)*HFHeight+6)];
    userView.backgroundColor = [UIColor colorWithHexString:@"F1F1F1"];
    
    if (isDelete) {
        for (int i = 1; i < self.addGroupUserArr.count + 1; i++) {
            UIImageView * userImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(userView)/6*((i-1)%6)+6, (HEIGHT(userView)-6)/HFHeight*((i-1)/6)+6, WIDTH(userView)/6-12, WIDTH(userView)/6-12)];
            userImage.layer.masksToBounds = YES;
            userImage.layer.cornerRadius = HEIGHT(userImage)/2;
            QCHFUserModel * model = self.addGroupUserArr[i-1];
            [userImage sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:[UIImage imageNamed:@"ios-template-120(1)"]];

            userImage.userInteractionEnabled = YES;
            [userView addSubview:userImage];
            
            UIImageView * deImage = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(userImage)-WIDTH(userImage)/3, Y(userImage)-WIDTH(userImage)/8, WIDTH(userImage)/2, WIDTH(userImage)/2)];
            [deImage setImage:[UIImage imageNamed:@"Diandi_delete3"]];
            [userView addSubview:deImage];
            
#pragma -mark 轻点删除/取消删除
            UITapGestureRecognizer * deleteTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteTapS:)];
            [userImage addGestureRecognizer:deleteTap];
            
        }
    }
    else
    {
        for (int i = 1; i < self.addGroupUserArr.count + 1; i++) {
            UIImageView * userImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(userView)/6*((i-1)%6)+6, (HEIGHT(userView)-6)/HFHeight*((i-1)/6)+6, WIDTH(userView)/6-12, WIDTH(userView)/6-12)];
            userImage.layer.masksToBounds = YES;
            userImage.layer.cornerRadius = HEIGHT(userImage)/2;
            userImage.userInteractionEnabled = YES;
            
            QCHFUserModel * model = self.addGroupUserArr[i-1];
            [userImage sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:[UIImage imageNamed:@"ios-template-120(1)"]];
            
#pragma -mark 轻点跳个人中心
            userImage.tag = 100+ i;
            UITapGestureRecognizer * userTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTapS:)];
            [userImage addGestureRecognizer:userTap];
            [userView addSubview:userImage];
        }
    }
    
    
    
    if ([creatUids isEqualToString:userUids]) {
        
        //添加组员按钮
        UIButton * addUserBu =[UIButton buttonWithType:UIButtonTypeCustom];
        addUserBu.frame = CGRectMake(WIDTH(userView)/6*(((self.addGroupUserArr.count+1)-1)%6)+6, (HEIGHT(userView)-6)/HFHeight*(((self.addGroupUserArr.count+1)-1)/6)+6, WIDTH(userView)/6-12, WIDTH(userView)/6-12);
        [addUserBu setImage:[UIImage imageNamed:@"LJadds"] forState:UIControlStateNormal];
        [addUserBu actionButton:^(UIButton *sender) {
            [self addGroupUser:addUserBu];
        }];
        [userView addSubview:addUserBu];
        
        //删除组员按钮
        UIButton * delUserBu =[UIButton buttonWithType:UIButtonTypeCustom];
        delUserBu.frame = CGRectMake(WIDTH(userView)/6*(((self.addGroupUserArr.count+2)-1)%6)+6, (HEIGHT(userView)-6)/HFHeight*(((self.addGroupUserArr.count+2)-1)/6)+6, WIDTH(userView)/6-12, WIDTH(userView)/6-12);
        [delUserBu setImage:[UIImage imageNamed:@"Reduction"] forState:UIControlStateNormal];
        [delUserBu actionButton:^(UIButton *sender) {
            [self delGroupUser:delUserBu];
        }];
        [userView addSubview:delUserBu];
    }
    
    [tableViews setTableHeaderView:userView];
}

-(void)userTapS:(UITapGestureRecognizer *)gesture{
    QCHFUserModel *model = self.addGroupUserArr[gesture.view.tag - 100 - 1];
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    if (sessions.user.uid == [model.uid integerValue]) {
        self.tabBarController.selectedIndex = 3;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HFUserPushGroupList" object:
         @"3"];
    }else{
        QCUserViewController2 *vc=[[QCUserViewController2 alloc]init];
        vc.uid = [model.uid integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 跳转我关注的好友页,添加组员
- (void)addGroupUser:(UIButton *)bu
{
        QCFriendListVC * friendList = [[QCFriendListVC alloc] initWithFriendStatus:2 listType:_type];
        friendList.isAddGroupUsers = @1;
        friendList.QCHFGroupUserDelegate = self;
        if (self.HFDestUidsArray.count > 0) {
            friendList.groupUsersArr = self.HFDestUidsArray;
        }
        [self.navigationController pushViewController:friendList animated:YES];
}

#pragma -mark 代理传值,把选中添加的联系传过来
- (void)sendGroupUserAvatar:(NSMutableArray *)usersDataArr
{
    isDelete = NO;
    for (QCFriendModel * model in usersDataArr) {
        [self.HFDestUidsArray addObject:model.destUid];
        NSDictionary * dic = [model.user mj_keyValues];
        
        QCHFUserModel * models = [QCHFUserModel mj_objectWithKeyValues:dic];
        models.avatarUrl = dic[@"avatar"];
        
        [self.addGroupUserArr addObject:models];
    }
    
    //把数组转换成字符串
    HFDestUids =[self.HFDestUidsArray componentsJoinedByString:@","];
    [self initAddGroupUser:HFDestUids];
}

#pragma -mark 添加群组成员
- (void)initAddGroupUser:(NSString *)destUids
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"groupId"] = self.HFGroupDataModel.Id;
    dic[@"destUids"] = destUids;
    
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:GROUP_ADDMEMBER parameter:dic success:^(id response) {
        
        [MBProgressHUD hideHUD];
        [self initHeaderView];
        [tableViews reloadData];
        if (joinFlag==1)
        {
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"加入成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];

        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}

#pragma -mark 轻点删除/取消删除
- (void)delGroupUser:(UIButton *)bu
{
    if (isDelete) {
        isDelete = NO;
        [self initHeaderView];
    }
    else
    {
        isDelete = YES;
        [self initHeaderView];
    }
    
    [tableViews reloadData];
}

- (void)deleteTapS:(UITapGestureRecognizer *)tap
{
    QCHFUserModel * model = self.addGroupUserArr[tap.view.tag];
    [self initDeleteUser:[NSString stringWithFormat:@"%@", self.HFGroupDataModel.Id] destUids:model.uid index:tap.view.tag];
}

- (void)initDeleteUser:(NSString *)groupId destUids:(NSString *)destUids index:(NSInteger)index
{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"groupId"] = groupId;
    dic[@"destUids"] = destUids;
    [self.addGroupUserArr removeObjectAtIndex:index];
    [self.HFDestUidsArray removeObjectAtIndex:index];
    
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:GROUP_REMOVEMEMBER parameter:dic success:^(id response) {
        
        [MBProgressHUD hideHUD];
        [self initHeaderView];
        [tableViews reloadData];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}

#pragma -mark 编辑群组名字
- (void)initUpDate:(NSString *)name
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"groupId"] = self.HFGroupDataModel.Id;
    dic[@"name"] = name;
    
    [NetworkManager requestWithURL:GROUP_UPDATE parameter:dic success:^(id response) {
        
        groupNameV.hidden = YES;
        [self initChatGroupDetail];
        [OMGToast showText:@"修改成功"];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        
    }];
}

#pragma -mark tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        indexS = 0;
        [self initTitleView];
        [cell.contentView addSubview:groupTitleView];
        return cell;
    }
    
    if(indexPath.row == 4)
    {
        [self initDeleteGroup];
        [cell.contentView addSubview:delGroupView];
        return cell;
    }
    
    if (!_isHFScan) {
        if (indexPath.row == 1)
        {
            if ([creatUids isEqualToString:userUids]) {
                indexS = 1;
                [self initTitleView];
                [cell.contentView addSubview:groupTitleView];
            }
            return cell;
        }
        else if (indexPath.row == 2)
        {
            indexS = 2;
            [self initTitleView];
            [cell.contentView addSubview:groupTitleView];
            return cell;
        }
        else
        {
            indexS = 3;
            [self initTitleView];
            [cell.contentView addSubview:groupTitleView];
            return cell;
        }
    }
    else
    {
        return cell;
    }
    
}

#pragma -mark 退出/删除群组按钮
- (void)initDeleteGroup
{
    if (self.HFGroupDataModel) {
        delGroupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view)/5)];
        delGroupView.backgroundColor = [UIColor colorWithHexString:@"F1F1F1"];
        UIButton * bu = [UIButton buttonWithType:UIButtonTypeCustom];
        bu.frame = CGRectMake(60, 15, WIDTH(delGroupView)-120, HEIGHT(delGroupView)-30);
        bu.backgroundColor = [UIColor colorWithHexString:@"E64545"];
        
        
        int flag=0;
        
        for (QCHFUserModel * model in self.addGroupUserArr) {
            NSLog(@"--modeluid==%@===%@",model.uid,userUids);
            if ([model.uid isEqualToString:userUids])
            {
                flag=1;
              
            }
        }
        if (flag==1)
        {
            
            if ([creatUids isEqualToString:userUids]) {
                [bu setTitle:@"删除并退出" forState:UIControlStateNormal];
                [bu actionButton:^(UIButton *sender) {
                    [self dissolveAction];
                }];
            }
            else
            {
                [bu setTitle:@"退出" forState:UIControlStateNormal];
                [bu actionButton:^(UIButton *sender) {
                    [self exitAction];
                }];
            }
        }else
        {
              [bu setTitle:@"加入" forState:UIControlStateNormal];
            [bu actionButton:^(UIButton *sender) {
                joinFlag=1;
                [self initAddGroupUser:userUids];
            }];
        }

        
        
        bu.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(bu)*2/5];
        bu.layer.masksToBounds = YES;
        bu.layer.cornerRadius = HEIGHT(bu)/2;
//        [bu actionButton:^(UIButton *sender) {
//            if ([creatUids isEqualToString:userUids]) {
//                [self dissolveAction];
//            }
//            else
//            {
//                [self exitAction];
//            }
//        }];
        [delGroupView addSubview:bu];
    }
    
}

- (void)initTitleView
{
    groupTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view)/8)];
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, ((HEIGHT(groupTitleView)-12)/2)*6, HEIGHT(groupTitleView)-12)];
    label1.font = [UIFont systemFontOfSize:HEIGHT(label1)/2];
    switch (indexS) {
        case 0:
            label1.text = @"群聊名字";
            [self initTitle];
            break;
        case 1:
            label1.text = @"群二维码";
            [self initQR_code];
            break;
        case 2:
        {
            if (creatUids) {
                label1.text = @"新消息通知";
                [self initNot];
            }
        }
            break;
        case 3:
            label1.text = @"清空聊天记录";
            [self initRemoveMessage];
            break;
        default:
            break;
    }
    label1.textColor = [UIColor colorWithHexString:@"333333"];
    [groupTitleView addSubview:label1];
    
}

//群聊名字
- (void)initTitle
{
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(groupTitleView)-WIDTH(groupTitleView)/2-15, Y(label1), WIDTH(groupTitleView)/2, HEIGHT(label1))];
    label2.textAlignment = NSTextAlignmentRight;
    label2.font = label1.font;
    label2.textColor = [UIColor colorWithHexString:@"333333"];
    label2.text = self.HFGroupDataModel.name;
    [groupTitleView addSubview:label2];
    
    UIImageView * line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT(groupTitleView)-0.5, WIDTH(groupTitleView), 0.5)];
    line1.backgroundColor = [UIColor colorWithHexString:@"E0E0E0"];
    [groupTitleView addSubview:line1];
}

//群二维码
- (void)initQR_code
{
    UIImageView * images = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(groupTitleView)-WIDTH(groupTitleView)/20-15, Y(label1)+HEIGHT(label1)/4, WIDTH(groupTitleView)/20, HEIGHT(label1)/2)];
    images.image = [UIImage imageNamed:@"Small_Arrow"];
    [groupTitleView addSubview:images];
    
    UIImageView * QRCode = [[UIImageView alloc] initWithFrame:CGRectMake(X(images)-40, Y(label1), HEIGHT(label1), HEIGHT(label1))];
    QRCode.image = [UIImage imageNamed:@"形状-5"];
    [groupTitleView addSubview:QRCode];
    
    UIImageView * line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT(groupTitleView)-0.5, WIDTH(groupTitleView), 0.5)];
    line1.backgroundColor = [UIColor colorWithHexString:@"E0E0E0"];
    [groupTitleView addSubview:line1];
}

//新消息通知
- (void)initNot
{
    if (!_blockSwitch) {
        _blockSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(WIDTH(groupTitleView)-WIDTH(groupTitleView)/7-15, Y(label1), WIDTH(groupTitleView)/7, HEIGHT(label1))];
    }
    
    if ([creatUids isEqualToString:userUids]) {
        
        [_blockSwitch setOn:YES animated:YES];
    }
    else
    {
        NSString * values = [_blockMessage objectForKey:_chatGroup.groupId];
        if (values) {
            [_blockSwitch setOn:NO animated:YES];
        }
        else
        {
            [_blockSwitch setOn:YES animated:YES];
        }
    }
    [_blockSwitch addTarget:self action:@selector(blockSwitchChangeds:) forControlEvents:UIControlEventValueChanged];
    
    [groupTitleView addSubview:_blockSwitch];
}

//清空聊天记录
- (void)initRemoveMessage
{
    UIImageView * line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(groupTitleView)-0.5, 0.5)];
    line1.backgroundColor = [UIColor colorWithHexString:@"999999"];
    [groupTitleView addSubview:line1];
    
    
    UIImageView * line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT(groupTitleView)-0.5, WIDTH(groupTitleView), 0.5)];
    line2.backgroundColor = [UIColor colorWithHexString:@"999999"];
    [groupTitleView addSubview:line2];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        return HEIGHT(delGroupView);
    }
    else
    {
        if (indexPath.row == 0) {
            return HEIGHT(groupTitleView);
        }
        
        if (indexPath.row == 4) {
            return HEIGHT(groupTitleView);;
        }
        
        if (!_isHFScan) {
            if (indexPath.row == 1) {
                if ([creatUids isEqualToString:userUids]) {
                    return HEIGHT(groupTitleView);
                }
                else
                {
                    return 0;
                }
            }
            else
            {
                return HEIGHT(groupTitleView);
            }
        }
        else
        {
            return 0;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            if ([creatUids isEqualToString:userUids]) {
                groupNameV.hidden = NO;
            }
        }
            break;
        case 1:
        {
            MyQRViewController * Vc = [[MyQRViewController alloc] init];
            
#pragma -mark 字典转成字符串
            NSMutableDictionary * dic = [NSMutableDictionary new];
            dic[@"type"] = self.HFGroupDataModel.type;
            dic[@"id"] = self.HFGroupDataModel.Id;
            NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            Vc.QRString = str;
            Vc.title = @"群名片";
            [self.navigationController pushViewController:Vc animated:YES];
        }
            break;
        case 3:
        {
            [self clearAction];
        }
            break;
        default:
            break;
    }
}

#pragma -mark 修改群名
- (void)initGroupName
{
    groupNameV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view))];
    groupNameV.backgroundColor = kColorRGBA(52,52,52,0.3);
    groupNameV.userInteractionEnabled = YES;
    [self.navigationController.view addSubview:groupNameV];
    
    titleView = [[UIView alloc] initWithFrame:CGRectMake(30, (HEIGHT(groupNameV)-HEIGHT(groupNameV)/3)/2, WIDTH(groupNameV)-60, HEIGHT(groupNameV)/3)];
    titleView.backgroundColor = [UIColor whiteColor];
    [groupNameV addSubview:titleView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH(titleView), HEIGHT(titleView)/5)];
    label.text = @"修改群名称";
    label.textColor = [UIColor colorWithHexString:@"333333"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:HEIGHT(label)/2];
    [titleView addSubview:label];
    
    textViews = [[UITextView alloc] initWithFrame:CGRectMake(25, HEIGHT(titleView)/2-HEIGHT(titleView)/8, WIDTH(titleView)-50, HEIGHT(titleView)/4)];
//    textView.backgroundColor = [UIColor greenColor];
    textViews.font = [UIFont systemFontOfSize:HEIGHT(textViews)/3];
    textViews.textColor = [UIColor colorWithHexString:@"333333"];
    textViews.delegate = self;
    //TextView占位符
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    UILabel * placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, WIDTH(textViews)-10, HEIGHT(textViews)/3)];
    placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    placeHolderLabel.font = [UIFont boldSystemFontOfSize:HEIGHT(placeHolderLabel)];
    placeHolderLabel.textColor = [UIColor colorWithHexString:@"999999"];
    placeHolderLabel.backgroundColor = [UIColor whiteColor];
    placeHolderLabel.alpha = 0;
    placeHolderLabel.tag = 999;
    placeHolderLabel.text = @"(请输入名称)";
    [textViews addSubview:placeHolderLabel];
    if ([[textViews text] length] == 0) {
        [[textViews viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[textViews viewWithTag:999] setAlpha:0];
    }
    [titleView addSubview:textViews];
    
    UIButton * cancelBu = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBu.frame = CGRectMake(0, HEIGHT(titleView)-HEIGHT(titleView)/5, WIDTH(titleView)/2, HEIGHT(titleView)/5);
    [cancelBu setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBu setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [cancelBu actionButton:^(UIButton *sender) {
        
        [groupNameV endEditing:YES];
        groupNames = nil;
        groupNameV.hidden = YES;
        
    }];
    [titleView addSubview:cancelBu];
    
    UIButton * doneBu = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBu.frame = CGRectMake(MaxX(cancelBu), Y(cancelBu), WIDTH(cancelBu), HEIGHT(cancelBu));
    [doneBu setTitle:@"确定" forState:UIControlStateNormal];
    [doneBu setTitleColor:[UIColor colorWithHexString:@"#2ab6f4"] forState:UIControlStateNormal];
    [doneBu actionButton:^(UIButton *sender) {
        
        [groupNameV endEditing:YES];
        [self initUpDate:groupNames];
        
    }];
    [titleView addSubview:doneBu];
    
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT(titleView)-HEIGHT(cancelBu)-0.5, WIDTH(titleView), 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"E0E0E0"];
    [titleView addSubview:line];
    
    
#pragma -mark 轻点消失
    UITapGestureRecognizer * dismissTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissTap:)];
    [groupNameV addGestureRecognizer:dismissTap];
}

//输入框要编辑的时候
- (void)textChanged:(NSNotification *)notification
{
    if ([[textViews text] length] == 0) {
        [[textViews viewWithTag:999] setAlpha:1];
    }
    else {
        [[textViews viewWithTag:999] setAlpha:0];
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length > 0) {
        
        groupNames = textView.text;
    }
    else
    {
        [OMGToast showText:@"名称不能为空!"];
    }
    
}

- (void)dismissTap:(UITapGestureRecognizer *)tap
{
//    groupNameV.hidden = YES;
    [groupNameV endEditing:YES];
}

#pragma -mark 屏蔽群信息
- (void)blockSwitchChangeds:(UISwitch *)switchBlock
{
//    [[EaseMob sharedInstance].chatManager asyncIgnoreGroupPushNotification:_chatGroup.groupId isIgnore:switchBlock.isOn completion:^(NSArray *ignoreGroupsList, EMError *error) {
//        if (!error) {
//            [OMGToast showText:@"屏蔽成功"];
//        }
//        else{
//            [OMGToast showText:@"屏蔽失败"];
//        }
//    } onQueue:nil];
    CZLog(@"%d",_blockSwitch.isOn);
    if (_blockSwitch.isOn) {
            [[EaseMob sharedInstance].chatManager asyncUnblockGroup:_chatGroup.groupId completion:^(EMGroup *group, EMError *error) {
                
                if ([creatUids isEqualToString:userUids]) {
                    [OMGToast showText:@"当前用户为本群创建者,无法屏蔽信息"];
                }
                else
                {
                    [OMGToast showText:@"屏蔽已关"];
                    [_blockMessage removeObjectForKey:_chatGroup.groupId];
                }
                
            } onQueue:nil];
        }
        else{
            
            [[EaseMob sharedInstance].chatManager asyncBlockGroup:_chatGroup.groupId completion:^(EMGroup *group, EMError *error) {
                if ([creatUids isEqualToString:userUids])
                {
                   [OMGToast showText:@"当前用户为本群创建者,无法屏蔽信息"];
                }
                else
                {
                   [OMGToast showText:@"屏蔽已开"];
                    [_blockMessage setObject:_chatGroup.groupId forKey:_chatGroup.groupId];
                }
                
            } onQueue:nil];
        }
    
}


#pragma -mark 清空聊天记录
- (void)clearAction
{
//    __weak typeof(self) weakSelf = self;
//    [EMAlertView showAlertWithTitle:NSLocalizedString(@"prompt", @"Prompt")
//                            message:NSLocalizedString(@"sureToDelete", @"please make sure to delete")
//                    completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
//                        if (buttonIndex == 1) {
//                            
//                        }
//                    } cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel")
//                  otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveAllMessages" object:self.HFGroupDataModel.hid];
}

#pragma -mark 解散群组
- (void)dissolveAction
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:nil background:NO];
    [[EaseMob sharedInstance].chatManager asyncDestroyGroup:_chatGroup.groupId completion:^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
        if (error) {
            [MBProgressHUD hideHUD];
            [weakSelf showHint:NSLocalizedString(@"解散失败", @"dissolution of group failure")];
            
        }
        else{
            [MBProgressHUD hideHUD];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitGroup" object:nil];
            [self initdismiss];
        }
    } onQueue:nil];
}

- (void)initdismiss
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"groupId"] = self.HFGroupDataModel.Id;
    
    [NetworkManager requestWithURL:GROUP_DELETE parameter:dic success:^(id response) {
    
        if (self.navigationController.viewControllers.count > 3) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        else
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        }
        [OMGToast showText:@"解散成功"];
        
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}

#pragma -mark 退出群组
- (void)exitAction
{
    [MBProgressHUD showMessage:nil background:NO];
    [[EaseMob sharedInstance].chatManager asyncLeaveGroup:_chatGroup.groupId completion:^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
        if (error) {
            [OMGToast showText:@"退出失败"];
            [MBProgressHUD hideHUD];
        }
        else{
            [MBProgressHUD hideHUD];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitGroup" object:nil];
            [self initExitAction];
        }
    } onQueue:nil];
    
}

- (void)initExitAction
{
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"destUids"] = [NSString stringWithFormat:@"%ld", _session.user.uid];
    dic[@"groupId"] = self.HFGroupDataModel.Id;
    
    [NetworkManager requestWithURL:GROUP_REMOVEMEMBER parameter:dic success:^(id response) {
        
        if (self.navigationController.viewControllers.count > 3) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        else
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        }
        
        [OMGToast showText:@"退出成功"];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [OMGToast showText:@"退出失败"];
        [MBProgressHUD hideHUD];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
