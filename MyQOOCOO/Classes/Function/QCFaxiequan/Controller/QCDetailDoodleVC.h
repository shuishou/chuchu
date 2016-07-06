//
//  QCDetailVCViewController.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/21.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"
#import "QCDoodleStatus.h"
#import "QCCommentToolBar.h"

@interface QCDetailDoodleVC : QCBaseTableVC

@property (nonatomic,strong)QCDoodleStatus *qcStatus;

@property (nonatomic,strong)QCCommentToolBar *toolbar;

@end
