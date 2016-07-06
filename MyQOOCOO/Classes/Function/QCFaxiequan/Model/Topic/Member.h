//
//  Member.h
//  Sport
//
//  Created by fenguo  on 15/3/27.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject

//id
@property(assign, nonatomic)NSInteger id;

/**
 *  用户id
 */
@property(nonatomic,assign)NSInteger uid;

/**
 *  环信id
 */
@property(nonatomic,copy)NSString *hid;

/**
 *  环信密码
 */
@property(nonatomic,copy)NSString *hpass;

/**
 *  用户姓名
 */
@property(nonatomic,copy)NSString *name;

/**
 *  用户头像的url
 */
@property(nonatomic,copy) NSString *avatarUrl;

@end
