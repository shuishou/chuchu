//
//  HttpURLMacros.h
//  Sport
//  服务端http请求地址
//  Created by fenguo  on 15-1-21.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#ifndef Sport_HttpURLMacros_h
#define Sport_HttpURLMacros_h
static NSString *const QCHttpApiBaseURL = @"http://www.qoocoo.net:8088/";//(正式)
//static NSString *const QCHttpApiBaseURL = @"http://192.168.1.134:9063/";
//static NSString *const QCHttpApiBaseURL = @"http://203.195.168.151:9063/";//（测试）

#pragma mark - custom自定义
 /** 时间戳*/
#define SYNCHRONIZE_DATA_TIMESTAMP    @"synchronize_data_timestamp"

#include "UIButton+JKTouch.h"
//---------- 点滴
 /** 写点滴*/
#define RECORD_CREATE_URL @"api/record/create"
 /** 点滴列表*/
#define RECORD_GETRECORDLIST_URL @"api/record/getRecordList"
 /** 点滴评论列表*/
#define RECORD_GETREPLYLIST @"api/record/getReplyList"
 /** 评论某篇文章*/
#define RECORD_REPLY @"api/record/reply"
 /** 点滴详情*/
#define RECORD_DETAIL @"api/record/detail"
 /** 点滴点赞*/
#define RECORD_PRAISE @"api/record/praise"
 /** 删除点滴*/
#define RECORD_DELETERECORD @"api/record/deleteRecord"
/** 删除点滴评论*/
#define RECORD_DELETEREPLY_RRL @"api/record/deleteReply"
 /** 查看个人点滴*/
#define RECORD_RECORDOFMEMBER @"api/record/recordOfMember"
 /** 点滴是否跟新*/
#define RECORD_HASUPDATE @"api/record/hasUpdate"



//---------获取好友
/**获取对应组别的好友*/
#define FRIEND_GETFRIENDLIST    @"api/friend/getFriends"
/**获取好友数量*/
#define FRIEND_GETFRIENDCOUNT   @"api/friend/getFriendCount"
/**备注好友**/
#define FRIEND_REMARK           @"api/friend/remarkUser"
/**查找好友*/
#define FRIEND_SEARCH           @"api/search/search"
/**搜索好友*/
#define FRIEND_SEARCHBYMARK     @"api/search/searchByMarks"
/**高级搜索*/
#define SEARCHBYCONDITIONS      @"api/search/searchByConditions"

/**个人资料*/
#define GETMARKGROUP            @"api/mark/getMarkGroup"

/**按组分页查询标签**/
#define QUERYTAG                @"api/mark/getMarksByGroupId"

/**举报**/
#define REPOT                   @"api/report/report"



/**偶遇*/
#define FRIEND_OUYU             @"api/search/searchByDistance"
/**单身*/
#define FRIEND_SINGLE           @"api/search/searchySingle"



/**添加好友(关注好友)*/
#define FRIEND_ADD              @"api/friend/add"
/**取消关注*/
#define FRIEND_REMOVEFOCUS      @"api/friend/removeFocus"

/**删除待定好友*/
#define DELETEFRIEND            @"api/friend/deleteFriend"
/**删除陌生人*/
#define REMOVEFRIEND            @"api/friend/removeFriend"


/**意见反馈*/
#define FEEDBACKADD             @"api/feedback/add"
/**取最新版本信息*/
#define GETLASTNEWLY            @"api/version/getLastNewly"

//----------潮星
/**潮星*/
#define FRIEND_STAR             @"api/search/searchByStar"
/**潮星推荐*/
#define FRIEND_STAR_RECOMMEND   @"api/search/recommendUser"
/**查询潮星标签*/
#define GETMARKLIST             @"api/starMark/getMarkList"
/**增加潮星标签*/
#define ADDSTARMARK             @"api/starMark/addStarMark"
/**删除潮星标签*/
#define DELETESTARMARK          @"api/starMark/deleteStarMark"




//----------群组
//获取群组/讨论组列表
#define GROUP_GETLIST              @"api/group/listMy"
//创建群组/讨论组
#define GROUP_CREAT                @"api/group/create"
//编辑群组/讨论组
#define GROUP_UPDATE               @"api/group/update"
//解散群组/讨论组
#define GROUP_DELETE               @"api/group/dismiss"
//群组/讨论组详情
#define GROUP_DETAIL               @"api/group/detail"
//添加群组/讨论组成员
#define GROUP_ADDMEMBER            @"api/group/member/add"
//移除群组/讨论组成员
#define GROUP_REMOVEMEMBER         @"api/group/member/remove"

/**通过环信id获取群详情*/
#define GETGROUPSBYHIDS            @"api/group/getGroupsByHids"



//---------趣友分组
/**获取趣友分组*/
#define GETCLASSES              @"api/classes/getClasses"
/**获取趣友分组成员*/
#define GETUSERBYCLASSID        @"api/classes/getUserByClassId"
/**增加趣友分组*/
#define ADDClASSES              @"api/classes/addClasses"
/**删除趣友分组*/
#define DELETECLASSES           @"api/classes/deleteClasses"
/**修改趣友分组*/
#define UPDATECLASSES           @"api/classes/updateClasses"
/**趣友分组添加成员*/
#define ADDUSER                 @"api/classes/addUser"
/**移除趣友分组成员*/
#define DELETEUSER              @"api/classes/deleteUser"




//---------摇一摇
/**摇一摇获取标签*/
#define GETMARKS                @"api/search/getMarks"
/**摇一摇标签搜索好友*/
#define SEARCHBYSHAKE           @"api/search/searchByShake"



//---------一起按
/**一起按*/
#define SEARCHBYTOGETHER        @"api/search/searchByTogether"




//----------快捷回复
/**获取快捷回复*/
#define GETREPLY                @"api/reply/getReply"
/**增加快捷回复*/
#define ADDREPLY                @"api/reply/addReply"
/**删除快捷回复内容*/
#define DELETEREPLY             @"api/reply/deleteReply"





//---------发泄圈
//发送涂鸦或怒吼
#define TOPIC_CREATE_URL @"api/topic/create"
//发泄圈所有文章
#define TOPIC_GETTOPICLIST_URL @"api/topic/getTopicList"
//发泄圈文章详情
#define TOPIC_DETAIL_URL @"api/topic/detail"
//发泄圈评论列表
#define TOPIC_GETREPLYLIST_URL @"api/topic/getReplyList"
//发泄圈进行评论
#define TOPIC_REPLY_URL @"api/topic/reply"
//发泄圈进行点赞和点黑
#define TOPIC_PRAISE_URL @"api/topic/praise"
//个人发泄圈文章列表
#define TOPIC_TOPICOFMEMBER @"api/topic/topicOfMember"
//删除发泄圈评论
#define TOPIC_DELETEREPLY_URL @"api/topic/deleteReply"
//删除发泄圈文章
#define TOPIC_DELETETOPIC_URL @"api/topic/deleteTopic"


//---------日省
/**日省项*/
#define DAYLOGLIST              @"api/dayLog/dayLogList"
/**增加日省项*/
#define ADDDAYLOG               @"api/dayLog/addDayLog"
/**删除日省项*/
#define DELETEDAYLOG            @"api/dayLog/deleteDayLog"
/**添加日省项纪录*/
#define ADDDATLOGRECORD         @"api/dayLog/addDayLogRecord"
/**修改日省项记录*/
#define UPDATEDAYLOGRECORD      @"api/dayLog/updateDayLogRecord"




//七牛的tocken
#define QINIU_TOCKEN_URL @"api/qiniu/getToken"
#define QINIU_BASE_URL @"http://7xs5rn.com1.z0.glb.clouddn.com/"
#define QINIUArraySeperateString @"09008909188"

/**
 
 */


//----------论库
 /** 发表论库*/
#define FORUM_CREATE @"api/forum/create"
 /** 论库列表*/
#define FORUM_LIST @"api/forum/getForumList"
 /** 论库某一的详情*/
#define FORUM_DETAIL @"api/forum/detail"
 /** 论库评论列表*/
#define FORUM_GETREPLY @"api/forum/getReplyList"
//发表轮库评论
#define FORUM_REPLY @"api/forum/reply"
// 删除轮库文章
#define FORUM_DELETEFORUM @"api/forum/deleteForum"
// 删除轮库评论
#define FORUM_DELETEREPLY_URL @"api/forum/deleteReply"
// 个人轮库
#define FORUM_FORUMOFMEMBER @"api/forum/forumOfMember"
// 轮库点赞
#define FORUM_PRAISE @"api/forum/praise"


// ------个人资料
 /** 获取个人资料*/
#define USERINFO_DETAIL @"api/user/detail"
 /** 通过环信id获取用户资料*/
#define USERINFO_GETMULTIBYHIDS @"api/user/getMultiByHids"
 /** 查看标签大类*/
#define USERINFO_GETMARKGROUP @"api/mark/getMarkGroup"
 /** 获取推荐标签*/
#define USERINFO_GETRECOMMENDMARK @"api/mark/getRecommendMark"
 /** 获取用户标签*/
#define USERINFO_GETUSERMARK @"api/mark/getUserMark"
 /** 添加用户标签*/
#define USERINFO_ADDUSERMARK @"api/mark/addUserMark"
 /** 添加标签大类*/
#define USERINFO_ADDMARKGROUP @"api/mark/addMarkGroup"
 /** 删除用户标签*/
#define USERINFO_DELETPUSERMARK @"api/mark/deleteUserMark"
 /** 删除标签大类*/
#define USERINFO_DELETEMARKGROUP @"api/mark/deleteMarkGroup"
 /** 设置标签大类权限*/
#define USERINFO_SETPERMISSIONS @"api/mark/setPermissions"
 /** 9.11批量添加用户标签*/
#define USERINFO_ADDPACTHMARKS @"api/mark/addPacthMarks"
/** 获取推荐标签*/
#define USERINFO_ReferrerMARKS @"api/mark/getRecommendMark"
/** 拉黑用户*/
#define USERINFO_blacklist @"api/friend/blacklist"
/** 恢复拉黑用户*/
#define USERINFO_restore @"api/friend/restore"

/**更换头像**/
#define USERHEAR @"api/profile/updateAvatar"
/**完善个人资料**/
#define USERDATA @"api/profile/update"
/**修改库号**/
#define USERNUMBER @"api/profile/updateUserno"



//－－－－－－－－－－用户模块接口
//登录
#define USER_LOGIN_URL @"api/auth/login"
//QQ登录
#define USER_QQLOGIN_URL @"api/auth/qqlogin"
//微博登录
#define USER_WBLOGIN_URL @"api/auth/wblogin"
//微信登录
#define USER_WXLOGIN_URL @"api/auth/wxlogin"
//推送后台接口
#define USER_SYNC_CLIENTINFO_URL @"api/auth/syncClientInfo"
//退出
#define USER_LOGOUT_URL @"api/auth/logout"
//忘记密码发送手机验证码
#define USER_MODIFYPSW_GENCODE_URL @"api/auth/pwd/genCode"
//更改密码
#define USER_PSW_CHANGE_URL @"api/auth/pwd/change"
//注册发送手机验证码

#define USER_REGISTER_GETCODE_URL @"api/auth/register/genCode"
//注册
#define USER_REGISTER_URL @"api/auth/register"
//同步客户端信息
#define USER_SYNCCLIENTINFO_URL @"api/auth/syncClientInfo"
//上传用户头像
#define USER_PROFILE_UPDATEAVATAR_URL @"api/profile/updateAvatar"
//更新用户昵称
#define USER_PROFILE_UPDATE_URL @"api/my/profile/update"
//查询用户信息
#define USER_GET_URL @"api/user/get"
//更新资料
#define USER_PROFILE_UPDATAE_URL @"api/profile/update"
//意见反馈
#define USER_FEEDBACK_CREATE_URL @"api/my/feedback/create"
//我的收藏
#define USER_MYCOLLECTS_URL @"api/my/collection/myCollects"
//获取用户的统计数据
#define USER_USERCOUNT_URL @"api/user/userCount"

//--------------消息
//查找好友
#define USER_SEARCH_URL @"api/user/search"
//添加好友
#define USER_FRIEND_FOLLOW_URL @"api/my/friend/follow"
//取消添加好友(就是删除好友)
#define USER_FRIEND_UNFOLLOW_URL @"api/my/friend/unfollow"
//获取好友列表
#define USER_LIST_URL @"api/user/list"
//获取更多的用户
#define USER_GETMULTIBYHIDS_URL @"api/user/getMultiByHids"
//手机号匹配用户
#define USER_MATCH_URL @"api/user/match"
//－－－－－－－－－－场馆模块接口
//场馆列表
#define STADIUM_LIST_URL @"api/stadium/list"
#define STADIUM_GET_URL @"api/stadium/get"
#define GROUND_GET_URL @"api/ground/get"
#define ROUND_LIST_DAY_URL @"api/round/listDay"
#define STADIUM_LISTASMER_URL @"api/stadium/listAsMer"
#define STADIUM_LISTCOMMENT_URL @"api/ground/listComment"
#define MER_MODIFY_URL @"api/my/merchants/modify"
#define MER_GET_URL @"api/my/merchants/get"

//-----------------订单模块接口
#define ORDER_SUBMIT_URL @"api/my/order/submit"
#define ORDER_PAY_URL @"api/my/order/pay"
#define ORDER_STARTPAY_URL @"api/my/order/startPay"
#define ORDER_SPEND_URL @"api/my/order/spend"
#define ORDER_VALIDATe_URL @"api/my/order/validate"
#define ORDER_LISTASMERCHANT_URL @"api/my/order/listAsMerchant"
#define ORDER_LISTASUSER_URL @"api/my/order/listAsUser"
#define ORDER_ADDCOMMENT_URL @"api/my/order/addComment"
#define ORDER_CANCEL_URL @"api/my/order/cancel"
#define ORDER_DETAIL_URL @"api/my/order/detail"

//－－－－－－－－－－－吹一吹
#define USER_BLOW_URL @"api/blow"



//---同步参数
#define HOME_SYNCH_URL @"api/synch/get"

//---收藏
#define USER_COLLECTION_CREATE @"api/my/collection/create"

//取消收藏
#define USER_COLLECTION_REMOVE @"api/my/collection/remove"

//获取app最新版本
#define USER_VERDSION_LATESTVETRSION @"api/version/latestVersion"



//环信 IM
/**
 clientId=YXA6QyaUIHFYEeSH4P0GQ4RcaQ
 clientSecret=YXA6_d-S3QvuSWqBB-8rW5j8MAhWbis
 */
//新增
//#define CLIENTID clientId @"YXA6QyaUIHFYEeSH4P0GQ4RcaQ"
//#define CLIENTSECRET clientSecret @"YXA6_d-S3QvuSWqBB-8rW5j8MAhWbis"

//原版
#define CLIENTID clientId @"YXA6QyaUIHFYEeSH4P0GQ4RcaQ"
#define CLIENTSECRET clientSecret @"YXA6_d-S3QvuSWqBB-8rW5j8MAhWbis"

//支付宝模块----------
//支付宝回调地址
#define ALIPAY_NOTIFY_URL @"http://58.215.177.180:9060/alipay/payNotify"
//付款回调
#define ALIPAY_SDKPAYUPDATE_URL @"alipay/sdkPayUpdate"
//token签名
#define APP_TOKEN_URL @"api/getEncryptToken"


//派活接活
#define AssignWork_URL @"api/search/searchByGroup"



/**自由人**/
#define FreeMan   @"api/work/getWorkList"
/**自由人发表文章**/
#define Publish @"api/work/create"
/**自由人文章详情**/
#define FreeManDetail  @"api/work/detail"
/**自由人评论列表**/
#define FreeManGetReplyList @"api/work/getReplyList"
/**评论自由人的文章**/
#define FreeManRelpy @"api/work/reply"
/**自由人点赞**/
#define FeeManPraise @"api/work/praise"
/**删除自由人文章**/
#define FeeManDeleteWork @"api/work/deleteWork"
/**删除自由人评论**/
#define FeeManDeleteReply @"api/work/deleteReply"
/**查看个人的自由人**/
#define FeeManWorkOfMember @"api/work/workOfMember"


/**全搜索**/
#define allSearch @"api/search/allSearch"
/**推荐关键字**/
#define searchSurport @"api/search/surport"

#endif
