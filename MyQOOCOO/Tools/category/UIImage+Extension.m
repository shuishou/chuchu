//
//  UIImage+Extension.m
//  Weibo
//
//  Created by Vincent_Guo on 15-3-16.
//  Copyright (c) 2015年 Fung. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+(instancetype)imageWithName:(NSString *)imgName{
    // 如果系统大于ios7,使用带有ios7的图片
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0){
        NSString *ios7ImgName = [imgName stringByAppendingString:@"_ios7"];
        return [UIImage imageNamed:ios7ImgName];
    }
    
    return [UIImage imageNamed:imgName];
}

+(instancetype)resizeImgWithName:(NSString *)imgName{
    UIImage *img = [UIImage imageNamed:imgName];
    return [img stretchableImageWithLeftCapWidth:img.size.width * 0.5 topCapHeight:img.size.height * 0.5];
    
}

-(UIImage*)scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
@end
