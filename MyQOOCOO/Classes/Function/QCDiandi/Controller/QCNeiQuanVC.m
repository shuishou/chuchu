//
//  QCNeiQuanVC.m
//  MyQOOCOO
//
//  Created by 贤荣 on 15/12/24.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCNeiQuanVC.h"
#import "QCDiandiListCell.h"
#import "QCDiandiDetailVC.h"
#import "OkamiPhotoView.h"


@interface QCNeiQuanVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableV;
}

@property (strong,nonatomic) NSMutableArray * modelArr;

@property (assign,nonatomic) long long timestamp;

@end

@implementation QCNeiQuanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kUIScreenW, kUIScreenH - 100)];
    tableV.backgroundColor = kGlobalBackGroundColor;
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableV.dataSource = self;
    tableV.delegate = self;
    tableV.rowHeight = 44;
    tableV.estimatedRowHeight = 2;
    tableV.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.view addSubview:tableV];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.uid) {
        [self requestUserData];
        [tableV addHeaderWithTarget:self action:@selector(requestUserData)];
        [tableV addFooterWithTarget:self action:@selector(moreUserData)];
    }else{
        [self requestData];
        [tableV addHeaderWithTarget:self action:@selector(requestData)];
        [tableV addFooterWithTarget:self action:@selector(moreData)];
    }
}

- (void)requestData {
     self.timestamp =[[NSDate date] timeIntervalSince1970]*1000;
    NSDictionary * parameters = @{@"timestamp":@(self.timestamp),@"type":@(2)};
    
    [NetworkManager requestWithURL:RECORD_GETRECORDLIST_URL parameter:parameters success:^(id response) {
        
        CZLog(@"%@",response);
        
        NSDictionary *dictionary = (NSDictionary *)response;
        self.timestamp = [[dictionary objectForKey:@"timestamp"] longLongValue];
        
        NSMutableArray * arr = [QCDiandiListModel mj_objectArrayWithKeyValuesArray:dictionary[@"list"]];
        self.modelArr = arr;
        [tableV reloadData];
        [tableV headerEndRefreshing];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
         [tableV headerEndRefreshing];
    }];
    
}

- (void)moreData{
    NSDictionary * parameters = @{@"timestamp":@(self.timestamp),@"type":@(2)};
    [NetworkManager requestWithURL:RECORD_GETRECORDLIST_URL parameter:parameters success:^(id response) {
        
        CZLog(@"%@",response);
        
        NSDictionary *dictionary = (NSDictionary *)response;
        self.timestamp = [[dictionary objectForKey:@"timestamp"] longLongValue];
        
        NSArray * moreArr = [QCDiandiListModel mj_objectArrayWithKeyValuesArray:dictionary[@"list"]];
        if (moreArr.count>0) {
            [self.modelArr addObjectsFromArray:moreArr];
            [tableV reloadData];
        }else{
            [OMGToast showText:@"已无更多数据"];
        }
        [tableV footerEndRefreshing];

    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [tableV footerEndRefreshing];
    }];
}


#pragma mark - 查看个人点滴数据
- (void)requestUserData{
    self.timestamp =[[NSDate date] timeIntervalSince1970]*1000;
    NSDictionary * parameters = @{@"timestamp":@(self.timestamp),@"type":@(2),@"destUid":self.uid};
    [NetworkManager requestWithURL:RECORD_RECORDOFMEMBER parameter:parameters success:^(id response) {
        
        NSDictionary *dictionary = (NSDictionary *)response;
        self.timestamp = [[dictionary objectForKey:@"timestamp"] longLongValue];
        
        NSMutableArray * arr = [QCDiandiListModel mj_objectArrayWithKeyValuesArray:dictionary[@"list"]];
        self.modelArr = arr;
        [tableV reloadData];
        [tableV headerEndRefreshing];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [tableV headerEndRefreshing];
    }];
}


- (void)moreUserData{
    NSDictionary * parameters = @{@"timestamp":@(self.timestamp),@"type":@(2),@"destUid":self.uid};
    [NetworkManager requestWithURL:RECORD_RECORDOFMEMBER parameter:parameters success:^(id response) {
        
        NSDictionary *dictionary = (NSDictionary *)response;
        self.timestamp = [[dictionary objectForKey:@"timestamp"] longLongValue];
        
        NSMutableArray * moreArr = [QCDiandiListModel mj_objectArrayWithKeyValuesArray:dictionary[@"list"]];
        if (moreArr.count>0) {
            [self.modelArr addObjectsFromArray:moreArr];
            [tableV reloadData];
        }else{
            [OMGToast showText:@"已无更多数据"];
        }
        [tableV footerEndRefreshing];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [tableV footerEndRefreshing];
    }];
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QCDiandiListCell *cell = [QCDiandiListCell cellWithTableView:tableView];
    
    
    
    CGRect rect = cell.frame;
    QCDiandiListModel*model=self.modelArr[indexPath.row];
    NSArray * tempArr = [model.coverUrl componentsSeparatedByString:@","];
    NSMutableArray *Arr =[tempArr mutableCopy];
    NSLog(@"Arr===%@",Arr);
    CGSize photosSize = [OkamiPhotoView photoViewSizeWithPictureCount:Arr.count];
    
//    NSString *str = Arr[0];
    if (Arr.count > 0 && [Arr[0] length] > 0) {
        rect.size.height = photosSize.height+257;
    }else{
        rect.size.height = 217;
    }
    
    cell.frame = rect;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.diandiListModel =self.modelArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QCDiandiDetailVC *VC = [[QCDiandiDetailVC alloc] init];
    VC.dianDi = self.modelArr[indexPath.row];
    [self.navigationController pushViewController:VC animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"cell height %f",cell.frame.size.height);
    
    return UITableViewAutomaticDimension;
    
    
    
}


@end
