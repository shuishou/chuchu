//
//  QCDoodleVC.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/20.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"
#import "QCTextView.h"
#import "QCDrawView.h"

@interface QCDoodleVC : QCBaseVC

@property (nonatomic , strong)QCTextView *contentField;
@property (nonatomic , strong)QCDrawView *drawView;

@end
