//
//  QCSelectContactsTableView.h
//  MyQOOCOO
//
//  Created by lanou on 16/1/29.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCSelectContactsTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray*dataArr;


@end
