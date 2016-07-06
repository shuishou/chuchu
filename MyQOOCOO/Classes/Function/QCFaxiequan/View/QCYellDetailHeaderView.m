//
//  QCYellDetailHeaderView.m
//  MyQOOCOO
//
//  Created by 贤荣 on 15/12/22.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCYellDetailHeaderView.h"
#import <AVFoundation/AVFoundation.h>
@interface QCYellDetailHeaderView ()
{
    AVAudioPlayer *_player;
}
@property (weak, nonatomic) IBOutlet UIView *bgV;

@property (weak, nonatomic) IBOutlet UIView *voiceBg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIImageView *animaPic;

- (IBAction)playBtnClick;

@end


@implementation QCYellDetailHeaderView

+(instancetype)headerView{
    return [[[NSBundle mainBundle]loadNibNamed:@"QCYellDetailHeaderView" owner:nil options:nil]lastObject];
}

-(void)awakeFromNib{
    
    self.bgV.layer.cornerRadius = 8;
    self.bgV.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 22;
    self.icon.layer.masksToBounds = YES;
    self.voiceBg.layer.cornerRadius = 8;
    self.voiceBg.layer.masksToBounds = YES;
}

-(void)setYellModel:(QCYellModel *)yellModel{
    _yellModel = yellModel;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:yellModel.user.avatar] placeholderImage:[UIImage imageNamed:@"ios-template-1024(1)"]];
    
    self.name.text = yellModel.user.nickname;
  
    NSString *timeString = yellModel.createTime;
    self.time.text = timeString;
    
//    NSString *timeS;
//    if (yellModel.durations<60) {
//        timeS = [NSString stringWithFormat:@"%d秒",yellModel.durations];
//    }else{
//        float  time = yellModel.durations/60.0;
//        timeS = [NSString stringWithFormat:@"%.1f分",time];
//    }
//    [self.playBtn setTitle:timeS  forState:UIControlStateNormal];
    
    NSString *content;
    if (fabsf((float)yellModel.durations) > 0) {
        content = [NSString stringWithFormat:@"%.0f分",fabsf((float)yellModel.durations)];
    }else{
        content = @"0分";
    }
    NSLog(@"content=====%@,fabsf(yellModel.contentBei)====%.0f",content,fabsf((float)yellModel.durations));
    [self.playBtn setTitle:content  forState:UIControlStateNormal];
    
}


- (IBAction)playBtnClick {
    
    [self playAnimationWithDuration:self.yellModel.durations andImageCount:25];
    
    //     CZLog(@"%@",self.yellModel.fileUrl);
    //    下载了再播放
    [self fileDownlowdUseAFN];
}

//  下载播放音频
-(void)fileDownlowdUseAFN{
    NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *sessionMan = [[AFURLSessionManager alloc] initWithSessionConfiguration:cfg];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.yellModel.fileUrl]];
    
    NSURLSessionDownloadTask *dowloadTask = [sessionMan downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        // 2.文件保存的路径
        NSString *fileName = [NSUUID UUID].UUIDString;
        NSString *filePath = [cachesPath stringByAppendingPathComponent:fileName];
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        //        CZLog(@"%@",filePath);
        
        if (_player.playing) {
            [_player stop];
            return;
        }
        NSError *errorr = nil;
        NSData * data = [NSData dataWithContentsOfURL:filePath];
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data  error:&errorr];
        if (errorr) {
            CZLog(@"%@",errorr);
        }
        
        //先缓存一些音频数据到内存
        [player prepareToPlay];
        _player = player;
        [player play];
        
        if (error) {
            [OMGToast showText:@"网络异常"];
            CZLog(@"%@",error);
        }
    }];
    // 执行下载的任务
    [dowloadTask resume];
}

#pragma mark - 播放帧动画
- (void) playAnimationWithDuration:(double)duration andImageCount:(int) imageCount
{
    //  判断当前是否正在执行动画
    if (self.animaPic.isAnimating) {
        return;
    }
    // 1.准备播放帧动画所使用图片，大图用imageWithContentsOfFile:
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:imageCount];
    for (int i = 0; i < imageCount; i++) {
        NSString *name = [NSString stringWithFormat:@"voice_000%02d",i];
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
        UIImage *image  = [UIImage imageWithContentsOfFile:path];
        if (image) {
           [images addObject:image];
        }
       
    }
    //  2、赋值
    self.animaPic.animationImages = images;
    //  设置动画持续的时间 Duration持续时间
    self.animaPic.animationDuration = duration;
    //  设置播放动画持续次数 Repeat 重复
    self.animaPic.animationRepeatCount = 1;
    // 3.开始执行动画
    [self.animaPic startAnimating];
    
    //    //等动画执行完毕后，再释放调图片内存
    //    [self.anmiPic performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:self.anmiPic.animationDuration+0.01];
}


@end
