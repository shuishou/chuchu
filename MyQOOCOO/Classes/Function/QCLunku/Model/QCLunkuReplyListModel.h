//
//  QCLunkuReplyListModel.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/10/28.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@class QCLunkuReplyListModel;

@interface QCLunkuReplyListModel : NSObject
 /** 评论id*/
@property ( nonatomic , assign) long id;//	long	评论id
 /** 评论用户id*/
@property ( nonatomic , assign) long uid;//	Long	评论用户id
 /** 文章id*/
@property ( nonatomic , assign) long forumId;//	Long	文章id
 /** 评论目标评论的id*/
@property ( nonatomic , assign) long toReplyId;//	Long	评论目标评论的id
 /** 评论目标用户的id*/
@property ( nonatomic , assign) long replyUid;//	Long	评论目标用户id
 /** 评论时间*/
@property ( nonatomic , copy) NSString* createTime;//	Long	评论时间
 /** 评论数量*/
@property ( nonatomic , assign) int commentCount;//	Int	评论数量
 /** 内容*/
@property (nonatomic , copy) NSString *content;//	String 	内容
 /** 字评论*/
@property (nonatomic , strong)QCLunkuReplyListModel *subReply;//	List<Reply>	子评论
 /** 评论用户详情*/
@property (nonatomic , strong)User *user;//	UserIdx	评论用户详情
 /** 评论目标用户详情*/
@property (nonatomic , strong)User *replyUser;//UserIdx	评论目标用户详情
// ------获取评论内容
-(NSString*)getReplyContent;

@end
