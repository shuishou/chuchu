//
//  QCEditFriendCell.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/3.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCEditFriendCell.h"


@interface QCEditFriendCell (){
    UIButton *_selectedBtn;
    UIImageView *_avatarView;
    UILabel *_nickName;
    UIView *_descriptionLabel;
}
//@property ( nonatomic , assign,getter = isSelected) BOOL selected;

@end

@implementation QCEditFriendCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //选中按钮
        _selectedBtn = [[UIButton alloc]init];
        [_selectedBtn setImage:[UIImage imageNamed:@"asf-dsaf-dsa"] forState:UIControlStateNormal];
        [_selectedBtn setImage:[UIImage imageNamed:@"but_diandi"] forState:UIControlStateSelected];
        [self addSubview:_selectedBtn];
        [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
        
        
        //头像
        _avatarView = [[UIImageView alloc]init];
        UIImage *_avatar = [UIImage imageNamed:@"default-avatar_1"];
        _avatarView.image = _avatar;
        [self addSubview:_avatarView];
        [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_selectedBtn.mas_right).offset(10);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(55, 55));
        }];
        
        //昵称
        _nickName = [[UILabel alloc]init];
        _nickName.text = @"大湿兄";
        _nickName.textColor = [UIColor blackColor];
        [self addSubview:_nickName];
        //布局
        [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarView.mas_right).offset(16);
            make.top.equalTo(_avatarView.mas_top);
            make.width.mas_equalTo(@120);
            make.height.mas_equalTo(@22);
            
        }];
        
        
        //标签
        _descriptionLabel = [[UIView alloc]init];
        _descriptionLabel.backgroundColor = [UIColor grayColor];
        [self addSubview:_descriptionLabel];
        
        [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nickName.mas_left);
            make.bottom.equalTo(_avatarView.mas_bottom);
            make.width.equalTo(@200);
            make.height.equalTo(@22);
        }];
        
        //
        
    }
    
    
    return self;
}
@end
