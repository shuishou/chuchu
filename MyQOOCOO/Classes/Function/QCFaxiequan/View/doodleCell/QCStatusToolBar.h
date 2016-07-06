//
//  QCToolBar.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/20.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QCDoodleStatus;
@protocol QCStatusToolBarDelegate <NSObject>
@optional
-(void)selfCommentBtnClick;
@end

@interface QCStatusToolBar : UIView

+(instancetype)toolBar;
@property (nonatomic , strong)QCDoodleStatus *qcStatus;
@property (nonatomic , strong)UIButton *agreeBtn;
@property (nonatomic , strong)UIButton *disgreeBtn;
@property (nonatomic , strong)UIButton *commentBtn;

//点击评论通知
@property (nonatomic,weak) id<QCStatusToolBarDelegate> delegate;

@end
