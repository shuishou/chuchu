//
//  QCHFUserModel.h
//  MyQOOCOO
//
//  Created by Wind on 15/12/5.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCHFUserModel : NSObject
/**用户uid*/
@property (strong, nonatomic) NSString * uid;
/**电话*/
@property (strong, nonatomic) NSString * phone;
/**性别*/
@property (assign, nonatomic) NSInteger  sex;
/**年龄*/
@property (strong, nonatomic) NSString * age;
/**用户标签*/
@property (strong, nonatomic) NSString * marks;
/**用户头像*/
@property (strong, nonatomic) NSString * avatarUrl;
/**创建时间*/
@property (strong, nonatomic) NSString * createTime;

@property (strong, nonatomic) NSString * origin;
/**最后访问时间*/
@property (strong, nonatomic) NSString * lastAccessTime;
/**环信群组ID*/
@property (strong, nonatomic) NSString * hid;
/**是否关注*/
@property (strong, nonatomic) NSString * isFriends;
/**昵称*/
@property (strong, nonatomic) NSString * nickname;

@property (strong, nonatomic) NSString * userno;
/**距离**/
@property(nonatomic,strong) NSString *distance;

@end
