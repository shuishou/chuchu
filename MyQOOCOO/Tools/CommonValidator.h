//
//  CommonValidator.h
//  Sport
//
//  Created by fenguo  on 15/2/7.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonValidator : NSObject

/**
 *  是否正确的手机号码
 *
 *  @return
 */
+ (BOOL)isPhoneNumber:(NSString*)number;

/**
 *  是否为正确的价格格式
 *
 *  @param price
 *
 *  @return
 */
+ (BOOL)isPrice:(NSString*)price;

@end
