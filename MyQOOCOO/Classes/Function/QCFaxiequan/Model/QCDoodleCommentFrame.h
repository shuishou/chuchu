//
//  QCDoodleCommentFrame.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/25.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#define kBouderWidth 12
#define kStatusCellNameFont [UIFont systemFontOfSize:18]
#define kStatusCellSendTimeFont [UIFont systemFontOfSize:13]
#define kStatusCellContentFont [UIFont systemFontOfSize:15]
#define kStatusCellMargin 15

#import <Foundation/Foundation.h>
#import "Reply.h"
#import "User.h"

@interface QCDoodleCommentFrame : NSObject

@property (nonatomic , strong)Reply *replyModel;

/** 背景 */
@property ( nonatomic , assign) CGRect originalViewF;
/** 头像 */
@property ( nonatomic , assign) CGRect iconF;
/** 昵称 */
@property ( nonatomic , assign) CGRect nickNameF;
/** 发送时间 */
@property ( nonatomic , assign) CGRect sendTimeF;
/** 正文 */
@property ( nonatomic , assign) CGRect contentF;
/** cell高度 */
@property ( nonatomic , assign) CGFloat cellHeight;

@end
