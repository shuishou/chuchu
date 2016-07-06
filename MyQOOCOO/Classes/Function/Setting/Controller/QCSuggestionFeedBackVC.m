//
//  QCSuggestionFeedBackVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/2.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCSuggestionFeedBackVC.h"
#import "QCTextView.h"

@interface QCSuggestionFeedBackVC ()<UIAlertViewDelegate, UITextViewDelegate>
{
    QCTextView *_textView ;
}
@property (strong, nonatomic) NSString * contentStr;
@end

@implementation QCSuggestionFeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addBarBtnTitle:@"提交" target:self action:@selector(submitSuggetion:)];
    [self setupTextView];
    
    }
-(void)setupTextView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _textView = [[QCTextView alloc]initWithFrame:CGRectMake(0, 84, SCREEN_W, 194)];
    _textView.placeHolder = @"在这里输入意见反馈";
    _textView.placeHolderColor = [UIColor grayColor];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.alwaysBounceVertical = YES;
    _textView.delegate = self;
    [self.view addSubview:_textView];
    [self setupForDismissKeyboard];

}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0 && ![textView.text isEqualToString:@" "]) {
        _contentStr = textView.text;
    }
}

#pragma mark - 意见提交
-(void)submitSuggetion:(id)sender{
    
    if (_contentStr.length > 0) {
        CZLog(@"意见提交");
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"谢谢反馈" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else
    {
        [OMGToast showText:@"写点什么吧"];
    }
}
#pragma mark - alertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        [self initFeedBackData:_contentStr];
    }
    
}

- (void)initFeedBackData:(NSString *)content
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"content"] = content;
    
    [NetworkManager requestWithURL:FEEDBACKADD parameter:dic success:^(id response) {
        CZLog( @"%@", response);
        if (response) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
//            [OMGToast showText:@"数据加载错误"];
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
}

@end
