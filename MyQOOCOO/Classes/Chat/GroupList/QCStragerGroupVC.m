//
//  QCStragerGroupVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/24.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCStragerGroupVC.h"
#import "QCFriendCell.h"
#import "QCChatViewController.h"
//个人信息
#import "QCFriendInfoVC.h"

@interface QCStragerGroupVC ()<QCFriendCellDelegate>
{
    QCBaseTableView *_tableView;
}

@end

@implementation QCStragerGroupVC


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"陌生人";
    //创建tableView
    _tableView = [[QCBaseTableView alloc]initWithFrame:CGRectMake(0, 64, Main_Screen_Width,SCREEN_H - 64 -44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.data = [[NSMutableArray alloc]init];
    _tableView.backgroundColor = [UIColor clearColor];
    //    _tableView.separatorColor = kSeparatorColor;
    
    [self.view addSubview:_tableView];
    
    
    
}
#pragma mark - 实现cell按钮点击的代理方法
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
    QCFriendCell *cell = (QCFriendCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!cell) {
        cell = [[QCFriendCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    //实现cell,avatar的点击事件
    cell.tag = indexPath.row;
    cell.delegate = self;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QCChatViewController *singleChatVC = [[QCChatViewController alloc]init];
    [self.navigationController pushViewController:singleChatVC animated:YES];
}
@end
