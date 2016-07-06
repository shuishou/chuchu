//
//  QCTextView.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/21.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCTextView.h"

@interface QCTextView ()<UITextFieldDelegate>
@property (nonatomic,weak) UILabel *placeHolderLabel;

@end

@implementation QCTextView

#pragma mark - 自定义textField
/** 自定义的textField */
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加一个占位的label
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        [self addSubview:placeHolderLabel];
        self.placeHolderLabel = placeHolderLabel;
        // 显示多行
        self.placeHolderLabel.numberOfLines = 0;
        
        // 监听文本变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    
    return self;
}

-(void)textViewDidChange:(UITextView *)textView{
    [self textChange];
}

#pragma mark 系统的setFont方法
-(void)setFont:(UIFont *)font{
    [super setFont:font];
    self.placeHolderLabel.font = font;
}

#pragma 文本变化
-(void)textChange{
    self.placeHolderLabel.hidden = self.text.length > 0;
}
-(void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    self.placeHolderLabel.text = placeHolder;
}

-(void)setPlaceHolderColor:(UIColor *)placeHolderColor{
    _placeHolderColor = placeHolderColor;
    self.placeHolderLabel.textColor = placeHolderColor;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    // 设置placeHolderLabel frm
    CGFloat labelW =  self.width - 5;
    
    // 计算字体尺寸
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSFontAttributeName] = self.placeHolderLabel.font;
    CGSize placeHolderSize = [self.placeHolder boundingRectWithSize:CGSizeMake(labelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil].size;
    self.placeHolderLabel.frame = CGRectMake(5, 7, labelW, placeHolderSize.height);
}

-(void)dealloc{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
