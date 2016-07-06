//
//  QCLKCommentCellTableViewCell.h
//  MyQOOCOO
//
//  Created by 贤荣 on 15/12/26.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCLunkuListModel.h"

@interface QCLKCommentCellTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (nonatomic,strong) QCLunkuListModel * lk;

@property(nonatomic,assign)BOOL isFree;


@end
