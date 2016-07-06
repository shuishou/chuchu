//
//  QCLunkuListModel.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/10/28.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"


@interface QCLunkuListModel : NSObject
 /** 文章id*/
@property ( nonatomic , assign) long id;//	long	文章id
 /** 作者*/
@property ( nonatomic , assign) long uid;//	Long	作者
 /** 标题*/
@property (nonatomic , copy) NSString *title;//	String	标题
 /** 内容*/
@property ( nonatomic , copy) NSString *content;//	Long	创建时间
 /** 评论数*/
@property ( nonatomic , assign) int commentCount;//	Int	评论数
 /** 点赞数*/
@property ( nonatomic , assign) int praiseCount;//	Int 	点赞数
 /** 创建时间*/
@property ( nonatomic , copy) NSString * createTime;//	Long	创建时间
 /** 图片Url*/
@property (nonatomic , copy) NSString *image;//	String	图片url
 /** 置顶*/
@property ( nonatomic , assign) int topType;//	Int	置顶  0-置顶  1-热门   2-普通
 /** 论库文章类型*/
@property ( nonatomic , assign) int type;//	Int	1、明星名人，2、动漫，3、游戏，4、文学艺术，5、体育，6、教育人文，7、娱乐，8、时尚生活，9军事科学，10、数码科技，11、情感
 /** 置顶过期时间*/
@property ( nonatomic , assign) long topExpire;//	Long	置顶过期时间
 /** 热门过期时间*/
@property ( nonatomic , assign) long hotExpire;//	long	热门过期时间
 /** 是否点赞*/
@property ( nonatomic , assign) BOOL hasPraise;//	Boolean	是否点赞
 /** 用户*/
@property (nonatomic , strong)User *user;//	UserIdx	用户信息

/** 审核*/
@property (nonatomic , assign)int audit;//Int	置顶  0-审核中  1-审核通过   2-不通过



@end
