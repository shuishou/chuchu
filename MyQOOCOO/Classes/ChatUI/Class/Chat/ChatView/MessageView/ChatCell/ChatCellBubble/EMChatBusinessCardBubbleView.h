//
//  EMChatBusinessCardBubbleView.h
//  MyQOOCOO
//
//  Created by lanou on 16/2/24.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EMChatBaseBubbleView.h"

#import "UIResponder+Router.h"



@interface EMChatBusinessCardBubbleView : EMChatBaseBubbleView

@property(nonatomic,strong)UIImageView*imageV;
@property(nonatomic,strong)UILabel*lb;
@property(nonatomic,strong)UIImageView*bgImageV;


//@property(nonatomic,strong)MessageModel*model;

+ (CGFloat)heightForBubbleWithObject:(MessageModel *)object;
@end
