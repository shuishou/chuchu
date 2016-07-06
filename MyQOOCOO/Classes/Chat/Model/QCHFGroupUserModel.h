//
//  QCHFGroupUserModel.h
//  MyQOOCOO
//
//  Created by Wind on 15/12/7.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QCFriendUser;
@interface QCHFGroupUserModel : NSObject
/**趣友分组id*/
@property (strong, nonatomic) NSString * id;
/**用户id*/
@property (strong, nonatomic) NSString * uid;
/**好友uid*/
@property (strong, nonatomic) NSString * destUid;
/**环信群组ID*/
@property (strong, nonatomic) NSString * hid;
/**好友环信id*/
@property (strong, nonatomic) NSString * destHid;
/**1、我关注的人，2、待定，3、陌生*/
@property (strong, nonatomic) NSString * status;
/**创建时间*/
@property (strong, nonatomic) NSString * createTime;
/**修改时间*/
@property (strong, nonatomic) NSString * updateTime;
/**趣友分组id，如果为null，则用户不在趣友分组里面*/
@property (strong, nonatomic) NSString * classes_id;
/**是否关注*/
@property (strong, nonatomic) NSString * eachFocus;
@property (strong , nonatomic) NSString *note;
/**destUid好友对象*/
@property (strong, nonatomic) QCFriendUser * user;
@end
