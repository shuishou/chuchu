//
//  QCFaQiQunLiaoCell.h
//  MyQOOCOO
//
//  Created by Wind on 15/12/7.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCFaQiQunLiaoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImage;
@property (strong, nonatomic) IBOutlet UILabel *niceNameLabel;

+(instancetype)QCFaQiQunLiaoCell:(UITableView *)tableView;
@end
