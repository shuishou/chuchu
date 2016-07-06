//
//  QCFriendInfo.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/3.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"
#import "User.h"

@interface QCFriendInfoVC : QCBaseVC
 /** 根据UserID来创建*/
-(instancetype)initWithUserID:(long)userID;



@property (strong, nonatomic)User *user;
@end
