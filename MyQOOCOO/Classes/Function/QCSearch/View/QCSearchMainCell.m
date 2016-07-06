//
//  QCSearchMainCell.m
//  MyQOOCOO
//
//  Created by wzp on 15/10/9.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCSearchMainCell.h"

@implementation QCSearchMainCellItem{
    UIImageView * _imageView;
    UILabel * _title;
}

-(instancetype)init{
    if (self = [super init]) {
        //
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
        
        _title = [UILabel new];
        _title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_title];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(_imageView.mas_bottom).offset(+10);
        }];
    }
    return self;
}

-(void)setInfoDic:(NSDictionary *)infoDic{
    _infoDic = infoDic;
    UIImage * image = [UIImage imageNamed:_infoDic[@"image"]];
    
    [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(image.size);
        make.centerY.equalTo(self.mas_centerY).offset(-image.size.height/3);
    }];
    _imageView.image = image;
    
    _title.text = _infoDic[@"name"];
    
}

@end


@implementation QCSearchMainCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //
        self.leftItem = [QCSearchMainCellItem new];
        [self.contentView addSubview:self.leftItem];
        
        self.rightItem = [QCSearchMainCellItem new];
        [self.contentView addSubview:self.rightItem];
        
        
        
        [self.leftItem addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)]];
        [self.rightItem addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)]];
        
        UIView * line = [UIView new];
        line.backgroundColor = kSeparatorColor;
        [self.contentView addSubview:line];
        
        UIView * endLine = [UIView new];
        endLine.backgroundColor = kSeparatorColor;
        [self.contentView addSubview:endLine];
        
//        self.leftItem.backgroundColor = [UIColor cyanColor];
//        self.rightItem.backgroundColor = [UIColor blueColor];
        
        
        
        [self.leftItem mas_makeConstraints:^(MASConstraintMaker *make) {
            //
            make.top.left.bottom.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            make.right.equalTo(self.contentView.mas_centerX);
            
        }];
        [self.rightItem mas_makeConstraints:^(MASConstraintMaker *make) {
            //
            make.top.bottom.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            make.left.equalTo(self.contentView.mas_centerX);
            
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            //
            make.top.mas_equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_centerX).offset(-0.25);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.right.equalTo(self.contentView.mas_centerX).offset(0.25);
            
        }];
        
        [endLine mas_makeConstraints:^(MASConstraintMaker *make) {
            //
            make.top.equalTo(self.contentView.mas_bottom).offset(-0.5);
            make.left.right.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

-(void)click:(UITapGestureRecognizer *)sender{
    if ([self.delegate respondsToSelector:@selector(searchMainCell:selectedIndex:)]) {
        [self.delegate searchMainCell:self selectedIndex:sender.view.tag];
    }
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
