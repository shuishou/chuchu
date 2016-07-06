//
//  QCHTTPEngine.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/19.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^QCCopletionBlock)(NSDictionary *respData);
typedef void(^QCFailedBlokc) (NSString *ErrMsg);

@interface QCHttpTool : NSObject
+(void)POST:(NSString *)url params:(id)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end
