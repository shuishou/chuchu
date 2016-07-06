//
//  QCQiniuTocken.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/23.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCQiniuTocken : NSObject
@property (nonatomic , strong)NSString *qiniuToken;

+(instancetype)shareInstance;
+(id)allocWithZone:(struct _NSZone *)zone;
+(id)copyWithZone:(struct _NSZone *)zone;
-(NSString *)getQiniuToken;//获取七牛tocken
@end
