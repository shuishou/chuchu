//
//  QCGroupModel.h
//  MyQOOCOO
//
//  Created by wzp on 15/10/13.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//
/*
 "id": "1",
 "user": {
 "uid": "18",
 "phone": "15077303525",
 "nickname": "",
 "sex": 0,
 "origin": 0,
 "createTime": "1441960231889",
 "lastAccessTime": "1442232158865",
 "hid": "29068fb52a2106b7732df229a9eaf795",
 "isFriends": false
 },
 "name": "国庆节",
 "type": 1,
 "description": "111",
 "hid": "105816515286139380",
 "status": 0,
 "createTime": "1442202130144",
 "updateTime": "1442202130144",
 "memberCount": 1,
 "locLat": 0,
 "locLng": 0,
 "hasFull": false
 */
#import <Foundation/Foundation.h>
#import "QCHFUserModel.h"
@interface QCGroupModel : NSObject
/**群组id*/
@property(copy,nonatomic)NSNumber *Id;
/**环信群组ID*/
@property(copy,nonatomic)NSString *hid;
/**群组名称*/
@property(copy,nonatomic)NSString *name;
/**活动类型*/
@property(copy,nonatomic)NSString *type;
/**群组简介*/
@property(copy,nonatomic)NSString *description;
/**是否已满*/
@property(copy,nonatomic)NSNumber *hasFull;
/**创建时间*/
@property(copy,nonatomic)NSString *createTime;
/**更新时间*/
@property(copy,nonatomic)NSString *updateTime;
/**成员个数*/
@property(copy,nonatomic)NSString *memberCount;
/**地理纬度*/
@property(copy,nonatomic)NSString *locLat;
/**地理经度*/
@property(copy,nonatomic)NSString *locLng;
/**获取群成员*/
@property(strong,nonatomic)NSArray *members;
/**与当前用户的关系*/
@property(strong,nonatomic)NSDictionary *membership;
/**创建者信息*/
@property(strong,nonatomic)QCHFUserModel *user;
/**状态*/
@property (strong,nonatomic)NSString *status;
@end
