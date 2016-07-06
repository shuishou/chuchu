//
//  QCReportVC.m
//  MyQOOCOO
//
//  Created by lanou on 16/1/28.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCReportVC.h"
@interface QCReportVC ()
{
    UITextView*textV;
}
@end
@implementation QCReportVC
-(void)viewWillAppear:(BOOL)animated
{
    //[super viewWillAppear:animated];// 1
    [textV becomeFirstResponder];// 2
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title=@"举报";
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIButton*leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.frame=CGRectMake(0, 0, 60, 40);
    leftBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [leftBtn setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(touchleftBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    //右侧按钮(自定义)
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    //    button.backgroundColor=[UIColor purpleColor];
    [button setTitle:@"提交" forState: UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0xed6664) forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 60, 30);
    button.titleLabel.font=[UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(reportUser) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];

    
    
    
    textV=[[UITextView alloc]initWithFrame:CGRectMake(10, 74, self.view.frame.size.width-20, 220)];
//    textV.delegate=self;
    textV.backgroundColor=[UIColor colorWithHexString:@"efefef"];
    textV.layer.borderWidth=0.5;
    textV.font=[UIFont systemFontOfSize:15];
    textV.layer.borderColor=[UIColor colorWithHexString:@"eaeaea"].CGColor;
    textV.layer.cornerRadius = 8;
    textV.keyboardType=UIKeyboardAppearanceDefault;
    textV.clipsToBounds = YES;
    [self.view addSubview:textV];
    
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
[textV resignFirstResponder];
}

-(void)touchleftBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)reportUser
{
    [textV resignFirstResponder];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"content"]=textV.text;
    dic[@"type"]=@(1);
    dic[@"destId"]=@(self.destId);
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:REPOT parameter:dic success:^(id response) {
        
        [MBProgressHUD hideHUD];
        [OMGToast showText:@"成功举报"];

        [self.navigationController popViewControllerAnimated:YES];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [MBProgressHUD hideHUD];
        [OMGToast showText:@"发送失败"];

    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
