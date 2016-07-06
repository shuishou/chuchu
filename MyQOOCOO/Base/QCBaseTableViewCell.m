//
//  XSBaseTableViewCell.m
//  XSTeachEDU
//
//  Created by xsteach on 14/12/19.
//  Copyright (c) 2014年 xsteach.com. All rights reserved.
//

#import "QCBaseTableViewCell.h"

@implementation QCBaseTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        UIView * selectedView = [[UIView alloc]initWithFrame:CGRectZero];
        selectedView.backgroundColor = [UIColor colorWithHex:0xE7E7E7];
        self.selectedBackgroundView = selectedView;
    }
    return self;
}
@end
