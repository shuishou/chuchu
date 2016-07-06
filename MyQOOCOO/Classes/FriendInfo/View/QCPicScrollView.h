//
//  QCPicScrollView.h
//  MyQOOCOO
//
//  Created by lanou on 16/3/16.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCGetUserMarkModel.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface QCPicScrollView : UIScrollView<UIScrollViewDelegate>
{
    UIPageControl*pageC;
    AVAudioPlayer *_avPlayer;
    
    BOOL isDelete;
}

@property (nonatomic,strong) NSMutableArray * dynamicImgPaths;

+(CGSize)photoViewSizeWithPictureCount:(NSInteger)count;

@end
