//
//  QCFriendAccout.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/4.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCFriendAccout : NSObject
/**用户id*/
@property (strong, nonatomic) NSString * uid;

/**手机号*/
@property (strong, nonatomic) NSString * phone;

/**头像URL*/
@property (strong, nonatomic) NSString * avatarUrl;

/**昵称*/
@property (strong, nonatomic) NSString * nickname;

/**性别*/
@property (assign, nonatomic) NSInteger sex;

/**环信id*/
@property (strong, nonatomic) NSString * hid;

/**是否已关注*/
@property (strong, nonatomic) NSNumber * isFriend;

/**与当前用户的距离*/
@property (strong, nonatomic) NSString * distance;

/**标签值，以“，”分隔*/
@property (strong, nonatomic) NSString * marks;

/**年龄*/
@property (strong, nonatomic) NSString * age;

/**创建时间*/
@property (strong, nonatomic) NSString * createTime;


@property (strong, nonatomic) NSString * origin;

/**最后访问时间*/
@property (strong, nonatomic) NSString * lastAccessTime;
@end
