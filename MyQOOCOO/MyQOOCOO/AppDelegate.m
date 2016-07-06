//
//  AppDelegate.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/17.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "AppDelegate.h"
#import "QCTabBarController.h"
#import "QCLoginVC.h"
//环信
#import "AppDelegate+EaseMob.h"

#import "QCNewFeatureVC.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <AlipaySDK/AlipaySDK.h>


//#import "AliPayViewController.h"
#import "GetWorkViewController.h"
#define appKey @"c1c60c0a3bf5"
#define appSecret @"dcd7223953f544d428e7e62d35ebcae4"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Fabric with:@[[Crashlytics class]]];

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //设置根控制器
    //1,没有用过就显示新特性
    NSString *version = [NSUserDefaults versionFromSandBox];
    
    NSString *currentVersion = [NSUserDefaults versionFromInfoPlist];
    if (version == nil) {
        QCNewFeatureVC *newFeatureVC = [[QCNewFeatureVC alloc]init];
        self.window.rootViewController = newFeatureVC;
    }else if ([currentVersion doubleValue] > [version doubleValue]){
        QCNewFeatureVC *newFeatureVC = [[QCNewFeatureVC alloc]init];
        self.window.rootViewController = newFeatureVC;
    }else{
        LoginSession *session = [[ApplicationContext sharedInstance] getLoginSession];
        
        if ([session isValidate]) {
//            QCTabBarController *tabBarVc = [[QCTabBarController alloc]init];
            GetWorkViewController *tabBarVc = [[GetWorkViewController alloc] init];
            self.window.rootViewController = tabBarVc;
        }else{
            QCLoginVC *loginVC = [[QCLoginVC alloc]init];
            self.window.rootViewController = loginVC;
        }
        [self Postpath];
    }
    
    
    //初始化环信SDK
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    [UINavigationBar appearance].tintColor = kGlobalTitleColor;
    //使主窗口可见
    [self.window makeKeyAndVisible];    
    return YES;
}

#pragma mark -- 获取版本号
-(void)Postpath
{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"version"] = @"1.0";
    dic[@"device"] = @"2";
    
    [NetworkManager requestWithURL:GETLASTNEWLY parameter:dic success:^(id response) {
        
        CZLog(@"%@", response);
        NSDictionary * dic = response;
        
        if (dic) {
              NSString*str=  dic[@"version"];
              downloadUrl=dic[@"url"];
            if (![str isEqualToString:[NSUserDefaults versionFromInfoPlist]]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil] ;
                [alert show];
            }
        }else{
//            [OMGToast showText:@"数据加载错误"];
        }
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];

    
    

}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"更新");
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:downloadUrl]];
    }else{
        NSLog(@"取消");
    }
    
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      NSLog(@"result = %@",resultDic);
                                                  }]; }
    if ([url.host isEqualToString:@"platformapi"]){ //支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
   
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
@end
