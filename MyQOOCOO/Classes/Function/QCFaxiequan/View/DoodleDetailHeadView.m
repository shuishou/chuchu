//
//  DoodleDetailHeadView.m
//  MyQOOCOO
//
//  Created by 贤荣 on 15/12/12.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "DoodleDetailHeadView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define kBouderWidth 12
#define kStatusCellNameFont [UIFont systemFontOfSize:18]
#define kStatusCellSendTimeFont [UIFont systemFontOfSize:13]
#define kStatusCellContentFont [UIFont systemFontOfSize:15]
#define kStatusCellMargin 15

@interface DoodleDetailHeadView ()


/** 昵称 */
@property (nonatomic, weak) UILabel *nickNameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *sendTimeLabel;
/** 正文 */
@property (nonatomic, weak) UILabel *contentLabel;
//单张配图
@property (nonatomic,strong) UIImageView *singelImageView;

/** 整体内容 */
@property (nonatomic, strong) UIView *originalView;

@end

@implementation DoodleDetailHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /** 内容整体 */
        UIView *originalView = [[UIView alloc]init];
        originalView.layer.cornerRadius = 8;
        originalView.layer.masksToBounds = YES;
        [self addSubview:originalView];
        self.originalView = originalView;
        originalView.backgroundColor = [UIColor whiteColor];
        
        /** 头像 */
        UIImageView * iconV = [[UIImageView alloc]init];
        [originalView addSubview:iconV];
        self.iconV = iconV;
        
        /** 昵称 */
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = kStatusCellNameFont;
        nameLabel.textColor = UIColorFromRGB(0x333333);
        [originalView addSubview:nameLabel];
        self.nickNameLabel = nameLabel;
        
        /** 时间 */
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = kStatusCellSendTimeFont;
        timeLabel.textColor = UIColorFromRGB(0x999999);
        [originalView addSubview:timeLabel];
        self.sendTimeLabel = timeLabel;
        
        /** 正文 */
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = kStatusCellContentFont;
        contentLabel.numberOfLines = 0;
        [originalView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        //    涂鸦画
        UIImageView *singleImageView = [[UIImageView alloc]init];
        [originalView addSubview:singleImageView];
        singleImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick)];
        [singleImageView addGestureRecognizer:tap];
        self.singelImageView = singleImageView;
    }
    return self;
}


-(void)setQcStatus:(QCDoodleStatus *)qcStatus{
    _qcStatus = qcStatus;
    User *user = qcStatus.user;

    self.iconV.layer.cornerRadius = 22;
    self.iconV.clipsToBounds = YES;
    
    NSURL *imgURL = [NSURL URLWithString:qcStatus.user.avatar];
    [self.iconV sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"ios-template-1024(1)"]];
    
    if (user.nickname) {
        self.nickNameLabel.text = user.nickname;
    }else{
        self.nickNameLabel.text = user.phone;
    }
    
    NSString *timeString = qcStatus.createTime;
    self.sendTimeLabel.text = timeString;
    
    self.contentLabel.text = qcStatus.content;
    
    /** 配图 */
    if (qcStatus.fileUrl.length > 0) {
        NSURL *url = [NSURL URLWithString:qcStatus.fileUrl];
        [self.singelImageView sd_setImageWithURL:url];
    }
}



-(void)layoutSubviews{
    [super layoutSubviews];
    //头像
    CGFloat iconWH = 44;
    CGFloat iconX = kBouderWidth;
    CGFloat iconY = kBouderWidth;
    self.iconV.frame = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    //昵称
    CGFloat nickNameX = CGRectGetMaxX(self.iconV.frame) + kBouderWidth;
    CGFloat nickNameY = iconY;
    CGSize nickNameSize;
    if (self.qcStatus.user.nickname) {
        nickNameSize = [self.qcStatus.user.nickname sizeWithFont:kStatusCellNameFont];
        self.nickNameLabel.text = self.qcStatus.user.nickname;
    }else{
        nickNameSize = [self.qcStatus.user.phone sizeWithFont:kStatusCellNameFont];
        self.nickNameLabel.text = self.qcStatus.user.phone;
    }
    self.nickNameLabel.frame = (CGRect){{nickNameX,nickNameY},nickNameSize};
    
    //发送时间
    CGFloat sendTimeX = nickNameX;
    CGFloat sendTimeY = CGRectGetMaxY(self.nickNameLabel.frame) + kBouderWidth;
    NSString *timeStr = self.qcStatus.createTime;
    CGSize sendTimeSize = [timeStr sizeWithFont:kStatusCellSendTimeFont];
    self.sendTimeLabel.frame = (CGRect){{sendTimeX,sendTimeY},sendTimeSize};
    
    NSString *timeString = self.qcStatus.createTime;
    self.sendTimeLabel.text = timeString;
    CGFloat timeX = self.nickNameLabel.frame.origin.x;
    CGFloat timeY = CGRectGetMaxY(self.nickNameLabel.frame) + kBouderWidth;
    CGSize timeSize = [timeString sizeWithFont:kStatusCellSendTimeFont];
    self.sendTimeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    
    //正文
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconV.frame), CGRectGetMaxY(self.sendTimeLabel.frame)) + kBouderWidth;
    CGFloat maxW = SCREEN_W - 2 * kBouderWidth - 2 * contentX;
    CGSize contentSize = [self.qcStatus.content sizeWithFont:kStatusCellContentFont maxW:maxW];
    self.contentLabel.frame = (CGRect){{contentX, contentY}, contentSize};
    
       /** 配图 */
    if (self.qcStatus.fileUrl.length > 0) {
        CGFloat photosX = contentX;
        CGFloat photosY = CGRectGetMaxY(self.contentLabel.frame) + kBouderWidth;
        self.singelImageView.frame = CGRectMake(photosX, photosY, (SCREEN_W - 4 * kBouderWidth)/3, (SCREEN_W - 4 * kBouderWidth)/3);
        self.singelImageView.hidden = NO;
    } else {
        self.singelImageView.hidden = YES;
    }
    
    /** 内容整体 */
    CGFloat originalX = kBouderWidth;
    CGFloat originalY = kStatusCellMargin;
    CGFloat originalW = SCREEN_W - 2 * kBouderWidth;
    CGFloat originalH= 0;
    if (self.qcStatus.fileUrl.length > 0) {
        originalH = CGRectGetMaxY(self.singelImageView.frame) + kStatusCellMargin;
    }else{
        originalH = CGRectGetMaxY(self.contentLabel.frame) + kStatusCellMargin;
    }
    self.originalView.frame = CGRectMake(originalX, originalY, originalW, originalH);
    
    self.frame = CGRectMake(0, 0, kUIScreenW, originalH +24);
}

-(void)imgClicks{
    MJPhotoBrowser * brower = [[MJPhotoBrowser alloc]init];
    MJPhoto *mjPhoto =[[MJPhoto alloc]init];
    mjPhoto.srcImageView = self.singelImageView;
    brower.photos =@[mjPhoto].mutableCopy;
    [brower show];
}









@end
