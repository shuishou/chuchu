//
//  QCYellVC.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/20.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "IQAudioRecorderController.h"

@interface QCYellVC : QCBaseVC<AVAudioRecorderDelegate>{
//    AVAudioRecorder *_recorder;
    NSTimer *_timer;
//    NSURL *_urlPlay;
}

@property (nonatomic,copy) NSURL *urlPlay;//录音路径

@property ( nonatomic , assign) float z;
@property (nonatomic , strong)AVAudioRecorder *recorder;
@property (nonatomic , strong)CADisplayLink *displayLink;
@property ( nonatomic , copy) NSString *highestDecibel;

@property (nonatomic,assign) double cTime;

@end
