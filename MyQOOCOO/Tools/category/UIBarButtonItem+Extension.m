//
//  UIBarButtonItem+Extension.m
//  myWeibo
//
//  Created by Fly_Fish_King on 15/5/6.
//  Copyright (c) 2015年 Fly_Fish_King. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)


//实例化返回一个barButtonItemwithImage

+(instancetype)addBarBtnImg:(NSString *)img highlightedImg:(NSString *)highlightedImg target:(id)target action:(SEL)action{
    //1,设置leftBarButtonItem的点击事件
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *normalImg = [UIImage imageNamed:img];
    
    [btn setImage:normalImg forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightedImg] forState:UIControlStateHighlighted];
    
    btn.bounds = CGRectMake(0, 0, normalImg.size.width, normalImg.size.height);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return  [[UIBarButtonItem alloc]initWithCustomView:btn];
   
}

//实例化一个barButtonItemWithImageAndTitle
+(instancetype)addBarBtnImg:(NSString *)img highlightedImg:(NSString *)highlightedImg title:(NSString *)title target:(id)target action:(SEL)action{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normalImg = [UIImage imageNamed:img];
    [btn setImage:normalImg forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightedImg] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    //设置btn的frame
    //1,设置字体的大小
    UIFont *titleFont = itemFont;
    btn.titleLabel.font = titleFont;
    //2,设置字体的颜色,有普通状态和高亮状态
    [btn setTitleColor:normalItemColor forState:UIControlStateNormal];
    [btn setTitleColor:highLightItemColor forState:UIControlStateHighlighted];
    //3,计算字体的尺寸
    CGSize maxTitle = CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize titleSize = [btn.titleLabel.text boundingRectWithSize:maxTitle options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:titleFont} context:nil].size;
    
    btn.bounds = CGRectMake(0, 0, normalImg.size.width + titleSize.width, normalImg.size.height );
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
   return  [[UIBarButtonItem alloc]initWithCustomView:btn];
    
}
//实例化一个barButtonItemWithTitle
+(instancetype)addBarBtnTitle:(NSString *)title target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
//    1,设置字体的大小
    UIFont *titleFont = [UIFont systemFontOfSize:15];
    btn.titleLabel.font =titleFont ;
//    2,设置字体的颜色
    [btn setTitleColor:normalItemColor forState:UIControlStateNormal];
    [btn setTitleColor:highLightItemColor forState:UIControlStateHighlighted];
    
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
//    3,计算字体的尺寸
    CGSize maxTitle = CGSizeMake(MAXFLOAT, MAXFLOAT);

    CGSize titleSize =[title boundingRectWithSize:maxTitle options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:titleFont} context:nil ].size;
    
    btn.bounds = CGRectMake(0, 0, titleSize.width, titleSize.height);
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    
}




@end
