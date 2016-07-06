//
//  AppDelegate+EaseMob.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/17.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (EaseMob)


@property (strong, nonatomic) NSDate *lastPlaySoundDate;

-(void)easemobApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)lauchOptions;

@end
