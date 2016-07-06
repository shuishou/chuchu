//
//  QCGroupController.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/29.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"

/**
 *  @author wzp, 15-10-24 16:10:10
 *
 *  此控制器显示的样式，1正常显示 好友分组列表  2选择分组 群聊选择群组员
 */
typedef NS_ENUM(NSInteger,kFriendGroupTpye) {
    /**
     *  @author wzp, 15-10-24 16:10:10
     *
     *  正常显示模式
     */
    kFriendGroupTpyeNormal,
    /**
     *  @author wzp, 15-10-24 16:10:10
     *
     *  选择显示模式
     */
    kFriendGroupTpyeSelected
};


@interface QCFriendMainVC : UITableViewController<UITableViewDataSource,UITableViewDelegate>
/**
 *  @author wzp, 15-10-24 16:10:46
 *
 *   构造函数
 *
 *  @param type 显示模式
 *
 *  @return 累对象
 */
-(instancetype)initWithType:(kFriendGroupTpye)type;
@property(strong,nonatomic)QCBaseTableView *tableView;
@end
