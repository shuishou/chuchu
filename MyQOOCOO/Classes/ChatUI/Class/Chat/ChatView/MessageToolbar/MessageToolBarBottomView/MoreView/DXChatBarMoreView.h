/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>

typedef enum{
    ChatMoreTypeChat,
    ChatMoreTypeGroupChat,
}ChatMoreType;

@protocol DXChatBarMoreViewDelegate;
@interface DXChatBarMoreView : UIView

@property (nonatomic,assign) id<DXChatBarMoreViewDelegate> delegate;

@property (nonatomic, strong) UIButton *faceButton;
@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UIButton *takePicButton;
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *audioCallButton;
@property (nonatomic, strong) UIButton *videoCallButton;

/**
 *  表情的附加页面
 */
@property (strong, nonatomic) UIView *faceView;
@property (strong, nonatomic) UIView *activityButtomView;//当前活跃的底部扩展页面


- (instancetype)initWithFrame:(CGRect)frame type:(ChatMoreType)type;

- (void)setupSubviewsForType:(ChatMoreType)type;

@end

@protocol DXChatBarMoreViewDelegate <NSObject>

@required
- (void)moreViewFaceAction:(DXChatBarMoreView *)moreView;
- (void)moreViewTakePicAction:(DXChatBarMoreView *)moreView;
- (void)moreViewPhotoAction:(DXChatBarMoreView *)moreView;
- (void)moreViewLocationAction:(DXChatBarMoreView *)moreView;
- (void)moreViewAudioCallAction:(DXChatBarMoreView *)moreView;
- (void)moreViewVideoAction:(DXChatBarMoreView *)moreView;

@end
