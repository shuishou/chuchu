//
//  QCSeniorTableView.h
//  MyQOOCOO
//
//  Created by lanou on 16/1/4.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCSeniorModel.h"

@interface QCSeniorTableView : UITableView<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)NSMutableArray*dataArr;

@end
