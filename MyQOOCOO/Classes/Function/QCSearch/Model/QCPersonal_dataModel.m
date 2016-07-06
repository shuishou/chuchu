//
//  QCPersonal_dataModel.m
//  MyQOOCOO
//
//  Created by Wind on 15/12/3.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCPersonal_dataModel.h"

@implementation QCPersonal_dataModel
- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _Id = value;
    }
}
@end
