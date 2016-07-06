//
//  QCUserViewController.h
//  MyQOOCOO
//
//  Created by lanou on 15/12/11.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import "QCTextVC.h"
#import "QCDiandiViewController.h"
#import "QCFaxiequanViewController.h"
#import "QCLunKuViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface QCUserViewController : QCBaseVC<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate,UIActionSheetDelegate>
{
    AVAudioPlayer *_avPlayer;
}


@property(nonatomic,assign)long uid;
@property(nonatomic,strong)NSDictionary *userDic;
@property(nonatomic,strong)NSMutableArray *personMarkArr;
@property(nonatomic,strong)NSMutableArray*userMarkArr;
@property(nonatomic,assign)BOOL isFriend;






@end
