//
//  QCGroupListVC.h
//  MyQOOCOO
//
//  Created by wzp on 15/10/13.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//


#import "QCBaseTableVC.h"
#import "QCHFGroupHeadView.h"
@interface QCGroupListVC : QCBaseTableVC<UITableViewDataSource,UITableViewDelegate, QCHFGroupHeadViewDelegate, UIAlertViewDelegate>
{
    UITableView* _tableView;
    NSInteger _currentSection;
    NSInteger _currentRow;
    
}
@property(nonatomic, retain) NSMutableArray* headViewArray;
@property (strong, nonatomic) NSNumber * isQunLiao;

@end
