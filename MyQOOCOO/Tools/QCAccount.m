//
//  QCAccount.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/20.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCAccount.h"

static QCAccount *account = nil;
@implementation QCAccount

+(instancetype)shareInstane{
    if (!account ) {
        account = [[self alloc]init];
    }
    return account;
    
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        account = [super allocWithZone:zone];//登陆账号在allocWithZone里面
        //从沙盒获取登陆信息
        NSUserDefaults *defaultsData = [NSUserDefaults standardUserDefaults];
        account.sessionId = [defaultsData objectForKey:@"sessionId"];
        account.expire = [defaultsData objectForKey:@"expire"];
        account.uid = [defaultsData objectForKey:@"uid"];
    });
    
    
    return account;
}
#pragma mark - 保存登陆信息到沙盒
-(void)saveAccountToSandBox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:account.sessionId forKey:@"sessionId"];
    [defaults setObject:account.expire forKey:@"expire"];
    [defaults setObject:account.uid forKey:@"uid"];
    [defaults synchronize];
}
//返回登陆信息
-(BOOL)isLogin{
    return self.sessionId.length;
}

/**
 *  保存cookie
 *
 */
#pragma mark - 保存cookie
-(void)setCookie:(NSString *)cookie{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:cookie forKey:@"cookieValue"];
    _cookieValue = cookie;
    [defaults synchronize];
    
}

/**
 *  注销登陆,清空本地保存的用户信息
 */
-(BOOL)userLogout{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary *dictionary = [defaults dictionaryRepresentation];
//    for (NSString *key in [dictionary allKeys]) {
//        self.sessionId = nil;
//        self.expire = nil;
//        self.uid = nil;
//    }
    self.sessionId = nil;
    return YES;
}

@end
