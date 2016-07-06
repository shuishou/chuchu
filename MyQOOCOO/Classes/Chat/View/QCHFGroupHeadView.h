//
//  QCHFGroupHeadView.h
//  MyQOOCOO
//
//  Created by Wind on 15/12/7.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QCHFGroupHeadViewDelegate;

@interface QCHFGroupHeadView : UIView{
    id<QCHFGroupHeadViewDelegate>__unsafe_unretained _delegate;//代理
    NSInteger section;
    UIButton* backBtn;
    UILabel * titleLabel;
    BOOL open;
}
@property(nonatomic, assign) id<QCHFGroupHeadViewDelegate> delegate;
@property(nonatomic, assign) NSInteger section;
@property(nonatomic, assign) BOOL open;
@property(nonatomic, retain) UIButton* backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@end

@protocol QCHFGroupHeadViewDelegate <NSObject>
-(void)selectedWith:(QCHFGroupHeadView *)view;
@end
