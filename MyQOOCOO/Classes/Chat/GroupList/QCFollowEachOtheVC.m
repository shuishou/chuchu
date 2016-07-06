//
//  QCFollowEachOtherViewController.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/24.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCFollowEachOtheVC.h"
#import "QCFriendCell.h"
#import "QCSingleChatVc.h"
#import "QCFriendInfoVC.h"

@interface QCFollowEachOtheVC ()<QCFriendCellDelegate>
{
    QCBaseTableView *_tableView;
}

@end

@implementation QCFollowEachOtheVC


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"相互关注的好友";
    //创建tableView
    _tableView = [[QCBaseTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.data = [[NSMutableArray alloc]init];
    _tableView.backgroundColor = [UIColor clearColor];
    //    _tableView.separatorColor = kSeparatorColor;
    
    [self.view addSubview:_tableView];
    
    
    
}
#pragma mark - 实现cell头像点击的代理
-(void)clickAvatar:(UIButton *)btn{
    QCFriendInfoVC *friendInfoVC = [[QCFriendInfoVC alloc]init];
    [self.navigationController pushViewController:friendInfoVC animated:YES];
    
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
    QCFriendCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!cell) {
        cell = [[QCFriendCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    //实现cell头像点击的代理
    cell.tag = indexPath.row;
    cell.delegate = self;
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QCSingleChatVc *singleChatVC = [[QCSingleChatVc alloc]init];
    [self.navigationController pushViewController:singleChatVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


@end
