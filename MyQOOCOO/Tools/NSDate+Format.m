//
//  NSDate+Format.m
//  Smart
//
//  Created by fenguo  on 14-10-25.
//  Copyright (c) 2014年 Fenguo. All rights reserved.
//

#import "NSDate+Format.h"

@implementation NSDate (Format)

-(NSString*)currentDateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString =  [formatter stringFromDate:self];
    //[formatter release];
    return dateString;
}

-(NSString*)currentDateString:(NSString*)formatString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    NSString *dateString =  [formatter stringFromDate:self];
    //[formatter release];
    return dateString;
}

//获取当前得时间
-(NSString*)time24String{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"hh:mm a"]; //十二小时制
    [formatter setDateFormat:@"HH:mm"]; //24小时
    NSString *dateString =  [formatter stringFromDate:self];
    //[formatter release];
    return dateString;
}

+(NSDate*)dateWithFormatString:(NSString*)formatString dateString:(NSString*)dateString{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatString];
    NSDate *date = [dateFormat dateFromString:dateString];
    //[dateFormat release];
    return date;
}

+(NSDate*)dateTimeFromString:(NSString*)dateString {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateFormat dateFromString:dateString];

    return date;
}

@end
