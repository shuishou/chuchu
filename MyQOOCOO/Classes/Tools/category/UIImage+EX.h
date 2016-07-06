//
//  UIImage+EX.h
//  XSTeachEDU
//
//  Created by xsteach on 15/1/29.
//  Copyright (c) 2015年 xsteach.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (EX)
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
+ (UIImage *)setImage:(UIImage *)image withAlpha:(CGFloat)alpha;
@end
