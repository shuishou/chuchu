//
//  AddInterestGropVC.m
//  MyQOOCOO
//
//  Created by Wind on 15/12/14.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "AddInterestGropVC.h"
#import "QCFriendListVC.h"
#import "QCFriendModel.h"
#import "QCGroupModel.h"
@interface AddInterestGropVC ()<UITableViewDataSource, UITableViewDelegate, QCHFGroupUserDelegate>
{
    UITableView * tabelViews;
    /**组员所有 id 的结合*/
    NSString * HFDestUids;
    /**组 id*/
    NSString * HFClassIds;
    kFriendGroupTpye _type;
    /**是否进入删除状态*/
    BOOL isDelete;
    /**名字输入框*/
    UITextField * titleField;
    
    UIView * interestGroupTitleView;
    UIView * titleView;
    
    UIView * creatView;
    UIView * deleteView;
}
/**组员头像数组*/
@property (strong, nonatomic) NSMutableArray * addGroupUserArr;
/**组员 ID*/
@property (strong, nonatomic) NSMutableArray * HFDestUidsArray;
@end

@implementation AddInterestGropVC

-(instancetype)initWithType:(kFriendGroupTpye)type{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"趣友分组";
    if (self.groupName.length > 0) {
        titleField.text = self.groupName;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.addGroupUserArr = [NSMutableArray array];
    self.HFDestUidsArray = [NSMutableArray array];
    isDelete = NO;
    
#pragma -mark 编辑跳转时,数据的获取
    if ([self.isEdit boolValue]) {
        [self initEditData];
    }
    
    [self initTableView];
    [self initHeaderView1];
    [self initHeaderView2];
    
    UIBarButtonItem * doneBar =[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = doneBar;
    
    UITapGestureRecognizer * addTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endKeyTap:)];
    [self.view addGestureRecognizer:addTap];
}

- (void)done:(UIBarButtonItem *)bar
{
    [self.view endEditing:YES];
    if ([self.isEdit boolValue]) {
        if (self.dataArray.count == self.HFDestUidsArray.count) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            
            [self initUpdateClasses:self.HFClassId name:self.groupName];
        }
    }
    else
    {
        if (self.HFDestUidsArray.count > 0) {
            [self initAddClassesData];
        }
        else
        {
            [MBProgressHUD show:@"请选择分组成员" icon:nil view:nil color:kColorRGBA(52,52,52,0.8)];
        }
    }
    
}

- (void)endKeyTap:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (void)initEditData
{
    for (QCFriendModel * model in self.dataArray) {
        [self.HFDestUidsArray addObject:model.destUid];
        if (model.user.avatar.length > 0) {
            [self.addGroupUserArr addObject:model.user.avatar];
        }
        else
        {
            [self.addGroupUserArr addObject:@"www"];
        }
    }
}


- (void)initTableView
{
    tabelViews = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view)) style:UITableViewStylePlain];
    tabelViews.delegate = self;
    tabelViews.dataSource = self;
    tabelViews.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabelViews.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    
    
    [self.view addSubview:tabelViews];
}

- (void)initHeaderView1
{
    interestGroupTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 45)];
    interestGroupTitleView.backgroundColor = [UIColor whiteColor];
    if ([self.isEdit boolValue]) {
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, WIDTH(interestGroupTitleView)-16, HEIGHT(interestGroupTitleView)-16)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = self.groupName;
        titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
        titleLabel.layer.borderWidth = 0.5;
        titleLabel.layer.borderColor = [UIColor colorWithHexString:@"E0E0E0"].CGColor;
        titleLabel.layer.masksToBounds = YES;
        titleLabel.layer.cornerRadius = 5;
        titleLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
        [interestGroupTitleView addSubview:titleLabel];
    }
    else
    {
        titleField = [[UITextField alloc] initWithFrame:CGRectMake(8, 8, WIDTH(interestGroupTitleView)-16, HEIGHT(interestGroupTitleView)-16)];
        titleField.font = [UIFont systemFontOfSize:14];
        titleField.placeholder = @"  请输入趣友分组的名字";
        [titleField setValue:[UIColor colorWithHexString:@"666666"] forKeyPath:@"_placeholderLabel.textColor"];
        titleField.textColor = [UIColor colorWithHexString:@"333333"];
        titleField.layer.borderWidth = 0.5;
        titleField.layer.borderColor = [UIColor colorWithHexString:@"E0E0E0"].CGColor;
        titleField.layer.masksToBounds = YES;
        titleField.layer.cornerRadius = 5;
        [titleField addTarget:self action:@selector(addClasssesName:) forControlEvents:UIControlEventEditingChanged];;
        [interestGroupTitleView addSubview:titleField];
    }
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(interestGroupTitleView), WIDTH(self.view), 45)];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, HEIGHT(titleView)*2/5, 30, 15)];
    titleLabel.text = @"成员";
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [titleView addSubview:titleLabel];
    
}

- (void)initHeaderView2
{
    int HFHeight;
    if(self.addGroupUserArr.count == 0)
    {
        HFHeight = 1;
    }
    else
    {
        if (((int)self.addGroupUserArr.count + 1)%7 == 0) {
            HFHeight = (int)self.addGroupUserArr.count/7+2;
        }
        else
        {
            HFHeight = (int)self.addGroupUserArr.count/7+1;
        }
    }
    
    UIView * userView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(titleView), WIDTH(self.view), (WIDTH(self.view)/7-6)*HFHeight+6)];
    userView.backgroundColor = [UIColor whiteColor];
    
    if (isDelete) {
        for (int i = 1; i < self.addGroupUserArr.count + 1; i++) {
            UIImageView * userImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(userView)/7*((i-1)%7)+6, (HEIGHT(userView)-6)/HFHeight*((i-1)/7)+6, WIDTH(userView)/7-12, WIDTH(userView)/7-12)];
            userImage.layer.masksToBounds = YES;
            userImage.layer.cornerRadius = HEIGHT(userImage)/2;
            [userImage sd_setImageWithURL:[NSURL URLWithString:self.addGroupUserArr[i-1]] placeholderImage:[UIImage imageNamed:@"ios-template-120(1)"]];
            userImage.tag = i-1;
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
            UIImageView * userImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(userView)/7*((i-1)%7)+6, (HEIGHT(userView)-6)/HFHeight*((i-1)/7)+6, WIDTH(userView)/7-12, WIDTH(userView)/7-12)];
            userImage.layer.masksToBounds = YES;
            userImage.layer.cornerRadius = HEIGHT(userImage)/2;
            [userImage sd_setImageWithURL:[NSURL URLWithString:self.addGroupUserArr[i-1]] placeholderImage:[UIImage imageNamed:@"ios-template-120(1)"]];
            
#pragma -mark 轻点跳个人中心
            UITapGestureRecognizer * userTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTapS:)];
            [userImage addGestureRecognizer:userTap];
            [userView addSubview:userImage];
        }
    }
    //添加组员按钮
    UIButton * addUserBu =[UIButton buttonWithType:UIButtonTypeCustom];
    addUserBu.frame = CGRectMake(WIDTH(userView)/7*(((self.addGroupUserArr.count+1)-1)%7)+6, (HEIGHT(userView)-6)/HFHeight*(((self.addGroupUserArr.count+1)-1)/7)+6, WIDTH(userView)/7-12, WIDTH(userView)/7-12);
    [addUserBu setImage:[UIImage imageNamed:@"LJadds"] forState:UIControlStateNormal];
    [addUserBu actionButton:^(UIButton *sender) {
        [self addGroupUser:addUserBu];
    }];
    [userView addSubview:addUserBu];
    
    //删除组员按钮
    UIButton * delUserBu =[UIButton buttonWithType:UIButtonTypeCustom];
    delUserBu.frame = CGRectMake(WIDTH(userView)/7*(((self.addGroupUserArr.count+2)-1)%7)+6, (HEIGHT(userView)-6)/HFHeight*(((self.addGroupUserArr.count+2)-1)/7)+6, WIDTH(userView)/7-12, WIDTH(userView)/7-12);
    [delUserBu setImage:[UIImage imageNamed:@"Reduction"] forState:UIControlStateNormal];
    [delUserBu actionButton:^(UIButton *sender) {
        [self delGroupUser:delUserBu];
    }];
    [userView addSubview:delUserBu];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(interestGroupTitleView)+HEIGHT(titleView)+HEIGHT(userView))];
    CZLog(@"%f", HEIGHT(headerView));
    [headerView addSubview:interestGroupTitleView];
    [headerView addSubview:titleView];
    [headerView addSubview:userView];
    
    [tabelViews setTableHeaderView:headerView];
}

- (void)addClasssesName:(UITextField *)field
{
    self.groupName = field.text;
}

#pragma -mark 跳转我关注的好友页,添加组员
- (void)addGroupUser:(UIButton *)bu
{
    if (self.groupName.length > 0) {
        QCFriendListVC * friendList = [[QCFriendListVC alloc] initWithFriendStatus:2 listType:_type];
        friendList.isAddGroupUsers = @1;
        friendList.QCHFGroupUserDelegate = self;
        if (self.HFDestUidsArray.count > 0) {
            friendList.groupUsersArr = self.HFDestUidsArray;
        }
        [self.navigationController pushViewController:friendList animated:YES];
    }
    else
    {
        [MBProgressHUD show:@"请输入分组名" icon:nil view:nil color:kColorRGBA(52,52,52,0.8)];
    }
    
}

#pragma -mark 代理传值,把选中添加的联系传过来
- (void)sendGroupUserAvatar:(NSMutableArray *)usersDataArr
{
    isDelete = NO;
    for (QCFriendModel * model in usersDataArr) {
        [self.HFDestUidsArray addObject:model.destUid];
        if (model.user.avatar.length > 0) {
            [self.addGroupUserArr addObject:model.user.avatar];
        }
        else
        {
            [self.addGroupUserArr addObject:@"www"];
        }
    }
    
    [self initHeaderView2];
}

#pragma -mark 删除组员
- (void)delGroupUser:(UIButton *)bu
{
    if (self.groupName.length > 0) {
        if (isDelete) {
            isDelete = NO;
            [self initHeaderView2];
        }
        else
        {
            isDelete = YES;
            [self initHeaderView2];
        }
        
        [tabelViews reloadData];
    }
    else
    {
        [MBProgressHUD show:@"请输入分组名" icon:nil view:nil color:kColorRGBA(52,52,52,0.8)];
    }
    
}

- (void)deleteTapS:(UITapGestureRecognizer *)taps
{
    if ([self.isEdit boolValue]) {
        //把数组转换成字符串
        HFDestUids = self.HFDestUidsArray[taps.view.tag];
        [self initDeleteUser:self.HFClassId destUids:HFDestUids index:taps.view.tag];
    }
    else
    {
        [self.addGroupUserArr removeObjectAtIndex:taps.view.tag];
        [self.HFDestUidsArray removeObjectAtIndex:taps.view.tag];
    }
    [self initHeaderView2];
}

- (void)initDeleteUser:(NSString *)classId destUids:(NSString *)destUids index:(NSInteger)index
{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"classId"] = classId;
    dic[@"destUids"] = destUids;
    [self.addGroupUserArr removeObjectAtIndex:index];
    [self.HFDestUidsArray removeObjectAtIndex:index];
    [NetworkManager requestWithURL:DELETEUSER parameter:dic success:^(id response) {
        
        
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
}

#pragma -mark 添加趣友分组
- (void)initAddClassesData
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"name"] = self.groupName;
    
    [NetworkManager requestWithURL:ADDClASSES parameter:dic success:^(id response) {
        
        NSDictionary * dic = response;
        NSString * Id = dic[@"id"];
        if (Id.length > 0) {
            //添加趣组成员
            [self initAddUserData:Id];
        }
        else
        {
            [MBProgressHUD hideHUD];
            return ;
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        NSLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}

#pragma mark - 修改趣友分组
- (void)initUpdateClasses:(NSString *)classId name:(NSString *)name
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"classId"] = classId;
    dic[@"name"] = name;
    
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:UPDATECLASSES parameter:dic success:^(id response) {
        
        [MBProgressHUD hideHUD];
        [self initAddUserData:classId];
        [self.navigationController popViewControllerAnimated:YES];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}

#pragma -mark 删除趣友分组
- (void)initDeleteClasses:(NSString *)classId
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"classId"] = classId;
    
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:DELETECLASSES parameter:dic success:^(id response) {
        
        [MBProgressHUD hideHUD];
        [self.navigationController popViewControllerAnimated:YES];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}

#pragma -mark 添加趣组成员
- (void)initAddUserData:(NSString *)classId
{
    //把数组转换成字符串
    HFDestUids =[self.HFDestUidsArray componentsJoinedByString:@","];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"classId"] = classId;
    dic[@"destUids"] = HFDestUids;
    
    [NetworkManager requestWithURL:ADDUSER parameter:dic success:^(id response) {
        [self.HFDestUidsArray removeAllObjects];
        
        [MBProgressHUD hideHUD];
        [self.navigationController popViewControllerAnimated:YES];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}

#pragma -mark 创建讨论组
- (void)initCreateGroup
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    dic[@"name"] = self.groupName;
    dic[@"type"] = @"2";
    dic[@"description"] = @"讨论";
//    dic[@"locLat"]=@"地理纬度";
//    dic[@"locLng"]=@"地理经度";
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:GROUP_CREAT parameter:dic success:^(id response) {
        
        QCGroupModel * model = [QCGroupModel mj_objectWithKeyValues:response];
        NSNumber * Id = response[@"id"];
        model.Id = Id;
        if (model) {
            //添加讨论组员
            [self initAddGroupChatUsers:[NSString stringWithFormat:@"%@", model.Id]];
        }
        else
        {
            [MBProgressHUD hideHUD];
            return ;
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}

#pragma -mark 添加添加讨论组员
- (void)initAddGroupChatUsers:(NSString *)groupId
{
    //把数组转换成字符串
    HFDestUids =[self.HFDestUidsArray componentsJoinedByString:@","];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"groupId"] = groupId;
    dic[@"destUids"] = HFDestUids;
    
    [NetworkManager requestWithURL:GROUP_ADDMEMBER parameter:dic success:^(id response) {
        
        if ([self.isEdit boolValue]) {
            
            [MBProgressHUD hideHUD];
            [OMGToast showText:@"创建成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            //创建趣友分组
            [self initAddClassesData];
        }
        
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.isEdit boolValue]) {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    cell.contentView.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    
    if ([self.isEdit boolValue]) {
        if (indexPath.row == 0) {
            [self deleteGroup];
            [cell.contentView addSubview:deleteView];
        }
        else
        {
            [self CreatTaoLunzu];
            [cell.contentView addSubview:creatView];
        }
    }
    else
    {
        [self CreatTaoLunzu];
        [cell.contentView addSubview:creatView];
    }
    
    return cell;
}

- (void)CreatTaoLunzu
{
    creatView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view)/6)];
    UIButton * creatBu = [UIButton buttonWithType:UIButtonTypeCustom];
    creatBu.frame = CGRectMake(WIDTH(self.view)/7, 10, WIDTH(self.view)-(WIDTH(self.view)/7)*2, HEIGHT(creatView)-20);
    creatBu.backgroundColor = [UIColor colorWithHexString:@"E64545"];
    creatBu.titleLabel.textAlignment = NSTextAlignmentCenter;
    creatBu.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(creatBu)/2];
    [creatBu setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
    [creatBu setTitle:@"创建讨论组" forState:UIControlStateNormal];
    [creatBu actionButton:^(UIButton *sender) {
        
        if (self.HFDestUidsArray.count>0) {
            [self.view endEditing:YES];
            [self initCreateGroup];
        }
        else
        {
            [MBProgressHUD show:@"请选择分组成员" icon:nil view:nil color:kColorRGBA(52,52,52,0.8)];
        }
        
        
    }];
    [creatView addSubview:creatBu];
}

- (void)deleteGroup
{
    deleteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view)/6+10)];
    UIButton * creatBu = [UIButton buttonWithType:UIButtonTypeCustom];
    creatBu.frame = CGRectMake(WIDTH(self.view)/7, 30, WIDTH(self.view)-(WIDTH(self.view)/7)*2, HEIGHT(deleteView)-30);
    creatBu.backgroundColor = [UIColor colorWithHexString:@"E64545"];
    creatBu.titleLabel.textAlignment = NSTextAlignmentCenter;
    creatBu.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(creatBu)/2];
    [creatBu setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
    [creatBu setTitle:@"删除当前分组" forState:UIControlStateNormal];
    [creatBu actionButton:^(UIButton *sender) {
        
        [self.view endEditing:YES];
        [self initDeleteClasses:self.HFClassId];
        
    }];
    [deleteView addSubview:creatBu];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.isEdit boolValue]) {
        if (indexPath.row == 0) {
            
            return HEIGHT(deleteView);
        }
        else
        {
        
            return HEIGHT(creatView);
        }
    }
    else
    {
        
        return HEIGHT(creatView);
    }
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
