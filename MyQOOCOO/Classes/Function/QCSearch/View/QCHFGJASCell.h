//
//  QCHFGJASCell.h
//  MyQOOCOO
//
//  Created by Wind on 15/12/23.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCHFGJASCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *addButton1;
@property (strong, nonatomic) IBOutlet UILabel *orLabel;
@property (strong, nonatomic) IBOutlet UIButton *addButton2;
@property (strong, nonatomic) IBOutlet UILabel *orLable1;
@property (strong, nonatomic) IBOutlet UIButton *addButton3;

+(instancetype)QCHFGJASCell:(UITableView *)tableView;

@end
