//
//  QCRecommendMarkModel.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/11/4.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCRecommendMarkModel : NSObject
 /** 标签id*/
@property ( nonatomic , assign) long Id;//	long	标签id
 /** 标签名称*/
@property (nonatomic , copy) NSString *title;//	string	标签名称
 /** 创建时间*/
@property ( nonatomic , assign) long createTime;//	long	创建时间
 /** 标签类型*/
@property ( nonatomic , assign) int type;//	Int	小类：0、不属于基本信息标签 ，1、身高，2、年龄，3、星座，4、爱好，5、特长，6、性格，7、职业，8、文化程度
 /** 标签大类*/
@property ( nonatomic , assign) int groupType;//	int	大类：1、基本信息，2、交友标签，3、时尚标签，4、买东西，5、卖东西，6创业

@end
