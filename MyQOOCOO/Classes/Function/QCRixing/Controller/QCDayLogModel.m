//
//  QCDayLogModel.m
//  MyQOOCOO
//
//  Created by Wind on 15/12/25.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCDayLogModel.h"

@implementation QCDayLogModel

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _Id = value;
    }
}
@end
