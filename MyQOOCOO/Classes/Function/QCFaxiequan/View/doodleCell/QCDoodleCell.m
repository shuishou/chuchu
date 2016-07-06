//
//  QCDoodleCell.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/20.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCDoodleCell.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface QCDoodleCell()

@end

@implementation QCDoodleCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"qcDooleStatusCell";
    QCDoodleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[QCDoodleCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;//选中不变色
        //初始化内容
        [self setupContent];
    }
    return self;
}
-(void)setupContent{
    /** 内容整体 */
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor whiteColor];
    originalView.layer.cornerRadius = 8;
    originalView.layer.masksToBounds = YES;
    self.originalView = originalView;
    [self.contentView addSubview:originalView];
    
    /** 头像 */
    UIImageView * iconV = [[UIImageView alloc]init];
    [originalView addSubview:iconV];
    self.iconV = iconV;
    
    /** 配图 */
//    QCStatusPhotosView *photosView = [[QCStatusPhotosView alloc] init];
//    photosView.backgroundColor = [UIColor orangeColor];
    
    UIImageView *singleImageView = [[UIImageView alloc]init];
    [originalView addSubview:singleImageView];
    singleImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick)];
    [singleImageView addGestureRecognizer:tap];
    self.singelImageView = singleImageView;
    
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
    
    /** toolbar */
    QCStatusToolBar *toolbar = [QCStatusToolBar toolBar];
    [originalView addSubview:toolbar];
    self.toolbar = toolbar;
}

-(void)setQcStatusFrame:(QCDoodleStatusFrame *)qcStatusFrame{
    _qcStatusFrame = qcStatusFrame;
    QCDoodleStatus *qcStatus = qcStatusFrame.qcStatus;
    User *user = qcStatus.user;
    //整体
    self.originalView.frame = qcStatusFrame.originalViewF;
    
    //头像
    self.iconV.frame = qcStatusFrame.iconF;
    self.iconV.layer.cornerRadius = 22;
    self.iconV.clipsToBounds = YES;
     NSURL *imgURL = [NSURL URLWithString:qcStatus.user.avatar];
    [self.iconV sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"ios-template-1024(1)"]];
    self.iconV.userInteractionEnabled=YES;
    UITapGestureRecognizer *avatartap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nuhouiconVpush)];
    [self.iconV addGestureRecognizer:avatartap];
    //昵称
    self.nickNameLabel.frame = qcStatusFrame.nickNameF;
    if (user.nickname) {
        self.nickNameLabel.text = user.nickname;
    }else{//如果用户没有昵称，就用注册电话号码代替
        self.nickNameLabel.text = user.phone;
    }
   
    //发送时间
    self.sendTimeLabel.frame = qcStatusFrame.sendTimeF;
    NSString *timeString = qcStatus.createTime;
    self.sendTimeLabel.text = timeString;
    CGFloat timeX = qcStatusFrame.nickNameF.origin.x;
    CGFloat timeY = CGRectGetMaxY(qcStatusFrame.nickNameF) + kBouderWidth;
    CGSize timeSize = [timeString sizeWithFont:kStatusCellSendTimeFont];
    self.sendTimeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    self.sendTimeLabel.text = timeString;
    //正文
    self.contentLabel.frame = qcStatusFrame.contentF;
    self.contentLabel.text = qcStatus.content;
    
    //配图
    if (qcStatus.fileUrl.length > 0) {
        self.singelImageView.frame = qcStatusFrame.photosF;
        NSURL *url = [NSURL URLWithString:qcStatus.fileUrl];
        
        [self.singelImageView sd_setImageWithURL:url];
        self.singelImageView.hidden = NO;
    } else {
        self.singelImageView.hidden = YES;
    }
    
    //工具条
    self.toolbar.frame = qcStatusFrame.toolBarF;
    self.toolbar.qcStatus = qcStatus;
}
-(void)nuhouiconVpush
{
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tuyaavatarpush" object:nil userInfo:@{@"model":self.qcStatusFrame}];
    

}



-(void)imgClick{
    MJPhotoBrowser * brower = [[MJPhotoBrowser alloc]init];
    MJPhoto *mjPhoto =[[MJPhoto alloc]init];
    mjPhoto.srcImageView = self.singelImageView;
    brower.photos =@[mjPhoto].mutableCopy;
    [brower show];
}


@end
