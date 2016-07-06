//
//  QCDoodleListVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/20.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCDoodleListVC.h"
#import "QCDoodleStatusFrame.h"
#import "QCDoodleCell.h"
#import "QCDetailDoodleVC.h"
#import "QCDoodleStatus.h"
#import "QCStatusToolBar.h"
#import "QCDoodleStatusFrame.h"
#import "QCUserViewController2.h"
@interface QCDoodleListVC ()<UITableViewDataSource,UITableViewDelegate,QCStatusToolBarDelegate>{
    QCBaseTableView *_tableView;
}
@property (nonatomic,strong)NSMutableArray *doodleStatusFrames;//数据模型frame
@property (nonatomic,assign) long long timestamp;
@property (nonatomic,assign) BOOL isRefresh;
@property (nonatomic,assign) BOOL isPush;
@property (nonatomic,assign) BOOL isFirst;

@end

@implementation QCDoodleListVC
-(NSMutableArray *)doodleStatusFrames{
    if (!_doodleStatusFrames) {
        self.doodleStatusFrames = [NSMutableArray array];
    }
    return _doodleStatusFrames;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isPush) {
        self.isPush = NO;
        return;
    }
    if (self.isFirst) { //第一次加载
        return;
    }
    
    self.isRefresh = YES;
    if (self.uid) {
        [self requestUserData];
        [_tableView addFooterWithTarget:self action:@selector(requestUserData)];
        [_tableView addFooterWithTarget:self action:@selector(userFooterData)];
    }else{
       [self requestData];
        [_tableView addFooterWithTarget:self action:@selector(requestData)];
        [_tableView addFooterWithTarget:self action:@selector(loadFooterData)];
    }
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPush = NO;
    
    _tableView = [[QCBaseTableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_W, SCREEN_H-103) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kGlobalBackGroundColor;
    [self.view addSubview:_tableView];
    
    
    [_tableView addHeaderWithTarget:self action:@selector(HearderRefresh)];
    [_tableView headerBeginRefreshing];
    //时间戳
    _timestamp = [[NSDate date]timeIntervalSince1970]*1000;
}

#pragma mark - 下拉刷新数据
-(void)requestData{
    if (self.isRefresh) {
        self.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    }
    NSDictionary *dict = @{@"timestamp":@(self.timestamp),@"type":@1};
//    [self popupLoadingView:@"正在加载数据..."];
    
    __block BOOL isRefresh = self.isRefresh;
    [NetworkManager requestWithURL:TOPIC_GETTOPICLIST_URL parameter:dict success:^(id response) {
        [self hideLoadingView];
        NSDictionary *dictionary = (NSDictionary *)response;
        self.timestamp = [[dictionary objectForKey:@"timestamp"]longLongValue];
        //把字典转为模型数据
        NSArray *newStatuses = [QCDoodleStatus mj_objectArrayWithKeyValuesArray:response[@"list"]];
        //把模型数组转为frame数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
        if (isRefresh) {
            [self.doodleStatusFrames removeAllObjects];
        }
        [self.doodleStatusFrames addObjectsFromArray:newFrames];
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [_tableView headerEndRefreshing];
    }];
    self.isFirst = NO;
}
#pragma mark - 上拉加载更多数据
-(void)loadFooterData{
    NSDictionary *dict = @{@"timestamp":@(self.timestamp),@"type":@1};
    [NetworkManager requestWithURL:TOPIC_GETTOPICLIST_URL parameter:dict success:^(id response) {
        [self hideLoadingView];
        NSDictionary *dictionary = (NSDictionary *)response;
        self.timestamp = [[dictionary objectForKey:@"timestamp"]longLongValue];
        //把字典转为模型数据
        NSArray *newStatuses = [QCDoodleStatus mj_objectArrayWithKeyValuesArray:response[@"list"]];
        //把模型数组转为frame数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
        if (newFrames.count >0) {
            [self.doodleStatusFrames addObjectsFromArray:newFrames];
            [_tableView reloadData];
        }else{
            [OMGToast showText:@"已无更多数据"];
        }
        [_tableView footerEndRefreshing];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [_tableView footerEndRefreshing];
    }];
    self.isFirst = NO;
}


#pragma mark - 个人中心跳转的个人怒吼数据
-(void)requestUserData{
    if (self.isRefresh) {
        self.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    }
    NSDictionary *dict = @{@"timestamp":@(self.timestamp),@"type":@1,@"destUid":self.uid};
    //    [self popupLoadingView:@"正在加载数据..."];
    
    __block BOOL isRefresh = self.isRefresh;
    [NetworkManager requestWithURL:TOPIC_TOPICOFMEMBER parameter:dict success:^(id response) {
        [self hideLoadingView];
        NSDictionary *dictionary = (NSDictionary *)response;
        self.timestamp = [[dictionary objectForKey:@"timestamp"]longLongValue];
        //把字典转为模型数据
        NSArray *newStatuses = [QCDoodleStatus mj_objectArrayWithKeyValuesArray:response[@"list"]];
        //把模型数组转为frame数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
        if (isRefresh) {
            [self.doodleStatusFrames removeAllObjects];
        }
        [self.doodleStatusFrames addObjectsFromArray:newFrames];
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [_tableView headerEndRefreshing];
    }];
    self.isFirst = NO;
}
#pragma mark - 上拉加载更多数据
-(void)userFooterData{
    NSDictionary *dict = @{@"timestamp":@(self.timestamp),@"type":@1,@"destUid":self.uid};
    [NetworkManager requestWithURL:TOPIC_TOPICOFMEMBER parameter:dict success:^(id response) {
        [self hideLoadingView];
        NSDictionary *dictionary = (NSDictionary *)response;
        self.timestamp = [[dictionary objectForKey:@"timestamp"]longLongValue];
        //把字典转为模型数据
        NSArray *newStatuses = [QCDoodleStatus mj_objectArrayWithKeyValuesArray:response[@"list"]];
        //把模型数组转为frame数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
        if (newFrames.count >0) {
            [self.doodleStatusFrames addObjectsFromArray:newFrames];
            [_tableView reloadData];
        }else{
            [OMGToast showText:@"已无更多数据"];
        }
        [_tableView footerEndRefreshing];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [_tableView footerEndRefreshing];
    }];
    self.isFirst = NO;
}



#pragma mark - 顶部刷新数据
-(void)HearderRefresh{
    _isRefresh = YES;
    if (self.uid) {
        [self requestUserData];
    }else{
       [self requestData];
    }
    
}

// 将HWStatus模型转为HWStatusFrame模型
 - (NSArray *)stausFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray *frames = [NSMutableArray array];
    for (QCDoodleStatus *status in statuses) {
        QCDoodleStatusFrame *f = [[QCDoodleStatusFrame alloc] init];
        f.qcStatus = status;
        [frames addObject:f];
    }
    return frames;
}

-(void)iconVTap:(UITapGestureRecognizer *)gesture{
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    QCDoodleStatusFrame *qcstatusF = self.doodleStatusFrames[gesture.view.tag];
    if (sessions.user.uid == qcstatusF.qcStatus.user.uid) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        QCUserViewController2 *user = [[QCUserViewController2 alloc] init];
        user.uid = qcstatusF.qcStatus.user.uid;
        [self.navigationController pushViewController:user animated:YES];
    }
}


#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.doodleStatusFrames.count;
}

//cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QCDoodleCell *cell = [QCDoodleCell cellWithTableView:tableView];
    cell.qcStatusFrame = self.doodleStatusFrames[indexPath.row];
    cell.iconV.userInteractionEnabled = YES;
    cell.iconV.tag = indexPath.row;
    [cell.iconV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconVTap:)]];
    //工具条的点击事件
    [cell.toolbar.commentBtn addTarget:self action:@selector(selfCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


#pragma mark - tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QCDoodleStatusFrame *doodleStatusFrame = self.doodleStatusFrames[indexPath.row];
    return doodleStatusFrame.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.isPush = NO;
    QCDetailDoodleVC *detailStatusVC = [[QCDetailDoodleVC alloc]init];
    QCDoodleStatusFrame *qcstatusF = self.doodleStatusFrames[indexPath.row];
    detailStatusVC.qcStatus = qcstatusF.qcStatus;
    [self.navigationController pushViewController:detailStatusVC animated:YES];
}

#pragma mark - 实现toolbar的点击事件代理
-(void)selfCommentBtnClick:(UIButton *)sender{
    
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    QCDetailDoodleVC *detailStatusVC = [[QCDetailDoodleVC alloc]init];
    QCDoodleStatusFrame *qcstatusF = self.doodleStatusFrames[indexPath.row];
    detailStatusVC.qcStatus = qcstatusF.qcStatus;
    [self.navigationController pushViewController:detailStatusVC animated:YES];
    
}





@end
