//
//  QCSearchModel.m
//  MyQOOCOO
//
//  Created by lanou on 16/2/19.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCSearchModel.h"

@implementation QCSearchModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
