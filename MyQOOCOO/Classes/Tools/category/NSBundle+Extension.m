//
//  NSBundle+Extension.m
//  myWeibo
//
//  Created by Fly_Fish_King on 15/5/7.
//  Copyright (c) 2015年 Fly_Fish_King. All rights reserved.
//

#import "NSBundle+Extension.h"

@implementation NSBundle (Extension)
+(id)loadNibNamedFrom:(NSString *)NibNamed{
    
    return [[[NSBundle mainBundle ] loadNibNamed:NibNamed owner:nil options:nil] lastObject];
}

@end
