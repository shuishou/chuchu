//
//  QCDanDiCommentToolBar.m
//  MyQOOCOO
//
//  Created by 贤荣 on 15/12/25.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCDanDiCommentToolBar.h"

@interface QCDanDiCommentToolBar ()

@property (weak, nonatomic) IBOutlet UIButton *DZBtn;
- (IBAction)DZBtnClick:(UIButton *)sender;

- (IBAction)sendBtnClick;

@property (nonatomic,assign) BOOL praise;

@end


@implementation QCDanDiCommentToolBar

+(instancetype)commentToolBar{
    return [[[NSBundle mainBundle]loadNibNamed:@"QCDanDiCommentToolBar" owner:nil options:nil]lastObject];
}


-(void)setDianDi:(QCDiandiListModel *)dianDi{
    _dianDi = dianDi;
    if (dianDi.hasPraise) {
        [self.DZBtn setImage:[UIImage imageNamed:@"but_clike_pre"] forState:UIControlStateNormal];
        self.praise = YES;
    }else{
        [self.DZBtn setImage:[UIImage imageNamed:@"but_clike"] forState:UIControlStateNormal];
        self.praise = NO;
    }
}

-(void)setLk:(QCLunkuListModel *)lk{
    _lk = lk;
    if (lk.hasPraise) {
        [self.DZBtn setImage:[UIImage imageNamed:@"but_clike_pre"] forState:UIControlStateNormal];
        self.praise = YES;
    }else{
        [self.DZBtn setImage:[UIImage imageNamed:@"but_clike"] forState:UIControlStateNormal];
        self.praise = NO;
    }
}

// 点赞
- (IBAction)DZBtnClick:(UIButton *)sender {
    self.praise = !self.praise;
    NSDictionary * parame;
    NSString * url;
    if (self.dianDi) {
        parame = @{@"recordId":@(self.dianDi.id)};
        url = RECORD_PRAISE;
    }else if (self.isFree){
         parame = @{@"forumId":@(self.lk.id)};
         url = FeeManPraise;
    }else{
         parame = @{@"forumId":@(self.lk.id)};
         url =FORUM_PRAISE;
    }
    
    [NetworkManager requestWithURL:url parameter:parame success:^(id response) {
        
        CZLog(@"%@",response);
        
        if (!self.praise) {
            [sender setImage:[UIImage imageNamed:@"but_clike"] forState:UIControlStateNormal];
        }else{
            [sender setImage:[UIImage imageNamed:@"but_clike_pre"] forState:UIControlStateNormal];
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
    }];
}

// 发送评论
- (IBAction)sendBtnClick {
    if ([self.delegate respondsToSelector:@selector(sendBtnClick)]) {
        [self.delegate sendBtnClick];
    }
}

@end
