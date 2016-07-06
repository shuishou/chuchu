//
//  QCFunctionBtn.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/29.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCFunctionBtn.h"

@implementation QCFunctionBtn

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

//自定义一个btn,设置btn的title显示在下面
+(QCFunctionBtn *)setupFunctionBtn:(NSString *)normalImageName highLightedImageName:(NSString *)highLightedImageName title:(NSString *)title index:(NSInteger)index {
    //获取图片的size
    UIImage *btnImage = [UIImage imageNamed:normalImageName];
    //    CGFloat btnImageW = CGImageGetWidth(btnImage.CGImage);
    CGFloat btnImageH = CGImageGetHeight(btnImage.CGImage);
    
    //创建btn
    CGFloat btnW = Main_Screen_Width / 3 ;
    CGFloat btnH = btnW;
    //把UIBotton改为QCFunctionButton
    QCFunctionBtn *btn = [[QCFunctionBtn alloc]initWithFrame:CGRectMake(index * btnW,0, btnW,btnH)];
    //获取文字的size
    UIFont *btnTitleFont = [UIFont systemFontOfSize:15];
    CGSize btnTitleSize = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:btnTitleFont,NSFontAttributeName, nil]];
    [btn.titleLabel setFont:btnTitleFont];
    
    //设置按钮图片
    [btn setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    //    [btn setImage:[UIImage imageNamed:highLightedImageName] forState:UIControlStateHighlighted];
    
    //设置title的属性
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [btn.layer setBorderColor:UIColorFromRGB(0xE0E0E0).CGColor];
    [btn.layer setBorderWidth:0.5];
    
    
    if (title.length > 0) {
        //设置image的center点
        CGPoint btnCenter = CGPointMake(CGRectGetMidX(btn.bounds), CGRectGetMidY(btn.bounds));
        //最终图片的中心点
        CGPoint endImageCeter = CGPointMake(btnCenter.x,btnCenter.y -(btnImageH / 2)+HEIGHT(btn)/4);
        //最初图片的中心点
        CGPoint startImageCeter = btn.imageView.center;
        //最终文字的中心点
        CGPoint endTitleCeter = CGPointMake(btnCenter.x, btnCenter.y + (btnTitleSize.height / 2 + 15));
        CGPoint startTitleCeter = btn.titleLabel.center;
        
        //设置edgeInset
        CGFloat imageTop = endImageCeter.y - startImageCeter.y;
        CGFloat imageLeft = endImageCeter.x - startImageCeter.x;
        btn.imageEdgeInsets = UIEdgeInsetsMake(imageTop,imageLeft,-imageTop,-imageLeft);
        
        CGFloat titleTop = endTitleCeter.y - startTitleCeter.y;
        CGFloat titleLeft = endTitleCeter.x - startTitleCeter.x;
        btn.titleEdgeInsets = UIEdgeInsetsMake(titleTop, titleLeft, -titleTop, -titleLeft);
    }
    else
    {
        
    }
    
    
    return btn;
}


@end
