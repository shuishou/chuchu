//
//  QCCommentToolBar.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/28.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#define kBorderWidth 12
#define kBorderHeight 8.5
#define kButtonWidth 32
#define kTextViewHeight 33

#import "QCCommentToolBar.h"
#import "QCDoodleStatus.h"

@interface QCCommentToolBar ()
@property (nonatomic,assign) BOOL praise;
@property (nonatomic,assign) BOOL press;

@end



@implementation QCCommentToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self initSubViews];//把
    }
    return self;
}

-(void)initSubViews{
    //赞
    _agreeBtn = [self setupWithNormalIcon:@"but_clike"];
    [_agreeBtn addTarget:self action:@selector(dianZanClick:) forControlEvents:UIControlEventTouchUpInside];
    //黑
    _disagreeBtn = [self setupWithNormalIcon:@"but_cdislike"];
    [_disagreeBtn addTarget:self action:@selector(dianHeiClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    输入框
    _textField = [[UITextField alloc]init];
    _textField.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    _textField.layer.cornerRadius =  8;
    _textField.clipsToBounds = YES;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftView = [[UIView alloc] init];
    leftView.bounds = CGRectMake(0, 0, 10, 0);
    _textField.leftView  = leftView;
    [self addSubview:_textField];
}
-(UIButton *)setupWithNormalIcon:(NSString *)normalIcon{
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:normalIcon] forState:UIControlStateNormal];
    [self addSubview:btn];
    return btn;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _agreeBtn.frame = CGRectMake(kBorderWidth,kBorderHeight, kButtonWidth, kButtonWidth);
    CGFloat disagreeBtnX = CGRectGetMaxX(_agreeBtn.frame);
    _disagreeBtn.frame = CGRectMake(disagreeBtnX + kBorderWidth, kBorderHeight, kButtonWidth, kButtonWidth);
    CGFloat textViewX = CGRectGetMaxX(_disagreeBtn.frame);
    _textField.frame = CGRectMake(textViewX + kBorderWidth, kBorderHeight, SCREEN_W - kBorderWidth * 2 -textViewX, kTextViewHeight);
}

#pragma mark - 点赞
-(void)dianZanClick:(UIButton *)sender{

    if (self.press) {
        return;
    }
    self.praise = !self.praise;
    NSDictionary *parameters = @{@"topicId":@(self.yellModel.id), @"type":@1};
    [NetworkManager requestWithURL:TOPIC_PRAISE_URL parameter:parameters success:^(id response) {
        
        if (!self.praise) {
            [sender setImage:[UIImage imageNamed:@"but_clike"] forState:UIControlStateNormal];
        }else{
            [sender setImage:[UIImage imageNamed:@"but_clike_pre"] forState:UIControlStateNormal];
        }
//        
//        qcStatus.hasPraise = !qcStatus.hasPraise;
//        NSString *fav = qcStatus.hasPraise ? @"点赞成功":@"取消点赞";
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        
    } ];

}

#pragma mark - 点黑
-(void)dianHeiClick:(UIButton *)sender{
    
    if (self.praise) {
        return;
    }
    self.press = !self.press;
    NSDictionary *parameters = @{@"topicId":@(self.yellModel.id), @"type":@0};
    [NetworkManager requestWithURL:TOPIC_PRAISE_URL parameter:parameters success:^(id response) {
        
        if (!self.press) {
            [sender setImage:[UIImage imageNamed:@"but_cdislike"] forState:UIControlStateNormal];
        }else{
            [sender setImage:[UIImage imageNamed:@"but_cdislike_pre"] forState:UIControlStateNormal];
        }
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        
    } ];
}

#pragma mark - 赋值给status
-(void)setQcStatus:(QCDoodleStatus *)qcStatus{
    _qcStatus = qcStatus;
    
    if (qcStatus.hasPraise) {
       [_agreeBtn setImage:[UIImage imageNamed:@"but_clike_pre"] forState:UIControlStateNormal];
        self.praise = YES;
    }
    
    if (qcStatus.hasPress) {
         [_disagreeBtn setImage:[UIImage imageNamed:@"but_cdislike_pre"] forState:UIControlStateNormal];
        self.press = YES;
    }
}

#pragma mark - 赋值给status
-(void)setYellModel:(QCYellModel *)yellModel{
    _yellModel = yellModel;
    
    if (yellModel.hasPraise) {
        [_agreeBtn setImage:[UIImage imageNamed:@"but_clike_pre"] forState:UIControlStateNormal];
        self.praise = YES;
    }
    
    if (yellModel.hasPress) {
        [_disagreeBtn setImage:[UIImage imageNamed:@"but_cdislike_pre"] forState:UIControlStateNormal];
        self.press= YES;
    }
}

@end
