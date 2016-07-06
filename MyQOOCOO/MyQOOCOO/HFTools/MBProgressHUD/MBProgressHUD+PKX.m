//
//  MBProgressHUD+NJ.m
//
//  Created by 李南江 on 14-5-5.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MBProgressHUD+PKX.h"

@implementation MBProgressHUD (PKX)

#pragma mark  显示信息（基）
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
//    hud.minSize = CGSizeMake(157, 91);
    
    hud.color = kColorRGBA(52,52,52,0.8);
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1];
}

#pragma mark  通讯录索引显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view color:(UIColor *)color
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.labelFont = [UIFont boldSystemFontOfSize:WIDTH(view)/15];
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.color = color;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:0.5];
}

+ (void)showLetter:(NSString *)title icon:(NSString *)icon color:(UIColor *)color
{
    [self show:title icon:icon view:nil color:color];
}

+ (void)showLetter:(NSString *)title color:(UIColor *)color
{
    [self showLetter:title icon:nil color:color];
}

#pragma mark 正确信息（钩）
+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"XR_custom_success.png" view:view];
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}


#pragma mark 网络异常信息（感叹号）  XR_custom_gantanhao.png
+ (void)showNetworkError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"XR_custom_gantanhao.png" view:view];
}

+ (void)showNetworkError:(NSString *)error
{
    [self showNetworkError:error toView:nil];
}


#pragma mark 普通错误信息（显示 X ）
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}



//
//#pragma mark 仅显示菊花指示器   选择是否添加背景蒙版
//+ (MBProgressHUD *)showIndecaterWithBackground:(BOOL)choose toView:(UIView *)view {
//    if (view == nil) {
//        for (UIWindow *window in [UIApplication sharedApplication].windows) {
//            if (!window.isKeyWindow)continue;
//            view = window;
//            break;
//        }
//    }
//    // 快速显示一个提示信息
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    // 隐藏时候从父控件中移除
//    hud.removeFromSuperViewOnHide = YES;
//    // YES代表需要蒙版效果
//    hud.dimBackground = choose;
//    return hud;
//}
//
//+ (MBProgressHUD *)showIndecaterWithBackground:(BOOL)choose
//{
//    return [self showIndecaterWithBackground:choose toView:nil];
//}




#pragma mark 仅显示信息文字  选择是否添加背景蒙版
+ (MBProgressHUD *)showMessage:(NSString *)message background:(BOOL)choose toView:(UIView *)view {
    if (view == nil) {
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
            if (!window.isKeyWindow)continue;
            view = window;
            break;
        }
    }
    // 快速显示一个提示信息
    if (view) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.labelText = message;
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        
        
//        hud.minSize = CGSizeMake(157, 91);
        hud.color = kColorRGBA(52,52,52,0.5);
        
        // YES代表需要蒙版效果
        hud.dimBackground = choose;
        return hud;
    }
    return nil;
}

+ (MBProgressHUD *)showMessage:(NSString *)message background:(BOOL)choose
{
    return [self showMessage:message background:choose toView:nil];
}




#pragma mark - 隐藏 移除
+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
@end
