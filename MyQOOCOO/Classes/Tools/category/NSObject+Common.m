//
//  NSObject+Common.m
//  Sport
//
//  Created by fenguo  on 15/3/30.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#import "NSObject+Common.h"
#import "NSDate+Common.h"

@implementation NSObject (Common)

//- (NSString *)timeAgoString:(NSNumber*)timestamp {
//    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:timestamp.longLongValue/1000];
//    NSString *startTimeString = [date stringTimesAgo];
//    return startTimeString;
//}
- (NSString *)timeAgoString:(NSNumber*)timestamp {
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:timestamp.longLongValue/1000];
    NSString *startTimeString = [date stringTimesAgo];
    return startTimeString;
}

@end
