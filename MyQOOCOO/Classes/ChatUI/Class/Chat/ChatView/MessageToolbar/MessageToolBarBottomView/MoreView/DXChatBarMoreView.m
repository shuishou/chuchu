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

#import "DXChatBarMoreView.h"

#define CHAT_BUTTON_SIZE 50
#define INSETS 8

@implementation DXChatBarMoreView

- (instancetype)initWithFrame:(CGRect)frame type:(ChatMoreType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviewsForType:type];
    }
    return self;
}

- (void)setupSubviewsForType:(ChatMoreType)type
{
    self.backgroundColor = [UIColor clearColor];
    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
    
    _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_faceButton setFrame:CGRectMake(insets, 20, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_faceButton setImage:[UIImage imageNamed:@"组-12"] forState:UIControlStateNormal];
    //    在UIButton中有三个对EdgeInsets的设置：ContentEdgeInsets、titleEdgeInsets、imageEdgeInsets
    //设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    _faceButton.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,_faceButton.titleLabel.bounds.size.width);
    //设置button的title
    [_faceButton setTitle:@"表情" forState:UIControlStateNormal];
    //title字体大小
    _faceButton.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(_faceButton)/4];
    //设置title的字体居中
    _faceButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    //设置title在一般情况下为白色字体
    [_faceButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    //设置title在button被选中情况下为灰色字体
    [_faceButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //设置title在button上的位置（上top，左left，下bottom，右right）
    _faceButton.titleEdgeInsets = UIEdgeInsetsMake(71, -_faceButton.titleLabel.bounds.size.width-50, 0, 0);
    
    //    [button setContentEdgeInsets:UIEdgeInsetsMake(70, 0, 0, 0)];//
    //设置button的内容横向居中。。设置content是title和image一起变化
    _faceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_faceButton addTarget:self action:@selector(faceAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_faceButton];
    
    _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_photoButton setFrame:CGRectMake(insets, 20, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_photoButton setImage:[UIImage imageNamed:@"组-13"] forState:UIControlStateNormal];
    //设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    _photoButton.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,_photoButton.titleLabel.bounds.size.width);
    //设置button的title
    [_photoButton setTitle:@"图片" forState:UIControlStateNormal];
    //title字体大小
    _photoButton.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(_photoButton)/4];
    //设置title的字体居中
    _photoButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    //设置title在一般情况下为白色字体
    [_photoButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    //设置title在button被选中情况下为灰色字体
    [_photoButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //设置title在button上的位置（上top，左left，下bottom，右right）
    _photoButton.titleEdgeInsets = UIEdgeInsetsMake(71, -_photoButton.titleLabel.bounds.size.width-50, 0, 0);
    
    //    [button setContentEdgeInsets:UIEdgeInsetsMake(70, 0, 0, 0)];//
    //设置button的内容横向居中。。设置content是title和image一起变化
    _photoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_photoButton];
    
    _takePicButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_takePicButton setFrame:CGRectMake( insets * 2 + CHAT_BUTTON_SIZE, 20, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_takePicButton setImage:[UIImage imageNamed:@"组-14"] forState:UIControlStateNormal];
    //设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    _takePicButton.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,_takePicButton.titleLabel.bounds.size.width);
    //设置button的title
    [_takePicButton setTitle:@"相机" forState:UIControlStateNormal];
    //title字体大小
    _takePicButton.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(_takePicButton)/4];
    //设置title的字体居中
    _takePicButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    //设置title在一般情况下为白色字体
    [_takePicButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    //设置title在button被选中情况下为灰色字体
    [_takePicButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //设置title在button上的位置（上top，左left，下bottom，右right）
    _takePicButton.titleEdgeInsets = UIEdgeInsetsMake(71, -_takePicButton.titleLabel.bounds.size.width-50, 0, 0);
    //    [button setContentEdgeInsets:UIEdgeInsetsMake(70, 0, 0, 0)];//
    //设置button的内容横向居中。。设置content是title和image一起变化
    _takePicButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_takePicButton];

    CGRect frame = self.frame;
//    if (type == ChatMoreTypeChat) {
        frame.size.height = 200;
        
        _locationButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_locationButton setFrame:CGRectMake( insets * 3 + CHAT_BUTTON_SIZE * 2 , 20, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_locationButton setImage:[UIImage imageNamed:@"组-15"] forState:UIControlStateNormal];
        //设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        _locationButton.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,_locationButton.titleLabel.bounds.size.width);
        //设置button的title
        [_locationButton setTitle:@"位置" forState:UIControlStateNormal];
        //title字体大小
        _locationButton.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(_locationButton)/4];
        //设置title的字体居中
        _locationButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        //设置title在一般情况下为白色字体
        [_locationButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        //设置title在button被选中情况下为灰色字体
        [_locationButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        //设置title在button上的位置（上top，左left，下bottom，右right）
        _locationButton.titleEdgeInsets = UIEdgeInsetsMake(71, -_locationButton.titleLabel.bounds.size.width-50, 0, 0);
        //    [button setContentEdgeInsets:UIEdgeInsetsMake(70, 0, 0, 0)];//
        //设置button的内容横向居中。。设置content是title和image一起变化
        _locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_locationButton];
        
        _videoCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_videoCallButton setFrame:CGRectMake(insets * 4 + CHAT_BUTTON_SIZE * 3 , 10 * 2 , CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_videoCallButton setImage:[UIImage imageNamed:@"组-18"] forState:UIControlStateNormal];
        //设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        _videoCallButton.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,_videoCallButton.titleLabel.bounds.size.width);
        //设置button的title
        [_videoCallButton setTitle:@"视频" forState:UIControlStateNormal];
        //title字体大小
        _videoCallButton.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(_videoCallButton)/4];
        //设置title的字体居中
        _videoCallButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        //设置title在一般情况下为白色字体
        [_videoCallButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        //设置title在button被选中情况下为灰色字体
        [_videoCallButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        //设置title在button上的位置（上top，左left，下bottom，右right）
        _videoCallButton.titleEdgeInsets = UIEdgeInsetsMake(71, -_videoCallButton.titleLabel.bounds.size.width-50, 0, 0);
        //    [button setContentEdgeInsets:UIEdgeInsetsMake(70, 0, 0, 0)];//
        //设置button的内容横向居中。。设置content是title和image一起变化
        _videoCallButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_videoCallButton addTarget:self action:@selector(takeVideoCallAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_videoCallButton];
        
        _audioCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_audioCallButton setFrame:CGRectMake(insets , 10 * 2 + CHAT_BUTTON_SIZE + 35, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_audioCallButton setImage:[UIImage imageNamed:@"组-17"] forState:UIControlStateNormal];
        //设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        _audioCallButton.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,_audioCallButton.titleLabel.bounds.size.width);
        //设置button的title
        [_audioCallButton setTitle:@"快捷回复" forState:UIControlStateNormal];
        //title字体大小
        _audioCallButton.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(_audioCallButton)/4];
        //设置title的字体居中
        _audioCallButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        //设置title在一般情况下为白色字体
        [_audioCallButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        //设置title在button被选中情况下为灰色字体
        [_audioCallButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        //设置title在button上的位置（上top，左left，下bottom，右right）
        _audioCallButton.titleEdgeInsets = UIEdgeInsetsMake(71, -_audioCallButton.titleLabel.bounds.size.width-50, 0, 0);
        //    [button setContentEdgeInsets:UIEdgeInsetsMake(70, 0, 0, 0)];//
        //设置button的内容横向居中。。设置content是title和image一起变化
        _audioCallButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_audioCallButton addTarget:self action:@selector(takeAudioCallAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_audioCallButton];
//    }
//    else if (type == ChatMoreTypeGroupChat)
//    {
//        frame.size.height = 180;
//    }
    self.frame = frame;
}

#pragma mark - action
- (void)faceAction
{
//    if(_delegate && [_delegate respondsToSelector:@selector(moreViewFaceAction:)]){
//        [_delegate moreViewFaceAction:self];
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HFFaceView" object:@"1"];
}

- (void)takePicAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)locationAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}

- (void)takeAudioCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
        [_delegate moreViewAudioCallAction:self];
    }
}

- (void)takeVideoCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewVideoAction:)]) {
        [_delegate moreViewVideoAction:self];
    }
}

@end
