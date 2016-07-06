//
//  UIView+Extension.h
//  myWeibo
//
//  Created by Fly_Fish_King on 15/5/5.
//  Copyright (c) 2015年 Fly_Fish_King. All rights reserved.
//

#import <UIKit/UIKit.h>
CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (Extension)
@property ( nonatomic , assign) CGFloat x;
@property ( nonatomic , assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property ( nonatomic , assign) CGFloat width;
@property ( nonatomic , assign) CGFloat height;

@property ( nonatomic , assign) CGSize size;
@property ( nonatomic , assign) CGPoint origin;

//xs分类
@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;


@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

@end
