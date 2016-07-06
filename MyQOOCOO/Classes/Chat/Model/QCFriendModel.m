//
//  QCFriendModel.m
//  MyQOOCOO
//
//  Created by wzp on 15/10/13.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCFriendModel.h"
@implementation QCFriendUserEasy

@end

@implementation QCFriendUser

@end

@implementation QCFriendModel
- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _Id = value;
    }
}
@end
