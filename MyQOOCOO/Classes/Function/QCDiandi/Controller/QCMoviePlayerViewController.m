//
//  QCMoviePlayerViewController.m
//  MyQOOCOO
//
//  Created by 贤荣 on 16/1/8.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCMoviePlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface QCMoviePlayerViewController ()
@property (nonatomic,strong) MPMoviePlayerController * movieContr;
@end

@implementation QCMoviePlayerViewController

-(NSURL *)videoURL{
    // 提示开发者
    // 断言
    NSAssert(_videoURL != nil, @"请设置videoURL,此属性不能为空");
    return _videoURL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.创建媒体播放器
    MPMoviePlayerController *movieContr = [[MPMoviePlayerController alloc] initWithContentURL:self.videoURL];
    self.movieContr = movieContr;
    
    // 对播放视频的view进行一个旋转的适配
    // FlexibleWidth 宽度可以伸缩
    // FlexibleHeight 高度可以伸缩
    movieContr.view.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    
    // 设置 媒体播放器的frame
    movieContr.view.frame = self.view.bounds;
    
    // 2.把 “媒体播放器” 里view属性，添加到当前的控制器view上
    [self.view addSubview:movieContr.view];
    
    // 设置播放界面按钮事件监听
    [self setupNotification];
    
    // 开始播放
    [movieContr play];
}

#pragma mark 设置播放界面按钮事件监听
-(void)setupNotification{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //1.监听播放，上一个，下一个按钮事件
    [center addObserver:self selector:@selector(playbackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    //2.监听播放完成
    [center addObserver:self selector:@selector(movieFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    //3.监听Done事件
    [center addObserver:self selector:@selector(movieFinished) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    
    //4.视频截屏
    //    MPMovieTimeOptionNearestKeyFrame,接近时间
    //    MPMovieTimeOptionExact ,精确时间,比较精确是耗性能
    if (self.imagesAtTimes.count != 0) {
        [self.movieContr requestThumbnailImagesAtTimes:self.imagesAtTimes timeOption:MPMovieTimeOptionExact];
        
        //通过通知来获取截屏数据
        [center addObserver:self selector:@selector(captureImg:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
        
    }
    
}

/**
 *  截屏
 *
 */
-(void)captureImg:(NSNotification *)noti{
    NSLog(@"%@",noti.userInfo);
    
    if ([self.delegate respondsToSelector:@selector(moviePlayerViewController:didFinishedCaptureImage:)]) {
        UIImage *img = noti.userInfo[MPMoviePlayerThumbnailImageKey];
        [self.delegate moviePlayerViewController:self didFinishedCaptureImage:img];
        
    }
}

-(void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)playbackStateChange:(NSNotification *)noti{
    
    //    MPMoviePlaybackStateStopped,//停止
    //    MPMoviePlaybackStatePlaying,//播放
    //    MPMoviePlaybackStatePaused,//暂停
    //    MPMoviePlaybackStateInterrupted,//中断
    //    MPMoviePlaybackStateSeekingForward,//前进，下一个
    //    MPMoviePlaybackStateSeekingBackward //后退 上一个
    NSLog(@"%ld",self.movieContr.playbackState);
    switch (self.movieContr.playbackState) {
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止");
            break;
            
        case MPMoviePlaybackStatePlaying:
            NSLog(@"播放");
            break;
        default:
            break;
    }
}

/**
 *  视频播放结束
 */
-(void)movieFinished{
    NSLog(@"%s",__func__);
    //结束当前控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
