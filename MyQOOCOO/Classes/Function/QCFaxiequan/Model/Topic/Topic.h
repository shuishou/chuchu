//
//  Topic.h
//  Sport
//
//  Created by fenguo on 15-1-29.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImageItem;

@interface Topic : NSObject

//文章id
@property(assign, nonatomic)NSInteger id;
//作者
@property (nonatomic , copy) NSString *author;

//帖子标题
@property(copy, nonatomic)NSString *title;
//创建时间
@property(strong, nonatomic) NSNumber *create_time;

//帖子内容
@property(copy, nonatomic)NSString *content;
//评论数量
@property(assign, nonatomic)NSInteger commentCount;
//点赞数量
@property ( nonatomic , assign) NSInteger praiseCount;
//点黑数量
@property(assign, nonatomic)NSInteger pressCount;
//文件Url
@property (nonatomic , copy) NSString *fileUrl;
//语音时长
@property ( nonatomic , assign) NSInteger durations;
//是否点过赞
@property ( nonatomic , assign) BOOL hasPraise;
//是否点过黑
@property ( nonatomic , assign) BOOL hasPress;



//放列表图片
@property(strong, nonatomic) NSMutableArray *images;

-(NSDate *)getCreateTime;

-(NSString *)getCreateTimeStr;

@end
