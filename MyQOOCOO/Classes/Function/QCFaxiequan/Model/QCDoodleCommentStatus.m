//
//  QCDoodleCommentCell.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/25.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCDoodleCommentStatus.h"

@implementation QCDoodleCommentStatus

-(NSString *)createtime{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //    注意：时间转化之前，需要设置NSDateFormatter的local，因为真机上转化时间的时候会为nil
    dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"YYYY.MM.dd HH:mm"];
     float dateNum = _createtime.floatValue /1000;
     NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)dateNum];
     
     NSString * showTimeStr = [dateFormatter stringFromDate:confromTimesp];
     
     return showTimeStr;
     
     }



@end
