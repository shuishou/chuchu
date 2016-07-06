//
//  QCASTVCell.m
//  MyQOOCOO
//
//  Created by Wind on 15/12/22.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCASTVCell.h"

@implementation QCASTVCell

- (void)awakeFromNib {
    // Initialization code
    [self.groupMarksLabel setFont:[UIFont systemFontOfSize:HEIGHT(self)/4]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)QCASTVCell:(UITableView *)tableView{
    static NSString *reuseId = @"QCASTVCellId";
    QCASTVCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"QCASTVCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
@end
