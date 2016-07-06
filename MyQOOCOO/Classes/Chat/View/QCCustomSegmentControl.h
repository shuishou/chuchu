//
//  QCSegmentController.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/28.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QCCustomSegmentControl;

@protocol QCSegmentControlDelegate <NSObject>

-(void)segmented:(UIView *)btn selectedFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface QCCustomSegmentControl : UIView
@property (nonatomic,weak) id<QCSegmentControlDelegate> delegate;

@end
