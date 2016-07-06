//
//  QCDiandiReplyListModel.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/11/3.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@class QCDiandiReplyListModel;

@interface QCDiandiReplyListModel : NSObject
 /** 评论id*/
@property ( nonatomic , assign) long id;//	long	评论id
 /** 评论用户id*/
@property ( nonatomic , assign) long uid;//	Long	评论用户id
 /** 文章id*/
@property ( nonatomic , assign) long recordId;//	Long	文章id
 /** 评论目标评论的id*/
@property ( nonatomic , assign) long toReplyId;//	Long	评论目标评论的id	父评论id,如果为0，则是直接对点滴进行评论
 /** 评论目标用户id被评论用户id*/
@property ( nonatomic , assign) long replyuid;//	Long	评论目标用户id	被评论用户id
 /** 评论时间*/
@property ( nonatomic , copy) NSString* createtime;//	Long	评论时间
 /** 评论数量*/
@property ( nonatomic , assign) int commentCount;//	Int	评论数量
 /** 内容*/
@property (nonatomic , copy) NSString *content;//	String 	内容

 /** 字评论*/
@property (nonatomic , strong)QCDiandiReplyListModel *subReply;//	List<Reply>	子评论
 /** 评论用户*/
@property (nonatomic , strong)User *user;//	UserIdx	评论用户详情	评论用户
 /** 评论目标用户详情*/
@property (nonatomic , strong)User *replyUser;//	UserIdx	评论目标用户详情	被评论用户

@end
