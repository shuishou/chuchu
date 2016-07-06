//
//  Global.h
//  Smart
//
//  Created by fenguo on 14-10-23.
//  Copyright (c) 2014年 Fenguo. All rights reserved.
//

#ifndef Smart_Global_h
#define Smart_Global_h



#endif

/* ****************************************************************************************************************** */
#pragma mark - Frame (宏 x, y, width, height)

// App Frame
#define Application_Frame       [[UIScreen mainScreen] applicationFrame]

// App Frame Height&Width
#define App_Frame_Height        [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width         [[UIScreen mainScreen] applicationFrame].size.width

// MainScreen Height&Width
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


// 参数同步----------------------------------

//生活服务支付费用
#define GLOBAL_INFO_LIFEPAY @"service.lifepay"

//保证金级数对应的金额
#define GLOBAL_INFO_DEPOSIT_L4 @"deposit.level4"
#define GLOBAL_INFO_DEPOSIT_L3 @"deposit.level3"
#define GLOBAL_INFO_DEPOSIT_L2 @"deposit.level2"
#define GLOBAL_INFO_DEPOSIT_L1 @"deposit.level1"

//充值金额级数
#define GLOBAL_INFO_RECHARGE_L4 @"recharge.level4"
#define GLOBAL_INFO_RECHARGE_L3 @"recharge.level3"
#define GLOBAL_INFO_RECHARGE_L2 @"recharge.level2"
#define GLOBAL_INFO_RECHARGE_L1 @"recharge.level1"

//提现最低额度
#define GLOBAL_INFO_KITTING_LOWLIMIT @"kiting.lowLimit"
#define GLOBAL_INFO_KITTING_HANDLECHARGE @"kiting.handleCharge"
//客服电话
#define GLOBAL_INFO_SERVICE_PHONE @"service.tel"

//系统常量
#define KEYBOARD_HEIGHT_PHONE 252

static const NSInteger CONTROL_TAG_OFFEST = 100; //tag的起始量
//错误枚举值
typedef NS_ENUM(NSInteger,AppErr){
    //网络出错,访问不到服务端
    ConnectionErr = 0,
    //找不到用户
    LoginErrNOUser = 5000100,
    //登录密码错误
    LoginErrPWDWrong = 5000102,
    //会话信息失效
    AppErrSessionInValid = 5000103,
    //用户未登录
    AppErrUserUnLogin = 5000104,
    
    //生活服务
    ServiceCanceled = 5000402,
    ServiceExpired = 5000403,
    ServiceUngoing = 5000404,
    ServiceNotFound = 5000405,
    
    //代购需求
    RequireNotFound = 5000301,
    RequireBidded = 5000302,
    RequireCanceled = 5000303,
    RequireExpired = 5000304,
    RequireUngoing = 5000305,
    RequireBidNoself = 5000306,
    //最多两次竞价
    RequireBidCountMax = 5000307,
    RequireCanotCancel = 5000308
};

//广告位置枚举值
typedef NS_ENUM(NSInteger,AdvertTag){
    AdvertTagHome = 1,
    AdvertTagSell = 2,
    AdvertTagStore = 3,
    AdvertTagMarket= 4
};

//评论类型枚举值
typedef NS_ENUM(NSInteger,CommentType){
    CommentTypeBox = 0,
    CommentTypeActivity = 1,
    CommentTypeOrderRequire = 2,
    CommentTypeOrderBidding = 3
};

//点赞类型枚举值
typedef NS_ENUM(NSInteger,FavType){
    FavTypeBox = 0,
    FavTypeActivity = 1,
    FavTypeRequire = 2,
    FavTypeService =3
    
};

//个人状态状态枚举值
typedef NS_ENUM(NSInteger,CredentialStatus){
    CredentialStatusInit = 0,
    CredentialStatusPass = 1,
    CredentialStatusReject = 2
};

//是否签到
typedef NS_ENUM(NSInteger,SignStatus){
     SignStatusGo = 0,
     SignStatusDid =1
   
};

//服务需求类型枚举值
typedef NS_ENUM(NSInteger,RequireType){

    RequireTypeInland = 0,
    RequireTypeAbroad = 1,
    RequireTypeEducation = 0,
    RequireTypeHomemaking = 1
};

//搜索类型枚举值
typedef NS_ENUM(NSInteger,SearchType){
    
    SearchTypeInland = 0,
    SearchTypeAbroad = 1,
    SearchTypeEducation = 2,
    SearchTypeHomemaking = 3,
    SearchTypeActivity = 4,
    SearchTypeBox = 5
};


//需求状态

typedef NS_ENUM(NSInteger,StatusType){
    
   StatusTypeGoing = 0,//进行中
   StatusTypeWon = 1,//已中标
   StatusTypeCancel = 2,//已取消
   StatusTypeExpire = 3 //已过期
    
};

//退货单状态
typedef NS_ENUM(NSInteger,OrderReturnStatusType){
    
    OrderReturnStatusTypeSubmit = 0,//进行中
    OrderReturnStatusTypeConfirm = 1,//确认退货
    OrderReturnStatusTypeForceDone = 2,//仲裁退货
    OrderReturnStatusTypeForceCancel = 3, //仲裁取消
    
    OrderReturnStatusTypeRefundInit = 0,//退货－未退款
    OrderReturnStatusTypeRefundOk = 1,//退货－已退款
};

//流水操作类型
typedef NS_ENUM(NSInteger,OperationType){
    
   OperationTypeRecharge = 0, //充值
   OperationTypeAmount = 1,//余额
   OperationTypeKiting = 2,//提现
   OperationTypeOrderIn = 3//订单卖方收入
};

//支付类型
typedef NS_ENUM(NSInteger,PlatformType){
    
    PlatformTypeAlipay = 0, //支付宝
    PlatformTypeUnionpay = 1,//银联
   
    
};
//订阅类型
typedef NS_ENUM(NSInteger,SubscribeType){
    
   SubscribeTypeRequire = 0, //代购
   SubscribeTypeService = 1,//生活服务
   SubscribeTypeActivity= 2,//活动
   
};

//订阅类型
typedef NS_ENUM(NSInteger,TargetType){
    
    TargetTypeBox = 0, //代购
    TargetTypeActivity = 1,//活动
    TargetTypeRequire= 2,//需求
    TargetTypeService= 3,//服务
    
};
//订单状态
static NSString * const OrderStatusToPay = @"待付款";
static NSString * const OrderStatusToSend = @"待发货";
static NSString * const OrderStatusToRecv = @"待收货";
static NSString * const OrderStatusFinish = @"已收货";
static NSString * const OrderStatusCancel = @"已取消";
static NSString * const OrderStatusReturn = @"退货";



//自定义通知中心常量
//用户登录通知
#define AppUserLoginNotification @"AppLoginUserLoginNotification"
//用户信息更新通知
#define AppLoginUserUpdateNotification @"AppLoginUserUpdateNotification"
//用户信息通知
#define AppUserUpdateNotification @"AppUserUpdateNotification"
//用户头像更新通知
#define AppLoginUserLogoUpdateNotification @"AppLoginUserLogoUpdateNotification"
//用户退出通知
#define AppExitUserNotification @"AppExitUserNotification"
//保存用户手机号码通知
#define AppUserPhoneNotification @"AppUserPhoneNotification"

//新增加地址通知
#define AppAddressAddNotification @"AppAddressAddNotification"
//新增我的订阅通知
#define AppSubscribeAddNotification @"AppSubscribeAddNotification"

//更新评论通知
#define AppUpDateCommentNotification @"AppUpDateCommentNotification"

//用户切换城市通知
#define AppChangeCityNotification @"AppChangeCityNotification"

//首页跳转到需求页面通知
#define AppHomeToRequireNotification @"AppHomeToRequireNotification"
//代购需求列表页面的刷新通知
#define RequireListRefreshNotification @"RequireListRefreshNotification"
//生活服务列表页面的刷新通知
#define ServiceListRefreshNotification @"ServiceListRefreshNotification"
//我的活动列表页面刷新通知
#define ActivityListRefreshNotification @"ActivityListRefreshNotification"
//我的竞价列表页面刷新通知
#define BiddingListRefreshNotification @"BiddingListRefreshNotification"
//判断定系统版本
#define isIOS7OrLater [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

//启动页图片名称
#define START_PAGE_IMAGE  @"start_page_image"

/**
 *  添加选择上传的默认图片
 */
#define DEFAULT_IMAGE_ADD_IMAGE @"public_add_photo"

/**
 *  活动默认图片
 */
#define ACTIVITY_DEFAULT_IMAGE @"default_activity_image"

/**
 *  列表默认缩略图片
 */
#define LIST_DEFAULT_IMAGE @"public_default"

/**
 *  默认滚动图片
 */
//#define SCROLL_DEFAULT_IMAGE @"100.png"
/**
 *  用户logo默认图片
 */
//#define USER_DEFAULT_LOGO @"user_default_logo"
#define USER_DEFAULT_LOGO @"public_user_gray"
/**
 *  用户成就的星星图片
 */
#define USER_STAR_NORMAL_IMAGE @"user_star_normal"
#define USER_STAR_SELECT_IMAGE @"user_star_select"

//地址薄的字体颜色
#define ADDRESS_CLOLOR_REQUIRE_IMAGE @"#333239"
/**
 *  广告轮播时间
 */
#define ADVERT_SWITCH_DURATION 5

/**
 *  验证码重新发送时间
 */
#define MAX_CODE_INTERVAL 60

/**
 *  主题颜色，包括导航栏，Tab栏，部分按钮的颜色
 */
#define APPLICATION_THEMECOLOR_DEFALUT [UIColor colorWithRed:(184.0/255.0) green:(145.0/255.0) blue:(94.0/255.0) alpha:1]

/**
 * 最大活动图片数
 */
#define MAX_ACTIVITY_IMAGE 5

/**
 * 最大活动图片数
 */
#define MAX_PRODUCT_IMAGE 5

/**
 * 企业最大产品数
 */
#define MAX_PRODUCT_COMPANY 100

/**
 * 金银铺最大产品数
 */
#define MAX_PRODUCT_STORE 10

//>>>>>>>>以下是样式常量

/**
 *  文字颜色
 */
#define PRICE_DEFAULT_COLOR [UIColor colorWithHexString:@"ff3e00"];

/**
 *  介绍性文字颜色
 */
#define INTRO_DEFAULT_COLOR [UIColor colorWithRed:(130.0/255.0) green:(128.0/255.0) blue:(128.0/255.0) alpha:1]

/**
 *  按钮样式1
 */
#define WDBUTTON_STYLE1_COLOR [UIColor colorWithRed:(184.0/255.0) green:(145.0/255.0) blue:(94.0/255.0) alpha:1]

/**
 *  textfield 默认边缘颜色
 */
#define TEXTFIELD_BORDER_COLOR_DEFAULT [UIColor colorWithRed:(205.0/255.0) green:(205.0/255.0) blue:(205.0/255.0) alpha:1.0f].CGColor;

/**
 * 内嵌网页内容的字体默认大小
 */
#define WEBVIEW_CONTENT_TEXT_SIZE_DEFAULT 15

/**
 * 产品分类界面选中字体颜色
 */
#define CATEGORY_TEXT_COLOR_HIGHLIGHT [UIColor colorWithRed:(255.0/255.0) green:(144.0/255.0) blue:(48.0/255.0) alpha:1.0f]
/**
 * 产品分类界面默认字体颜色
 */
#define CATEGORY_TEXT_COLOR_DEFAULT [UIColor blackColor]
//分享
#define SHARE_REDIRECTURI @"http://www.baidu.com/index.php?tn=01025065_7_pg"

//#define SHARE_REDIRECTURI  @"http://a.app.qq.com/o/simple.jsp?pkgname=com.fenguo.opp.microlight"
