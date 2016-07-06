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

#import "EMChatBaseBubbleView.h"

#define ANIMATION_IMAGEVIEW_SIZE 25 // 小喇叭图片尺寸
#define ANIMATION_IMAGEVIEW_SPEED 1 // 小喇叭动画播放速度


#define ANIMATION_TIME_IMAGEVIEW_PADDING 5 // 时间与动画间距


#define ANIMATION_TIME_LABEL_WIDHT 30 // 时间宽度
#define ANIMATION_TIME_LABEL_HEIGHT 15 // 时间高度
#define ANIMATION_TIME_LABEL_FONT_SIZE 14 // 时间字体

// 发送
#define SENDER_ANIMATION_IMAGEVIEW_IMAGE_DEFAULT @"chatto_voice_playing" // 小喇叭默认图片
#define SENDER_ANIMATION_IMAGEVIEW_IMAGE_01 @"chat_sender_audio_playing_000" // 小喇叭动画第一帧
#define SENDER_ANIMATION_IMAGEVIEW_IMAGE_02 @"chatto_voice_playing_f1" // 小喇叭动画第二帧
#define SENDER_ANIMATION_IMAGEVIEW_IMAGE_03 @"chatto_voice_playing_f2" // 小喇叭动画第三帧
#define SENDER_ANIMATION_IMAGEVIEW_IMAGE_04 @"chatto_voice_playing_f3" // 小喇叭动画第四帧

 
// 接收
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_DEFAULT @"chatfrom_voice_playing_f3" // 小喇叭默认图片
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_01 @"voice_00000" // 小喇叭动画第一帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_02 @"voice_00001" // 小喇叭动画第二帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_03 @"voice_00002" // 小喇叭动画第三帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_04 @"voice_00003" // 小喇叭动画第四帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_05 @"voice_00004" // 小喇叭动画第一帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_06 @"voice_00005" // 小喇叭动画第二帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_07 @"voice_00006" // 小喇叭动画第三帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_08 @"voice_00007" // 小喇叭动画第四帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_09 @"voice_00008" // 小喇叭动画第一帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_10 @"voice_00009" // 小喇叭动画第二帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_11 @"voice_00010" // 小喇叭动画第三帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_12 @"voice_00011" // 小喇叭动画第四帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_13 @"voice_00012" // 小喇叭动画第一帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_14 @"voice_00013" // 小喇叭动画第二帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_15 @"voice_00014" // 小喇叭动画第三帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_16 @"voice_00015" // 小喇叭动画第四帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_17 @"voice_00016" // 小喇叭动画第一帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_18 @"voice_00017" // 小喇叭动画第二帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_19 @"voice_00018" // 小喇叭动画第三帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_20 @"voice_00019" // 小喇叭动画第四帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_21 @"voice_00020" // 小喇叭动画第四帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_22 @"voice_00021" // 小喇叭动画第一帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_23 @"voice_00022" // 小喇叭动画第二帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_24 @"voice_00023" // 小喇叭动画第三帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_25 @"voice_00024" // 小喇叭动画第四帧

extern NSString *const kRouterEventAudioBubbleTapEventName;

@interface EMChatAudioBubbleView : EMChatBaseBubbleView
{
    UIImageView *_animationImageView; // 动画的ImageView
    UILabel *_timeLabel; // 时间label
}

-(void)startAudioAnimation;
-(void)stopAudioAnimation;

@end
