//
//  QCFriendRelationModel.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/11/4.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCFriendRelationModel : NSObject
 /** 好友关系对象的id*/
@property ( nonatomic , assign) long Id;//	long	好友关系对象的id
 /** 备注名称*/
@property (nonatomic , copy) NSString *note;//	string	备注名称
 /** 备注图片Url,以,号隔开*/
@property (nonatomic , copy) NSString *imageUrl;//	String	备注图片url，以”,”分隔
 /** 语音备注*/
@property (nonatomic , copy) NSString *voiceUrl;//	String	语音备注


@end
