//
//  QCHFGroupHeadView.m
//  MyQOOCOO
//
//  Created by Wind on 15/12/7.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCHFGroupHeadView.h"

@implementation QCHFGroupHeadView
@synthesize delegate = _delegate;
@synthesize section,open,backBtn,titleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        open = NO;
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 70/2-15/2, 18, 15);
//        [btn addTarget:self action:@selector(doSelected) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"but_down-arrow"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"but_uparrow"] forState:UIControlStateHighlighted];
        
        UILabel * tLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(btn)+30, Y(btn)-5/2, 50, 20)];
        tLabel.textColor = [UIColor colorWithHexString:@"333333"];
        tLabel.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:btn];
        [self addSubview:tLabel];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doSelected:)];
        tap1.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tap1];
        
        UIImageView * Line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 69, WIDTH(self), 1)];
        Line.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1];
        [self addSubview:Line];
        
        self.backBtn = btn;
        self.titleLabel = tLabel;
    }
    return self;
}

-(void)doSelected:(UITapGestureRecognizer *)tap
{
    //    [self setImage];
    if (_delegate && [_delegate respondsToSelector:@selector(selectedWith:)]){
        [_delegate selectedWith:self];
    }
}
@end
