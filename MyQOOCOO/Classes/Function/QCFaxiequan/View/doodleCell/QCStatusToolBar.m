
//  QCToolBar.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/20.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCStatusToolBar.h"
#import "QCDoodleStatus.h"


@interface QCStatusToolBar(){
    UIButton *_agreeBtn;
    UIButton *_disgreeBtn;
    UIButton *_commentBtn;
}
@property (nonatomic , strong)NSMutableArray *btns;

@property (nonatomic,assign) BOOL praise;
@property (nonatomic,assign) BOOL press;

@end

@implementation QCStatusToolBar

-(NSMutableArray *)btns{
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return  _btns;
}
+(instancetype)toolBar{
    return [[self alloc] init];
}
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
       //点赞
        _agreeBtn = [self setupBtnTitle:@"0" normalIcon:@"but_like"];
        [_agreeBtn addTarget:self action:@selector(dianZan:) forControlEvents:UIControlEventTouchUpInside];
        //点黑
        _disgreeBtn = [self setupBtnTitle:@"0" normalIcon:@"but_dislike"];
        [_disgreeBtn addTarget:self action:@selector(dianHei:) forControlEvents:UIControlEventTouchUpInside];
        //评论
        _commentBtn = [self setupBtnTitle:@"0" normalIcon:@"but_eva"];
        [_commentBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (UIButton *)setupBtnTitle:(NSString *)title normalIcon:(NSString *)normalIcon
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:normalIcon] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:btn];
    [self.btns addObject:btn];
    return btn;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    NSUInteger btnCount = self.btns.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i<btnCount; i++) {
        UIButton *btn = self.btns[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
}
-(void)setQcStatus:(QCDoodleStatus *)qcStatus{
    _qcStatus = qcStatus;
    
    if (qcStatus.hasPraise) {
        [_agreeBtn setImage:[UIImage imageNamed:@"but_like_pre"] forState:UIControlStateNormal];
        self.praise = YES;
    }else{
        [_agreeBtn setImage:[UIImage imageNamed:@"but_like"] forState:UIControlStateNormal];
         self.praise = NO;
    
    }
    
    if (qcStatus.hasPress) {
        [_disgreeBtn setImage:[UIImage imageNamed:@"but_dislike_pre"] forState:UIControlStateNormal];
        self.press = YES;
    }else{
        [_disgreeBtn setImage:[UIImage imageNamed:@"but_dislike"] forState:UIControlStateNormal];
        self.press = NO;

    
    }
  
    [self setupBtnCount:qcStatus.praiseCount btn:_agreeBtn title:@"0"];
    [self setupBtnCount:qcStatus.pressCount btn:_disgreeBtn title:@"0"];
    [self setupBtnCount:qcStatus.commentCount btn:_commentBtn title:@"0"];
}

- (void)setupBtnCount:(int)count btn:(UIButton *)btn title:(NSString *)title
{
    if (count) { // 数字不为0
        if (count < 10000) { // 不足10000：直接显示数字，比如786、7986
            title = [NSString stringWithFormat:@"%d", count];
        } else { // 达到10000：显示xx.x万，不要有.0的情况
            double wan = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万", wan];
            // 将字符串里面的.0去掉
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
    }
    [btn setTitle:title forState:UIControlStateNormal];
}


#pragma mark - 点赞
-(void)dianZan:(UIButton *)sender{

    if (self.press) {
        return;
    }
    self.praise = !self.praise;
    NSDictionary *parameters = @{@"topicId":@(self.qcStatus.id), @"type":@1};
    [NetworkManager requestWithURL:TOPIC_PRAISE_URL parameter:parameters success:^(id response) {
        self.qcStatus.hasPraise=[response[@"hasPraise"] boolValue];
        self.qcStatus.praiseCount=[response[@"praiseCount"] integerValue];

        if (!self.qcStatus.hasPraise) {
            [sender setImage:[UIImage imageNamed:@"but_like"] forState:UIControlStateNormal];
            if (self.qcStatus.praiseCount==0) {
                [sender setTitle:@"0" forState:UIControlStateNormal];
            }else{
                 [sender setTitle:[NSString stringWithFormat:@"%d",self.qcStatus.praiseCount] forState:UIControlStateNormal];
            }
        }else{
            [sender setImage:[UIImage imageNamed:@"but_like_pre"] forState:UIControlStateNormal];
            [sender setTitle:[NSString stringWithFormat:@"%d",self.qcStatus.praiseCount ] forState:UIControlStateNormal];
        }

    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        
    } ];
}

#pragma mark - 点黑
-(void)dianHei:(UIButton *)sender{
    
    if (self.praise) {
        return;
    }
    self.press = !self.press;
    NSDictionary *parameters = @{@"topicId":@(self.qcStatus.id), @"type":@0};
    [NetworkManager requestWithURL:TOPIC_PRAISE_URL parameter:parameters success:^(id response) {
        self.qcStatus.hasPress=[response[@"hasPress"] boolValue];
        self.qcStatus.pressCount=[response[@"pressCount"] integerValue];
        if (!self.qcStatus.hasPress) {
            [sender setImage:[UIImage imageNamed:@"but_dislike"] forState:UIControlStateNormal];
            if (self.qcStatus.pressCount==0) {
                [sender setTitle:@"0" forState:UIControlStateNormal];
            }else{
                [sender setTitle:[NSString stringWithFormat:@"%d",self.qcStatus.pressCount] forState:UIControlStateNormal];
            }
        }else{
            [sender setImage:[UIImage imageNamed:@"but_dislike_pre"] forState:UIControlStateNormal];
            [sender setTitle:[NSString stringWithFormat:@"%d",self.qcStatus.pressCount ] forState:UIControlStateNormal];
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        
    } ];
}


-(void)commentClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(selfCommentBtnClick)]) {
        [self.delegate selfCommentBtnClick];
    };
    
}

@end
