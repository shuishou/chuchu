//
//  QCFriendListVC.h
//  MyQOOCOO
//
//  Created by wzp on 15/10/13.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseTableVC.h"
#import "QCFriendCell.h"
#import "QCFriendInfoVC.h"
#import "QCFriendMainVC.h"

#define kDianDiSeleteUserUidNotification @"DianDiSeleteUserUidNotification"

@protocol QCHFGroupUserDelegate <NSObject>

- (void)sendGroupUserAvatar:(NSMutableArray *)usersDataArr;

@end

/**
 *  联系人状态
 */
typedef NS_ENUM(NSInteger,kFriendStatus){
    /**
     *  互相关注
     */
    kFriendStatusEachOther  = 1,
    /**
     *  我关注的
     */
    kFriendStatusMyAttention = 2,
    /**
     *  关注我的
     */
    kFriendStatusAttentionMe = 3,
    /**
     *  待定
     */
    kFriendStatusPending = 4,
    /**
     *  陌生人
     */
    kFriendStatusStranger = 5
};

@interface QCFriendListVC : QCBaseTableVC
/**
 *  @author wzp, 15-10-24 20:10:38<QCFriendCellDelegate>
 *
 *   构造函数
 *
 *  @param friendStatus 好友状态
 *  @param listType     列表状态
 *
 *  @return 对象
 */
-(instancetype)initWithFriendStatus:(kFriendStatus)friendStatus listType:(kFriendGroupTpye)listType;

/**添加趣组成员/讨论组成员*/
@property (strong, nonatomic) NSNumber * isAddGroupUsers;
/**趣友成员数组(对比剩下没选的)*/
@property (strong, nonatomic) NSMutableArray * groupUsersArr;
/**组员头像和 id 代理*/
@property (assign, nonatomic) id< QCHFGroupUserDelegate>QCHFGroupUserDelegate;

// 点滴跳转
@property (nonatomic,assign) BOOL isDD;


@end
