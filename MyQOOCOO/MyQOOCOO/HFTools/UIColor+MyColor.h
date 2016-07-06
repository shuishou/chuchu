//
//  UIColor+MyColor.h
//  mffm
//
//  Created by linaicai on 14-5-29.
//  Copyright (c) 2014年 li naicai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MyColor)
+ (UIColor *)CustomSeparatorViewColor;
+ (UIColor *)CustomOrangeColor;
+ (UIColor *)IncomingBubbleTextColor;
+ (UIColor *)OutcomingBubbleTextColor;
+ (UIColor *)OutcomingBubbleBackgroundColor;
+ (UIColor *)IncomingBubbleBackgroundColor;
+ (UIColor *)NavigationBarBackgroundColor;
+ (UIColor *)TabBarBackgroundColor;
+ (UIColor *)TabBarTitleColor;
+ (UIColor *)ViewBackgroundColor;
+ (UIColor *)ViewBgColor;
+ (UIColor *)CellTitleColor;
+ (UIColor *)cellBackgroundColor1;
+ (UIColor *)cellBackgroundColor2;
+ (UIColor *)cellBackgroundColor3;
+ (UIColor *)cellBackgroundColor4;
+ (UIColor *)cellBackgroundColor5;
+ (UIColor *)cellBackgroundColor6;
+ (UIColor *)cellBackgroundColor7;
+ (UIColor *)cellBackgroundColor8;
+ (UIColor *)cellBackgroundColor9;
+ (UIColor*) themeColor;

//markerSearch
+ (UIColor *)searchResultTextColor;
+ (UIColor *)searchBgColor;

#pragma mark - table view
+ (UIColor*) tableViewBackgroundColorEFEFF4;
+ (UIColor*) tableViewSeparaterColorEAEAEA;
#pragma mark- 通用方法
    //根据16进制获取一个颜色
+ (UIColor *) colorWithHexString: (NSString *)color;
@end
