//
//  QCRecommendMarkModel.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/11/4.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCRecommendMarkModel.h"

@implementation QCRecommendMarkModel
- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _Id = (long)value;
    }
}
@end
