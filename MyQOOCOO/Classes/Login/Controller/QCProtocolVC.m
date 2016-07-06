//
//  QCProtocolVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/7.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCProtocolVC.h"

@implementation QCProtocolVC
-(void)viewDidLoad{
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.qoocoo.net:8088/api/agreement/getAgreement"]]];
    self.view.backgroundColor = UIColorFromRGB(0xF1F1F1);
    self.navigationItem.title = @"注册协议";
    UIImage *leftImage = [UIImage imageNamed:@"Arrow"];
    leftImage = [leftImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backto)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    //文字内容
//    UILabel *content = [[UILabel alloc]init];
//    content.textColor = UIColorFromRGB(0x333333);
//    content.font = [UIFont systemFontOfSize:16];
//    content.text = @"Implements a read-only text view. A label can contain an arbitrary amount of text, but UILabel may shrink, wrap, or truncate the text, depending on the size of the bounding rectangle and properties you set. You can control the font, text color, alignment, highlighting, and shadowing of the text in the label.Implements a read-only text view. A label can contain an arbitrary amount of text, but UILabel may shary amount of text, but UILabel may shrink, wrap, or truncate the text, depending on the size of the bounding rectangle and properties you set. You can control the font, text color, alignment, highlighting, and shadowing of the text in the label.";
//    content.textAlignment = NSTextAlignmentLeft;
//    content.numberOfLines = 0;
//    //如何让文字从上往下去显示嗯?
////    content.textAlignment = UIControlContentVerticalAlignmentTop;
//    [self.view addSubview:content];
//    [content mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).offset(20);
//        make.left.equalTo(self.view.mas_left).offset(20);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
//        make.right.equalTo(self.view.mas_right).offset(-20);
//        
//    }];
//}
//
////返回

}
-(void)backto{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController.view removeFromSuperview];
}
@end
