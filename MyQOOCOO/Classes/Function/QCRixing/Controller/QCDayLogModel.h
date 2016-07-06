//
//  QCDayLogModel.h
//  MyQOOCOO
//
//  Created by Wind on 15/12/25.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCDayLogModel : NSObject
/**日省记录集合*/
@property (strong, nonatomic) NSMutableArray * records;
/**日省id*/
@property (strong, nonatomic) NSString * Id;
/**日省项*/
@property (strong, nonatomic) NSString * title;
/**用户id*/
@property (strong, nonatomic) NSString * uid;
/**创建时间*/
@property (strong, nonatomic) NSString * createTime;
@end
