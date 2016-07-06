//
//  QCDiandiListCell.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/11/3.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCDiandiListModel.h"
#define kMovieUrlNotification @"MovieUrlNotification"

@interface QCDiandiListCell : UITableViewCell

@property (nonatomic , strong)QCDiandiListModel *diandiListModel;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
