//
//  QCFriendInfo.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/3.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCFriendInfoVC.h"
#import "QCFriendHeaderView.h"
#import "QCFriendHeaderView2.h"
#import "QCDiandiViewController.h"
//第三方tableViewView

#import "SKSTableView.h"
#import "SKSTableViewCell.h"

//#import "QCPersonInfoVC.h"//个人注册信息
//#import "QCDiandiViewController.h"//点滴
//#import "QCYellListVC.h"//怒吼
//#import "QCLunKuViewController.h"//论库
//#import "QCChatMainVc.h"//朋友
//#import "QCQRCodeVC.h"//扫一扫

#import "QCPersonMarkModel.h"


@interface QCFriendInfoVC()<SKSTableViewDelegate,QCFriendHeaderViewDelegate> {
    SKSTableView*_tableView;
    QCFriendHeaderView2 *_headerView;
    long _userID;

}
@property (nonatomic , strong)NSArray *bigMarks;//标签内容
@property (nonatomic , strong)NSMutableArray *smallMakrs;//小标签

@end

@implementation QCFriendInfoVC

#pragma mark - 根据UserID来创建个人
-(instancetype)initWithUserID:(long )userID{
    if (self = [super init]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        _userID = userID;
    }
    return self;
}

-(void)setUser:(User *)user{
    if (!_user) {
        _user = [[ApplicationContext sharedInstance]getLoginUser];
    }
}

#pragma mark - 标签数组
-(NSArray *)bigMarks{
    if (!_bigMarks) {
        _bigMarks = [NSMutableArray arrayWithArray:@[@"基本信息",@"交友标签",@"自创大类",@"时尚标签",@"添加自创类"]];
    }
    return _bigMarks;
}
-(NSMutableArray *)smallMakrs{
    if (!_smallMakrs) {
        _smallMakrs = [NSMutableArray arrayWithArray:@[@"基本信息",@"信息",@"基本信息",@"基本信息",@"基本信息"]];
    }
    return _smallMakrs;
}

#pragma mark - 初始化
-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"个人资料";
    
    //获取大类标签
//    [self getBigMarks];
    
    //创建tableView
    _tableView = [[SKSTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.SKSTableViewDelegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = kSeparatorColor;
    [self.view addSubview:_tableView];
    
    //navigationBar
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addBarBtnImg:@"but_Option" highlightedImg:@"but_Option" target:self action:@selector(rightBarButtonClick:)];
    

}

-(void)rightBarButtonClick:(id)sender{
    CZLog(@"保存完成退出页面");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取大类标签
-(void)getBigMarks{
    NSDictionary *parameters = @{@"uid":@(_userID)};
    // $$$$$ 在这里先写死uid
//    long uid = self.user.uid;
    parameters = @{@"uid":@13};
    
    [NetworkManager requestWithURL:USERINFO_GETMARKGROUP parameter:parameters success:^(id response) {
        // ------在这里赋值给bigMark数组
        //接收
        // $$$$$ 怎么接受返回来数据呢?
        
        _bigMarks = [QCPersonMarkModel mj_objectArrayWithKeyValuesArray:response];
        [_tableView reloadData];
        
//        NSArray *array = [QCPersonMarkModel objectArrayWithKeyValuesArray:[dict objectForKey:@"data"]];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bigMarks.count;
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return 1;
}

- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath
{
//    QCPersonMarkModel *model = _bigMarks[indexPath.row];
//    if (model.userMarks.count==0) {
//        return NO;
//    }else{
//        return YES;
//    }
    return NO;
    
}

// ------hearderView
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 181;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    QCFriendHeaderView *headerView = [[QCFriendHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 181) navigationController:self.navigationController];
    self.user = [[ApplicationContext sharedInstance]getLoginUser];
    headerView.user = self.user;
//    CZLog(@"===%@",self.user.nickname);
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SKSTableViewCell";
    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    QCPersonMarkModel *model = _bigMarks[indexPath.row];
//    cell.textLabel.text = model.title;
    cell.expandable = YES;
    //增加一个权限的按钮
    // $$$$$ 权限先不做
    UIButton *permissionBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W-150, 0, 50, cell.height)];
    [cell.contentView addSubview:permissionBtn];
    [permissionBtn setTitle:@"权限" forState:UIControlStateNormal];
    [permissionBtn setTitleColor:kGlobalTitleColor forState:UIControlStateNormal];
    permissionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [permissionBtn addTarget:self action:@selector(permisionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
//    QCPersonMarkModel *model = _bigMarks[indexPath.row];
//    cell.textLabel.text = model.title;
//
    return cell;
}

- (CGFloat)tableView:(SKSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"Section: %d, Row:%d, Subrow:%d", indexPath.section, indexPath.row, indexPath.subRow);
}

- (void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"Section: %d, Row:%d, Subrow:%d", indexPath.section, indexPath.row, indexPath.subRow);
}




#pragma mark - 私有方法
-(void)permisionBtnClick:(id)sender{
    
}




@end
