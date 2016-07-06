//
//  QCYellListVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/20.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCYellListVC.h"
#import "MJExtension.h"
#import "QCDetailYellVC.h"
#import "QCUserViewController2.h"
@interface QCYellListVC ()<UITableViewDataSource,UITableViewDelegate,QCYellListCellDelegate>{
    QCBaseTableView *_tableView;
}
@property (nonatomic,strong) NSMutableArray * yellArray;

@property (nonatomic,assign) long long timestamp;

@property (nonatomic,assign) NSIndexPath *indexPath;

@end

@implementation QCYellListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _timestamp = [[NSDate date]timeIntervalSince1970]*1000;
    
    _tableView = [[QCBaseTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64-30) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kGlobalBackGroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 212;
    _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.view addSubview:_tableView];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.uid) {
        [self requestUserData];
        [_tableView addHeaderWithTarget:self action:@selector(requestUserData)];
        [_tableView addFooterWithTarget:self action:@selector(userMoreData)];
    }else{
        [self requestData];
        [_tableView addHeaderWithTarget:self action:@selector(requestData)];
        [_tableView addFooterWithTarget:self action:@selector(moreData)];
    }
}

#pragma mark - 下拉加载最新数据
-(void)requestData{
    self.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
  
    NSDictionary *parameters = @{@"timestamp":@(self.timestamp),@"type":@2};
    
    [NetworkManager requestWithURL:TOPIC_GETTOPICLIST_URL parameter:parameters success:^(id response) {
//        CZLog(@"--%@",response);
//        NSLog(@"--%@",response);
        NSDictionary *dict = (NSDictionary *)response;
        self.timestamp = [[dict objectForKey:@"timestamp"]longLongValue];
        
        NSMutableArray *newModel = [NSMutableArray array];
        for (NSDictionary *tempDict in response[@"list"]) {
            QCYellModel *yellModel = [QCYellModel mj_objectWithKeyValues:tempDict];
            yellModel.contentBei = [tempDict[@"content"] floatValue];
            [newModel addObject:yellModel];
        }
        self.yellArray =newModel;
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [_tableView headerEndRefreshing];
    }];
}

#pragma mark - 上拉加载更多数据
-(void)moreData{
    NSDictionary *parameters = @{@"timestamp":@(self.timestamp),@"type":@2};
    [NetworkManager requestWithURL:TOPIC_GETTOPICLIST_URL parameter:parameters success:^(id response) {
        NSArray *moreArr = [QCYellModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        if (moreArr.count>0) {
            [self.yellArray addObjectsFromArray:moreArr];
            [_tableView reloadData];
        }else{
            [OMGToast showText:@"已无更多数据"];
        }
          [_tableView footerEndRefreshing];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [_tableView footerEndRefreshing];
    }];
    
}

#pragma mark - 个人中心跳转的个人怒吼烈表示数据
-(void)requestUserData{
    self.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    
    NSDictionary *parameters = @{@"timestamp":@(self.timestamp),@"type":@2,@"destUid":self.uid};
    
    [NetworkManager requestWithURL:TOPIC_TOPICOFMEMBER parameter:parameters success:^(id response) {
        CZLog(@"%@",response);
        
        NSDictionary *dict = (NSDictionary *)response;
        self.timestamp = [[dict objectForKey:@"timestamp"]longLongValue];
        
        NSMutableArray *newModel = [QCYellModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        self.yellArray =newModel;
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [_tableView headerEndRefreshing];
    }];
    
}

#pragma mark - 个人中心跳转的，更多数据
-(void)userMoreData{
    
    NSDictionary *parameters = @{@"timestamp":@(self.timestamp),@"type":@2,@"destUid":self.uid};
    [NetworkManager requestWithURL:TOPIC_TOPICOFMEMBER parameter:parameters success:^(id response) {
        
        NSArray *moreArr = [QCYellModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        if (moreArr.count>0) {
            [self.yellArray addObjectsFromArray:moreArr];
            [_tableView reloadData];
        }else{
            [OMGToast showText:@"已无更多数据"];
        }
        [_tableView footerEndRefreshing];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [_tableView footerEndRefreshing];
    }];
    
}

-(void)avatarTap:(UITapGestureRecognizer *)gesture{
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    QCYellModel *model = self.yellArray[gesture.view.tag];
    if (model.user.uid == sessions.user.uid) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        QCUserViewController2 *user = [[QCUserViewController2 alloc] init];
        user.uid = model.user.uid;
        [self.navigationController pushViewController:user animated:YES];
    }
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.yellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QCYellListCell *cell =[QCYellListCell collectTableViewCellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.yellModel = self.yellArray[indexPath.row];
    cell.delegate = self;
    cell.avatar.userInteractionEnabled = YES;
    cell.avatar.tag = indexPath.row;
    [cell.avatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTap:)]];
    return cell;
}

#pragma mark - tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QCDetailYellVC *detailYellVC = [[QCDetailYellVC alloc]init];
    detailYellVC.yellModel = self.yellArray[indexPath.row];
    [self.navigationController pushViewController:detailYellVC animated:YES];
    
    self.indexPath = indexPath;
}

#pragma mark - QCYellListCellDelegate
-(void)commentBtnClick{
    QCDetailYellVC * detailYellVC = [[QCDetailYellVC alloc]init];
    detailYellVC.yellModel = self.yellArray[self.indexPath.row];
    [self.navigationController pushViewController:detailYellVC animated:YES];  
}




@end
