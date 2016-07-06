//
//  QCLKCommentTableView.m
//  MyQOOCOO
//
//  Created by 贤荣 on 15/12/26.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCLKCommentTableView.h"
#import "QCLKCommentCellTableViewCell.h"
#import "OkamiPhotoView.h"

#define kLKCellClickNotification @"LKCellClickNotification"
#define kLKCellClickNotification2 @"LKCellClickNotification2"

@interface QCLKCommentTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation QCLKCommentTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    self.rowHeight = UITableViewAutomaticDimension;
    self.estimatedRowHeight = 2;
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rowHeight = 100;
        
    }
    return self;
}


#pragma mark - tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QCLKCommentCellTableViewCell *cell = [QCLKCommentCellTableViewCell cellWithTableView:tableView];
    CGRect rect = cell.frame;
    QCLunkuListModel *model = self.arr[indexPath.row];
    NSArray *tempArr = [model.image componentsSeparatedByString:@","];
    NSMutableArray *Arr = [tempArr mutableCopy];
    CGSize photosSize = [OkamiPhotoView photoViewSizeWithPictureCount:Arr.count];
    
    NSString *str = Arr[0];
    if (![str isEqualToString:@""]) {
        rect.size.height = photosSize.height+206;
    }else{
        rect.size.height = 206;
    }
    cell.frame = rect;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lk = model;
//    NSLog(@"model.commentCount===%d",model.commentCount);
    cell.icon.userInteractionEnabled = YES;
    cell.icon.tag = indexPath.row;
    [cell.icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTap:)]];
    cell.isFree = self.isfree;

    return cell;
}

-(void)iconTap:(UITapGestureRecognizer *)gesture{
    QCLunkuListModel *model = self.arr[gesture.view.tag];
    NSDictionary *dict = @{@"model":@(model.uid)};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"lunkuIconTap" object:self userInfo:dict];
}

#pragma mark - tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QCLunkuListModel *lk = self.arr[indexPath.row];
    if (self.isfree) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kLKCellClickNotification2 object:nil userInfo:@{@"model":lk}];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:kLKCellClickNotification object:nil userInfo:@{@"model":lk}];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"cell height %f",cell.frame.size.height);
    
    return UITableViewAutomaticDimension;
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"keyBord" object:nil userInfo:nil];
}


@end
