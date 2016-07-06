//
//  QCHFShakeMarksModel.h
//  MyQOOCOO
//
//  Created by Wind on 15/12/8.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCHFShakeMarksModel : NSObject
/**标签id*/
@property (strong, nonatomic) NSString * id;
/**用户uid*/
@property (strong, nonatomic) NSString * uid;
/**备注*/
@property (strong, nonatomic) NSString * note;
/**路径*/
@property (strong, nonatomic) NSString * url;
/**类型1、文字*/
@property (strong, nonatomic) NSString * type;
/**标签名称*/
@property (strong, nonatomic) NSString * title;
/**1、普通，2高级*/
@property (strong, nonatomic) NSString * level;
/**创建时间*/
@property (strong, nonatomic) NSString * createTime;
/**用户 id*/
@property (strong, nonatomic) NSString * destUid;
/**缩略图*/
@property (strong, nonatomic) NSString * thumbnail;
/**组id*/
@property (strong, nonatomic) NSString * groupId;
/**持续时间*/
@property (strong, nonatomic) NSString * durations;
/**状态*/
@property (strong, nonatomic) NSString * status;
@end
