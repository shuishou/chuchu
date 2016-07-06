//
//  QCSingleChatCell.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/4.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCChatListCell.h"

@interface QCChatListCell()
{
//    UIImageView *_placeholderImage;
    UILabel *_nickName;
    UILabel *_lastMS;
    UILabel *_timeLabel;
    UILabel *_unreadLabel;//未读消息数
}

@end

@implementation QCChatListCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //头像
        _placeholderImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 55, 55)];
//        _placeholderImage.image = [UIImage imageNamed:@"ios-template-120(1)"];
        _placeholderImage.layer.cornerRadius = 5;
        _placeholderImage.layer.masksToBounds = YES;
        _placeholderImage.layer.borderWidth = 0.5;
        _placeholderImage.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
        [self.contentView addSubview:_placeholderImage];
        
        
        
        //昵称
        _nickName = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_placeholderImage)+8, Y(_placeholderImage)+5, SCREEN_W/3, 17)];
        _nickName.textColor = kNickNameColor;
        _nickName.font = [UIFont boldSystemFontOfSize:HEIGHT(_nickName)];
        _nickName.numberOfLines = 1;
        [self.contentView addSubview:_nickName];
        
        
        
        
        //最新一条消息
        _lastMS = [[UILabel alloc] initWithFrame:CGRectMake(X(_nickName), MaxY(_placeholderImage)-14-5, WIDTH(self.contentView) *2/3, 14)];
        _lastMS.textColor = kMessageColor;
        _lastMS.font = kMessageFont;
        _lastMS.numberOfLines = 1;//只显示一行
        [self.contentView addSubview:_lastMS];
        
//        _lastMS.size = [lastSting boundingRectWithSize:CGSizeMake(250, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:kMessageFont,NSFontAttributeName, nil] context:nil].size;
//        [_lastMS mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_nickName.mas_left);
//            make.bottom.equalTo(_placeholderImage.mas_bottom).offset(-2);
//            
//        }];
        
        //时间标签
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenW-WIDTH(self.contentView)/4)-8, Y(_nickName)+1.5, WIDTH(self.contentView)/4, 14)];
        _timeLabel.textColor = kTimeLabelColor;
        _timeLabel.numberOfLines = 1;
        _timeLabel.font = kTimeLabelFont;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
        
        //删除按钮
        _deleteImage = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenW, 0, 50, 75)];
        _deleteImage.contentMode = UIViewContentModeScaleAspectFit;
        [_deleteImage setImage:[UIImage imageNamed:@"组-9"]];
        [_deleteImage setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:_deleteImage];
        
        _whiteImage = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(_deleteImage), 0, kUIScreenW, 75)];
        _whiteImage.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_whiteImage];
        
        _Cline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 74, kUIScreenW*2, 1)];
        [self.contentView addSubview:_Cline];
        
//        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(_placeholderImage);
//            make.right.equalTo(self.mas_right).offset(-16);
//        }];
        
//        [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_placeholderImage.mas_right).offset(16);
//            make.top.equalTo(_placeholderImage.mas_top).offset(5);
//            make.height.mas_equalTo(@15);
//            make.right.equalTo(_timeLabel.mas_left).offset(-10);
//        }];
        
        
        //未读消息数
        _unreadLabel = [[UILabel alloc] init];
        _unreadLabel.backgroundColor = [UIColor colorWithHex:0xf74d31];
        _unreadLabel.textColor = [UIColor whiteColor];
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.font = [UIFont systemFontOfSize:12];
        _unreadLabel.layer.cornerRadius = 10;
        _unreadLabel.clipsToBounds = YES;
        [self.contentView addSubview:_unreadLabel];
        
        [_unreadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_placeholderImage.mas_right).offset(-5);
            make.centerY.mas_equalTo(_placeholderImage.mas_top).offset(5);
            make.size.mas_equalTo(CGSizeMake(20,20));
        }];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)setName:(NSString *)name{
    _name = name;
    _nickName.text = name;
}

-(void)setPlaceholderImage:(UIImageView *)placeholderImage{
    _placeholderImage = placeholderImage;
}

-(void)setImageURL:(NSURL *)imageURL{
    _imageURL = imageURL;
    [_placeholderImage sd_setImageWithURL:_imageURL placeholderImage:_placeholderImage.image];
}

-(void)setDetailMsg:(NSString *)detailMsg{
    _detailMsg = detailMsg;
    _lastMS.text = _detailMsg;
}

-(void)setTime:(NSString *)time{
    _time = time;
    _timeLabel.text = _time;
//    CGSize timeSize = [_time boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:kTimeLabelFont,NSFontAttributeName, nil] context:nil].size;
//    [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(timeSize);
//    }];
}

-(void)setUnreadCount:(NSInteger)unreadCount{
    _unreadCount = unreadCount;
    if (_unreadCount==0) {
        _unreadLabel.hidden = YES;
    }else{
        _unreadLabel.hidden = NO;
    }
    _unreadLabel.text = [NSString stringWithFormat:@"%ld",_unreadCount];
}
-(BOOL)canBecomeFirstResponder{
    return YES;
}
+(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
@end
