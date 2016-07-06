//
//  QCBaseTableVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/10.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseTableVC.h"

@interface QCBaseTableVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation QCBaseTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kGlobalBackGroundColor;
    _tableView = [[QCBaseTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.data = [NSMutableArray array];
    _tableView.dataSource = self;
    _tableView.backgroundColor = kGlobalBackGroundColor;
    [self.view addSubview:_tableView];
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
