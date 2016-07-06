//
//  Reply.h
//  Sport
//
//  Created by fenguo on 15-2-2.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "User.h"
@class Reply;

@interface Reply : NSObject

@property (nonatomic,assign) NSInteger id;//评论ID

@property (nonatomic,assign) NSInteger uid;//评论用户ID

@property (nonatomic,copy) NSString * content;//评论内容

@property (nonatomic,assign) NSInteger topicId;//文章id

@property (nonatomic,copy) NSString * createTime;//创建时间

@property (nonatomic,assign) NSInteger toReplyId;//评论目标评论的id
@property (nonatomic,assign) NSInteger replyuid; //评论目标用户id

@property (nonatomic,strong)User *user;//评论用户
@property (nonatomic,strong)User *replyUser;//被评论用户详情

//@property (nonatomic,strong)Reply *subReply;//子评论 List<Reply>

//-------------------------------------------------------
//作者
@property (nonatomic , copy) NSString *author;
//标题
@property (nonatomic , copy) NSString *title;
//评论数
@property ( nonatomic , assign) int commentCount;
//点赞数
@property ( nonatomic , assign) int praiseCount;
//点黑数
@property ( nonatomic , assign) int pressCount;
//类型
@property ( nonatomic , assign) int contentType;
//文件Url
@property (nonatomic , copy) NSString *fileUrl;

@property ( nonatomic , assign) long forumId;

-(NSString*)getReplyContent;

@end
