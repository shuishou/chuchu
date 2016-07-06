//
//  QCTapeViewController.h
//  MyQOOCOO
//
//  Created by lanou on 16/1/5.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "IQAudioRecorderController.h"

@interface QCTapeViewController : QCBaseVC<AVAudioRecorderDelegate,AVAudioPlayerDelegate,UITextFieldDelegate>
{

    
    UIView*blackv;
    
    NSTimer *_timer;
    NSURL *_urlPlay;
    
    float audioDurationSeconds;
    
    UILabel *_decibelView;
    
    UIImageView*volume;
    
    AVAudioPlayer *_avPlayer;
    
    
    UILabel*msLb;
    
    UIImageView*animage;
    
    
    UIView*voiceV;
    
    
    UIView*bV;
    UIView*boxV;
    UITextField*boxtf;
    UILabel*textlb;

}


@property (nonatomic , strong)AVAudioRecorder *recorder;
@property ( nonatomic , assign) float decibelNum;
@property ( nonatomic , copy) NSString *highestDecibel;
@property(nonatomic,assign)BOOL isAdd;


@property(nonatomic,assign) double cTime;



@end
