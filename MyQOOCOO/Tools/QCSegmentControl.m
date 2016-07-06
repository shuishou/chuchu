//
//  QCSegmentControl.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/31.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCSegmentControl.h"


@implementation QCSegmentControl

-(instancetype)initWithFrame:(CGRect)frame withItmesName:(NSArray *)items{
    if (self = [super initWithFrame:frame]) {
        /**
         *  自定义改构造函数
         *
         *  @return self
         */
        self.backgroundColor = [UIColor whiteColor];
        itemH = 2;
        itemW = CGRectGetWidth(frame)/items.count;
        for (int i = 0; i < items.count; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(i*itemW, 0, itemW, CGRectGetHeight(frame))];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTag:i+10];
            [button setTitleColor:[UIColor colorWithHex:0x4285f4] forState:UIControlStateSelected];
            [button setTitle:[items objectAtIndex:i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor whiteColor];
            [self addSubview:button];
            NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
            
            CGSize size = [items[i] boundingRectWithSize:CGSizeMake(SCREEN_W/2, 14) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            lineW = size.width+8;
        }
        
        UIImageView * endLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-0.5, CGRectGetWidth(self.bounds), 0.5)];
        endLine.backgroundColor = [UIColor colorWithHex:0xdbdbdb];
        [self addSubview:endLine];
        
        UIButton * button = (UIButton *)[self viewWithTag:10];
        line = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-itemH+0.5, lineW, itemH)];
        line.center = CGPointMake(button.center.x, CGRectGetHeight(frame)-itemH+0.5);
        line.backgroundColor = [UIColor colorWithHex:0x4285f4];
        [self addSubview:line];
    }
    return self;
}
-(void)setSelectColor:(UIColor *)selectColor{
    line.backgroundColor = selectColor;
    for (UIButton * view in self.subviews) {
        if (view.tag>9) {
            [view setTitleColor:selectColor forState:UIControlStateSelected];
            if (view.tag==10) {
                view.selected = YES;
            }
        }
    }
}
-(void)setNormalColor:(UIColor *)nromalColor{
    for (UIButton * view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view setTitleColor:[UIColor colorWithHex:0x1d1d1d] forState:UIControlStateNormal];
        }
    }
}
-(void)setCurrentItem:(NSInteger)currentItem{
    if (self.hideLine == YES) {
        line.hidden = YES;
    }
    UIButton * button = (UIButton *)[self viewWithTag:currentItem+10];
    float cunX = CGRectGetMidX(button.frame);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [line setCenter:CGPointMake(cunX, CGRectGetHeight(self.frame)-itemH+0.5)];
        button.selected = YES;
    } completion:nil];
    for (UIButton * view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            if (view !=button) {
                view.selected = NO;
            }
        }
    }
}
-(void)clickItem:(UIButton *)sender{
    
    float cunX = CGRectGetMidX(sender.frame);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [line setCenter:CGPointMake(cunX, CGRectGetHeight(self.frame)-itemH+0.5)];
        sender.selected = YES;
    } completion:nil];
    for (UIButton * view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            if (view !=sender) {
                view.selected = NO;
            }
        }
    }
    
    if ([_delegate respondsToSelector:@selector(segmentControll:selectItem:)]) {
        [_delegate segmentControll:self selectItem:sender.tag-10];
    }
}
-(void)setHideLine:(BOOL)hideLine{
    _hideLine = hideLine;
    line.hidden = YES;
}


@end
