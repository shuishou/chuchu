//
//  QCPersonMarkModel.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/11/4.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QCPersonMarkModel;

@interface QCPersonMarkModel : NSObject
 /** 推荐标签id*/
@property ( nonatomic , assign) long Id;//	long	推荐标签id
 /** 标签大类的名称*/
@property (nonatomic , copy) NSString *title;//	String	标签大类的名称
 /** 所属用户uid*/
@property ( nonatomic , assign) long uid;//	Long	所属用户uid
 /** 评论时间*/
@property ( nonatomic , assign) long createtime;//	Long	评论时间
 /** 权限*/
@property ( nonatomic , assign) int showOthers;//	Int	权限，1、所有人都可以观看，2、仅自己
 /** 标签类型*/
@property ( nonatomic , assign) int type;//	int	大类：0、属于用户自创大类，1、基本信息，2、交友标签，3、时尚标签，4、买东西，5、卖东西，6、创业


 /** 用户已添加标签*/
@property (nonatomic , strong)NSMutableArray *userMarks;//	List<UserMark>	用户已添加标签
@end
