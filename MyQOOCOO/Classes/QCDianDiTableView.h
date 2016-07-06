//
//  QCDianDiTableView.h
//  MyQOOCOO
//
//  Created by lanou on 16/2/27.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCDiandiListCell.h"

@interface QCDianDiTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray*modelArr;


@end
