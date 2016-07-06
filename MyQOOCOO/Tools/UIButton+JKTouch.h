//
//  UIButton+JKTouch.h
//  FrameSetDemo
//
//  Created by kunge on 16/3/23.
//  Copyright © 2016年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

#define defaultInterval .5  //默认时间间隔

@interface UIButton (JKTouch)

/**设置点击时间间隔*/
@property (nonatomic, assign) NSTimeInterval timeInterval;

@end
