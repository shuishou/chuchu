//
//  QCDoodleCommentFrame.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/25.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCDoodleCommentFrame.h"
#import "QCDoodleStatus.h"
#import "User.h"
#import "QCStatusPhotosView.h"
#import "NSDate+Format.h"
#import "NSDate+Common.h"
#import "NSObject+Common.h"

@implementation QCDoodleCommentFrame

-(void)setReplyModel:(Reply *)replyModel{
    _replyModel = replyModel;
    //整个bgView
    
    //头像
    CGFloat iconWH = 44;
    CGFloat iconX = kBouderWidth;
    CGFloat iconY = kBouderWidth;
    _iconF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    //昵称
    CGFloat nickNameX = CGRectGetMaxX(_iconF) + kBouderWidth;
    CGFloat nickNameY = iconY;
    CGSize nickNameSize = [replyModel.user.phone sizeWithFont:kStatusCellNameFont];
    _nickNameF = (CGRect){{nickNameX,nickNameY},nickNameSize};
    
    //发送时间
    CGFloat sendTimeX = nickNameX;
    CGFloat sendTimeY = CGRectGetMaxY(_nickNameF) + kBouderWidth;
    NSString *timeStr = self.replyModel.createTime;
    CGSize sendTimeSize = [timeStr sizeWithFont:kStatusCellSendTimeFont];
    _sendTimeF = (CGRect){{sendTimeX,sendTimeY},sendTimeSize};
    
    
    //正文
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(_iconF), CGRectGetMaxY(_sendTimeF)) + kBouderWidth;
    CGFloat maxW = SCREEN_W - 2 * kBouderWidth - 2 * contentX;
    CGSize contentSize = [replyModel.content sizeWithFont:kStatusCellContentFont maxW:maxW];
    _contentF = (CGRect){{contentX, contentY}, contentSize};
    
    
    /** 内容整体 */
    CGFloat originalX = kBouderWidth;
    CGFloat originalY = kStatusCellMargin;
    CGFloat originalW = SCREEN_W - 2 *kBouderWidth;
    CGFloat originalH1 = CGRectGetMaxY(_contentF) + kStatusCellMargin;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH1);
    
    
    /** cell的高度 */
    self.cellHeight = CGRectGetMaxY(_originalViewF);
    
    
}
@end
