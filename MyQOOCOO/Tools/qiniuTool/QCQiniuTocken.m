//
//  QCQiniuTocken.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/23.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCQiniuTocken.h"

@implementation QCQiniuTocken

+(instancetype)shareInstance{
    static QCQiniuTocken *token = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        token = [[self alloc]init];
    });
    return token;
}
//当调用alloc方法的时候,会调用allocWithZone这个方法,所以重写这个方法
+(id)allocWithZone:(struct _NSZone *)zone{
    return [QCQiniuTocken shareInstance];
}

+(id)copyWithZone:(struct _NSZone *)zone{
    return [QCQiniuTocken shareInstance];
}

-(NSString *)getQiniuToken{
    [NetworkManager requestWithURL:QINIU_TOCKEN_URL parameter:nil success:^(id response) {
        NSString *urlString = [QCHttpApiBaseURL stringByAppendingString:QINIU_TOCKEN_URL];
        NSURL *url = [NSURL URLWithString:urlString];
        NSString *jsonString = [[NSString alloc]initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *dict = [jsonString objectFromJSONString];
        _qiniuToken = [dict valueForKey:@"data"];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        
    }];
    return _qiniuToken;
}

@end
