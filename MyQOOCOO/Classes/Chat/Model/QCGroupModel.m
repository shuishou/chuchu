//
//  QCGroupModel.m
//  MyQOOCOO
//
//  Created by wzp on 15/10/13.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCGroupModel.h"

@implementation QCGroupModel
@dynamic description;
//+(NSDictionary *)objectClassInArray{
//    return @{@"user" : @"User"};
//}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _Id = value;
    }
}
@end
