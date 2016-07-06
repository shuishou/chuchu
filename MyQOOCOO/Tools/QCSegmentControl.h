//
//  QCSegmentControl.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/31.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QCSegmentControl;
@protocol QCSegmentControlDelegate <NSObject>

-(void)segmentControll:(QCSegmentControl *)aSegment selectItem:(NSInteger)index;

@end
@interface QCSegmentControl : UIView
{
    UIImageView *line;
    float itemW;
    float itemH;
    float lineW;
}
-(instancetype)initWithFrame:(CGRect)frame withItmesName:(NSArray *)items;

@property (assign,nonatomic)UIColor * selectColor;
@property (assign,nonatomic)UIColor * normalColor;
@property (assign,nonatomic)NSInteger currentItem;
@property (assign,nonatomic)id<QCSegmentControlDelegate> delegate;
@property (assign,nonatomic)BOOL hideLine;

@end
