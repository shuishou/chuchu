//
//  QCFriendListCell.m
//  MyQOOCOO
//
//  Created by wzp on 15/9/29.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCFriendListCell.h"

@implementation QCFriendListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.avaterImage.backgroundColor = [UIColor cyanColor];
        
//        [self.avaterImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            //
//            make.top.left.bottom.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 10, 0));
//            make.width.mas_equalTo(self.avaterImage.mas_height);
//        }];
//        
//        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            //
//            make.left.equalTo(self.avaterImage.mas_right).offset(10);
//            make.right.equalTo(self.contentView.mas_right).offset(-10);
//            make.height.mas_equalTo(@20);
//            make.centerY.mas_equalTo(self.contentView.mas_centerY);
//        }];
        [self initCell];
    }
    return self;
}

- (void)initCell
{
    self.avaterImage = [UIImageView new];
    [self.contentView addSubview:self.avaterImage];
    
    self.titleLabel = [UILabel new];
    [self.contentView addSubview:self.titleLabel];
    
    self.HFLine = [UIImageView new];
    [self.contentView addSubview:self.HFLine];
    
    self.detailLabel = [UILabel new];
    [self.contentView addSubview:self.detailLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.avaterImage.frame = CGRectMake(8, 8, HEIGHT(self.contentView)-16, HEIGHT(self.contentView)-16);
    self.avaterImage.layer.borderWidth = 0.5;
    self.avaterImage.layer.borderColor = [UIColor colorWithRed:186.0/255 green:186.0/255 blue:186.0/255 alpha:1].CGColor;
    self.avaterImage.layer.masksToBounds = YES;
    self.avaterImage.layer.cornerRadius = 3;
    
    self.titleLabel.frame = CGRectMake(MaxX(self.avaterImage)+13, HEIGHT(self.contentView)/2 - (HEIGHT(self.contentView)/3)/2, WIDTH(self.contentView)-32-HEIGHT(self.contentView), HEIGHT(self.contentView)/3);
    self.titleLabel.font = [UIFont systemFontOfSize:13];
//    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    
    
   
    
 
    
    
    self.HFLine.frame = CGRectMake(0, HEIGHT(self.contentView)-1, WIDTH(self.contentView), 1);
    self.HFLine.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
