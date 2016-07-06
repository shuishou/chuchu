//
//  QCCustomBtn.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/11/4.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCCustomBtn.h"

#define kBtnNums 4
#define kTitleFont 15

@implementation QCCustomBtn


//自定义一个btn,设置btn的title显示在下面
+(QCCustomBtn *)setupFunctionBtn:(NSString *)normalImageName highLightedImageName:(NSString *)highLightedImageName title:(NSString *)title index:(NSInteger)index btnH:(CGFloat)btnH{
    //获取图片的size
    UIImage *btnImage = [UIImage imageNamed:normalImageName];
    //    CGFloat btnImageW = CGImageGetWidth(btnImage.CGImage);
    CGFloat btnImageH = CGImageGetHeight(btnImage.CGImage);
    
    //创建btn
    CGFloat btnW = Main_Screen_Width / kBtnNums ;
//    CGFloat btnH = btnW;
    QCCustomBtn *btn = [[QCCustomBtn alloc]initWithFrame:CGRectMake(index * btnW,0, btnW,btnH)];
    //获取文字的size
    UIFont *btnTitleFont = [UIFont systemFontOfSize:kTitleFont];
    CGSize btnTitleSize = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:btnTitleFont,NSFontAttributeName, nil]];
    [btn.titleLabel setFont:btnTitleFont];
    
    //设置按钮图片
    [btn setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highLightedImageName] forState:UIControlStateHighlighted];
    
    //设置title的属性
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn.layer setBorderColor:UIColorFromRGB(0xE0E0E0).CGColor];
//    [btn.layer setBorderWidth:0.5];
    
    //设置image的center点
    CGPoint btnCenter = CGPointMake(CGRectGetMidX(btn.bounds), CGRectGetMidY(btn.bounds));
    //最终图片的中心点
    CGPoint endImageCeter = CGPointMake(btnCenter.x,btnImageH / 2);
    //最初图片的中心点
    CGPoint startImageCeter = btn.imageView.center;
    
    
    //最终文字的中心点
    CGPoint endTitleCeter = CGPointMake(btnCenter.x, btnH - btnTitleSize.height / 2);
    CGPoint startTitleCeter = btn.titleLabel.center;
    //设置edgeInset
    CGFloat imageTop = endImageCeter.y - startImageCeter.y -10;
    CGFloat imageLeft = endImageCeter.x - startImageCeter.x;
    
    btn.imageEdgeInsets = UIEdgeInsetsMake(imageTop,imageLeft,-imageTop,-imageLeft);
    
    CGFloat titleTop = endTitleCeter.y - startTitleCeter.y;
    CGFloat titleLeft = endTitleCeter.x - startTitleCeter.x;
    btn.titleEdgeInsets = UIEdgeInsetsMake(titleTop, titleLeft, -titleTop, -titleLeft);
    
    return btn;
}

@end
