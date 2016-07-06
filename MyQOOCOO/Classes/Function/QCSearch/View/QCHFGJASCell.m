//
//  QCHFGJASCell.m
//  MyQOOCOO
//
//  Created by Wind on 15/12/23.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCHFGJASCell.h"

@implementation QCHFGJASCell

- (void)awakeFromNib {
    // Initialization code
    
    self.orLabel.font = [UIFont systemFontOfSize:HEIGHT(self.addButton1)/3];
    self.orLable1.font = [UIFont systemFontOfSize:HEIGHT(self.addButton1)/3];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)QCHFGJASCell:(UITableView *)tableView{
    static NSString *reuseId = @"QCHFGJASCellId";
//    [tableView registerClass:[QCHFGJASCell class] forCellReuseIdentifier:reuseId];
    QCHFGJASCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"QCHFGJASCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.addButton1 setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [cell.addButton2 setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [cell.addButton3 setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        
    }
    return cell;
}
@end
