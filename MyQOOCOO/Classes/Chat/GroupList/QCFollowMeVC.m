//
//  QCFollowMe.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/24.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCFollowMeVC.h"
#import "QCFriendCell.h"
#import "QCSingleChatVc.h"
#import "QCFriendInfoVC.h"

@interface QCFollowMeVC ()<QCFriendCellDelegate>
{
    QCBaseTableView *_tableView;
}

@end

@implementation QCFollowMeVC


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"关注我的好友";
    //创建tableView
    _tableView = [[QCBaseTableView alloc]initWithFrame:CGRectMake(0, 64, Main_Screen_Width,SCREEN_H - 64 -44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.data = [[NSMutableArray alloc]init];
    _tableView.backgroundColor = [UIColor clearColor];
    //    _tableView.separatorColor = kSeparatorColor;
    
    [self.view addSubview:_tableView];
    
    
    
}
#pragma mark - 实现点击cell头像的功能
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

@end
