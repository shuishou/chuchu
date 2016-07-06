//
//  QCTag.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/11.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCTag.h"

@implementation QCTag{
    UIButton *_deleteButton;
}
- (instancetype)initWithFrame:(CGRect)frame qcTag:(NSString *)qcTag{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:.5];
        //标题
        [self setTitle:qcTag forState:UIControlStateNormal];
        [self setTitleColor:RandomColor forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:rand()%3+15];
        //frame
        CGSize contentSize = [qcTag boundingRectWithSize:CGSizeMake(SCREEN_W, self.titleLabel.font.pointSize) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.titleLabel.font,NSFontAttributeName, nil] context:nil].size;
        self.size = CGSizeMake(contentSize.width+24, contentSize.height+15);
        self.layer.cornerRadius = 5;
        
        UILongPressGestureRecognizer * longRress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longRress];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_deleteButton setTitle:@"X" forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(CGRectGetWidth(self.frame)-5, -5, 10, 10);
        _deleteButton.hidden = YES;
        [_deleteButton addTarget:self action:@selector(deleteSelf) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        
    }
    return self;
}
-(void)longPress:(UILongPressGestureRecognizer *)sender{
    
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    _deleteButton.hidden = NO;
    
    if ([self.delegate respondsToSelector:@selector(tagView:longPressIndex:)]) {
        [self.delegate tagView:self longPressIndex:self.tag];
    }
}
-(void)deleteSelf{
    if ([self.delegate respondsToSelector:@selector(tagView:deleteTagView:)]) {
        [self.delegate tagView:self deleteTagView:self.tag];
    }
}
-(void)showDelegateButton:(BOOL)isShow{
    _deleteButton.hidden = !isShow;
}
@end
