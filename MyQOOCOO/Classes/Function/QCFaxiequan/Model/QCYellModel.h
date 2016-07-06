//
//  QCYellModel.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/11/2.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface QCYellModel : NSObject


@property (nonatomic , strong)User *user;

/**	文章ID*/
@property (nonatomic, assign) int id;
/**	作者*/
@property (nonatomic, copy) NSString *author;
/**	文章标题*/
@property (nonatomic, copy) NSString *title;
/**	文章创建时间*/
@property (nonatomic, copy) NSString * createTime;
/**	评论数*/
@property (nonatomic, assign) int commentCount;
/**	点赞数*/
@property (nonatomic, assign) int praiseCount;
/**	点黑数*/
@property (nonatomic, assign) int pressCount;
/**	文件Url*/
@property (nonatomic, copy) NSString *fileUrl;
/**	文章内容*/
@property (nonatomic, copy) NSString *content;
/**	录音时长*/
@property (nonatomic, assign) int durations;
/** 录音分贝*/
@property (nonatomic,assign) float contentBei;
/**	是否点赞*/
@property ( nonatomic , assign) BOOL hasPraise;
/**	是否点黑*/
@property ( nonatomic , assign) BOOL hasPress;


@end
