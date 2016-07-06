//
//  QCFriendModel.h
//  MyQOOCOO
//
//  Created by wzp on 15/10/13.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 <__NSCFArray 0x7fc03d8f97b0>(
 {
 createTime = 1444662347948;
 destHid = 710b5197ec6accb407f374183e64b00e;
 destUid = 62;
 eachFocus = 1;
 hid = 799efc6678a02eef4b75e16aecaa7684;
 id = 182;
 status = 1;
 uid = 45;
 updateTime = 1444662347948;
 user =     {
 createTime = 1444648245049;
 hid = 710b5197ec6accb407f374183e64b00e;
 lastAccessTime = 1444668210659;
 locGeo = "";
 nickname = "";
 origin = 0;
 phone = 15507668781;
 sex = 0;
 status = 0;
 uid = 62;
 userno = 2Am;
 };
 userOfUid =     {
 age = 25;
 avatar = "";
 createTime = 1443449405675;
 firstSpell = G;
 hid = 799efc6678a02eef4b75e16aecaa7684;
 lastAccessTime = 1444738273378;
 locGeo = "";
 nickname = "\U9694\U58c1\U8001\U738b";
 origin = 0;
 phone = 13247377651;
 sex = 0;
 status = 0;
 uid = 45;
 userno = C66wAU;
 };
 }
 )

 */
@interface QCFriendUser : NSObject
@property(copy,nonatomic)NSString *uid;
@property(copy,nonatomic)NSString *phone;
@property(copy,nonatomic)NSString *sex;
@property(copy,nonatomic)NSString *age;
@property(copy,nonatomic)NSString *firstSpell;
@property(copy,nonatomic)NSString *avatar;
@property(copy,nonatomic)NSString *createTime;
@property(copy,nonatomic)NSString *origin;
@property(copy,nonatomic)NSString *lastAccessTime;
@property(copy,nonatomic)NSString *hid;
@property(copy,nonatomic)NSString *nickname;
@property(copy,nonatomic)NSString *userno;
@property(copy,nonatomic)NSString *locGeo;
@property(copy,nonatomic)NSString *status;
@property(copy,nonatomic)NSString * locLng;
@property(copy,nonatomic)NSString * locLat;
@property(copy,nonatomic)NSString * isSele;
@property(copy,nonatomic)NSString * note;
@end

@interface QCFriendUserEasy : NSObject
@property(copy,nonatomic)NSString *locLat;
@property(copy,nonatomic)NSString *uid;
@property(copy,nonatomic)NSString *phone;
@property(copy,nonatomic)NSString *sex;
@property(copy,nonatomic)NSString *age;
@property(copy,nonatomic)NSString *locLng;
@property(copy,nonatomic)NSString *firstSpell;
@property(copy,nonatomic)NSString *avatar;
@property(copy,nonatomic)NSString *createTime;
@property(copy,nonatomic)NSString *origin;
@property(copy,nonatomic)NSString *lastAccessTime;
@property(copy,nonatomic)NSString *hid;
@property(copy,nonatomic)NSString *nickname;
@property(copy,nonatomic)NSString *locGeo;
@property(copy,nonatomic)NSString *status;
@end

@interface QCFriendModel : NSObject
@property(copy,nonatomic)NSString *Id;
@property(copy,nonatomic)NSString *updateTime;
@property(copy,nonatomic)NSString *uid;
@property(copy,nonatomic)NSString *note;
@property(copy,nonatomic)NSString *eachFocus;
@property(copy,nonatomic)NSString *classes_id;
@property(copy,nonatomic)NSString *destUid;
@property(copy,nonatomic)NSString *createTime;
@property(copy,nonatomic)NSString *hid;
@property(copy,nonatomic)NSString *destHid;
@property(copy,nonatomic)NSString *status;
@property(copy,nonatomic)NSString *marks;
@property(retain,nonatomic)QCFriendUser *user;
@property(retain,nonatomic)QCFriendUserEasy *userOfUid;
@end
