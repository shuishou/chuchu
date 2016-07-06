//
//  UIColor+MyColor.m
//  mffm
//
//  Created by linaicai on 14-5-29.
//  Copyright (c) 2014年 li naicai. All rights reserved.
//

#import "UIColor+MyColor.h"
@implementation UIColor (MyColor)
+ (UIColor *)CustomSeparatorViewColor
{
    return [self colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:0.3];
}
+ (UIColor *)CustomOrangeColor
{
    return [self colorWithRed:235/255.0 green:142/255.0 blue:51/255.0 alpha:1.0];
}
+ (UIColor *)IncomingBubbleTextColor
{
    return [self colorWithHexString:@"383838"];
}
+ (UIColor *)OutcomingBubbleTextColor
{
    return [self colorWithHexString:@"ffffff"];
}
+ (UIColor *)OutcomingBubbleBackgroundColor
{
    return [self colorWithHexString:@"808080"];
}
+ (UIColor *)IncomingBubbleBackgroundColor
{
    return [self colorWithHexString:@"ececec"];
}
+ (UIColor *)NavigationBarBackgroundColor
{
    return [self colorWithHexString:@"2146a9"];
}
+ (UIColor *)TabBarBackgroundColor
{
    return [UIColor colorWithHexString:@"b2a5b5"];
}
+ (UIColor *)TabBarTitleColor
{
     return [self colorWithHexString:@"1d8ae9"];
}
+ (UIColor *)CellTitleColor
{
    return [self colorWithHexString:@"262626"];
}
+ (UIColor *)ViewBackgroundColor
{
    return [self colorWithHexString:@"e97c13"];
}
+ (UIColor *)ViewBgColor
{
    return [self colorWithHexString:@"efefef"];
}

+ (UIColor *)searchResultTextColor
{
    return [self colorWithHexString:@"666666"];
}

+ (UIColor *)searchBgColor{
    
    return [self colorWithHexString:@"efeff4"];
}


#pragma mark- 随即色
+ (UIColor *)cellBackgroundColor1
{
    return [self colorWithRed:206/255.0 green:80/255.0 blue:106/255.0 alpha:1.0];
}
+ (UIColor *)cellBackgroundColor2
{
    return [self colorWithRed:248/255.0 green:207/255.0 blue:100/255.0 alpha:1.0];
}
+ (UIColor *)cellBackgroundColor3
{
    return [self colorWithRed:90/255.0 green:193/255.0 blue:229/255.0 alpha:1.0];
}
+ (UIColor *)cellBackgroundColor4
{
    return [self colorWithRed:220/255.0 green:125/255.0 blue:163/255.0 alpha:1.0];
}
+ (UIColor *)cellBackgroundColor5
{
    return [self colorWithRed:93/255.0 green:202/255.0 blue:200/255.0 alpha:1.0];
}
+ (UIColor *)cellBackgroundColor6
{
    return [self colorWithRed:234/255.0 green:176/255.0 blue:131/255.0 alpha:1.0];
}
+ (UIColor *)cellBackgroundColor7
{
    return [self colorWithRed:249/255.0 green:132/255.0 blue:159/255.0 alpha:1.0];
}
+ (UIColor *)cellBackgroundColor8
{
    return [self colorWithRed:255/255.0 green:208/255.0 blue:0/255.0 alpha:1.0];
}
+ (UIColor *)cellBackgroundColor9
{
    return [self colorWithRed:0/255.0 green:183/255.0 blue:229/255.0 alpha:1.0];
}

+ (UIColor*) themeColor
{
    return [UIColor colorWithHexString:@"dd8822"];
}

+ (UIColor*) tableViewBackgroundColorEFEFF4
{
    return [UIColor colorWithHexString:@"efeff4"];
}

+ (UIColor*) tableViewSeparaterColorEAEAEA
{
    return [UIColor colorWithHexString:@"eaeaea"];
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
        // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
        // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
        // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
        //r
    NSString *rString = [cString substringWithRange:range];
    
        //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
        //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
        // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
@end
