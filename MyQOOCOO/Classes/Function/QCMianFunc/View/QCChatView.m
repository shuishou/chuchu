//
//  QCChatView.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/21.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCChatView.h"

@interface QCChatView() <UITableViewDelegate,UITableViewDataSource>

@end

@implementation QCChatView





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"chatCell";
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewStyleGrouped;
    cell.textLabel.text = [NSString stringWithFormat:@"聊天 - Row %zd",  indexPath.row];
    return cell;
}

#pragma mark - 实现选中的代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    QCChatController *oneChat = [[QCChatController alloc]init];
//    [self.navigationController pushViewController:oneChat animated:YES] ;
    
    
}

@end
