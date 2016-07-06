//
//  QCSearchRecommendModel.m
//  MyQOOCOO
//
//  Created by lanou on 16/2/19.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCSearchRecommendModel.h"

@implementation QCSearchRecommendModel
- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _Id = value;
    }
}

@end
