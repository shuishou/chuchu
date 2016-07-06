//
//  QCYellListCell.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/11/2.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCYellListCell.h"
#import "NSString+Common.h"
#import <AVFoundation/AVFoundation.h>

#import "RecordAudio.h"
@interface QCYellListCell ()
{
    AVAudioPlayer *_player;
    AVPlayer * avPlayer;
}

@property (weak, nonatomic) IBOutlet UIView *cellBgView;


@property (strong, nonatomic) IBOutlet UILabel *nickName;//昵称
@property (strong, nonatomic) IBOutlet UILabel *sendTime;//发送时间
@property (strong, nonatomic) IBOutlet UIView *playBackground;//背景
@property (strong, nonatomic) IBOutlet UIButton *playBtn;//播放按钮
- (IBAction)playBtnClick;

@property (weak, nonatomic) IBOutlet UIImageView *anmiPic;//声音动画图片

//点赞
- (IBAction)DZBtnClick;
@property (weak, nonatomic) IBOutlet UIButton *DZBtn;
@property (weak, nonatomic) IBOutlet UILabel *DZLabel;

//点黑
- (IBAction)DHBtnClick;
@property (weak, nonatomic) IBOutlet UIButton *DHBtn;
@property (weak, nonatomic) IBOutlet UILabel *DHLabel;

//评论
- (IBAction)commentBtnClick;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (nonatomic,assign) BOOL praise;//记录点赞

@property (nonatomic,assign) BOOL press;//记录点黑

@end

@implementation QCYellListCell

+(instancetype)collectTableViewCellWithTableView:(UITableView *)tableView{
    
    static NSString *reuseId = @"QCYellListCell";
    QCYellListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"QCYellListCell" owner:nil options:nil]lastObject];
    }
    return cell;
    
}

- (void)awakeFromNib {
    
    self.cellBgView.layer.cornerRadius = 8;
    self.cellBgView.layer.masksToBounds = YES;
    
    //  头像
    self.avatar.layer.cornerRadius = 22;
    self.avatar.layer.masksToBounds = YES;
    _avatar.userInteractionEnabled = YES;
    UITapGestureRecognizer *avatartap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatarpush)];
    [self.avatar addGestureRecognizer:avatartap];

    
    // 播放背景
    _playBackground.layer.cornerRadius = 8;
    _playBackground.layer.masksToBounds = YES;
}


-(void)setYellModel:(QCYellModel *)yellModel{
        _yellModel = yellModel;
    NSMutableDictionary *dict = [yellModel mj_keyValues];
    NSLog(@"dict====%@",dict);
//    1、头像
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:yellModel.user.avatar] placeholderImage:[UIImage imageNamed:@"ios-template-1024(1)"]];
    
    //2、昵称
    self.nickName.text = yellModel.user.nickname;
    
    //3、发送时间
    NSString *timeString = yellModel.createTime;
    self.sendTime.text = timeString;
    
//   4、音频时长
//    NSString *timeS;
//    if (yellModel.durations<60) {
//       timeS = [NSString stringWithFormat:@"%d秒",yellModel.durations];
//    }else{
//        float  time = yellModel.durations/60.0;
//        timeS = [NSString stringWithFormat:@"%.1f分",time];
//    }
//    [self.playBtn setTitle:timeS  forState:UIControlStateNormal];
    
    
    
    NSString *content;
    if (fabsf((float)yellModel.contentBei) > 0) {
        content = [NSString stringWithFormat:@"%.0f分",fabsf((float)yellModel.contentBei)];
    }else{
        content = @"0分";
    }
    NSLog(@"content=====%@,fabsf(yellModel.contentBei)====%.0f",content,fabsf((float)yellModel.contentBei));
    [self.playBtn setTitle:content forState:UIControlStateNormal];
    
//    5、点赞数
    self.DZLabel.text = [NSString stringWithFormat:@"%d",yellModel.praiseCount];
    if (yellModel.hasPraise) {
        [self.DZBtn setImage:[UIImage imageNamed:@"but_like_pre"] forState:UIControlStateNormal];
        self.praise= YES;
    }else{
        [self.DZBtn setImage:[UIImage imageNamed:@"but_like"] forState:UIControlStateNormal];
        self.praise= NO;
    }
    
//    6、点黑
    self.DHLabel.text = [NSString stringWithFormat:@"%d",yellModel.pressCount];
    if (yellModel.hasPress) {
        [self.DHBtn setImage:[UIImage imageNamed:@"but_dislike_pre"] forState:UIControlStateNormal];
        self.press= YES;
    }else{
        [self.DHBtn setImage:[UIImage imageNamed:@"but_dislike"] forState:UIControlStateNormal];
        self.press= NO;
    }
    
//    7、评论
    self.commentLabel.text = [NSString stringWithFormat:@"%d",yellModel.commentCount];
}

// 播放
- (IBAction)playBtnClick {
    
    [self playAnimationWithDuration:self.yellModel.durations andImageCount:25];
     CZLog(@"%@",self.yellModel.fileUrl);
   
//    下载了再播放
    [self fileDownlowdUseAFN];
}

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
        NSData *b = DecodeAMRToWAVE(data);
        NSLog(@"%zd",data.length);
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:b  error:&errorr];
        if (errorr) {
            CZLog(@"%@",errorr);
        }
        //选加载音频的一部份数据到内存
        [player prepareToPlay];
        _player = player;
        [player play];
        if (error) {
            CZLog(@"%@",error);
            [OMGToast showText:@"网络异常"];
        }
    }];
    // 执行下载的任务
    [dowloadTask resume];
}


#pragma mark - 播放帧动画
- (void) playAnimationWithDuration:(double)duration andImageCount:(int) imageCount
{
    //  判断当前是否正在执行动画
    if (self.anmiPic.isAnimating) {
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
    self.anmiPic.animationImages = images;
    //  设置动画持续的时间 Duration持续时间
    self.anmiPic.animationDuration = duration;
    //  设置播放动画持续次数 Repeat 重复
    self.anmiPic.animationRepeatCount = 1;
    // 3.开始执行动画
    [self.anmiPic startAnimating];
    
    //等动画执行完毕后，再释放调图片内存
    [self.anmiPic performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:self.anmiPic.animationDuration+0.01];
}



#pragma mark - 点赞
- (IBAction)DZBtnClick {
    
    if (self.press) {
        return;
    }
    self.praise = !self.praise;
    NSDictionary *parameters = @{@"topicId":@(self.yellModel.id), @"type":@1};
    [NetworkManager requestWithURL:TOPIC_PRAISE_URL parameter:parameters success:^(id response) {
    
        if (!self.praise) {
            [self.DZBtn setImage:[UIImage imageNamed:@"but_like"] forState:UIControlStateNormal];
            if (self.yellModel.praiseCount==0) {
                self.DZLabel.text =@"0";
            }else{
                self.DZLabel.text = [NSString stringWithFormat:@"%d",self.yellModel.praiseCount];
            }
        }else{
            [self.DZBtn setImage:[UIImage imageNamed:@"but_like_pre"] forState:UIControlStateNormal];
            self.DZLabel.text = [NSString stringWithFormat:@"%d",self.yellModel.praiseCount +1];
        }
        
//        NSString *fav = self.yellModel.hasPraise ? @"点赞成功":@"取消点赞";
//        [OMGToast showText:fav];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@",error);
    } ];

}

// 点黑
- (IBAction)DHBtnClick {
    
    if (self.praise) {
        return;
    }
     self.press = !self.press;
    NSDictionary *parameters = @{@"topicId":@(self.yellModel.id), @"type":@0};
    [NetworkManager requestWithURL:TOPIC_PRAISE_URL parameter:parameters success:^(id response) {

        if (!self.press) {
            [self.DHBtn setImage:[UIImage imageNamed:@"but_dislike"] forState:UIControlStateNormal];
            if (self.yellModel.pressCount==0) {
                 self.DHLabel.text = @"0";
            }else{
                self.DHLabel.text = [NSString stringWithFormat:@"%d",self.yellModel.pressCount];
            }
        } else {
            [self.DHBtn setImage:[UIImage imageNamed:@"but_dislike_pre"] forState:UIControlStateNormal];
            self.DHLabel.text = [NSString stringWithFormat:@"%d",self.yellModel.pressCount+1];
        }
//        
//        NSString *fav = self.yellModel.hasPress ? @"点黑成功":@"取消点黑";
//        [OMGToast showText:fav];
    
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
         CZLog(@"%@",error);
    } ];
    
}

//  评论
- (IBAction)commentBtnClick {
    if ([self.delegate respondsToSelector:@selector(commentBtnClick)]) {
        [self.delegate commentBtnClick];
    }
}

-(void)avatarpush
{

    [[NSNotificationCenter defaultCenter]postNotificationName:@"nuhouavatarpush" object:nil userInfo:@{@"model":self.yellModel}];

    
}


@end
