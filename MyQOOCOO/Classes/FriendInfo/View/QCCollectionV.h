//
//  QCCollectionV.h
//  MyQOOCOO
//
//  Created by lanou on 15/12/29.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCGetUserMarkModel.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface QCCollectionV : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource,AVAudioPlayerDelegate>
{
    AVAudioPlayer *_avPlayer;
}





@property(nonatomic,retain)NSMutableArray*dataArr;

@property(nonatomic,assign)BOOL isAdd;

@property(nonatomic,assign)BOOL isDelete;

@property(nonatomic,assign)NSInteger inSection;



@property(nonatomic,assign)BOOL isEdite;//是否可编辑




@end
