//
//  QCSwitchCell.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/31.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCSwitchCell.h"

@implementation QCSwitchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title switchView:(UIView *)switchView{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel.text = title;
        self.accessoryView = switchView;
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
