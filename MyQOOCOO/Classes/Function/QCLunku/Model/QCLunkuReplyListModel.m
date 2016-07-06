//
//  QCLunkuReplyListModel.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/10/28.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCLunkuReplyListModel.h"

@implementation QCLunkuReplyListModel


-(NSString*)getReplyContent{
    
    if (!self.toReplyId) {
        return self.content;
    }else{
        return [NSString stringWithFormat:@"回复%zd:%@",self.toReplyId,self.content];
    }
}

-(NSString *)createTime{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //    注意：时间转化之前，需要设置NSDateFormatter的local，因为真机上转化时间的时候会为nil
    dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"YYYY.MM.dd HH:mm"];
    float dateNum = _createTime.floatValue /1000;
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)dateNum];
    
    NSString * showTimeStr = [dateFormatter stringFromDate:confromTimesp];
    
    return showTimeStr;
    
}



@end
