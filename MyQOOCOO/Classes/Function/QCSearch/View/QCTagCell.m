//
//  QCTagCell.m
//  MyQOOCOO
//
//  Created by wzp on 15/10/12.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCTagCell.h"

@implementation QCTagCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //
    }
    return self;
}
-(void)setMarks:(NSArray *)marks{
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
