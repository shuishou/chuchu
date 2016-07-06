//
//  QCYellVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/20.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCYellVC.h"
#import "MDRadialProgressView.h"
#import "RecordAudio.h"
@interface QCYellVC ()<RecordAudioDelegate>{
    UIView *_yellView;
    UIButton *_yellBtn;
    UIButton *_playBtn;
    AVAudioPlayer *_avPlayer;
    //分贝圈圈
    MDRadialProgressView *_radialView;
    UILabel *_decibelView;
    //分贝数
    
    RecordAudio *recordAudio;
    
}
@property ( nonatomic , assign) float decibelNum;
@end

@implementation QCYellVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _highestDecibel = @"0";
    
    [self setupSubViews];//添加子控件
    
    //录音设置
    [self audio];
    
    //录音
    [_yellBtn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
    [_yellBtn addTarget:self action:@selector(btnUp:) forControlEvents:UIControlEventTouchUpInside];
    [_yellBtn addTarget:self action:@selector(btnDragUp:) forControlEvents:UIControlEventTouchDragExit];
    //播放
    [_playBtn addTarget:self action:@selector(playRecordSound:) forControlEvents:UIControlEventTouchUpInside];
    
    
    recordAudio = [[RecordAudio alloc]init];
    recordAudio.delegate = self;
}

#pragma mark - 录音
-(void)btnDown:(id)sender{
//    测试文件别人的
//    IQAudioRecorderController *iqRecorderVC = [[IQAudioRecorderController alloc]init];
//    [self presentViewController:iqRecorderVC animated:YES completion:nil];
    
    //创建录音文件，准备录音
    NSError * err = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err){
        CZLog(@"audioSession: %@ %ld %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    
    [audioSession setActive:YES error:&err];
    
    err = nil;
    if(err){
        CZLog(@"audioSession: %@ %ld %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    
    //开始录音
    if ([_recorder prepareToRecord]) {
        //开始
        [_recorder record];
    }
    //设置定时检测
    _timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];//把定时器添加到runloop里面
    
}
-(void)btnUp:(UIButton *)sender{
    double cTime = _recorder.currentTime;
    self.cTime = cTime;
    [sender setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    if (cTime > 1) {//如果录制时间<1 不发送
        CZLog(@"已录音超过1s");
        
//        [self audio];
    }else {
        //删除记录的文件
        [_recorder deleteRecording];
        //提示录音时间少于1s
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"录音时间少于1s,再给点力";
        hud.margin = 10.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
        
    }
    [_recorder stop];
    [_timer invalidate];
}
-(void)btnDragUp:(id)sender{
    //删除录制文件
    [_recorder deleteRecording];
    [_recorder stop];
    [_timer invalidate];
    
    CZLog(@"取消发送");
}
-(void)detectionVoice{
    [_recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
//    音量的最大值
    float highestVoid = [_recorder peakPowerForChannel:0];
    _highestDecibel = [NSString stringWithFormat:@"%f",highestVoid];
    
    double lowPassResults = pow(10, (0.05 * [_recorder peakPowerForChannel:0]));
//    CZLog(@"%lf",lowPassResults);
    //最大50  0
    //图片 小-》大

    if (0 < lowPassResults <= 0.25) {
        [_yellBtn setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    }else if (0.25 < lowPassResults <=0.5){
        [_yellBtn setImage:[UIImage imageNamed:@"voice_1"] forState:UIControlStateNormal];
    }else if (0.5 < lowPassResults <= 0.75){
        [_yellBtn setImage:[UIImage imageNamed:@"voice_2"] forState:UIControlStateNormal];
    }else if (0.75 < lowPassResults <= 1.0){
        [_yellBtn setImage:[UIImage imageNamed:@"voice_3"] forState:UIControlStateNormal];
    }else{
        [_yellBtn setImage:[UIImage imageNamed:@"voice_3"] forState:UIControlStateNormal];
    }
    
    //检查分贝
    _decibelNum = [self levelTimerCallback:nil];//分贝数
    [_decibelView setText:[NSString stringWithFormat:@"%.0f",_decibelNum]];
    
    //圈圈变化
    //最大分贝数200
    float currentDecibel = _decibelNum / 200 * 50;
    [_radialView setProgressCurrent:currentDecibel];
    [_radialView setNeedsDisplay];
    
}

#pragma mark - 检测分贝
- (float)levelTimerCallback:(NSTimer *)timer {
    
    [_recorder updateMeters];
    
    float   level;                // The linear 0.0 .. 1.0 value we need.
    
    float   minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
    
    float   decibels = [_recorder averagePowerForChannel:0];
    
    if (decibels < minDecibels)
        
    {
        
        level = 0.0f;
        
    }
    
    else if (decibels >= 0.0f)
        
    {
        
        level = 1.0f;
        
    }
    
    else
        
    {
        
        float   root            = 2.0f;
        
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        
        float   amp             = powf(10.0f, 0.05f * decibels);
        
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        
        level = powf(adjAmp, 1.0f / root);
        
    }   
    
//    CZLog(@"平均值 %f", level * 120);
    
    return level * 120;
    
}

#pragma mark - 播放录音
-(void)playRecordSound:(id)sender{
    if (_avPlayer.playing) {
        [_avPlayer stop];
        return;
    }
    
    NSData * a = [NSData dataWithContentsOfURL:self.urlPlay];
    NSData *b =  EncodeWAVEToAMR(a,1,16);
 
//    NSLog(@"%zd",data.length);
    
    
    [recordAudio play:b];
    
//    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data  error:nil];
////    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:self.urlPlay error:nil];
//    _avPlayer = player;
//    [_avPlayer play];
}

#pragma mark - 子控件
-(void)setupSubViews{
    //分贝视图
    _yellView = [[UIView alloc]init];
    _yellView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_yellView];
    [_yellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(55);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(150,150));
    }];
    //圈圈
    _radialView = [[MDRadialProgressView alloc ]initWithFrame:CGRectMake(0, 0, 150, 150)];
    _radialView.progressTotal = 50;
    _radialView.progressCurrent = 1;
    _radialView.completedColor = kGlobalTitleColor;
    _radialView.incompletedColor = UIColorFromRGB(0xC9C9C9);
    _radialView.thickness = 50;
    _radialView.backgroundColor = kGlobalBackGroundColor;
    _radialView.sliceDividerHidden = NO;
    _radialView.sliceDividerColor = [UIColor whiteColor];
    _radialView.sliceDividerThickness = 1;
    [_yellView addSubview:_radialView];
    
    //分贝
    _decibelView = [[UILabel alloc]init];
    _decibelView.textColor = kGlobalTitleColor;
    [_yellView addSubview:_decibelView];
    [_decibelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_yellView.mas_centerX);
        make.centerY.mas_equalTo(_yellView.mas_centerY);
    }];
    UIFont *font1 = [UIFont fontWithName:@"DBLCDTempBlack" size:40];
    _decibelView.font = font1;
    _decibelView.text = [NSString stringWithFormat:@"%.0f",_decibelNum];
    
    //录音按钮
    _yellBtn = [[UIButton alloc]init];
    [_yellBtn setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    
    [self.view addSubview:_yellBtn];
    [_yellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_yellView.mas_bottom).offset(100);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(90,90));
    }];
    
    //播放录音
    _playBtn = [[UIButton alloc]init];
    [_playBtn setBackgroundColor:[UIColor whiteColor]];
    [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
    
    [_playBtn setTitleColor:kGlobalTitleColor forState:UIControlStateNormal];//字体颜色
    [self.view addSubview:_playBtn];
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_yellBtn.mas_top).offset(25);
        make.left.equalTo(_yellBtn.mas_right).offset(30);
        make.bottom.equalTo(_yellBtn.mas_bottom).offset(-25);
        make.right.equalTo(self.view.mas_right).offset(-30);
    }];
}

#pragma mark - 录音参数
-(void)audio{
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    dateForm.dateFormat = @"order";
    NSString *currentDateStr = [dateForm stringFromDate:[NSDate date]];
    NSString *fileName = [currentDateStr stringByAppendingString:@"order.wav"];
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:fileName];
    [[NSUserDefaults standardUserDefaults] setObject:filePath forKey:@"filePath1"];
    
    NSData * a =[NSData dataWithContentsOfFile:filePath];
    [[NSUserDefaults standardUserDefaults] setObject:a forKey:@"data1"];
    
    NSURL * url = [NSURL fileURLWithPath:filePath];
    self.urlPlay = url;
    CZLog(@"%@",url);
    
    
    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                   //[NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                   [NSNumber numberWithFloat:8000.00], AVSampleRateKey,
                                   [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                   //  [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
                                   [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                   nil];
    
    
    
    
    NSError *error;
    _recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    
    //开启音量检测
    _recorder.meteringEnabled = YES;
    _recorder.delegate = self;
}



@end
