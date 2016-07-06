//
//  MBProgressHUD+NJ.h
//
//  Created by 李南江 on 14-5-5.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (PKX)

// 基方法
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view;
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view color:(UIColor *)color;

//通讯录索引显示信息(自定义)
+ (void)showLetter:(NSString *)title icon:(NSString *)icon color:(UIColor *)color;
+ (void)showLetter:(NSString *)title color:(UIColor *)color;

// 正确信息（大钩）
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success;

// 网络异常信息（感叹号）
+ (void)showNetworkError:(NSString *)error toView:(UIView *)view;
+ (void)showNetworkError:(NSString *)error;

// 普通错误信息（显示 X ）
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showError:(NSString *)error;


#pragma mark - 带指示器、蒙版

// 显示信息文字  选择是否添加背景蒙版   需要和隐藏方法搭配使用
+ (MBProgressHUD *)showMessage:(NSString *)message background:(BOOL)choose toView:(UIView *)view;
+ (MBProgressHUD *)showMessage:(NSString *)message background:(BOOL)choose;

//  隐藏
+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;


@end
