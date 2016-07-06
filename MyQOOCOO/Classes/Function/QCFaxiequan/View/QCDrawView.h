//
//  QCDrawView.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/21.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, DrawingMode) {
    DrawingModeNone = 0,
    DrawingModePaint,
    DrawingModeErase,
};
@interface QCDrawView : UIView
@property (nonatomic, readwrite) DrawingMode drawingMode;
@property (nonatomic, strong) UIColor *selectedColor;
@property ( nonatomic , assign) BOOL isDraw;

//把画板的涂鸦转化成图片
-(UIImage *)converViewToImage:(UIView *)view;
@end
