//
//  User.h
//  Sport
//
//  Created by fenguo  on 15-1-26.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAchievement.h"

@interface User : NSObject

/**
 *  用户id
 */
@property(nonatomic,assign)long uid;

/**
 *  环信id
 */
@property(nonatomic,copy)NSString *hid;

/**
 *  环信密码
 */
@property(nonatomic,copy)NSString *hpass;

/**
 *  用户姓名
 */
@property(nonatomic,copy)NSString *nickname;

/**
 *  用户性别
 */
@property(nonatomic,assign)NSInteger sex;

/**
 *  用户登录名，同时也是联系电话
 */
@property(nonatomic,copy)NSString *phone;

/**
 *  用户头像的url
 */
@property(nonatomic,strong) NSString *avatarUrl;

@property (nonatomic,copy) NSString *avatar;//帖子头像有些返回字段为avatar

/**
 *  上次登录时间
 */
@property(nonatomic,assign)long long lastAccessTime;
/**
 *  注册时间
 */
@property(nonatomic,assign)long long createTime;

/**
是否跟新过资料
 */
@property ( nonatomic , assign) int profileInfo;
/**
 *  用户积分情况
 */
@property(nonatomic,strong)UserAchievement * achi;


@property(nonatomic,assign)BOOL isFriend;

@property(nonatomic,copy)NSString * marks;

@property(nonatomic,assign)double distance;


@end
