//
//  UIViewController+Loading.h
//  Smart
//
//  Created by User on 14-10-22.
//  Copyright (c) 2014年 Fenguo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGProgressHUD;

@interface UIViewController (Loading)

@property (nonatomic,retain)JGProgressHUD *progressView;

- (void)popupLoadingView;
/**
 * 显示加载框
 *
 *  @param message 需要显示的文字信息
 */
- (void)popupLoadingView:(NSString*)message;

/**
 *  隐藏加载框
 */
-(void)hideLoadingView;
@end
