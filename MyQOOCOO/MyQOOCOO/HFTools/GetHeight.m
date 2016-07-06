//
//  GetHeight.m
//  Backpacking
//
//  Created by lanou on 15/7/24.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "GetHeight.h"

@implementation GetHeight

//实现计算label高度的方法
+(CGFloat)getLabelHeight:(CGFloat)fontSize labelWidth:(CGFloat)labelWidth content:(NSString *)content
{
    //1.写一个CGSize  高度给一个尽量大的值
    CGSize size = CGSizeMake(labelWidth, 10000);
    //2.定义一个字典
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];
    //3.计算高度
    CGRect rect = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    //4.返回高度
    return rect.size.height;
}

@end
