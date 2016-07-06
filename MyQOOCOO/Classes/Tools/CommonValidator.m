//
//  CommonValidator.m
//  Sport
//
//  Created by fenguo  on 15/2/7.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#import "CommonValidator.h"

@implementation CommonValidator

+ (BOOL)isPhoneNumber:(NSString*)number {
    NSString *regex = @"^((13[0-9])|(17[0-9])|(147)|(15[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
}

+ (BOOL)isPrice:(NSString*)price{
    NSString *regex = @"^\\d+(\\.\\d{0,2})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:price];
    return isMatch;
}

@end
