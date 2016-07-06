//
//  QCNavigationController.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/17.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCNavigationVC.h"

@interface QCNavigationVC ()<UIGestureRecognizerDelegate>

@end

@implementation QCNavigationVC
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条背景,在另外一个方法中更改颜色
    UINavigationBar *navbar = [UINavigationBar appearance];
    if (!iOS7) {
        navbar.translucent = YES;//半透明的
    }
    
    self.view.backgroundColor = kGlobalBackGroundColor;//全局颜色
    
    //   设置导航条标题样式
    NSMutableDictionary * attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName]= normalItemColor;
    attributes[NSFontAttributeName] =[UIFont systemFontOfSize:20];
    [navbar setTitleTextAttributes:attributes];
}

#pragma mark - 当导航控制器push去掉导航栏的线条
-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithRootViewController:rootViewController]) {
        // 设置全局样式
        
        if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
            
            NSArray *list=self.navigationBar.subviews;
            
            for (id obj in list) {
                
                if ([obj isKindOfClass:[UIImageView class]]) {
                    
                    UIImageView *imageView=(UIImageView *)obj;
                    
                    imageView.hidden=YES;
                    
                }
                
            }
            
            
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -20, Main_Screen_Width, 64)];
            
            imageView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithColor:UIColorFromRGB(0xf8f8f8) andSize:imageView.bounds.size]];
            
            [self.navigationBar addSubview:imageView];
            
            [self.navigationBar sendSubviewToBack:imageView];
            
            self.navigationBar.translucent = YES;
            
            self.myNavigationBar = imageView;
        }
    }
    return self;
}


#pragma mark - 拦截导航栏push方法,设置两个按钮
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSInteger navChildCount = self.viewControllers.count;
    if (navChildCount > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem addBarBtnImg:@"Arrow" highlightedImg:@"Arrow" target:self action:@selector(back)];
//        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem addBarBtnTitle:@"完成" target:self action:@selector(menu)];
    }
    
//    //如果在push方法中禁用手势
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//            self.interactivePopGestureRecognizer.enabled = NO;
//    }
    
    //这里是它的父类来pushView
    [self resetNavigationBarColor:normalTabbarColor];
    [super pushViewController:viewController animated:YES];
}

-(void)back{
    [self popViewControllerAnimated:YES];
//    self.navigationBarHidden = YES;
    
}
-(void)menu{
    [self popToRootViewControllerAnimated:YES];

}

//重写navigationBar的背景颜色
-(void)resetNavigationBarColor:(UIColor *)color{
    [self.navigationBar setBarTintColor:color];
}

#pragma mark - 重新启用手势返回功能(还没实现)
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


@end
