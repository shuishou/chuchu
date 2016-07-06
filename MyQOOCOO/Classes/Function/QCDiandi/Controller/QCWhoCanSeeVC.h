//
//  QCWhoCanSee1.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/10.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseTableVC.h"

@protocol QCWhoCanSeeVCDelegate <NSObject>
@optional
-(void)whoCanSeeWhitTypeIndex:(NSInteger)index;
@end
@interface QCWhoCanSeeVC : QCBaseTableVC

@property (nonatomic,weak) id <QCWhoCanSeeVCDelegate> delegate;

@property (nonatomic , strong)NSString *permissionString;

@end
