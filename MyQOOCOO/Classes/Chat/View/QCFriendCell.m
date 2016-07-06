//
//  QCFriendCell.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/3.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCFriendCell.h"

@interface QCFriendCell (){
}

@end

@implementation QCFriendCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //头像
        _avatarbtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 55, 55)];
        [_avatarbtn addTarget:self action:@selector(clickAvatarBtn:) forControlEvents:UIControlEventTouchUpInside];
        _avatarbtn.layer.cornerRadius = 55/2;
        _avatarbtn.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatarbtn];
        
        //昵称
        _nickName = [[UILabel alloc]init];
        _nickName.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nickName];

        UIImage *_avatar = [UIImage imageNamed:@"default-avatar_1"];
        [_avatarbtn setImage:_avatar forState:UIControlStateNormal];
        [_avatarbtn addTarget:self action:@selector(clickAvatarBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_avatarbtn];
        
        //昵称
        _nickName = [[UILabel alloc]init];
        _nickName.text = @"大湿兄";
        _nickName.textColor = [UIColor blackColor];
        [self addSubview:_nickName];
        //布局
        [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarbtn.mas_right).offset(16);
            make.top.equalTo(_avatarbtn.mas_top);
            make.width.mas_equalTo(@120);
            make.height.mas_equalTo(@22);
            
        }];
        
        _attentionBtn = [UIButton new];
        _attentionBtn.backgroundColor = [UIColor colorWithHex:0x00AE69];
        _attentionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_attentionBtn addTarget:self action:@selector(clickAttentionButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_attentionBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
        [self.contentView addSubview:_attentionBtn];
        
        [_attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 0, 0, 15));
            make.size.mas_equalTo(CGSizeMake(70, 25));
        }];
    }
    return self;
}

-(void)setUserModel:(User *)userModel{
    _userModel = userModel;
    for (UIView *subView in self.contentView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]&&subView.tag>=1000000) {
            [subView removeFromSuperview];
        }
    }
    
    if (_userModel.isFriend) {
        _attentionBtn.hidden = YES;
    }else{
        _attentionBtn.hidden = NO;
    }
    
    [_avatarbtn sd_setImageWithURL:[NSURL URLWithString:_userModel.avatarUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default-avatar_1"]];
    if (_userModel.nickname.length!=0) {
        _nickName.text = _userModel.nickname;
    }else{
        _nickName.text = _userModel.phone;
    }
    
    
    NSArray * tagArray = [_userModel.marks componentsSeparatedByString:@","];
    UIButton * lastButton;
    for (int i= 0; i<tagArray.count; i++) {
        UIButton * tagButton = [UIButton new];
        tagButton.titleLabel.font = [UIFont systemFontOfSize:14];
        tagButton.backgroundColor = [UIColor whiteColor];
        tagButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        tagButton.layer.borderWidth = 1;
        tagButton.layer.cornerRadius = 4;
        tagButton.layer.masksToBounds = YES;
        tagButton.tag = 1000000+i;
        [tagButton addTarget:self action:@selector(clickTagButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:tagButton];
        if (i%2==0) {
            [tagButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [tagButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
        NSString * tag = tagArray[i];
        [tagButton setTitle:tag forState:UIControlStateNormal];

        CGFloat width =[tag sizeWithFont:tagButton.titleLabel.font].width;
        [tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nickName.mas_bottom).offset(10);
            make.width.mas_equalTo(width+5);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        
        if (!lastButton) {
            [tagButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_nickName);
            }];
        }else{
            [tagButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastButton.mas_right).offset(10);
            }];
        }
        lastButton = tagButton;
    }
}

-(void)setFriendModel:(QCFriendModel *)friendModel{
    _friendModel = friendModel;
//    for (UIView *subView in self.contentView.subviews) {
//        if ([subView isKindOfClass:[UIButton class]]&&subView.tag>=1000000) {
//            [subView removeFromSuperview];
//        }
//    }
    _attentionBtn.hidden = _friendModel.eachFocus;
    
    [_avatarbtn sd_setImageWithURL:[NSURL URLWithString:_friendModel.user.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default-avatar_1"]];
    if (_friendModel.user.nickname.length!=0) {
        _nickName.text = _friendModel.user.nickname;
    }else{
        _nickName.text = _friendModel.user.phone;
    }
}
-(void)clickAvatarBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(friendCell:clickAvatar:)]) {
        [self.delegate friendCell:self clickAvatar:_userModel];
    }
}

-(void)clickTagButton:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(friendCell:clickTagButton:)]) {
        [self.delegate friendCell:self clickTagButton:sender.titleLabel.text];
    }
}

-(void)clickAttentionButton:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(friendCell:clickAttention:user:)]) {
        [self.delegate friendCell:self clickAttention:self.tag user:_userModel];
    }
}

@end
