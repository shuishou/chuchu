//
//  QCrecordView.h
//  MyQOOCOO
//
//  Created by lanou on 16/3/16.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCGetUserMarkModel.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface QCrecordView : UIView <AVAudioPlayerDelegate>
{
    
        AVAudioPlayer *_avPlayer;
    
    BOOL isDelete;
}


@property(nonatomic,strong)NSMutableArray*dataArr;

+(CGSize)recordViewSizeWithArrCount:(NSInteger)count;
@end
