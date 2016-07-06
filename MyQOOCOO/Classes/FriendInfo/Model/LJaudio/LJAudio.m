//
//  LJAudio.m
//  LJ个人项目
//
//  Created by lanou on 15/8/18.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "LJAudio.h"


@interface LJAudio()
{
    BOOL _isPlaying;// 标记是否正在播放
    BOOL _isPrepared;// 标记播放器是否准备完成
}

// 音乐播放器

@property (nonatomic, retain) NSTimer *timer;

@end

@implementation LJAudio

- (void)setAudioMetadataWithURL:(NSString *)urlString
{
    if (self.audioPlayer.currentItem) {
        [self.audioPlayer.currentItem removeObserver:self forKeyPath:@"status"];
    }
    // 根据指定的URL创建一个AVPlayerItem对象
    _isPlaying = YES;
    _isPrepared = NO;
    AVPlayerItem *currentItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:urlString]];
    [currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    // 根据给定的Item对象 替换音频播放器当前的item
    [self.audioPlayer replaceCurrentItemWithPlayerItem:currentItem];
}

// lazyLoding
- (AVPlayer*)audioPlayer
{
    if (!_audioPlayer) {
        self.audioPlayer = [[AVPlayer alloc] init] ;
    }
    return _audioPlayer;
}


+ (instancetype)sharedStreamer
{
    static LJAudio *streamer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        streamer = [[self alloc] init];
        
    });
    return streamer;
}

- (instancetype) init
{
    if (self= [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEndTimeNotifation:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

#pragma mark- audio Control
- (void)play
{
    if ([self isPrepared]  == YES) {
        [self.audioPlayer play];
        
    
        if (self.timer) {
            return;
        }
        //添加定时器来
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(handleTimerAction:) userInfo:nil repeats:YES];
        _isPlaying = YES;
    }
    
    
}



- (void)pause
{
    [self.audioPlayer pause];
    [self.timer invalidate];
    self.timer = nil;
    _isPlaying = NO;
}

- (void)stop
{
    // 设置播放器暂停然后进度跳到0秒
    [self pause];
    [self.audioPlayer seekToTime:CMTimeMake(0, self.audioPlayer.currentTime.timescale)];
}
- (void)setVolume:(float)volume
{
    
    self.audioPlayer.volume = volume;
}

- (float)volume
{
    return self.audioPlayer.volume;
}

- (float)totalTime
{
    return CMTimeGetSeconds([self.audioPlayer.currentItem duration]);
}

- (void)seekToTime:(float)time
{
    [self pause];
    [self.audioPlayer seekToTime:CMTimeMakeWithSeconds(time, self.audioPlayer.currentTime.timescale)];
    [self play];
}

- (void)handleTimerAction:(NSTimer *)sender
{
    if (self.delegate == nil) {
        
        return;
    }
    //
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioStramer:didPlayingWithProgress:)])
    {
        float progress = self.audioPlayer.currentTime.value / self.audioPlayer.currentTime.timescale;
        
        [self.delegate audioStramer:self didPlayingWithProgress:progress];
        self.totalTime = CMTimeGetSeconds([self.audioPlayer.currentItem duration]);
    }
}

- (void)handleEndTimeNotifation:(NSNotificationCenter*)notification
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioStramerDidFinishPlaying:)])
    {
        [self.delegate audioStramerDidFinishPlaying:self];
        
    }
}

- (BOOL)isPlaying
{
    
    return _isPlaying;
}

- (BOOL)isPrepared
{
    return _isPrepared;
}

- (BOOL)isPlayingCurrentAudioWithURL:(NSString *)urlString
{
    NSString *currentURLString = [(AVURLAsset *) self.audioPlayer.currentItem.asset URL].absoluteString;
    return [currentURLString isEqualToString:urlString];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    switch ([change[@"new"] integerValue]) {
        case AVPlayerItemStatusFailed:
            
            break;
        case AVPlayerItemStatusReadyToPlay:
            _isPrepared = YES;
            [self play];
            break;
        case AVPlayerItemStatusUnknown:
            break;
        default:
            break;
    }
}


@end
