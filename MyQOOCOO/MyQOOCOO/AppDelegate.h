//
//  AppDelegate.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/17.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCChatListVC.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,IChatManagerDelegate>
{
    EMConnectionState _connectionState;
    
    NSString*downloadUrl;
    QCChatListVC *chatCtr;
}

@property (strong, nonatomic) UIWindow *window;


@end

