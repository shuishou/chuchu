//
//  ShareInstance.h
//  Sport
//
//  Created by fenguo on 15-3-11.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface ShareInstance : NSObject

+ (ShareInstance *)creatInstance;

@property(nonatomic,strong)User *user;
@property(nonatomic,assign)NSInteger unreadFri;

@end
