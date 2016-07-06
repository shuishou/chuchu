//
//  QCRemarksViewController.m
//  MyQOOCOO
//
//  Created by lanou on 15/12/23.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCRemarksViewController.h"
//七牛
#import "QCQinniuUploader.h"
#import "RecordAudio.h"

@interface QCRemarksViewController ()<RecordAudioDelegate>
{
    UITextField*txtf;
    
    NSMutableArray*picArr;
    
    NSString*picUrl;
    
    
    UIImageView*voiceimagev;
    
    UIActionSheet *Figure;
    
    UIView*topV;
    
    UIScrollView* scroll;
    
    
    UILabel*msLb;
    
    UIImageView*igev;
    UIImageView*volume;
    UILabel *_decibelView;
    //分贝数
    
    
    AVAudioPlayer *_avPlayer;

    RecordAudio *recordAudio;
    
    NSString *filePoth;
}
@property (nonatomic , copy) NSString *qiniuToken;
@property ( nonatomic , assign) float decibelNum;
@property (nonatomic,assign) NSTimeInterval recordTime;
@end

@implementation QCRemarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加备注";
    
    
  
       
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem addBarBtnImg:@"Arrow" highlightedImg:@"Arrow" target:self action:@selector(touchleftBtn)];
    
    UIButton*rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.frame=CGRectMake(0, 0, 60, 40);
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0xed6664) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(starButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    

    UIImage*image=[UIImage imageNamed:@"LJadds"];
    picArr=[[NSMutableArray alloc]initWithObjects:image, nil];
    
    
    [self showtopv ];
    
    [self showbottomv];
    
    // Do any additional setup after loading the view.
    
    //录音设置
    [self audio];
    
    recordAudio = [[RecordAudio alloc]init];
    recordAudio.delegate = self;
    
}

-(void)showtopv
{

    topV=[[UIView alloc]initWithFrame:CGRectMake(0, 20+64, WIDTH(self.view), 180)];
    topV.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topV];
    
    UIView*titleV=[[UIView alloc]initWithFrame:CGRectMake(0, 0,topV.bounds.size.width/3-20,topV.bounds.size.height)];
    //titleV.backgroundColor=[UIColor yellowColor];
    [topV addSubview:titleV];
    
    UILabel*txtLb=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, WIDTH(titleV)-10, 40)];
    txtLb.text=@"文字";
    txtLb.font=[UIFont systemFontOfSize:14];
    [titleV addSubview:txtLb];

    
    UILabel*picLb=[[UILabel alloc]initWithFrame:CGRectMake(10, 40, WIDTH(titleV)-10, 100)];
    picLb.text=@"图片";
    //picLb.textAlignment=NSTextAlignmentCenter;
    //picLb.backgroundColor=[UIColor redColor];
    picLb.font=[UIFont systemFontOfSize:14];
    [titleV addSubview:picLb];

    
    UILabel*voiceLb=[[UILabel alloc]initWithFrame:CGRectMake(10, HEIGHT(titleV)-40, WIDTH(titleV)-10, 40)];
    voiceLb.text=@"语音";
    voiceLb.font=[UIFont systemFontOfSize:14];
    [titleV addSubview:voiceLb];


    txtf=[[UITextField alloc]initWithFrame:CGRectMake(WIDTH(titleV), 0, topV.bounds.size.width-WIDTH(titleV), 40)];
    txtf.placeholder =@"备注好友";
    txtf.delegate=self;
    txtf.font=[UIFont systemFontOfSize:14];
    [topV addSubview:txtf];
    
    
    scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(WIDTH(titleV), 40, 65*picArr.count, 100)];
    [topV addSubview: scroll];
    //设置可滚动范围
    scroll.contentSize=CGSizeMake( 65*picArr.count+(65*picArr.count-(topV.bounds.size.width-titleV.bounds.size.width)), 0);
    scroll.backgroundColor=[UIColor whiteColor];
    
    //分页显示
    scroll.pagingEnabled=NO;
    
    //滑动到第一页和最后一页是否允许继续滑动
    
    scroll.bounces=NO;
    
    //取消滚动条
    
    scroll.showsHorizontalScrollIndicator=NO;//水平(横)
    
    scroll.showsVerticalScrollIndicator=NO;//垂直(竖)
    
    //指定代理人
    //scroll.delegate=self;
    //一开始显示到第几张
    scroll.contentOffset=CGPointMake(0,0);


    
    for (int i=0; i<[picArr count]; i++) {
        UIImageView*imagev=[[UIImageView alloc]initWithFrame:CGRectMake(65*i, 20, 60, 60)];
        imagev.image=picArr[i];
        imagev.tag=i;
        imagev.userInteractionEnabled=YES;
        [scroll addSubview:imagev];
        if ((i+1)==picArr.count) {
            UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchImagev:)];
            tap.numberOfTapsRequired =1;
            [imagev addGestureRecognizer:tap];

            
        }else{
            UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
            [longPressGestureRecognizer addTarget:self action:@selector(longTouchImage:)];
            [longPressGestureRecognizer setMinimumPressDuration:2];
            [longPressGestureRecognizer setAllowableMovement:50.0];
            [imagev addGestureRecognizer:longPressGestureRecognizer];

        
        }

    }
    
    
    UIView*voiceV=[[UIView alloc]initWithFrame:CGRectMake(WIDTH(titleV), HEIGHT(titleV)-40+5, 90, 30)];
    voiceV.backgroundColor=self.view.backgroundColor;
    voiceV.layer.borderColor=[UIColor blackColor].CGColor;
    voiceV.layer.borderWidth=0.5;
    voiceV.layer.cornerRadius = 8;
    voiceV.layer.masksToBounds = YES;
    [topV addSubview:voiceV];
    
    UITapGestureRecognizer*voicetap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVoice)];
    voicetap.numberOfTapsRequired =1;
    [voiceV addGestureRecognizer:voicetap];

    
    UILongPressGestureRecognizer *voicetaplongPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [voicetaplongPressGestureRecognizer addTarget:self action:@selector(voiceVlongTouchImage:)];
    [voicetaplongPressGestureRecognizer setMinimumPressDuration:2];
    [voicetaplongPressGestureRecognizer setAllowableMovement:50.0];
    [voiceV addGestureRecognizer:voicetaplongPressGestureRecognizer];
    
    
    voiceimagev=[[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 12, 14)];
    voiceimagev.image=[UIImage imageNamed:@"LJ_0"];
    [voiceV addSubview:voiceimagev];
    
    
    msLb=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, voiceV.bounds.size.width-40, 30)];
    msLb.text=@"0'";
    msLb.textColor=[UIColor blackColor];
    msLb.textAlignment=NSTextAlignmentRight;
    msLb.font=[UIFont systemFontOfSize:14];
    [voiceV addSubview:msLb];
    
    
    
    
    UIView*line=[[UIView alloc]initWithFrame:CGRectMake(10, 40, WIDTH(topV)-10, 0.5)];
    line.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
    [topV addSubview:line];
    
    UIView*line2=[[UIView alloc]initWithFrame:CGRectMake(10, HEIGHT(topV)-40, WIDTH(topV)-10, 0.5)];
    line2.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
    [topV addSubview:line2];

       
    
}
-(void)showbottomv
{

    UIView*bottomV=[[UIView alloc]initWithFrame:CGRectMake(0, MaxY(self.view)-300, WIDTH(self.view), 300)];
    bottomV.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bottomV];
    
    
    igev=[[UIImageView alloc]initWithFrame:CGRectMake((bottomV.bounds.size.width-100)/2, (bottomV.bounds.size.height-100)/2, 100, 100)];
    igev.image=[UIImage imageNamed:@"voice"];
    igev.userInteractionEnabled=YES;
    [bottomV addSubview:igev];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [longPressGestureRecognizer addTarget:self action:@selector(longVoiceIge:)];
    [longPressGestureRecognizer setMinimumPressDuration:1];
    [longPressGestureRecognizer setAllowableMovement:50.0];
    [igev addGestureRecognizer:longPressGestureRecognizer];

}

-(void)longVoiceIge:(UILongPressGestureRecognizer*)longResture
{
    
    if (blackv==nil) {
     blackv=[[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-80)/2, (self.view.frame.size.height-80)/2, 80, 80)];
     blackv.backgroundColor=[UIColor blackColor];
     blackv.alpha=0.5;
     blackv.layer.cornerRadius = 8;
    [self.view addSubview:blackv];
    }
    
   
    if (volume==nil) {
    
        
    volume=[[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 40, 40)];
    volume.image=[UIImage imageNamed:@"HFrecord_animate_01"];
        [blackv addSubview:volume];
    }
    
    if (longResture.state == UIGestureRecognizerStateEnded) {
        blackv .hidden=YES;
        //[volume stopAnimating];
        [self theVoiceTime ];
        
        
        return;
        
    }else if (longResture.state == UIGestureRecognizerStateBegan) {
        
        
        blackv .hidden=NO;
        [self vicoeStar ];
        //[self playTaped ];

       
    }

    
}

-(void)longTouchImage:(UILongPressGestureRecognizer*)longResture
{

    if (longResture.state==UIGestureRecognizerStateBegan) {
        if (longResture.view.tag!=picArr.count-1) {

    //初始化AlertView
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认删除"
                                                    message:@"是否删除该图片"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
        alert.tag=longResture.view.tag;
        [alert show];
    }
    }
    

}
-(void)voiceVlongTouchImage:(UILongPressGestureRecognizer*)longResture
{
    
    if (longResture.state==UIGestureRecognizerStateBegan) {
        UIAlertController * alertCtr = [UIAlertController alertControllerWithTitle:@"确定删除该语言?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            msLb.text=@"0'";
            [_recorder deleteRecording];
            
        }];
        [alertCtr addAction:sure];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [alertCtr addAction:cancelAction];
        
        [self presentViewController:alertCtr animated:YES completion:^{
            
        }];
    }
    
    
}
////根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%ld",buttonIndex);
    switch (buttonIndex) {
        case 0:
            return;
            
            break;
        case 1:
            if (alertView.tag!=picArr.count-1) {

                if (picArr.count-1!=0) {
                    
                
            [picArr removeObjectAtIndex:alertView.tag];
                }
                
            [topV removeFromSuperview];
            [self showtopv];
            }


            break;
            
        default:
            break;
    }
    
}





-(void)touchImagev:(UITapGestureRecognizer*)resture
{

    Figure = [[UIActionSheet alloc]
                initWithTitle:nil
                delegate:self
                cancelButtonTitle:@"取消"
                destructiveButtonTitle:nil
                otherButtonTitles: @"从相册选择",@"拍照",nil];
  
    
    [txtf resignFirstResponder];
    [Figure showInView:self.view];



}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    
    
    
    if (buttonIndex == Figure.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    
    switch (buttonIndex) {
        case 0:
            [self LocalPhoto ];
            break;
        case 1:
            [self takePhoto];
            break;
            
            
        default:
            break;
    }
    
}

-(void)playVoice
{
    
    if (_avPlayer.playing) {
        [_avPlayer stop];
        
        return;
    }
//    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:_urlPlay error:nil];
//    _avPlayer = player;
//    _avPlayer.delegate=self;
//    [_avPlayer play];

    NSData * a = [NSData dataWithContentsOfURL:_urlPlay];
    NSData *b =  EncodeWAVEToAMR(a,1,16);
    
   
    
    
    [recordAudio play:b];
}

-(void)touchleftBtn
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)starButtonClicked:(id)sender
{
    [self popupLoadingView:@"上传中"];
    
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(touchRights) object:sender];
    [self performSelector:@selector(touchRights) withObject:sender afterDelay:3.0f];
}

-(void)touchRights
{
    NSLog(@"提交");
    [self uploadImageToQiuniu];
}






#pragma mark -选择拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
    }else{
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

#pragma mark -选择相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    
    [self presentModalViewController:picker animated:YES];
    
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        NSString* filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        NSLog(@"%@",filePath);
        
        //关闭相册界面
        [picker dismissModalViewControllerAnimated:YES];
        
        //        设置图片
        [picArr insertObject:image atIndex:0];
        [topV removeFromSuperview];
        [self showtopv];
        
        
        
        
        
    }
}


#pragma mark -取消选择图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissModalViewControllerAnimated:YES];
}


#pragma mark - 录音参数
-(void)audio{
//    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
//    //设置录音格式
//    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
//    //设置录音采样率
//    [recordSetting setValue:[NSNumber numberWithInt:44100] forKey:AVSampleRateKey];
//    //录音通道数
//    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
//    //线性采样位数
//    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
//    //录音的质量
//    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    
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
    
    NSString *strURL = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    filePoth=[NSString stringWithFormat:@"%@/lll.wav",strURL];
    NSURL *url = [NSURL fileURLWithPath:filePoth];
    _urlPlay = url;
    
    NSError *error;
    _recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    //开启音量检测
    _recorder.meteringEnabled = YES;
    _recorder.delegate = self;
    
}

#pragma mark - 录音

-(void)detectionVoice{
    [_recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //    音量的最大值
    float highestVoid = [_recorder peakPowerForChannel:0];
    _highestDecibel = [NSString stringWithFormat:@"%f",highestVoid];
    

    
    //检查分贝
    _decibelNum = [self levelTimerCallback:nil];//分贝数
    [_decibelView setText:[NSString stringWithFormat:@"%.0f",_decibelNum]];
    volume.image= [UIImage imageNamed:[NSString stringWithFormat:@"HFrecord_animate_0%d",(int)_decibelNum % 14+1]];
    
    
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
    
    CZLog(@"平均值 %f", level * 120);
    
    return level * 120;
    
}
-(void)theVoiceTime
{
    double cTime = _recorder.currentTime;
    
    if (cTime > 1) {//如果录制时间<2 不发送
        CZLog(@"发出去");
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

-(void)vicoeStar
{
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


}



#pragma mark - AVAudioRecorderDelegate
- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{

    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:_urlPlay options:nil];
    CMTime audioDuration = audioAsset.duration;
    audioDurationSeconds =CMTimeGetSeconds(audioDuration);
    msLb.text=[NSString stringWithFormat:@"%.0f'",audioDurationSeconds];
    
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [voiceimagev stopAnimating];
    
}



#pragma mark - 获取七牛的tocken
-(void)uploadImageToQiuniu{
    if (picArr.count!=1) {
        
    
    NSMutableArray*tempArr=[NSMutableArray array];
       for (int i=0; i<[picArr count]-1; i++) {
        [tempArr addObject:picArr [i]];
        
    }
    
    [QCQinniuUploader uploadImages:tempArr progress:^(CGFloat progress) {
        
        
    } success:^(NSArray *urlArray) {
        
        
        for (int i=0; i<urlArray.count; i++) {
            if (i==0) {
                picUrl=urlArray[i];
            }else{
                picUrl=[NSString stringWithFormat:@"%@,%@",picUrl,urlArray[i]];
            }
            
        }
        
//        [self getvoicetoken];
        [self pushDataMethod];
  
    } failure:^{
         [self hideLoadingView];
        [OMGToast showText:@"上传音频失败"];
    }];

    }else{
//        [self getvoicetoken];
        [self pushDataMethod];
    }
}


-(void)pushDataMethod{
  
    
    int durations = (int)audioDurationSeconds;//时间
    if (durations > 0) {
        [self getvoicetoken];
    }else{
        
        NSMutableDictionary *parameter=[NSMutableDictionary dictionary];
        //NSString*voiceUrl=[url stringByAppendingString:@".acc"];
        
        [parameter setValue:@(self.Id) forKey:@"id"];
        if (![txtf.text isEqualToString: @""]) {
            [parameter setValue:txtf.text forKey:@"note"];
        }
        if (picUrl!=nil) {
            [parameter setValue:picUrl forKey:@"imageUrl"];
        }
        [parameter setValue:@"" forKey:@"voiceUrl"];
        [parameter setValue:@"" forKey:@"durations"];
        [self pushData:parameter];
    }
    
}



-(void)getvoicetoken
{

    int durations = (int)audioDurationSeconds;//时间
//    NSURL * url = _recorder.url;
//    NSData * data = [NSData dataWithContentsOfURL:_urlPlay];
//    NSLog(@"%ld",data.length);
    
  
//    NSString *recordPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    
    NSData * a =[NSData dataWithContentsOfFile:filePoth];
    NSData *data = EncodeWAVEToAMR(a,1,16);
    
    [[NSFileManager defaultManager]createFileAtPath:filePoth contents:data attributes:nil];
    
    NSURL *url = [NSURL fileURLWithPath:filePoth];
    
    
    
    [QCQinniuUploader uploadVocieFile:url progress:nil success:^(NSString *url){
        CZLog(@"===url=%@",url);
        //上传成功获取到七牛返回来的url
        NSMutableDictionary *parameter=[NSMutableDictionary dictionary];
        NSString*voiceUrl=url;
      
        [parameter setValue:@(self.Id) forKey:@"id"];
        if (![txtf.text isEqualToString: @""]) {
            [parameter setValue:txtf.text forKey:@"note"];
        }
        if (picUrl!=nil) {
            [parameter setValue:picUrl forKey:@"imageUrl"];
        }
        if (voiceUrl!=nil) {
            [parameter setValue:voiceUrl forKey:@"voiceUrl"];
            [parameter setValue:@(durations) forKey:@"durations"];
        }
        
        
//        parameter=  @{
//                      @"id":@(self.uid),
//                      @"note":txtf.text,
//                      @"imageUrl":picUrl,
//                      @"voiceUrl":voiceUrl,
//                      @"durations":@(durations)
//                      };
        
        [self pushData:parameter];
        //    2、发送音频URL到服务器
    } failure:^{
         [self hideLoadingView];
        [OMGToast showText:@"上传音频失败"];
    }];

}




-(void)pushData:(NSDictionary*)parameter
{
    [NetworkManager requestWithURL:FRIEND_REMARK parameter:parameter success:^(id response) {
        NSLog(@"%@",response);
        [self hideLoadingView];
        [OMGToast showText:@"发送成功"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"upData" object:nil userInfo:nil];

        [self.navigationController popViewControllerAnimated:YES];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [self hideLoadingView];
        [OMGToast showText:@"发送失败"];

    }];


}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //回收键盘
    [textField  resignFirstResponder];
    return YES;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![txtf isExclusiveTouch]) {
        [txtf resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
