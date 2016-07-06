//
//  QCASTVCell.h
//  MyQOOCOO
//
//  Created by Wind on 15/12/22.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCASTVCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *groupMarksLabel;

+(instancetype)QCASTVCell:(UITableView *)tableView;
@end
