//
//  QCDoodleVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/20.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCDoodleVC.h"
#import "QCTextView.h"
#import "QCDrawView.h"

#define MAX_LIMIT_NUMS 50

@interface QCDoodleVC ()<UITextViewDelegate>{
    UIView *_backgroundView;
    UIButton *_brushBtn;
    UIButton *_rubberBtn;
}

@end

@implementation QCDoodleVC

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView == _contentField) {
        NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
        NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
        if (caninputlen >= 0){
            
        }else{
            NSInteger len = text.length + caninputlen;
            //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
            NSRange rg = {0,MAX(len,0)};
            if (rg.length > 0)
            {
                NSString *s = [text substringWithRange:rg];
                [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            }
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == _contentField) {
        NSString  *nsTextContent = textView.text;
        NSInteger existTextNum = nsTextContent.length;
        
        if (existTextNum > MAX_LIMIT_NUMS)
        {
            //截取到最大位置的字符
            NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
            [textView setText:s];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackgroundView];
}

-(void)setupBackgroundView{
    _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(12, 12, SCREEN_W - 24, SCREEN_H - 119)];
    _backgroundView.backgroundColor = [UIColor whiteColor];
    _backgroundView.layer.cornerRadius = 10;
    [self.view addSubview:_backgroundView];
    [self setupSubviews];
    [self brushBtnClick:_brushBtn];
}


-(void)setupSubviews{
    //内容输入框
    _contentField = [[QCTextView alloc]initWithFrame:CGRectMake(12, 16, _backgroundView.width -24, 44)];
    _contentField.backgroundColor = kGlobalBackGroundColor;
    _contentField.placeHolder = @"发泄你心中的不快";
    _contentField.placeHolderColor = [UIColor grayColor];
    _contentField.font = [UIFont systemFontOfSize:15];
    _contentField.layer.cornerRadius = 5;
    _contentField.delegate = self;
    _contentField.alwaysBounceVertical = YES;
    _contentField.returnKeyType = UIReturnKeyDefault;
    _contentField.enablesReturnKeyAutomatically = YES;
    
    [_backgroundView addSubview:_contentField];
    [self setupForDismissKeyboard];
    
    //画板
    _drawView = [[QCDrawView alloc]initWithFrame:CGRectMake(0, 60, _backgroundView.width, _backgroundView.height - 60)];
    _drawView.backgroundColor = [UIColor whiteColor];
    _drawView.layer.borderColor = UIColorFromRGB(0xF1F1F1).CGColor;
    _drawView.layer.cornerRadius = 5;
    _drawView.layer.borderWidth = .5;
    
    [_backgroundView addSubview:_drawView];
    
    //橡皮擦
    _rubberBtn = [[UIButton alloc]init];
    [_rubberBtn setImage:[UIImage imageNamed:@"but_rubber"] forState:UIControlStateNormal];
    [_backgroundView addSubview:_rubberBtn];
    [_rubberBtn addTarget:self action:@selector(rubberBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rubberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(39,39));
        make.right.equalTo(_backgroundView.mas_right).offset(-16);
        make.bottom.equalTo(_backgroundView.mas_bottom).offset(-16);
    }];
    //画笔
    _brushBtn = [[UIButton alloc]init];
    [_brushBtn setImage:[UIImage imageNamed:@"but_pen"] forState:UIControlStateNormal];
    [_backgroundView addSubview:_brushBtn];
    [_brushBtn addTarget:self action:@selector(brushBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_brushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(39,39));
        make.right.equalTo(_rubberBtn.mas_left).offset(-16);
        make.bottom.equalTo(_rubberBtn.mas_bottom).offset(-0);
    }];
    
}

#pragma mark - 橡皮擦
-(void)rubberBtnClick:(UIButton*)btn{
   [btn setImage:[UIImage imageNamed:@"faxiequan_xpc_btn"] forState:UIControlStateNormal];
   [_brushBtn setImage:[UIImage imageNamed:@"but_pen"] forState:UIControlStateNormal];
   [_drawView setDrawingMode:DrawingModeErase];

}
#pragma mark - 画笔
-(void)brushBtnClick:(UIButton*)btn{
       [btn setImage:[UIImage imageNamed:@"faxiequan_hb_btn"] forState:UIControlStateNormal];
        [_rubberBtn setImage:[UIImage imageNamed:@"but_rubber"] forState:UIControlStateNormal];
      [_drawView setDrawingMode:DrawingModePaint];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_contentField resignFirstResponder];
}
@end
