//
//  QCRemarksViewController.h
//  MyQOOCOO
//
//  Created by lanou on 15/12/23.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "IQAudioRecorderController.h"




@interface QCRemarksViewController : QCBaseVC<UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate,UITextFieldDelegate>
{

    UIView*blackv;
    NSTimer *_timer;
    NSURL *_urlPlay;
    
    float audioDurationSeconds;
    
       
    
}

@property(nonatomic,assign)long uid;
@property(nonatomic,assign)long Id;


@property ( nonatomic , assign) float z;
@property (nonatomic , strong)AVAudioRecorder *recorder;
@property (nonatomic , strong)CADisplayLink *displayLink;
@property ( nonatomic , copy) NSString *highestDecibel;


@property (nonatomic,retain) NSTimer * timer;
@property (nonatomic,retain) NSDate * date1;
@property (nonatomic,retain) NSDate * date2;






@end
