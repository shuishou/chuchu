//
//  UIColor+Hex.h
//  XSTeachBBS
//
//  Created by Jacky Chan on 9/17/14.
//  Copyright (c) 2014 XSTeach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;

@end