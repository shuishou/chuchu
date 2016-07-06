//
//  QCDiandiListModel.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/11/3.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface QCDiandiListModel : NSObject
 /** 文章id*/
@property ( nonatomic , assign) long id;//	long	文章id

 /** 作者*/
@property ( nonatomic , assign) long author;//	Long	作者

 /** 标题*/
@property (nonatomic , copy) NSString *title;//	String	标题

 /** 图片Url*/
@property (nonatomic , copy) NSString * coverUrl;//	String	图片url

 /** 评论数*/
@property ( nonatomic , assign) int commentCount;//	Int	评论数

 /** 点赞数*/
@property ( nonatomic , assign) int praiseCount;//	Int 	点赞数

 /** 创建时间*/
@property ( nonatomic , copy)NSString * createTime;//	Long	创建时间

 /** 经度*/
@property ( nonatomic , assign) double locLat;//	Double	经度

 /** 纬度*/
@property ( nonatomic , assign) double locLng;//	Double	纬度

 /** Geo*/
@property (nonatomic , copy) NSString *locGeo;//	String	Geo

 /** 地址*/
@property (nonatomic , copy) NSString *address;//	String	地址

 /** 内容类型*/
@property ( nonatomic , assign) int contentType;//	Int	内容类型

 /** 可见性*/
@property ( nonatomic , assign) int permission;//	权限	1-所有人   2-仅自己   3-选择性可见

 /** 被限制的集合*/
@property (nonatomic , copy) NSString *defineUids;//	String	被限制的uid集合，以“，”分隔

 /** 内容*/
@property (nonatomic , copy) NSString *content;//	String	内容

 /** 圈子类型(内外日)*/
@property ( nonatomic , assign) int ranges;//	int	1、外圈，2、内圈，3、日记

 /** 日记类型*/
@property ( nonatomic , assign) int type;//	int	类型，1、普通，2、来自日省

 /** 当前用户是否点赞*/
@property ( nonatomic , assign) BOOL hasPraise;// boolean 当前用户是否点赞

 /** 用户*/
@property (nonatomic,strong) User * user;//	UserIdx	用户对象

//id = 129,
//content = {"day":"10-16","key":"心情,学习,帮人,为人处世,工作,陪伴家人,空间了","value":"1,1,0,1,-2,-2,-2","keyCount":0},
//praiseCount = 0,
//locLng = 0,
//hasPraise = 0,
//author = 14,
//permission = 1,
//contentType = 3,
//type = 2,
//title = ,
//ranges = 1,
//createTime = 1444980653502,
//address = ,
//defineUids = ,
//commentCount = 0,
//coverUrl = ,
//user = {
//    locLat = 23.13281,
//    uid = 14,
//    phone = 15626291424,
//    sex = 1,
//    age = 56,
//    locLng = 113.377948,
//    firstSpell = L,
//    avatar = http://203.195.168.151:9063/res/apg/E1/FF/a00fecca10c93a82f50d318570f63b4e.jpg,
//    createTime = 1441530784204,
//    origin = 0,
//    lastAccessTime = 1450945238137,
//    hid = deba8646e548428394a30709451778c2,
//    nickname = 龙斌华,
//    locGeo = ws0eegpq3,
//    status = 0

@end
