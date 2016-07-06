
//
//  myCell.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/24.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "myInterestCell.h"

@implementation myInterestCell

+ (instancetype)myCellWithTableView:(UITableView *) tableView
{
    static NSString *ID = @"myInterestCell";
    
    //  检测缓冲池有没有空闲cell
    myInterestCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //  如果没哟创建新的
    if (cell == nil) {
        cell  = [NSBundle loadNibNamedFrom:@"myInterestCell"];
    }
    
    return cell;
}

@end
