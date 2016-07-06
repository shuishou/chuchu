//
//  QCDoodleCommentCell.h
//  MyQOOCOO
//
//  Created by 贤荣 on 15/12/12.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reply.h"

@interface QCDoodleCommentCell : UITableViewCell

@property (nonatomic,strong) Reply * reply;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *rUser;//回复人

@property (weak, nonatomic) IBOutlet UIImageView *icon;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
