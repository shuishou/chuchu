//
//  QCAccount.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/20.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface QCAccount : NSObject


//返回的数据
@property (nonatomic , copy) NSString *sessionId;//登录session
@property ( nonatomic , copy) NSString *expire;//过期时间
@property ( nonatomic , copy) NSString *uid;//用户id
@property (nonatomic , copy) NSString *hid;//环信ID
@property (nonatomic , copy) NSString *phone;//手机号
@property (nonatomic , copy) NSString *hpass;//环信密码
@property (nonatomic , copy) NSString *avatarUrl;//头像URL
@property (nonatomic , copy) NSString *nickname;//昵称
@property ( nonatomic , copy) NSString *sex;//性别
@property ( nonatomic , assign) long long createTime;//注册时间
@property ( nonatomic , assign) long long lastAccessTime;//上次访问的时间

@property (nonatomic , copy) NSString *cookieValue;//登陆信息保存
@property (nonatomic , strong)User *user;


/**
 *  用户是否登录过
 *
 */
-(BOOL)isLogin;

/**
 *  把账号信息保存到沙盒(用户偏好设置)
 */
-(void)saveAccountToSandBox;

+(QCAccount *)shareInstance;


-(void)setUserInfo:(NSDictionary *)infoDic;
-(void)setCookie:(NSString *)cookie;
-(void)setSignIn:(NSString *)infoDic;
//-(void)setUserAvatar:(NSString *)avatarID;
-(BOOL)userLogout;

@end
