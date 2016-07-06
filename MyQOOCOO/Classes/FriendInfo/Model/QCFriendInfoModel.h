//
//  QCFriendInfoModel.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/11/4.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCFriendRelationModel.h"

@interface QCFriendInfoModel : NSObject
 /** 用户id*/
@property ( nonatomic , assign) long uid;//	long	用户id
 /** 环信ID*/
@property (nonatomic , copy) NSString *hid;//	string	环信ID
 /** 手机号*/
@property (nonatomic , copy) NSString *phone;//	string	手机号
 /** 头像Url小图*/
@property (nonatomic , copy) NSString *avatarUrl;//	string	头像URL-小图
 /** 头像Url源图*/
@property (nonatomic , copy) NSString *avatarRawUrl;//	string	头像URL-原图
 /** 昵称*/
@property (nonatomic , copy) NSString *nickname;//	string	昵称
 /** 性别*/
@property ( nonatomic , assign) int sex;//	int	性别
 /** 年龄*/
@property ( nonatomic , assign) int age;//	int	年龄
 /** 签名*/
@property (nonatomic , copy) NSString *note;//	string	签名
 /** 省份*/
@property (nonatomic , copy) NSString *province;//	string	省份
 /** 城市*/
@property (nonatomic , copy) NSString *city;//	string	城市
 /** 是否关注*/
@property ( nonatomic , assign) Boolean mFriends;//	bool	我是否关注
@property ( nonatomic , assign) Boolean fFriends;// 是否关注我

@property ( nonatomic , assign) Boolean stranger;// 是否关注我
/**是否更新库号**/
@property(nonatomic,assign)int isUpdateUserno;//是否更新库号，0，没更新，已更新

/**语音备注**/
@property(nonatomic,strong)NSString*voiceUrl;

/**备注图URL**/
@property(nonatomic,strong)NSString*imageUrl;

/**黑名单**/
@property(nonatomic,strong)NSString*blacklist;


/****/
@property(nonatomic,strong)NSString*createTime;
@property(nonatomic,strong)NSString*lastAccessTime;

/**处号**/
@property(nonatomic,strong)NSString*userno;

 /** 好友关系*/
@property (nonatomic , strong)QCFriendRelationModel *relation;//	Relation	好友关系，获取备注信息

- (instancetype)initWithDict:(NSDictionary *)dict;// 键值对应

@end
