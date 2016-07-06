//
//  QCCommonTableView.h
//  MyQOOCOO
//
//  Created by lanou on 16/1/4.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QCCommonTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *titleArr;
}

@property(nonatomic,strong)NSMutableArray *textArr;
@property(nonatomic,strong)NSMutableArray *selectedArr;

@end
