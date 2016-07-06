//
//  QCPersonal_dataModel.h
//  MyQOOCOO
//
//  Created by Wind on 15/12/3.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCPersonal_dataModel : NSObject
/**所属用户uid*/
@property (strong, nonatomic) NSString * uid;

/**推荐标签id*/
@property (strong, nonatomic) NSString * Id;

/**标签大类的名称*/
@property (strong, nonatomic) NSString * title;

/**用户已添加标签*/
@property (strong, nonatomic) NSMutableArray * userMarks;

/**大类：0、属于用户自创大类，1、基本信息，2、交友标签，3、时尚标签，4、买东西，5、卖东西，6、创业*/
@property (strong, nonatomic) NSString * type;

/**评论时间*/
@property (strong, nonatomic) NSString * createTime;

/**权限，1、所有人都可以观看，2、仅自己*/
@property (strong, nonatomic) NSString * showOthres;


@end
