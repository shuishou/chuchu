//
//  QCDiandiDetailVC.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/11/3.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"
#import "QCDiandiListModel.h"
#import "QCDiandiReplyListModel.h"

@interface QCDiandiDetailVC : QCBaseVC

@property (nonatomic , strong)QCDiandiListModel *dianDi;

@property (nonatomic , strong)QCDiandiReplyListModel *commnet;

@end
