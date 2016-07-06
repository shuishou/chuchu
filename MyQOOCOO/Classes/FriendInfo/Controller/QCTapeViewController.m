//
//  QCTapeViewController.m
//  MyQOOCOO
//
//  Created by lanou on 16/1/5.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCTapeViewController.h"

#import "QCSeniorModel.h"
#import "RecordAudio.h"
@interface QCTapeViewController ()<RecordAudioDelegate>
{
UIActionSheet*Figures;
    
    
    UIImage*pushImage;
    NSString*filePath;
    
    RecordAudio *recordAudio;
}


@property(nonatomic,strong)QCSeniorModel*model;

@end

@implementation QCTapeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"语音录制";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowNotificationded:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardRemoveed:) name:UIKeyboardWillHideNotification object:nil];

    
    UIView*backgroundV=[[UIView alloc]initWithFrame:CGRectMake(10, 20,self.view.width-20, self.view.height-104)];
    backgroundV.backgroundColor=[UIColor whiteColor];
    backgroundV.layer.cornerRadius= 5;
    [self.view addSubview:backgroundV];
    
    
    
    UIImageView*iagev=[[UIImageView alloc]initWithFrame:CGRectMake((backgroundV.bounds.size.width-(backgroundV.bounds.size.width/5*2))/2, backgroundV.bounds.size.height-30-(backgroundV.bounds.size.width/5*2), backgroundV.bounds.size.width/5*2, backgroundV.bounds.size.width/5*2)];
    iagev.image=[UIImage imageNamed:@"voice"];
    iagev.userInteractionEnabled=YES;
    [backgroundV addSubview:iagev];
    
    
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [longPressGestureRecognizer addTarget:self action:@selector(longVoiceIge:)];
    [longPressGestureRecognizer setMinimumPressDuration:1];
    [longPressGestureRecognizer setAllowableMovement:50.0];
    [iagev addGestureRecognizer:longPressGestureRecognizer];
    
    
    
    UIButton*rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.frame=CGRectMake(0, 0, 60, 40);
    rightBtn.font=[UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0xed6664) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(touchRights) forControlEvents:UIControlEventTouchUpInside];
    

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];

    
    
    
    
    voiceV=[[UIView alloc]initWithFrame:CGRectMake((backgroundV.bounds.size.width-200)/2,backgroundV.bounds.size.height/2-100,200,50)];
    //voiceV.backgroundColor=RGBA_COLOR(155, 162, 173, 1);
//    voiceV.layer.borderColor=[UIColor blackColor].CGColor;
//    voiceV.layer.borderWidth=0.5;
    voiceV.layer.cornerRadius = 8;
    voiceV.alpha=0.8;
    voiceV.layer.masksToBounds = YES;
    voiceV.hidden=YES;
    [backgroundV addSubview:voiceV];
    
    UITapGestureRecognizer*voicetap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVoice)];
    voicetap.numberOfTapsRequired =1;
    [voiceV addGestureRecognizer:voicetap];

    
    animage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, voiceV.bounds.size.width-25, 30)];
    animage.image=[UIImage imageNamed:@"voice_00000"];
    [voiceV addSubview:animage];
    
    
    UIImageView*msImage=[[UIImageView alloc]initWithFrame:CGRectMake(voiceV.bounds.size.width-50, 0, 50, 50)];
    msImage.image=[UIImage imageNamed:@"bg_play"];
    [voiceV addSubview:msImage];
    
    msLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, msImage.bounds.size.width, msImage.bounds.size.height)];
    msLb.text=@"0'";
    msLb.textColor=[UIColor whiteColor];
    msLb.textAlignment=NSTextAlignmentCenter;
    msLb.font=[UIFont systemFontOfSize:16];
    [msImage addSubview:msLb];
    
    
    recordAudio = [[RecordAudio alloc]init];
    recordAudio.delegate = self;
    
    
    //录音设置
    [self audio];
    // Do any additional setup after loading the view.
}

-(void)touchRights
{

    
    if ( _cTime>1) {
        
    
    [self popBoxView:NO];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您还没有录音哦~";
        hud.margin = 10.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
        voiceV.hidden=YES;

    
    }
    
    
}

-(void)playVoice
{
  
    
        //1将所有图片装进数组
        NSMutableArray*arr=[[NSMutableArray alloc]init];
        for (int i=0; i<24; i++) {
            NSString*name;
            if (i<10) {
            
            name=[NSString stringWithFormat:@"voice_0000%d",i];
            }else{
            
            name=[NSString stringWithFormat:@"voice_000%d",i];
            }
            UIImage*image=[UIImage imageNamed:name];
            [arr addObject:image];
    
        }
        //逐帧动画三步
        //1,设置图片资源
        animage.animationImages=arr;
        //2,设置动画时间
        animage.animationDuration=audioDurationSeconds;
        //3.设置重复次数  如果写0代表无限重复
        animage.animationRepeatCount=1;
        
        //启动动画
        [animage startAnimating];

    
    if (_avPlayer.playing) {
        [_avPlayer stop];
        
        return;
    }
    
    NSData * a = [NSData dataWithContentsOfURL:_urlPlay];
    NSData *b =  EncodeWAVEToAMR(a,1,16);
    [recordAudio play:b];
    
//    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:_urlPlay error:nil];
//    _avPlayer = player;
//    _avPlayer.delegate=self;
//    [_avPlayer play];
    
    
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
    filePath=[NSString stringWithFormat:@"%@/lll.wav",strURL];
    NSURL *url = [NSURL fileURLWithPath:filePath];
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
    _cTime = _recorder.currentTime;
    
    if (_cTime > 1) {//如果录制时间<2 不发送
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
        voiceV.hidden=YES;
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
        voiceV.hidden=NO;
        blackv .hidden=YES;
        
        [self theVoiceTime ];
        
        
        return;
        
    }else if (longResture.state == UIGestureRecognizerStateBegan) {
        
        voiceV.hidden=YES;
        blackv .hidden=NO;
        [self vicoeStar ];
        
        
        
        
    }
    
    
}




-(void)popBoxView:(BOOL)isPic
{
    self.isAdd=NO;
    
    bV=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.width,self.view.height)];
    bV.backgroundColor=[UIColor blackColor];
    bV.alpha=0.5;
    [self.view addSubview:bV];
    
    boxV=[[UIView alloc]initWithFrame:CGRectMake(40,(self.view.height-200)/2,self.view.width-80,200)];
    boxV.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:boxV];
    
    
    textlb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, boxV.bounds.size.width, 50)];
    if (isPic==YES) {
    textlb.text=@"为您的语音添加一张照片";
    }else{
    textlb.text=@"为您的语音添加一段描述";
    
    
   
    
    boxtf=[[UITextField alloc]initWithFrame:CGRectMake(20, (boxV.bounds.size.height- 30)/2, boxV.bounds.size.width-40, 30)];
    boxtf.font=[UIFont systemFontOfSize:16];
    boxtf.delegate=self;
    [boxtf becomeFirstResponder];

    [boxV addSubview:boxtf];
    }
    textlb.textAlignment=NSTextAlignmentCenter;
    textlb.font=[UIFont systemFontOfSize:18];

     [boxV addSubview:textlb];
    
    if (isPic==NO) {

    UIButton*choiceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [choiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    choiceBtn.frame=CGRectMake(0, boxV.frame.size.height-45, boxV.frame.size.width/2, 45);
    [choiceBtn setTitle:@"取消" forState: UIControlStateNormal];
    [choiceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    choiceBtn.tag=1;
    choiceBtn.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
    choiceBtn.layer.borderWidth=0.5;
    [choiceBtn addTarget:self action:@selector(choiceBtnCliack:) forControlEvents:UIControlEventTouchUpInside];
    [boxV addSubview:choiceBtn];
    
    UIButton*choiceBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
    [choiceBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    choiceBtn2.frame=CGRectMake(boxV.frame.size.width/2,boxV.frame.size.height-45, boxV.frame.size.width/2, 45);
    [choiceBtn2 setTitle:@"确定" forState: UIControlStateNormal];
    [choiceBtn2 setTitleColor:RGBA_COLOR(118, 168, 244, 1) forState:UIControlStateNormal];
    choiceBtn2.tag=2;
    choiceBtn2.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
    choiceBtn2.layer.borderWidth=0.5;
    
    [choiceBtn2 addTarget:self action:@selector(choiceBtnCliack:) forControlEvents:UIControlEventTouchUpInside];
    [boxV addSubview:choiceBtn2];
    }else{
        UIButton*choiceBtn3=[UIButton buttonWithType:UIButtonTypeCustom];
        [choiceBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        choiceBtn3.frame=CGRectMake(0, boxV.frame.size.height-45, boxV.frame.size.width/2, 45);
        [choiceBtn3 setTitle:@"取消" forState: UIControlStateNormal];
        [choiceBtn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        choiceBtn3.tag=1;
        choiceBtn3.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
        choiceBtn3.layer.borderWidth=0.5;
        [choiceBtn3 addTarget:self action:@selector(choiceBtnCliack:) forControlEvents:UIControlEventTouchUpInside];
        [boxV addSubview:choiceBtn3];

        UIButton*choiceBtn4=[UIButton buttonWithType:UIButtonTypeCustom];
        [choiceBtn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        choiceBtn4.frame=CGRectMake(boxV.frame.size.width/2,boxV.frame.size.height-45, boxV.frame.size.width/2, 45);
        [choiceBtn4 setTitle:@"添加图片" forState: UIControlStateNormal];
        [choiceBtn4 setTitleColor:RGBA_COLOR(118, 168, 244, 1) forState:UIControlStateNormal];
        choiceBtn4.tag=2;
        choiceBtn4.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
        choiceBtn4.layer.borderWidth=0.5;
        
        [choiceBtn4 addTarget:self action:@selector(addPicreacd) forControlEvents:UIControlEventTouchUpInside];
        [boxV addSubview:choiceBtn4];

        
    }
    
    
    
}

-(void)addPicreacd
{
    
    
    Figures = [[UIActionSheet alloc]
               initWithTitle:nil
               delegate:self
               cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
               otherButtonTitles:@"拍照",@"从相册选择",nil];
    
    [Figures showInView:self.view];
    
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    
    
    
    if (buttonIndex == Figures.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    
    
    switch (buttonIndex) {
        case 0://拍照
            
            [self takePhoto];
            break;
        case 1://相册
           
            [self LocalPhoto];
            break;

        default:
            break;
    }
    
}

#pragma mark -取消选择图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissModalViewControllerAnimated:YES];
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
        
        
        pushImage=image;
        self.model.image=pushImage;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"voiceUrl" object:nil userInfo:@{@"Url":self.model}];
        
        [self.navigationController popViewControllerAnimated:YES];

        
         
    }
}


-(void)choiceBtnCliack:(UIButton*)bt
{
    if (bt.tag==1) {
        // 取消
        self.isAdd=NO;
        [bV removeFromSuperview];
        [boxV removeFromSuperview];
            }else{
        //确定
        self.isAdd=YES;
        
        
        self.model=[[QCSeniorModel alloc]init];
        self.model.type=2;
        self.model.url=_urlPlay;
        self.model.str=msLb.text;
        self.model.describeStr=boxtf.text;
        self.model.filePath=filePath;
        

        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"voiceUrl" object:nil userInfo:@{@"Url":self.model}];
//        
//        [self.navigationController popViewControllerAnimated:YES];
                [bV removeFromSuperview];
                [boxV removeFromSuperview];

      [self popBoxView:YES];
    }
    
    
    
}



#pragma -mark 键盘弹出
//键盘将要弹出的方法
-(void)keyBoardWillShowNotificationded:(NSNotification *)not
{
    
    //获取键盘高度
    NSDictionary *dic = not.userInfo;
    //获取坐标
    CGRect rc = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //键盘高度
    CGFloat f = rc.size.height;
    
    //调整输入框的位置
    [UIView animateWithDuration:0.1 animations:^{
        boxV.frame = CGRectMake(40, self.view.frame.size.height-f-((self.view.height-200)/2)-60,self.view.size.width-80, self.view.size.height/3);
    }];
}

//键盘消失的方法
-(void)keyBoardRemoveed:(NSNotification *)not
{
    //调整输入框的位置
    [UIView animateWithDuration:0.1 animations:^{
        
        boxV.frame = CGRectMake(40,(self.view.height-200)/2,self.view.width-80,200);
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //回收键盘
    [textField  resignFirstResponder];
    return YES;
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
