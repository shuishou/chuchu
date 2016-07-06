//
//  QCHTTPEngine.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/19.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCHttpTool.h"

@implementation QCHttpTool

+(void)POST:(NSString *)url params:(id)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
//    NSURLSessionTaskManager *manager = [NSURLSessionTaskManager manager];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    [manager POST:url parameters:params success:^(NSURLSessionTask *operation, id responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//        
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
