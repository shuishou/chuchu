//
//  QCBaseTableVC.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/10.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"
#import "QCBaseTableView.h"
#import "QCFriendModel.h"


@interface QCBaseTableVC : QCBaseVC<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong)QCBaseTableView *tableView;

@end
