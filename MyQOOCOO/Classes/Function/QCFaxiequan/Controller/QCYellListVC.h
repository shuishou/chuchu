//
//  QCYellListVC.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/20.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"
#import "QCYellModel.h"
#import "QCYellListCell.h"

@interface QCYellListVC : QCBaseVC
@property (nonatomic , strong)QCYellModel *yellModel;

@property (nonatomic,copy) NSString * uid;

@end
