//
//  chat_config.h
//  MyQOOCOO
//
//  Created by wzp on 15/9/23.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#ifndef chat_config_h
#define chat_config_h

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"

#define CHATVIEWBACKGROUNDCOLOR [UIColor colorWithRed:0.936 green:0.932 blue:0.907 alpha:1]

#endif /* chat_config_h */

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "EMAlertView.h"
#import "TTGlobalUICommon.h"
#import "UIViewController+HUD.h"
#import "UIViewController+DismissKeyboard.h"
#import "NSString+Valid.h"

#import "EaseMob.h"

#endif
