//
//  UIViewController+Loading.m
//  Smart
//加载
//  Created by User on 14-10-22.
//  Copyright (c) 2014年 Fenguo. All rights reserved.
//

#import "UIViewController+Loading.h"
#import <objc/runtime.h>
#import "JGProgressHUD.h"

@implementation UIViewController (Loading)
    
static char const *JGProgressHUDTagKey = "JGProgressHUD";
@dynamic progressView;
//加载
- (void)popupLoadingView{
    self.progressView = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
    [self.progressView showInView:self.view animated:YES];
    
}
//加载中添加文字
- (void)popupLoadingView:(NSString *)message{
    self.progressView = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    self.progressView.textLabel.text =message;
    [self.progressView showInView:self.view animated:YES];
    
}
//隐藏加载框
- (void)hideLoadingView{
    if(self.progressView){
        [self.progressView dismiss];
        self.progressView = nil;
    }
}
- (id)progressView{
    return  objc_getAssociatedObject(self, JGProgressHUDTagKey);
}
- (void)setProgressView:(JGProgressHUD *)progressView{
    objc_setAssociatedObject(self, JGProgressHUDTagKey,progressView,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
@end
