//
//  LoginSession.h
//  Sport
//
//  Created by fenguo  on 15-1-26.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface LoginSession : NSObject

/**
 *  登录会话ID
 */
@property(nonatomic,copy)  NSString *sessionId;

/**
 *  登录过期时间
 */
@property(nonatomic,assign)  long long expire;

/**
 *  登录用户对象
 */
@property(nonatomic,strong) User *user;

/**
 *  session 是否可用
 *
 *  @return
 */
-(BOOL)isValidate;

/**
 *  通过NSDictionary 初始化对象
 *
 *  @param item
 *
 *  @return LoginSession对象
 */
- (id)initWithDictionary:(NSDictionary*)item;


@end
