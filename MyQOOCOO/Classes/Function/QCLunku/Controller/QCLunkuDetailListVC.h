//
//  QCLunkuDetailListVC.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/10/29.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCLunkuListModel.h"
#import "QCLunkuReplyListModel.h"
#define kLKCellClickNotification @"LKCellClickNotification"

@interface QCLunkuDetailListVC : UIViewController

@property (nonatomic,strong)QCLunkuListModel *lk;

@property (nonatomic , strong)QCLunkuReplyListModel *replyModel;

@property(nonatomic,assign)BOOL isFree;

@property(nonatomic,assign)BOOL isRoot;//是否是从贴标签跳转到详情

@end
