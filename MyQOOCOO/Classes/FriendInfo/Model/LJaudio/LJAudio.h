//
//  LJAudio.h
//  LJ个人项目
//
//  Created by lanou on 15/8/18.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class LJAudio;

@protocol LJAudioDelegate <NSObject>

@optional
- (void)audioStramer:(LJAudio *)stramer didPlayingWithProgress:(float)progress;

- (void)audioStramerDidFinishPlaying:(LJAudio *)streamer;

@end



@interface LJAudio : NSObject
@property (nonatomic, retain)AVPlayer *audioPlayer;

@property (nonatomic, assign) float volume;// 播放器的音量

@property (nonatomic, assign) id<LJAudioDelegate> delegate;

@property (nonatomic, assign) float totalTime;


// 单利方法
+ (instancetype)sharedStreamer;

// 播放、暂停、停止
- (void)play;

- (void)pause;

- (void)stop;

// 设置音频的URL

- (void)setAudioMetadataWithURL:(NSString *)urlString;

- (void)seekToTime:(float)time;// 跳转到指定的时间播放

- (BOOL)isPlaying;// 判断是否正在播放
- (BOOL)isPrepared;// 判断是否准备完成
- (BOOL)isPlayingCurrentAudioWithURL:(NSString *)urlString;// 判断是否正在播放指定的URL


@end
