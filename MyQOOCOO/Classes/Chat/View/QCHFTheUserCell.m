//
//  QCHFTheUserCell.m
//  MyQOOCOO
//
//  Created by Wind on 15/12/3.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCHFTheUserCell.h"

@implementation QCHFTheUserCell

- (void)awakeFromNib {
    // Initialization code
    
    
    self.age.backgroundColor=kLoginbackgoundColor;
    self.age.textAlignment=NSTextAlignmentCenter;
    self.age.textColor=[UIColor whiteColor];
    self.age.layer.cornerRadius=5;
    self.age.layer.masksToBounds=YES;
    
    self.avatarUrlImage.layer.masksToBounds = YES;
    self.avatarUrlImage.layer.cornerRadius = 25;
    [self.isFriendBu setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateSelected];
    
    self.markView1.layer.borderWidth = 0.5;
    self.markView1.layer.borderColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1].CGColor;
    self.markView1.layer.masksToBounds = YES;
    self.markView1.layer.cornerRadius = 5;
    
    self.markView2.layer.borderWidth = 0.5;
    self.markView2.layer.borderColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1].CGColor;
    self.markView2.layer.masksToBounds = YES;
    self.markView2.layer.cornerRadius = 5;

    self.markView3.layer.borderWidth = 0.5;
    self.markView3.layer.borderColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1].CGColor;
    self.markView3.layer.masksToBounds = YES;
    self.markView3.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)QCHFTheUserCell:(UITableView *)tableView{
    static NSString *reuseId = @"QCHFTheUserCellId";
    QCHFTheUserCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"QCHFTheUserCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.marksLabel1.textColor = RandomColor;
        cell.marksLabel2.textColor = RandomColor;
        cell.marksLabel3.textColor = RandomColor;
    }
    return cell;
}


@end
