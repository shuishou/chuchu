//
//  QCGetUserMarkModel.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/11/4.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCGetUserMarkModel : NSObject
 /** 标签id*/
@property ( nonatomic , assign) long ID;//	long	标签id
 /** 用户uid*/
@property ( nonatomic , assign) long uid;//	long	用户uid
 /** 分组id*/
@property ( nonatomic , assign) long groupId;//	long	组id
 /** 标签名称*/
@property (nonatomic , copy) NSString *title;//	string	标签名称
 /** 标签类型*/
@property ( nonatomic , assign) int type;//	int	1-文字  2-图片  3-视频  4-音频
/**视频或图片url**/
@property(nonatomic,copy) NSString *url;//网址
 /** 创建时间*/
@property ( nonatomic , assign) long createTime;//	long	创建时间
 /** 标签等级*/
@property ( nonatomic , assign) long level;//	int	1、普通，2、高级
 /** 标签状态*/
@property ( nonatomic , assign) int status;//	Int	状态
 /** 标签缩略图*/
@property (nonatomic , copy) NSString *thumbnail;//	String	略缩图
 /** 视频时长*/
@property ( nonatomic , assign) int durations;//	Int	视频时长
/**上传者的id**/
@property(nonatomic,copy)NSString *destUid;// 不知道什么鬼
@end
