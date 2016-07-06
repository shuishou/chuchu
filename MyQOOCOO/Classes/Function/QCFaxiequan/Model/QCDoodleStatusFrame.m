//
//  QCDoodleFrame.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/20.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//


#import "QCDoodleStatusFrame.h"
#import "QCDoodleStatus.h"
#import "User.h"
#import "QCStatusPhotosView.h"
#import "NSDate+Format.h"
#import "NSDate+Common.h"
#import "NSObject+Common.h"

@implementation QCDoodleStatusFrame

-(void)setQcStatus:(QCDoodleStatus *)qcStatus{
    _qcStatus = qcStatus;

    //头像
    CGFloat iconWH = 44;
    CGFloat iconX = kBouderWidth;
    CGFloat iconY = kBouderWidth;
    _iconF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    //昵称
    CGFloat nickNameX = CGRectGetMaxX(_iconF) + kBouderWidth;
    CGFloat nickNameY = iconY;
    CGSize nickNameSize = [qcStatus.user.phone sizeWithFont:kStatusCellNameFont];
    _nickNameF = (CGRect){{nickNameX,nickNameY},nickNameSize};
    
    //发送时间
    CGFloat sendTimeX = nickNameX;
    CGFloat sendTimeY = CGRectGetMaxY(_nickNameF) + kBouderWidth;
    NSString *timeStr = [self.qcStatus timeAgoString:self.qcStatus.createTime];
    CGSize sendTimeSize = [timeStr sizeWithFont:kStatusCellSendTimeFont];
    _sendTimeF = (CGRect){{sendTimeX,sendTimeY},sendTimeSize};
    
    
    //正文
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(_iconF), CGRectGetMaxY(_sendTimeF)) + kBouderWidth;
    CGFloat maxW = SCREEN_W - 2 * kBouderWidth - 2 * contentX;
    CGSize contentSize = [qcStatus.content sizeWithFont:kStatusCellContentFont maxW:maxW];
    _contentF = (CGRect){{contentX, contentY}, contentSize};
    
    //图片
    CGFloat originalH = 0;
    if (qcStatus.fileUrl.length > 0) { // 有配图
        CGFloat photosX = contentX;
        CGFloat photosY = CGRectGetMaxY(_contentF) + kBouderWidth;
        _photosF = CGRectMake(photosX, photosY, (SCREEN_W - 4 * kBouderWidth)/3, (SCREEN_W - 4 * kBouderWidth)/3);
        originalH = CGRectGetMaxY(_photosF) + kBouderWidth;
    } else { // 没配图
        originalH = CGRectGetMaxY(_contentF) + kBouderWidth;
    }
 
//   工具条
    CGFloat toolbarW = 200;
    CGFloat toolbarX = SCREEN_W - 3 *kBouderWidth - toolbarW ;
    CGFloat toolbarY = originalH;
    CGFloat toolbarH = 25;
    _toolBarF = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);


    /** 内容整体 */
    CGFloat originalX = kBouderWidth;
    CGFloat originalY = kStatusCellMargin;
    CGFloat originalW = SCREEN_W - 2 *kBouderWidth;
    CGFloat originalH1 = CGRectGetMaxY(_toolBarF) + kStatusCellMargin;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH1);
    
    
    /** cell的高度 */
    self.cellHeight = CGRectGetMaxY(_originalViewF);
}
@end
