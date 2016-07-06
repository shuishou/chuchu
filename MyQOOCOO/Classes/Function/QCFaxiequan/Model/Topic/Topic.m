//
//  Topic.m
//  Sport
//
//  Created by fenguo on 15-1-29.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#import "Topic.h"
#import "ImageItem.h"
#import "NSDate+Format.h"

@implementation Topic


- (NSDictionary *)objectClassInArray
{
    return @{@"images":[ImageItem class]};
}

-(NSDate*)getCreateTime{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:self.create_time.longLongValue/1000];
    return date;
}

-(NSString*)getCreateTimeStr{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:self.create_time.longLongValue/1000];
    NSString *startTimeString = [date currentDateString:@"yyyy-MM-dd hh:MM:ss"];
    return startTimeString;
}

@end
