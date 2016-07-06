//
//  QCHFChatGroupDetailVC.h
//  MyQOOCOO
//
//  Created by Wind on 15/12/16.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  群组成员类型
 */
typedef enum{
    GroupOccupantTypeOwners,//创建者
    GroupOccupantTypeMembers,//成员
}GroupOccupantTypes;

@interface QCHFChatGroupDetailVC : UIViewController

/**群组环信 Id*/
@property (strong ,nonatomic) NSString * hids;

/**扫一扫*/
@property (strong, nonatomic) NSNumber * isHFScan;

- (instancetype)initWithGroup:(EMGroup *)chatGroup;

- (instancetype)initWithGroupId:(NSString *)chatGroupId;
@end
