//
//  QCDoodleCommentCell.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/25.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface QCDoodleCommentStatus : NSObject
@property ( nonatomic , assign) long id;//	long	评论id
@property ( nonatomic , assign) long uid;//	Long	评论用户id
@property ( nonatomic , assign) long topicId;//	Long	文章id
@property ( nonatomic , assign) long toReplyId;//	Long	评论目标评论的id	父评论id
@property ( nonatomic , assign) long replyuid;//	Long	评论目标用户id	被评论人id
@property ( nonatomic , copy) NSString *  createtime;//	Long	评论时间
@property ( nonatomic , assign) int commentCount;//	Int	评论数量
@property (nonatomic , copy) NSString *content;//	String 	内容

@property (nonatomic , strong)NSDictionary *subReply;//	List<Reply>	子评论
@property (nonatomic , strong)User *user;//	UserIdx	评论用户详情	评论用户
@property (nonatomic , strong)User *replyUser;//	UserIdx	评论目标用户详情	被评论用户


@end
