//
//  QCCursorButton.m
//  MyQOOCOO
//
//  Created by Zhou Shaolin on 16/7/9.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCCursorButton.h"

@implementation QCCursorButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init {
    self = [super init];
    if(self) {
        self.mainButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _mainButton.backgroundColor = [UIColor clearColor];
        self.mainImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"normalCurButton"] highlightedImage:[UIImage imageNamed:@"selectedCurButton"]];
        _mainImageView.clipsToBounds = YES;
        _mainImageView.contentMode = UIViewContentModeScaleAspectFit;

        self.separatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"curSep"]];
        _separatorImageView.clipsToBounds = YES;
        _separatorImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = _normalColor;
        [self addSubview:_mainButton];
        [self addSubview:_mainImageView];
        [self addSubview:_separatorImageView];
        [self addSubview:_titleLabel];
        [self bringSubviewToFront:_mainImageView];
    }
    return self;
}

-(void)adjustFrame:(CGRect)frame mode:(int)mode {
    self.frame = frame;
    if (_selected) {
        _mainImageView.highlighted = YES;
        _mainImageView.frame = CGRectMake(frame.size.width * 0.5 - 6.5, 7, 13, 13);
    }
    else {
        _mainImageView.highlighted = NO;
        _mainImageView.frame = CGRectMake(frame.size.width * 0.5 - 3.5, 10, 7, 7);
    }
    _titleLabel.frame = CGRectMake(0, 0.5 * frame.size.height + 5, frame.size.width, frame.size.height * 0.5 - 8);
    _mainButton.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    if (mode == 0) {
        _separatorImageView.frame = CGRectMake(0.5 * frame.size.width, 14, 0.5 * frame.size.width, 1);
    }
    else if(mode == 1) {
        _separatorImageView.frame = CGRectMake(0, 14, 0.5 * frame.size.width, 1);
    }
    else {
        _separatorImageView.frame = CGRectMake(0, 14, frame.size.width, 1);
    }
}

-(void)setSelected:(BOOL)select {
    _selected = select;
    if (_selected) {
        _mainImageView.highlighted = YES;
        _mainImageView.frame = CGRectMake(self.frame.size.width * 0.5 - 6.5, 7, 13, 13);
        if (_selectedColor) {
            _titleLabel.textColor = _selectedColor;
        }
    }
    else {
        _mainImageView.highlighted = NO;
        _mainImageView.frame = CGRectMake(self.frame.size.width * 0.5 - 3.5, 10, 7, 7);
        if (_normalColor) {
            _titleLabel.textColor = _normalColor;
        }
    }
}

-(void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    if (!_selected) {
        _titleLabel.textColor = normalColor;
    }
}

-(void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    if (_selected) {
        _titleLabel.textColor = selectedColor;
    }
}

-(instancetype)initWithTitle:(NSString*)title {
    self = [self init];
    if(self) {
        _titleLabel.text = title;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        if (_normalColor) {
            _titleLabel.textColor = _normalColor;
        }
        _titleLabel.textColor = UIColorFromRGB(0x505050);
    }
    return self;
}

@end
