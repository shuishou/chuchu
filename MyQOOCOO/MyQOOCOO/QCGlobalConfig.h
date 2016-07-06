//
//  QCGlobalConfig.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/31.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#ifndef MyQOOCOO_QCGlobalConfig_h
#define MyQOOCOO_QCGlobalConfig_h


#endif

/** 测试 ********************************************************************************************** */
#define kTestIP @""


/** 环信 ********************************************************************************************** */
#define kEMClient_id        @"YXA6D1XUwESUEeW0dilkjVGFyA"
#define kEMClient_secret    @"YXA64RiAz4ZqjI_B36GCxVV-DIy9xbg"
#define kApnsCertName       @"None"
#define kHXUserName         @"GZQOOCOO"
#define kHXPassWord         @"GZQOOCOO123"
#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"

// 开发环境宏定义
//#define QC_DEV_ENV     //(真实环境注释该行)

#ifdef QC_DEV_ENV
#define server_v2_addr      @"http://api.dev.xsteach.com"
#define kEMAppKey           @"ifenguo#fenguoim"
#else
//zenlailing.xicp.net:10596

#define server_v2_addr      @"http://api.xsteach.com"
//#define kEMAppKey           @"ifenguo#kupai"
#define kEMAppKey           @"qoocoo666#chuchu"

#endif

/* ** 系统相关的frame ********************************************************************************** */
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)


/* ** 系统相关的frame **************************************************************************** */
#pragma mark - Frame (宏 x, y, width, height)

// App Frame
#define Application_Frame       [[UIScreen mainScreen] applicationFrame]

// App Frame Height&Width
#define App_Frame_Height        [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width         [[UIScreen mainScreen] applicationFrame].size.width

// MainScreen Height&Width
#define Main_Screen_Bounds      [[UIScreen mainScreen] bounds]
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)

// 系统控件默认高度
#define kStatusBarHeight        (20.f)

#define kTopBarHeight           (44.f)
#define kBottomBarHeight        (49.f)

#define kCellDefaultHeight      (44.f)

#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)


//xs兼容
#define     SCREEN_W            [UIScreen mainScreen].bounds.size.width
#define     SCREEN_H            [UIScreen mainScreen].bounds.size.height
#define     kStart_Nav_Y        64
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width

#define kUIScreenH [UIScreen mainScreen].bounds.size.height
#define kUIScreenW [UIScreen mainScreen].bounds.size.width

#define     KFont(size)         [UIFont systemFontOfSize:size]
#define     KFontBold(size)     [UIFont boldSystemFontOfSize:size]

#define     MainBgColor [UIColor colorWithHex:0xf3f7fa]

/** 通知 ********************************************************************************* */
#define kTagsHavedChange @"TagsHavedChange"
/* ** 登陆 ****************************************************************************** */
#define kLoginbackgoundColor UIColorFromRGB(0xed6664)

/* ** 系统字体颜色配置 **************************************************************************** */

//设置item的样式
#define itemFont [UIFont systemFontOfSize:18]
#define normalItemColor UIColorFromRGB(0xed6664)
#define highLightItemColor UIColorFromRGB(0xb73030)

//设置tabBar的颜色,样式
#define normalTabbarColor UIColorFromRGB(0xf8f8f8)
#define funcBarColor UIColorFromRGB(0xed6664)

//分割线颜色
#define kSeparatorColor UIColorFromRGB(0xe0e0e0)

//全局背景颜色
#define kGlobalBackGroundColor UIColorFromRGB(0xf1f1f1)
#define kGlobalTitleColor UIColorFromRGB(0xed6664)

//消息字体颜色
#define kNickNameColor UIColorFromRGB(0x333333)
#define kNickNameFont [UIFont systemFontOfSize:17.0f]
#define kMessageColor UIColorFromRGB(0x666666)
#define kMessageFont [UIFont systemFontOfSize:14.0f]
#define kTimeLabelColor UIColorFromRGB(0x999999)
#define kTimeLabelFont [UIFont systemFontOfSize:14.0f]

//个人资料字体颜色
#define kPersonNickNameLabelColor UIColorFromRGB(0xFFFFFF)
#define kPersonNickNameLabelFont [UIFont systemFontOfSize:17.0f]
#define kPersonNormalColor UIColorFromRGB(0x333333)
#define kPersonDarkColor UIColorFromRGB(0x999999)
//

//block
#define WEAKSELF typeof(self) __weak weakSelf = self;

//通知
#define kDianzanNotification @"dianzanNotification"

//自定义RGB值和透明度的宏
#define kColorRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]


/* ** 自定义缩写 ******************************************************************************** */
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

