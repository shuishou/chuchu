//
//  NSDate+Format.h
//  Smart
//
//  Created by fenguo  on 14-10-25.
//  Copyright (c) 2014年 Fenguo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Format)

/**
 * 按照格式yyyy-MM-dd返回当前的日期字符串
 */
-(NSString*)currentDateString;

/**
 * 按照指定格式返回当前的日期字符串
 */
-(NSString*)currentDateString:(NSString*)formatString;

/**
 * 按照时间格式返回24小时时间
 */
-(NSString*)time24String;

/**
 * 按照对应该的格式，将日期字符串转变成NSDate对象
 */
+(NSDate*)dateWithFormatString:(NSString*)formatString dateString:(NSString*)dateString;

/**
 * 按照"yy:MM:dd HH:mm"的格式，将日期字符串转变成NSDate对象
 */
+(NSDate*)dateTimeFromString:(NSString*)dateString;

@end
