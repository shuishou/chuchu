//
//  QCFriendListVC.m
//  MyQOOCOO
//
//  Created by wzp on 15/10/13.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCFriendListVC.h"
#import "QCChatViewController.h"
#import "UserProfileManager.h"
#import "HFSearchFriendListVc.h"
#import "ChineseToPinyin.h"
#import "QCHFTheUserCell.h"
#import "PopViewController.h"
#import "QCHFDDMSRTVCell.h"
#import "QCUserViewController2.h"
@interface QCFriendListVC ()
{
    NSArray * suoYinArr;
    UILabel * titleLabel;
    //右键弹框选择
    PopViewController *popVCs;
    NSInteger isStatus;
    //批量用户 ID
    NSString * destUids;
    UIView * views;
}
@property (strong, nonatomic) NSMutableArray *sectionTitles;
/**分组字典*/
@property (strong, nonatomic) NSMutableDictionary * groupDictionary;
/**通讯录数组*/
@property (strong, nonatomic) NSMutableArray * addressBookArr;
/**添加组员 id*/
@property (strong, nonatomic) NSMutableArray * destUidsArr;
/**点击添加组员的下标*/
@property (strong, nonatomic) NSMutableArray * addGZSCArr;
/**添加趣友组员数组*/
@property (strong, nonatomic) NSMutableArray * groupUserArray;

// 点滴所选的成员ID
@property (nonatomic,strong) NSMutableArray * dianDiSelectArr;

@end

@implementation QCFriendListVC{
    kFriendStatus _friendStatus;

    //列表显示模式 选中 或者 正常显示模式
    kFriendGroupTpye _listType;
}

-(NSMutableArray *)dianDiSelectArr{
    if (!_dianDiSelectArr) {
        _dianDiSelectArr = [NSMutableArray array];
    }
    return _dianDiSelectArr;
}


-(instancetype)initWithFriendStatus:(kFriendStatus)friendStatus listType:(kFriendGroupTpye)listType{
    if (self = [super init]) {
        //
        _friendStatus = friendStatus;
        _listType = listType;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (popVCs.show) {
        [popVCs dismiss];
    }
    
//    点滴选完人后返回发通知
    if (self.isDD) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kDianDiSeleteUserUidNotification object:nil userInfo:@{@"uidArr":self.dianDiSelectArr}];
        CZLog(@"%@",self.dianDiSelectArr);
    }
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self.isAddGroupUsers boolValue]){
        self.navigationItem.title = @"联系人选择";
    }else{
        switch (_friendStatus) {
            case kFriendStatusEachOther:
                self.navigationItem.title = @"好友";
                break;
            case kFriendStatusAttentionMe:
                self.navigationItem.title = @"粉丝";
                break;
            case kFriendStatusMyAttention:
                self.navigationItem.title = @"偶像";
                break;
            case kFriendStatusPending:
                self.navigationItem.title = @"待定";
                break;
            case kFriendStatusStranger:
                self.navigationItem.title = @"黑名单";
                break;
        }
    }
    
    suoYinArr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    self.groupDictionary = [NSMutableDictionary dictionary];
    self.addressBookArr = [NSMutableArray array];
    self.destUidsArr = [NSMutableArray array];
    self.addGZSCArr = [NSMutableArray array];
    self.groupUserArray = [NSMutableArray array];
    isStatus = -1;
    
    if (_friendStatus == 4 || _friendStatus == 5 || [self.isAddGroupUsers boolValue]) {
        [self initNavBar];
    }
    else
    {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH(self.view), WIDTH(self.view)/10+16)];
        view.backgroundColor = kColorRGBA(237, 237, 237, 1);
        UILabel * searchLa = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.view.frame.size.width-16, WIDTH(self.view)/10)];
        searchLa.backgroundColor = [UIColor whiteColor];
        searchLa.textAlignment = NSTextAlignmentCenter;
        searchLa.textColor = [UIColor colorWithHexString:@"999999"];
        searchLa.text = @"搜索";
        searchLa.font = [UIFont systemFontOfSize:HEIGHT(searchLa)/2];
        searchLa.layer.masksToBounds = YES;
        searchLa.layer.cornerRadius = 5;
        searchLa.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchViewTapped:)];
        tap1.cancelsTouchesInView = NO;
        [searchLa addGestureRecognizer:tap1];
        [view addSubview:searchLa];
        
        [self.view addSubview:view];
//        [self.tableView setTableHeaderView:view];
    }
    
    //创建tableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    
    if (_friendStatus == 4 || _friendStatus == 5 || [self.isAddGroupUsers boolValue]) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
        }];
    }
    else
    {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.view).insets(UIEdgeInsetsMake(64+(WIDTH(self.view)/10+16), 0, 0, 0));
        }];
    }
    
    
    
    [self loadData];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
}

- (void)searchViewTapped:(UITapGestureRecognizer *)taps
{
    HFSearchFriendListVc * friendListVc = [[HFSearchFriendListVc alloc] init];
    UINavigationController * friendNa = [[UINavigationController alloc] initWithRootViewController:friendListVc];
    friendListVc.hidesBottomBarWhenPushed = YES;
    [self presentViewController:friendNa animated:YES completion:nil];
}

#pragma mark - 陌生人,待定的右侧按钮
- (void)initNavBar
{
    if (_friendStatus == kFriendStatusStranger) {
        UIBarButtonItem *doneBar =[[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(getRestore:)];
        self.navigationItem.rightBarButtonItem = doneBar;

    }else
    {
        if ([self.isAddGroupUsers boolValue]) {
            UIBarButtonItem * doneBar =[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(addDone:)];
            self.navigationItem.rightBarButtonItem = doneBar;
        }
        else
        {
            UIBarButtonItem * doneBar =[[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(getMore:)];
            self.navigationItem.rightBarButtonItem = doneBar;
        }
    }
    
}
#pragma mark - 批量恢复
- (void)getRestore:(UIBarButtonItem *)bar
{
    if (!popVCs) {
        popVCs = [[PopViewController alloc] initWithItems:@[@"批量恢复"]];
    }
    
    if (popVCs.show) {
        [popVCs dismiss];
    }else{
        [popVCs showInView:self.view selectedIndex:^(NSInteger selectedIndex) {
            self.tableView.frame = CGRectMake(0, 64, WIDTH(self.view), HEIGHT(self.view)-64);
            switch (selectedIndex) {
                case 0:{
                    isStatus = selectedIndex;
                    [self initTabelViewFootderView];
                    [self.tableView reloadData];
                }
                    break;
               
            }
            
        }];
    }
}
#pragma mark - 批量删除/关注按钮方法
- (void)getMore:(UIBarButtonItem *)bar
{
    if (!popVCs) {
        popVCs = [[PopViewController alloc] initWithItems:@[@"批量删除", @"批量关注"]];
    }
    
    if (popVCs.show) {
        [popVCs dismiss];
    }else{
        [popVCs showInView:self.view selectedIndex:^(NSInteger selectedIndex) {
            self.tableView.frame = CGRectMake(0, 64, WIDTH(self.view), HEIGHT(self.view)-64);
            switch (selectedIndex) {
                case 0:{
                    isStatus = selectedIndex;
                    [self initTabelViewFootderView];
                    [self.tableView reloadData];
                }
                    break;
                case 1:{
                    isStatus = selectedIndex;
                    [self initTabelViewFootderView];
                    [self.tableView reloadData];
                }
                    break;
                default:
                    break;
            }
            
        }];
    }
}

#pragma mark - 添加趣组成员的按钮方法
- (void)addDone:(UIBarButtonItem *)bar
{
    if (self.destUidsArr.count > 0) {
        //把数组转换成字符串
        [self.QCHFGroupUserDelegate sendGroupUserAvatar:self.groupUserArray];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [MBProgressHUD show:@"请选择联系人" icon:nil view:nil color:kColorRGBA(52,52,52,0.8)];
    }
}

#pragma -mark 批量关注/删除
- (void)initTabelViewFootderView
{
    views = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 44)];
    views.backgroundColor = [UIColor whiteColor];
    UIButton * leftBu = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBu.frame = CGRectMake(0, 0, (WIDTH(views)-1)/2, HEIGHT(views));
    leftBu.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftBu setTitleColor:kLoginbackgoundColor forState:UIControlStateNormal];
    if (isStatus == 0) {
        [leftBu setTitle:@"删除" forState:UIControlStateNormal];
    }
    else
    {
        [leftBu setTitle:@"关注" forState:UIControlStateNormal];
    }
    if (_friendStatus==kFriendStatusStranger) {
        [leftBu setTitle:@"恢复" forState:UIControlStateNormal];
    }
    [leftBu actionButton:^(UIButton *sender) {
        if (isStatus == 0) {
            
            [self deleteUsers:leftBu];
            
           
        }
        else
        {
            [self friendUsers:leftBu];
        }
    }];
    [views addSubview:leftBu];
    
    UIImageView * line1 = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(leftBu), 8, 1, HEIGHT(views)-16)];
    line1.backgroundColor = kLoginbackgoundColor;
    [views addSubview:line1];
    
    UIButton * rightBu = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBu.frame = CGRectMake(MaxX(line1), Y(leftBu), WIDTH(leftBu), HEIGHT(views));
    rightBu.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBu setTitleColor:kLoginbackgoundColor forState:UIControlStateNormal];
    [rightBu setTitle:@"取消" forState:UIControlStateNormal];
    [rightBu actionButton:^(UIButton *sender) {
        isStatus = -1;
        [views removeFromSuperview];
        self.tableView.frame = CGRectMake(0, 64, WIDTH(self.view), HEIGHT(self.view)-20);
        [self.tableView reloadData];
    }];
    [views addSubview:rightBu];
    
    UIImageView * line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT(views)-1, WIDTH(views), 1)];
    line2.backgroundColor = [UIColor colorWithHexString:@"E0E0E0"];
    [views addSubview:line2];
    [self.tableView setTableFooterView:views];
}

//批量删除
- (void)deleteUsers:(UIButton *)delBu
{
    if (self.destUidsArr.count > 0) {
        isStatus = -1;
        [views removeFromSuperview];
        self.tableView.frame = CGRectMake(0, 64, WIDTH(self.view), HEIGHT(self.view)-20);
        
        if (_friendStatus == 5) {
//            [self initRemoveFriendData];
            [self initRemoveblacklist];
        }
        else
        {
            [self initDeleteFriendData];
        }
    }
    else
    {
        [MBProgressHUD show:@"请选择联系人" icon:nil view:nil];
    }
}

#pragma -mark 批量删除陌生人
- (void)initRemoveFriendData
{
    //把数组转换成字符串
    destUids =[self.destUidsArr componentsJoinedByString:@","];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"destUids"] = destUids;
    
    [NetworkManager requestWithURL:REMOVEFRIEND parameter:dic success:^(id response) {
        [self.destUidsArr removeAllObjects];
        [self loadData];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
}
#pragma -mark 批量恢复黑名单
- (void)initRemoveblacklist
{
    //把数组转换成字符串
    destUids =[self.destUidsArr componentsJoinedByString:@","];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"destUids"] = destUids;
    
    [NetworkManager requestWithURL:USERINFO_restore parameter:dic success:^(id response) {
        [self.destUidsArr removeAllObjects];
        [self loadData];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
}
#pragma -mark 批量删除待定
- (void)initDeleteFriendData
{
    //把数组转换成字符串
    destUids =[self.destUidsArr componentsJoinedByString:@","];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"destUids"] = destUids;
    
    [NetworkManager requestWithURL:DELETEFRIEND parameter:dic success:^(id response) {
        [self.destUidsArr removeAllObjects];
        [self loadData];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
}

//批量关注
- (void)friendUsers:(UIButton *)friBu
{
    if (self.destUidsArr.count > 0) {
        isStatus = -1;
        [views removeFromSuperview];
        self.tableView.frame = CGRectMake(0, 64, WIDTH(self.view), HEIGHT(self.view)-20);
        [self initFriendAdd];
    }
    else
    {
        [MBProgressHUD show:@"请选择联系人" icon:nil view:nil];
    }
    
}

#pragma -mark 批量关注
- (void)initFriendAdd
{
    if (_friendStatus == 4 || _friendStatus == 5) {
        //把数组转换成字符串
        destUids =[self.destUidsArr componentsJoinedByString:@","];
    }
    
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"destUids"] = destUids;
    
    [NetworkManager requestWithURL:FRIEND_ADD parameter:dic success:^(id response) {
        if (_friendStatus == 4 || _friendStatus == 5) {
            [self.destUidsArr removeAllObjects];
        }
        [self loadData];
        [OMGToast showText:@"关注成功"];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
}

-(void)loadData{
     self.groupDictionary = [NSMutableDictionary dictionary];
//    [MBProgressHUD showMessage:nil background:NO];
    NSLog(@"_friendStatus====%ld",(long)_friendStatus);
    //@(_friendStatus)  @{@"type":@(1)}
    
    NSDictionary *parameterDict = nil;
    if ([self.isAddGroupUsers boolValue]){
        parameterDict = @{@"type":@(0)};
    }else{
        parameterDict = @{@"type":@(_friendStatus)};
    }
    [NetworkManager requestWithURL:FRIEND_GETFRIENDLIST parameter:parameterDict success:^(id response) {
        //
        CZLog(@"%@", response);
        NSMutableArray * Array = [QCFriendModel mj_objectArrayWithKeyValuesArray:response];
        if (Array.count > 0) {
#pragma -mark 添加趣组成员时要对数组进行快速筛选
            if ([self.isAddGroupUsers boolValue]) {
                NSMutableArray * arrs = [NSMutableArray array];
                if (self.groupUsersArr.count > 0) {
                    for(int j = 0; j < Array.count;j++) {
                        QCFriendModel * nModel = Array[j];
                        //判断对象是否存在
                        __block BOOL isObjectExist = NO;
                        [self.groupUsersArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if([obj isEqual:nModel.destUid]) {
                                isObjectExist = YES;
                                *stop = YES;
                            }
                        }];
                        
                        //如果对象不存在,添加它
                        if(!isObjectExist) {
                            [arrs addObject:nModel];
                        }
                    }
                    //筛选完毕的数组
                    self.tableView.data = [arrs mutableCopy];
                }
                else
                {
                    self.tableView.data = [Array mutableCopy];
                }
            }
            else
            {
                self.tableView.data = [Array mutableCopy];
            }
            //遍历分区名字
            for (NSString * groupName in suoYinArr) {
                
                NSMutableArray * groupArray = [[NSMutableArray alloc] initWithCapacity:10];
                
                for (QCFriendModel * model in self.tableView.data) {
                    //分区名(字典的 key)
                    NSString * nameStr;
                    //不同 model 的用户的名字拼音
                    NSString *firstLetter;
                    //关注我的人
                    if (_friendStatus ==  3) {
                        firstLetter = [ChineseToPinyin pinyinFromChineseString:model.userOfUid.nickname];
                    }
                    //其他
                    else
                    {
                        firstLetter = [ChineseToPinyin pinyinFromChineseString:model.user.nickname];
                    }
                    //名字不为空时
                    if (firstLetter.length > 0) {
                        //拼音字符串转字符数组
                        const char * mingziKey = [firstLetter cStringUsingEncoding:NSASCIIStringEncoding];
                        //取首个字符,判断字符范围
                        if (mingziKey[0] > 'A' && mingziKey[strlen(mingziKey)-1] < 'Z' ) {
                            nameStr = [NSString stringWithFormat:@"%c",mingziKey[0]];
                        }
                        else
                        {
                            nameStr = @"#";
                        }
                    }
                    //名字为空
                    else
                    {
                        nameStr = @"#";
                    }
                    
                    //model 对应的拼音的首个字符与分区名字是否相同
                    if ([nameStr isEqualToString:groupName]) {
                        [groupArray addObject:model];
                    }
                }
                //分区名为 key, 对应的数组为 value,
                [self.groupDictionary setObject:groupArray forKey:groupName];
            }
            
            //取出所有 key 转数组以此分区
            NSArray * arrays = [self.groupDictionary allKeys];
            
            //根据key值进行比较排序（这里不能用系统的，系统排序乱了）
            NSArray * sortedArray = [arrays sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1 compare:obj2 options:NSNumericSearch];
            }];
            
            self.addressBookArr = [NSMutableArray arrayWithArray:sortedArray];
            [self.addressBookArr removeObjectAtIndex:0];
            [self.addressBookArr addObject:suoYinArr[suoYinArr.count-1]];
            
            [MBProgressHUD hideHUD];
            [self.tableView reloadData];
        }
        else
        {
            [MBProgressHUD hideHUD];
            [self.tableView reloadData];
//            return ;
        }
        
//        if (_listType == kFriendGroupTpyeSelected) {
//            [self.tableView setEditing:YES animated:YES];
//        }
        
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        //
        NSLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}


#pragma -mark - 实现cell头像点击的代理
-(void)clickAvatar:(UIButton *)btn{
    QCFriendInfoVC *friendInfoVC = [[QCFriendInfoVC alloc]init];
    [self.navigationController pushViewController:friendInfoVC animated:YES];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark - datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.tableView.data.count>0) {
        return self.addressBookArr.count;
    }
    else
    {
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.tableView.data.count > 0) {
        return [self.groupDictionary[self.addressBookArr[section]] count];
    }
    else
    {
        return 0;
    }
}
#pragma mark - tableViewdelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (isStatus == 0 || isStatus == 1 || [self.isAddGroupUsers boolValue]|| self.isDD)
    {
        QCHFDDMSRTVCell * cells = [QCHFDDMSRTVCell QCHFDDMSRTVCell:self.tableView];
        if (self.tableView.data.count > 0) {
            //调用内容，给model赋值的方式
            NSString * key = self.addressBookArr[indexPath.section];
            NSArray * array = self.groupDictionary[key];
            QCFriendModel * model = array[indexPath.row];
            
            if (_friendStatus ==  3) {
                if (model.note.length>0) {
                   cells.niceNameLabel.text = model.note;
                }else{
                cells.niceNameLabel.text = model.userOfUid.nickname;
                }
                [cells.avatarUrlsImaged sd_setImageWithURL:[NSURL URLWithString:model.userOfUid.avatar] placeholderImage:[UIImage imageNamed:@"ios-template-120(1)"]];
                
            }
            else
            {
                if (model.note.length>0) {
                    cells.niceNameLabel.text = model.note;
                }else{

                cells.niceNameLabel.text = model.user.nickname;
                }
                [cells.avatarUrlsImaged sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] placeholderImage:[UIImage imageNamed:@"ios-template-120(1)"]];
            }

            
//            cells.niceNameLabel.text = model.user.nickname;
//            [cells.avatarUrlsImaged sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] placeholderImage:[UIImage imageNamed:@"ios-template-120(1)"]];
            
            if (model.marks.length > 0) {
                NSArray * markArr = [model.marks componentsSeparatedByString:@","];
                
                if (markArr.count > 2) {
                    cells.marksLa.text = markArr[markArr.count-1];
                    cells.marksLa2.text = markArr[markArr.count-2];
                    cells.marksLa3.text = markArr[markArr.count-3];
                }
                else if (markArr.count > 1)
                {
                    cells.marksLa.text = markArr[markArr.count-1];
                    cells.marksLa2.text = markArr[markArr.count-2];
                }
                else
                {
                    cells.marksLa.text = markArr[0];
                }
                
                if (cells.marksLa.text.length < 1) {
                    cells.marksV1.hidden = YES;
                }
                if (cells.marksLa2.text.length < 1) {
                    cells.marksV2.hidden = YES;
                }
                if (cells.marksLa3.text.length < 1) {
                    cells.marksV3.hidden = YES;
                }
            }
            else
            {
                cells.marksV1.hidden = YES;
                cells.marksV2.hidden = YES;
                cells.marksV3.hidden = YES;
            }
            
        }
        
        //防止重用问题
        for (NSIndexPath * indexPs in self.addGZSCArr) {
            if (indexPs == indexPath) {
                cells.selectButton.selected = YES;
            }
        }
        
        return cells;

    }
    else
    {
        QCHFTheUserCell * cell = [QCHFTheUserCell QCHFTheUserCell:self.tableView];
        cell.isFriendBu.hidden = YES;
        cell.searchLine.hidden = YES;
        if (self.tableView.data.count > 0) {
            //调用内容，给model赋值的方式
            NSString * key = self.addressBookArr[indexPath.section];
            NSArray * array = self.groupDictionary[key];
            QCFriendModel * model = array[indexPath.row];
            
            if (_friendStatus ==  3) {
                if (model.note.length>0) {
                    cell.nicknameLabel.text = model.note;
                }else{
                    
                    cell.nicknameLabel.text = model.userOfUid.nickname;
                }

                
                [cell.avatarUrlImage sd_setImageWithURL:[NSURL URLWithString:model.userOfUid.avatar] placeholderImage:[UIImage imageNamed:@"ios-template-120(1)"]];
            }
            else
            {
                if (model.note.length>0) {
                    cell.nicknameLabel.text = model.note;
                }else{

                cell.nicknameLabel.text = model.user.nickname;
                }
                [cell.avatarUrlImage sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] placeholderImage:[UIImage imageNamed:@"ios-template-120(1)"]];
            }
            if (model.marks.length > 0) {
                NSArray * markArr = [model.marks componentsSeparatedByString:@","];
                
                if (markArr.count > 2) {
                    cell.marksLabel1.text = markArr[markArr.count-1];
                    cell.marksLabel2.text = markArr[markArr.count-2];
                    cell.marksLabel3.text = markArr[markArr.count-3];
                }
                else if (markArr.count > 1)
                {
                    cell.marksLabel1.text = markArr[markArr.count-1];
                    cell.marksLabel2.text = markArr[markArr.count-2];
                }
                else
                {
                    cell.marksLabel1.text = markArr[0];
                }
                
                if (cell.marksLabel1.text.length < 1) {
                    cell.markView1.hidden = YES;
                }
                if (cell.marksLabel2.text.length < 1) {
                    cell.markView2.hidden = YES;
                }
                if (cell.marksLabel3.text.length < 1) {
                    cell.markView3.hidden = YES;
                }
            }
            else
            {
                cell.markView1.hidden = YES;
                cell.markView2.hidden = YES;
                cell.markView3.hidden = YES;
            }
            
        }
        
        
        return cell;

    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    switch (_friendStatus) {
//     
//        case kFriendStatusStranger:
//            self.navigationItem.title = @"黑名单";
//            break;
//    }
   
    
    
    if (self.isDD) {//点滴跳转的内容
        
        NSString * key = self.addressBookArr[indexPath.section];
        NSArray * array = self.groupDictionary[key];
        QCFriendModel * model = array[indexPath.row];
        
        if (_friendStatus==3) {//1、关注我的好友
            QCHFDDMSRTVCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
            //判断是否有相同点击的,有则取消
            if (self.dianDiSelectArr.count>0) {
                for (int i = 0; i < self.dianDiSelectArr.count; i++) {
                    NSString * uidStr = self.dianDiSelectArr[i];
                    if ([uidStr isEqualToString:model.userOfUid.uid]) {
                        cell.selectButton.selected = NO;
                        [self.dianDiSelectArr removeObjectAtIndex:i];
//                        CZLog(@"%@",model.userOfUid.uid);
                        return;
                    }
                }
            }
            cell.selectButton.selected = YES;
            [self.dianDiSelectArr addObject:model.userOfUid.uid];
//               CZLog(@"%@",self.dianDiSelectArr);
            
        }else{//2、相互关注的
        
        QCHFDDMSRTVCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        //判断是否有相同点击的,有则取消
        if (self.dianDiSelectArr.count>0) {
            for (int i = 0; i < self.dianDiSelectArr.count; i++) {
                NSString * uidStr = self.dianDiSelectArr[i];
                if ([uidStr isEqualToString:model.user.uid]) {
                    cell.selectButton.selected = NO;
                    [self.dianDiSelectArr removeObjectAtIndex:i];
//                    CZLog(@"%@",model.uid);
                    return;
                }
            }
        }
            cell.selectButton.selected = YES;
            [self.dianDiSelectArr addObject:model.user.uid];
//            CZLog(@"%@",self.dianDiSelectArr);
        }
        
        
    
    }
    else if (_listType != kFriendGroupTpyeSelected) {
        //调用内容，给model赋值的方式
        NSString * key = self.addressBookArr[indexPath.section];
        NSArray * array = self.groupDictionary[key];
        QCFriendModel * model = array[indexPath.row];
        
        if (_friendStatus == 3) {
            QCChatViewController *chatView = [[QCChatViewController alloc]initWithChatter:model.hid isGroup:NO];
            if (model.note.length>0) {
                chatView.title = [[UserProfileManager sharedInstance] getNickNameWithUsername:model.note];
            }else{

            chatView.title = [[UserProfileManager sharedInstance] getNickNameWithUsername:model.userOfUid.nickname];
            }
            [self.navigationController pushViewController:chatView animated:YES];
        }
        else
        {
            if (isStatus == 0 || isStatus == 1 || [self.isAddGroupUsers boolValue] ) {
                QCHFDDMSRTVCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
                //判断是否有相同点击的,有则取消
                for (int i = 0; i < self.addGZSCArr.count; i++) {
                    NSIndexPath * indexPs = self.addGZSCArr[i];
                    if (indexPs == indexPath) {
                        cell.selectButton.selected = NO;
                        [self.addGZSCArr removeObjectAtIndex:i];
                        [self.destUidsArr removeObjectAtIndex:i];
                        [self.groupUserArray removeObjectAtIndex:i];
                        return;
                    }
                }
                
                cell.selectButton.selected = YES;
                [self.destUidsArr addObject:model.destUid];
                [self.groupUserArray addObject:model];
                [self.addGZSCArr addObject:indexPath];
            }
            else
            {
                if (_friendStatus==kFriendStatusStranger||_friendStatus==kFriendStatusPending) {
                    
                    QCUserViewController2*vc=[QCUserViewController2 new];
                    QCFriendModel * model = array[indexPath.row];
                    vc.uid=[model.user.uid longLongValue];
                    [self.navigationController pushViewController:vc animated:YES];
                    return;
                }
                QCChatViewController *chatView = [[QCChatViewController alloc]initWithChatter:model.destHid isGroup:NO];
                if (model.note.length>0) {
                 chatView.title = [[UserProfileManager sharedInstance] getNickNameWithUsername:model.note];
                }else{
                chatView.title = [[UserProfileManager sharedInstance] getNickNameWithUsername:model.user.nickname];
                }
                [self.navigationController pushViewController:chatView animated:YES];
            }
            
        }
        
        
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.addressBookArr[section];
}

//返回索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    tableView.sectionIndexColor =[UIColor colorWithHexString:@"666666"];
    tableView.sectionIndexBackgroundColor = [UIColor whiteColor];
    return suoYinArr;
}

//响应点击索引时的委托方法
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    //弹出首字母提示
    [self showLetter:title];
    if (self.addressBookArr.count>1) {
        
    
    NSString * key = self.addressBookArr[index];
    
    NSArray * array = self.groupDictionary[key];
    //一旦区的数组为空不响应方法
    if (array.count > 0) {
        return index;
    }
    else
    {
        return -1;
    }
    }else{
         return -1;
    
    }
    
}

- (void)showLetter:(NSString *)title
{
    [MBProgressHUD showLetter:title color:kLoginbackgoundColor];
}

/*多选*/
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
//}



//进入可编辑状态
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (_friendStatus != 4 && _friendStatus != 5) {
        [super setEditing:editing animated:animated];
        [self.tableView setEditing:editing animated:animated];
    }
}

//指定编辑的单元
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_friendStatus != 4 && _friendStatus != 5)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//指定编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//设置按钮的字体
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * str;
    
    switch (_friendStatus) {
        case kFriendStatusEachOther:
        {
            str = @"取消关注";
        }
            
            break;
        case kFriendStatusAttentionMe:
        {
            str = @"关注";
        }
            
            break;
        case kFriendStatusMyAttention:
        {
            str = @"取消关注";
        }
            
            break;
        case kFriendStatusPending:
        {
            str = nil;
        }
            break;
        case kFriendStatusStranger:
        {
            str = nil;
        }
            break;
    }

    return str;
}

//完成编辑、提交（关注/取消关注）
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    //判断编辑样式是否相同
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (self.addressBookArr.count > 0) {
            //调用内容，给model赋值的方式
            NSString * key = self.addressBookArr[indexPath.section];
            NSArray * array = self.groupDictionary[key];
            QCFriendModel * model = array[indexPath.row];
            
            if (_friendStatus == 3) {
                destUids = model.uid;
                [self  initFriendAdd];
            }
            else
            {
                [self initRemoveFocusDataByDestUids:model.destUid];
            }
            
        }

    }
}

#pragma -mark 取消关注好友
- (void)initRemoveFocusDataByDestUids:(NSString *)uids
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"destUids"] = uids;
    
    [NetworkManager requestWithURL:FRIEND_REMOVEFOCUS parameter:dic success:^(id response) {
        CZLog(@"%@", response);
        
        [self loadData];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
}

@end
