//
//  QCFriendRelationModel.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/11/4.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCFriendRelationModel.h"

@implementation QCFriendRelationModel
- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _Id = [value longValue];
    }
}
@end
