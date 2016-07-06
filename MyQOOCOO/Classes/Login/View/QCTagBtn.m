//
//  QCTagBtn.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/12.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCTagBtn.h"

@implementation QCTagBtn
- (instancetype)initWithFrame:(CGRect)frame btnString:(NSString *)btnString{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:.5];
        //标题
        [self setTitle:btnString forState:UIControlStateNormal];
        [self setTitleColor:RandomColor forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:rand()%3+15];
        //frame
        CGSize contentSize = [btnString boundingRectWithSize:CGSizeMake(SCREEN_W, self.titleLabel.font.pointSize) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.titleLabel.font,NSFontAttributeName, nil] context:nil].size;
        self.size = CGSizeMake(contentSize.width+24, contentSize.height+15);
        self.layer.cornerRadius = 5;
    }
    return self;
}@end
