//
//  QCFaQiQunLiaoCell.m
//  MyQOOCOO
//
//  Created by Wind on 15/12/7.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCFaQiQunLiaoCell.h"

@implementation QCFaQiQunLiaoCell

- (void)awakeFromNib {
    // Initialization code
    
    self.avatarImage.layer.masksToBounds = YES;
    self.avatarImage.layer.cornerRadius = 25;
    
    [self.addButton setImage:[UIImage imageNamed:@"offs"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)QCFaQiQunLiaoCell:(UITableView *)tableView{
    static NSString *reuseId = @"QCFaQiQunLiaoCellID";
    QCFaQiQunLiaoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"QCFaQiQunLiaoCell" owner:nil options:nil]lastObject];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
@end
