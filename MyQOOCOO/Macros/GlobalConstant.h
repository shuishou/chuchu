//
//  GlobalConstant.h
//  Sport
//  全局常量
//  Created by fenguo  on 15-1-21.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#ifndef Sport_GlobalConstant_h
#define Sport_GlobalConstant_h


#pragma mark - custom
//发布点滴的类型
typedef NS_ENUM(NSInteger,RecordType){
    RecordTypeNormal = 1, //普通点滴
    RecordTypeVideo = 2,  //视频点滴
};
//谁可以看
typedef NS_ENUM(NSInteger, PermissionType) {
    PermissionTypeAll = 1,//所有人
    PermissionTypeOnlyMyself = 2,//仅仅自己看
    PermissionTypeSome = 3,//部分人
};

//点滴发到哪里
typedef NS_ENUM(NSInteger, TypeDiandiKind) {
    TypeDiandiKindNeiquan = 1,
    TypeDiandiKindWaiquan = 2,
    TypeDiandiKindDiary = 3,
};

//评论类型
typedef NS_ENUM(NSInteger,CommentType){
    CommentTypeTopic = 0, //评论帖子
    CommentTypeReply = 1,  //回复评论
    
};











//-------------------------自定义通知中心常量
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
//天气信息通知
#define AppWeatherNotification @"AppWeatherNotification"
//论坛球类切换信息通知
#define AppForumSportSwitchNotification @"AppForumSportSwitchNotification"
//--------------------------

//服务请求状态码枚举值
typedef NS_ENUM(NSInteger, StateCode){
    //网络出错,访问不到服务端
    StateConnectionError = 0,
    //请求成功，正常
    StateOk = 2000000,
    
    //找不到用户
    StateLoginErrorNOUser = 5000100,
    //登录密码错误
    StateLoginErrorPWDWrong = 5000102,
    //会话信息失效
    StateSessionInValid = 5000103,
    //用户未登录
    StateUserErrorUnLogin = 5000104,
    //超出时间
    StateDateError = 5000704,
};


/**  ******************************************************************************* */

//帖子分类
typedef NS_ENUM(NSInteger,TopicSortType){
    TopicSortTypeHot = 0, //热门
    TopicSortTypeFav = 1,  //最多点赞
    TopicSortTypeLatest = 2  //最新
   
};

//发布帖子类型
typedef NS_ENUM(NSInteger,TopicType){
    TopicTypeNormal = 0, //普通帖子
    TopicTypeFight = 1,  //约战帖子
    
    
};

//男女
typedef NS_ENUM(NSInteger,SexType){
    SexTypeBoy = 0, //男
    SexTypeGirl = 1,  //女
  
};

//评论类型
typedef NS_ENUM(NSInteger,CommenType){
    CommenTypeTopic = 0, //评论帖子
    CommenTypeReply = 1,  //回复评论
    
};

//点赞类型
typedef NS_ENUM(NSInteger,FavType){
    FavTypeTopic = 0, //帖子
    FavTypeStadium = 1,  //场馆
    
};


//收藏类别
typedef NS_ENUM(NSInteger,CollectionType){
     CollectionTypeStadium= 0, //场馆
     CollectionTypeTopic = 1,  //帖子
    
};

//首页场馆排序
typedef NS_ENUM(NSInteger,StadiumSortType){
    StadiumSortTypeNearby = 0, //离我最近
    StadiumSortTypePriceASC = 1,  //价格从低到高
    StadiumSortTypePriceDESC = 2 //价格从高到低
};

//收藏类型枚举值
typedef NS_ENUM(NSInteger,CollectType){
    CollectTypeStadium = 0,
    CollectTypeTopic = 1
};

//商家还是普通用户
typedef NS_ENUM(NSInteger,UserType){
    UserTypeNormal = 0,//普通用户
    UserTypeBusiness = 1  //商家
};

//消息
typedef NS_ENUM(NSInteger,MessageType){
    MessageTypeAttention= 0, //我的关注
    MessageTypeFans = 1,  //我的粉丝
    MessageTypeNews = 2 //新的消息
};

//关注那个人的信息
typedef NS_ENUM(NSInteger,InfoType){
    InfoTypeAttention= 0, //我的关注
    InfoTypeFans = 1,  //我的粉丝
    InfoTypeTopic = 2 //他发布的帖子
};


//好友关系的类型
typedef NS_ENUM(NSInteger,FriendType){
    FriendTypeAttention= 0, //关注
    FriendTypeFans = 1,  //粉丝
    FriendTypeTogetherAttention = 2 ,//互相关注——暂时没有用到
    FriendTypeNoAttention = 3 //相互不关注

};

//场次类型
typedef NS_ENUM(NSInteger,GroundType){
    GroundTypeNonRound = 0, //无场次
    GroundTypeRound = 1,  //有场次
    GroundTypeLook = 2  //只供查看
};

//支付平台类型
typedef NS_ENUM(NSInteger,PlatformType){
    PlatformTypeAliPay= 0, //支付宝
    PlatformTypeWeiXin = 1,//微信支付
    PlatformTypeBank//银联
};

//订单状态
static NSString * const OrderStatusToPay = @"TOPAY";//@"待付款";
static NSString * const OrderStatusToSpend = @"TOSPEND";//@"待消费";
static NSString * const OrderStatusToComment = @"TOCOMMENT";//@"待评价";
static NSString * const OrderStatusFinish = @"FINISH";//@"已结束";
static NSString * const OrderStatusExpire = @"EXPIRE";//@"已过期";
static NSString * const OrderStatusCacel = @"CANCEL";//@"已取消";
static NSString * const OrderStatusInvalid = @"INVALID";
//一次预定场次数量
static NSInteger BookMaxSize = 10;
/**
 *  默认分页数量
 */
#define DEFAULT_PAGE_SIZE 20

//－－－－－－－－－－－－－－－－默认图片

//启动页图片名称
#define START_PAGE_IMAGE  @"start_page_image"

/**
 *  默认滚动图片
 */
#define DEFAULT_SCROLL_IMAGE @"default_home_scrollView_photo"

/**
 *  默认场馆列表图片
 */
#define DEFAULT_STADIUM_IMAGE @"default_stadiumList_photo"

/**
 *  默认帖子列表图片
 */
#define DEFAULT_TOPIC_IMAGE @"default_forum_photo"


/**
 *  用户的个人资料的头像
 */
#define USER_LOGOHEADER_IMAGE @"default_myInfo_photo"
/**
 *  用户的聊天默认的头像
 */
#define USER_CHAT_DEFUAULT_IMAGE @"chat_defaultHeader"

/**
 *  选中的红条
 */
#define USER_SELECTREDLINE_IMAGE @"commen_redLine"

/**
 *  正常状态的图片
 */
#define USER_NORAMALFRAME_IMAGE @"commen_normalFrame"

/**
 *  选中的图片
 */
#define USER_SELEXCTROUND_IMAGE @"commen_selectRound"

/**
 * app主题颜色
 */
#define APP_THEME_COLOR [UIColor colorWithRed:255.0/255.0 green:91.0/255.0 blue:59.0/255.0 alpha:1.0f]

/**
 *  正常星星的图片
 */
#define USER_NORAMALSTAR_IMAGE @"评价icon_未选中"

/**
 *  选中星星的图片
 */
#define USER_SELEXCTSTAR_IMAGE @"评价iicon_已选中"


/**
 *  验证码重新发送时间
 */
#define MAX_CODE_INTERVAL 60

/**
*  图片最多可上传5张
*/
#define MAX_IMAGE_PHOTONUMBER 5

/**
 *  男的图片
 */
#define USER_BOY_IMAGE @"my_boyicon"

/**
 *  女的图片
 */
#define USER_GITL_IMAGE @"my_girlicon"


/**
 *  用于qq登录的appkey
 */
static const NSString *const APP_KEY = @"Sport-iphone";
/**
 *  用于qq登录的appsecret
 */
static const NSString *const APP_SECRET = @"nA8fjeF9xb3Fu11FFe99ao0ASS";

#endif
