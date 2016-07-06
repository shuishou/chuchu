//
//  QCGroupListVC.m
//  MyQOOCOO
//
//  Created by wzp on 15/10/13.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCGroupListVC.h"
#import "QCFriendListCell.h"
#import "QCGroupModel.h"
#import "QCHFTheUserCell.h"
#import "QCHFGroupUserModel.h"
#import "QCChatViewController.h"
#import "UserProfileManager.h"
#import "QCFaQiQunLiaoCell.h"
#import "AddInterestGropVC.h"

@interface QCGroupListVC ()<UIGestureRecognizerDelegate, UITextViewDelegate>
{
    /**添加组员的 id*/
    NSString * HFDestUids;
//    /**趣友组组名字*/
//    NSString * groupTitle;
    
    UIView * groupNameV;
    UITextView * textViews;
    UIView * titleView;
    
    NSString * groupNames;
}

/**点击数组*/
@property (strong, nonatomic) NSMutableArray * selectArray;
/**分组好友*/
@property (strong, nonatomic) NSMutableArray * groupUserArr;
/**点击添加群聊*/
@property (strong, nonatomic) NSMutableArray * addQunLiaoArr;
/**群聊的组员*/
@property (strong, nonatomic) NSMutableArray * addQunLiaoUsersArr;
/**群组字典*/
@property (strong, nonatomic) NSMutableDictionary * groupDictionary;
/**添加组员 id*/
@property (strong, nonatomic) NSMutableArray * destUidArr;
@end

@implementation QCGroupListVC
@synthesize headViewArray;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
    self.addQunLiaoUsersArr = [NSMutableArray array];
    self.groupUserArr = [NSMutableArray array];
    self.groupDictionary = [NSMutableDictionary dictionary];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectArray = [NSMutableArray array];
    self.addQunLiaoArr = [NSMutableArray array];
    self.destUidArr = [NSMutableArray array];
    
    if (self.isQunLiao) {
        UIBarButtonItem * doneBar =[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(groupChat:)];
        self.navigationItem.rightBarButtonItem = doneBar;
    }
    else{
        UIBarButtonItem * doneBar =[[UIBarButtonItem alloc]initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(groupDiscussion:)];
        self.navigationItem.rightBarButtonItem = doneBar;
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //监听键盘弹出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowNotificationded:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardRemoveed:) name:UIKeyboardWillHideNotification object:nil];
//    [self.tableView registerClass:[QCFriendListCell class] forCellReuseIdentifier:NSStringFromClass([QCFriendListCell class])];
    
    
    // Do any additional setup after loading the view.
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

#pragma -mark 发起群聊
- (void)groupChat:(UIBarButtonItem *)barC
{
    if (self.destUidArr.count>0)
    {
        [self initGroupName];
    }else{
        [OMGToast showText:@"请先选择群组好友"];
    }
    
}


#pragma -mark 填写群名
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
    label.text = @"请设置群名称";
    label.textColor = [UIColor colorWithHexString:@"333333"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:HEIGHT(label)*2/5];
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
    cancelBu.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(cancelBu)*2/5];
    [cancelBu setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [cancelBu actionButton:^(UIButton *sender) {
        
        [groupNameV endEditing:YES];
        groupNames = nil;
        [groupNameV removeFromSuperview];
        
    }];
    [titleView addSubview:cancelBu];
    
    UIButton * doneBu = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBu.frame = CGRectMake(MaxX(cancelBu), Y(cancelBu), WIDTH(cancelBu), HEIGHT(cancelBu));
    [doneBu setTitle:@"确定" forState:UIControlStateNormal];
    doneBu.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(doneBu)*2/5];
    [doneBu setTitleColor:[UIColor colorWithHexString:@"#2ab6f4"] forState:UIControlStateNormal];
    [doneBu actionButton:^(UIButton *sender) {
        
        [groupNameV endEditing:YES];
        //得到输入框
        if (groupNames.length > 0 && ![groupNames isEqualToString:@" "]) {
            [self.view endEditing:YES];
            [self createGroupChat:groupNames];
        }
        else
        {
            [OMGToast showText:@"创建失败!请填写群聊组名字!"];
        }
        
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
    
    groupNames = textView.text;
    
}

- (void)dismissTap:(UITapGestureRecognizer *)tap
{
    //    markNameV.hidden = YES;
    [groupNameV endEditing:YES];
}

#pragma -mark 新增趣友分组
- (void)groupDiscussion:(UIBarButtonItem *)barD
{
    AddInterestGropVC * Vc = [[AddInterestGropVC alloc] init];
    Vc.title = @"编辑趣友分组";
    Vc.isEdit = 0;
    [self.navigationController pushViewController:Vc animated:YES];
}

//- (void)willPresentAlertView:(UIAlertView *)alertView {
//    
//    // 遍历 UIAlertView 所包含的所有控件
//    for (UIView *tempView in alertView.subviews) {
//        
//        
//        if ([tempView isKindOfClass:[UIButton class]]) {
//            
//            // 当该控件为一个 UILabel 时
//            UIButton *cancelBu  = (UIButton *) tempView;
//            
//            if ([cancelBu.titleLabel.text isEqualToString:[alertView buttonTitleAtIndex:0]]) {
//                
//                // 调整对齐方式
//                cancelBu.titleLabel.textAlignment = NSTextAlignmentCenter;
//                
//                // 调整字体大小
//                [cancelBu.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
//            
//                [cancelBu setTitleColor:[UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1] forState:UIControlStateNormal];
//            }
//            
//        }
//        
//    }
//
//}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        //得到输入框
        UITextField *tf=[alertView textFieldAtIndex:0];
        if (tf.text.length > 0 && ![tf.text isEqualToString:@" "]) {
            [self.view endEditing:YES];
            [self createGroupChat:tf.text];
        }
        else
        {
            [OMGToast showText:@"创建失败!请填写群聊组名字!"];
        }
    }
}

#pragma -mark 创建群组
- (void)createGroupChat:(NSString *)groupName
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"name"] = groupName;
    dic[@"type"] = @"1";
    dic[@"description"] = @"群聊";
    
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:GROUP_CREAT parameter:dic success:^(id response) {
        
        QCGroupModel * model = [QCGroupModel mj_objectWithKeyValues:response];
        NSNumber * Id = response[@"id"];
        model.Id = Id;
        if (model) {
            [self addGroupChatUsers:[NSString stringWithFormat:@"%@", model.Id]];
        }
        else
        {
            [MBProgressHUD hideHUD];
            [self.tableView reloadData];
            return ;
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog( @"%@", error);
        [OMGToast showText:@"发起群聊失败"];
        [MBProgressHUD hideHUD];
    }];
}

#pragma -mark 添加组员
- (void)addGroupChatUsers:(NSString *)groupId
{
    //把数组转换成字符串
    HFDestUids =[self.destUidArr componentsJoinedByString:@","];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"groupId"] = groupId;
    dic[@"destUids"] = HFDestUids;
    
    [NetworkManager requestWithURL:GROUP_ADDMEMBER parameter:dic success:^(id response) {
        [self.destUidArr removeAllObjects];
        [self.view endEditing:YES];
        [MBProgressHUD hideHUD];
        [groupNameV removeFromSuperview];
        [OMGToast showText:@"创建成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [OMGToast showText:@"添加组员失败"];
        [MBProgressHUD hideHUD];
    }];
}

#pragma -mark 获取趣友/群分组
-(void)loadData{
    
//    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:GETCLASSES parameter:nil success:^(id response) {
        
        NSArray * array = response;
        if (array.count < 1) {
            [MBProgressHUD hideHUD];
            [self.tableView reloadData];
            return ;
        }
        else
        {
            self.tableView.data = [array mutableCopy];
            [self loadGetUser];
            [self loadModel];
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        //
        NSLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}

#pragma -mark 获取趣友/群分组组员
- (void)loadGetUser
{
    [NetworkManager requestWithURL:GETUSERBYCLASSID parameter:nil success:^(id response) {
        
        NSArray * arr = [QCHFGroupUserModel mj_objectArrayWithKeyValuesArray:response];
        if (arr.count > 0) {
            self.groupUserArr = [NSMutableArray arrayWithArray:arr];
            
#pragma -mark 将分组和组员合拼
            for (NSDictionary * dic in self.tableView.data) {
                
                NSString * str = [NSString stringWithFormat:@"%@%@",dic[@"id"],dic[@"name"]];
                
                NSMutableArray * groupArray = [[NSMutableArray alloc] initWithCapacity:10];
                
                for (QCHFGroupUserModel * models in arr) {
                    
                    if ([models.classes_id isEqualToString:dic[@"id"]]) {
                        [groupArray addObject:models];
                    }
                }
                [self.groupDictionary setObject:groupArray forKey:str];
            }
            NSArray * array = [self.groupDictionary allKeys];
            
            //根据key值进行比较排序（这里不能用系统的，系统排序乱了）
            NSArray * sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1 compare:obj2 options:NSNumericSearch];
            }];

            self.addQunLiaoUsersArr = [NSMutableArray arrayWithArray:sortedArray];
            
            [MBProgressHUD hideHUD];
            [self.tableView reloadData];
        }
        else
        {
            [MBProgressHUD hideHUD];
            [self.tableView reloadData];
            return ;
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
    }];
}

#pragma mark - 每个区的区头视图
- (void)loadModel
{
    _currentRow = -1;
    headViewArray = [[NSMutableArray alloc]init ];
    for(int i = 0;i< self.tableView.data.count ;i++)
    {
        NSDictionary * dic = self.tableView.data[i];
        QCHFGroupHeadView* headview = [[QCHFGroupHeadView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 70)];
        headview.delegate = self;
        headview.section = i;
        headview.tag = i;
        headview.backgroundColor = [UIColor whiteColor];
        headview.titleLabel.text = [NSString stringWithFormat:@"%@(%@)", dic[@"name"], dic[@"count"]];
        [headview.titleLabel sizeToFit];
        [self.headViewArray addObject:headview];
        
        
        if (![_isQunLiao boolValue]) {
#pragma -mark 长按编辑
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressEdit:)];
            [longPressGesture setDelegate:self];
            //允许15秒中运动
            longPressGesture.allowableMovement=NO;
            //所需触摸1次
            longPressGesture.numberOfTouchesRequired=1;
            longPressGesture.minimumPressDuration=0.5;//默认0.5秒
            [headview addGestureRecognizer:longPressGesture];
        }
    }
}

#pragma -mark 长按跳转编辑
- (void)longPressEdit:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        //长按事件开始"
        //do something
        
    }else if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        //长按事件结束
        //do something
        AddInterestGropVC * vc = [[AddInterestGropVC alloc] init];
        vc.title = @"编辑趣友分组";
        vc.isEdit = @1;
        if (self.addQunLiaoUsersArr.count > 0) {
            //调用内容，给model赋值的方式
            NSString * key = self.addQunLiaoUsersArr[gestureRecognizer.view.tag];
            NSArray * array = self.groupDictionary[key];
            vc.dataArray = [NSMutableArray arrayWithArray:array];
        }
        
        NSDictionary * dic = self.tableView.data[gestureRecognizer.view.tag];
        vc.groupName = dic[@"name"];
        vc.HFClassId = dic[@"id"];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - TableViewdelegate&&TableViewdataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.tableView.data.count > 0)
    {
        return self.tableView.data.count;
    }
    else
    {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.headViewArray.count > 0)
    {
        QCHFGroupHeadView* headView = [self.headViewArray objectAtIndex:section];
        NSDictionary * dic = self.tableView.data[section];
        
        if (self.addQunLiaoUsersArr.count > 0) {
            NSString * key = self.addQunLiaoUsersArr[section];
            
            NSArray * array = self.groupDictionary[key];
            return headView.open?array.count:0;
        }else{
            return 0;
        }
    }
    else
    {
        return 0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.headViewArray.count > 0)
    {
        QCHFGroupHeadView* headView = [self.headViewArray objectAtIndex:indexPath.section];
        return headView.open?70:0;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self.headViewArray objectAtIndex:section];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    QCHFGroupHeadView * view = [self.headViewArray objectAtIndex:indexPath.section];
    
    if (self.isQunLiao)
    {
#pragma -mark 发起群聊
        QCFaQiQunLiaoCell * cells = [QCFaQiQunLiaoCell QCFaQiQunLiaoCell:self.tableView];
        
        if (view.open) {
            cells.addButton.tag = indexPath.row;
            //调用内容，给model赋值的方式
            NSString * key = self.addQunLiaoUsersArr[indexPath.section];
            NSArray * array = self.groupDictionary[key];
            QCHFGroupUserModel * model = array[indexPath.row];
            NSString *noteStr = [self judgeNullBackKongString:model.note];
            cells.niceNameLabel.text = noteStr.length > 0?model.note:model.user.nickname;
            [cells.avatarImage sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] placeholderImage:[UIImage imageNamed:@"ios-template-120(1)"]];
            
            for (NSIndexPath * indexPaths in self.addQunLiaoArr) {
                if ((indexPaths.section == indexPath.section) && (indexPaths.row == indexPath.row)) {
                    cells.addButton.selected = YES;
                }
            }
        }
        return cells;
    }else{
#pragma -mark 趣友分组
        QCHFTheUserCell * cell = [QCHFTheUserCell QCHFTheUserCell:self.tableView];
        cell.chatLine.hidden = YES;
        if (view.open) {
            cell.isFriendBu.hidden = YES;
            cell.markView1.hidden = YES;
            cell.markView2.hidden = YES;
            cell.markView3.hidden = YES;
            //调用内容，给model赋值的方式
            NSString * key = self.addQunLiaoUsersArr[indexPath.section];
            NSArray * array = self.groupDictionary[key];
            QCHFGroupUserModel * model = array[indexPath.row];
            NSString *noteStr = [self judgeNullBackKongString:model.note];
            cell.nicknameLabel.text = noteStr.length > 0?model.note:model.user.nickname;
            [cell.avatarUrlImage sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] placeholderImage:[UIImage imageNamed:@"ios-template-120(1)"]];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //调用内容，给model赋值的方式
    NSString * key = self.addQunLiaoUsersArr[indexPath.section];
    NSArray * array = self.groupDictionary[key];
    QCHFGroupUserModel * model = array[indexPath.row];
    
    //发起群聊功能
    if (self.isQunLiao) {
        
        QCFaQiQunLiaoCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        _currentRow = indexPath.row;
        
        for (int i = 0; i < self.addQunLiaoArr.count; i++) {
            NSIndexPath *indexP = self.addQunLiaoArr[i];
            if ((indexP.section == indexPath.section) && (indexP.row == indexPath.row)) {
                cell.addButton.selected = NO;
                [self.addQunLiaoArr removeObjectAtIndex:i];
                [self.destUidArr removeObjectAtIndex:i];
                return;
            }
        }
        
        for (int i=0; i<self.destUidArr.count; i++)
        {
            if ([model.destUid isEqualToString:self.destUidArr[i]])
            {
                [OMGToast showText:@"用户已选择该好友"];
                return;
            }
        }
        
        cell.addButton.selected = YES;
        [self.destUidArr addObject:model.destUid];
        [self.addQunLiaoArr addObject:indexPath];
        NSLog(@"---%@---%@",model.destUid,self.destUidArr);
        
    }else{
        //进行群聊
        QCChatViewController *chatView = [[QCChatViewController alloc]initWithChatter:model.destHid isGroup:NO];
        chatView.title = [[UserProfileManager sharedInstance] getNickNameWithUsername:model.user.nickname];
        [self.navigationController pushViewController:chatView animated:YES];
        
        
        
    }
    
}

#pragma mark - HeadViewdelegate
-(void)selectedWith:(QCHFGroupHeadView *)view{
//    _currentRow = -1;
    _currentSection = view.section;
    if (view.open) {
        //点击同一个关闭
        for(int i = 0;i<[self.selectArray count];i++)
        {
            QCHFGroupHeadView *head = [self.selectArray objectAtIndex:i];
            if (head.section == _currentSection) {
                head.open = NO;
                [head.backBtn setBackgroundImage:[UIImage imageNamed:@"but_down-arrow"] forState:UIControlStateNormal];
                [self.selectArray removeObjectAtIndex:i];
            }
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:view.section] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
    [self reset];
}

//界面重置
- (void)reset
{
    for(int i = 0;i<[headViewArray count];i++)
    {
        QCHFGroupHeadView *head = [headViewArray objectAtIndex:i];
        
        if(head.section == _currentSection)
        {
            //展开
            head.open = YES;
            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"but_uparrow"] forState:UIControlStateNormal];
            [self.selectArray addObject:head];
        }
//        else
//        {
//            //收缩
//            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"but_down-arrow"] forState:UIControlStateNormal];
//            head.open = NO;
//        }
        
    }
    
    [self.tableView reloadData];

}

-(NSString *)judgeNullBackKongString:(id)objc{
    if (objc == nil || [objc isEqual:[NSNull null]]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",objc];
}


@end
