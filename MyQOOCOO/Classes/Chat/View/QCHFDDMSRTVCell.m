//
//  QCHFDDMSRTVCell.m
//  MyQOOCOO
//
//  Created by Wind on 15/12/14.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCHFDDMSRTVCell.h"

@implementation QCHFDDMSRTVCell

- (void)awakeFromNib {
    // Initialization code
    
    self.avatarUrlsImaged.layer.masksToBounds = YES;
    self.avatarUrlsImaged.layer.cornerRadius = 25;
    [self.selectButton setImage:[UIImage imageNamed:@"offs"] forState:UIControlStateSelected];
    
    self.marksV1.layer.borderWidth = 0.5;
    self.marksV1.layer.borderColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1].CGColor;
    self.marksV1.layer.masksToBounds = YES;
    self.marksV1.layer.cornerRadius = 5;
    
    self.marksV2.layer.borderWidth = 0.5;
    self.marksV2.layer.borderColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1].CGColor;
    self.marksV2.layer.masksToBounds = YES;
    self.marksV2.layer.cornerRadius = 5;
    
    self.marksV3.layer.borderWidth = 0.5;
    self.marksV3.layer.borderColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1].CGColor;
    self.marksV3.layer.masksToBounds = YES;
    self.marksV3.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)QCHFDDMSRTVCell:(UITableView *)tableView{
    static NSString *reuseId = @"QCHFDDMSRTVCellId";
    QCHFDDMSRTVCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"QCHFDDMSRTVCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.marksLa.textColor = RandomColor;
        cell.marksLa2.textColor = RandomColor;
        cell.marksLa3.textColor = RandomColor;
    }
    return cell;
}
@end
