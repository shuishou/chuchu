//
//  QCUndeterminedGroupVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/24.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCUndeterminedGroupVC.h"
#import "QCFriendCell.h"
#import "QCEditFriendCell.h"
#import "QCChatViewController.h"

@interface QCUndeterminedGroupVC ()
{
    QCBaseTableView *_tableView;
}

@end

@implementation QCUndeterminedGroupVC


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"待定";
    //创建tableView
    _tableView = [[QCBaseTableView alloc]initWithFrame:CGRectMake(0, 64, Main_Screen_Width,SCREEN_H - 64 -44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.data = [[NSMutableArray alloc]init];
    _tableView.backgroundColor = [UIColor clearColor];
    //    _tableView.separatorColor = kSeparatorColor;
    
    [self.view addSubview:_tableView];
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

#pragma mark - datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
#pragma mark - tableViewdelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"FriendCell";
    QCEditFriendCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!cell) {
        cell = [[QCEditFriendCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QCChatViewController *singleChatVC = [[QCChatViewController alloc]init];
    [self.navigationController pushViewController:singleChatVC animated:YES];
}

@end
