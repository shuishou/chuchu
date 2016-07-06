//
//  QCAddRixingVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/29.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCAddRixingVC.h"

@interface QCAddRixingVC ()<UITextFieldDelegate>
{
    NSString * name;
}
@end

@implementation QCAddRixingVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255  blue:241.0/255  alpha:1];
    [self initViews];
    
    UIBarButtonItem * doneBar =[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = doneBar;
    
    UITapGestureRecognizer * taps =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyBroad:)];
    [self.view addGestureRecognizer:taps];
}

- (void)keyBroad:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (void)done:(UIBarButtonItem *)bar
{
    [self.view endEditing:YES];
    
    if (name.length > 0 &&  ![name isEqualToString:@" "]) {
        
        if (name.length > 1 && name.length < 5) {
            [self initAddDayLog:name];
        }
        else
        {
            [OMGToast showText:@"请限制内容为二至四个字"];
        }
        
    }
    else
    {
        [OMGToast showText:@"请输入日省项"];
    }
    
}

- (void)initAddDayLog:(NSString *)title
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"title"] = title;
    
    [MBProgressHUD showMessage:nil background:YES];
    [NetworkManager requestWithURL:ADDDAYLOG parameter:dic success:^(id response) {
        CZLog(@"%@", response);
        
        [MBProgressHUD hideHUD];
        [OMGToast showText:@"添加成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}

- (void)initViews
{
    UIView * views = [[UIView alloc] initWithFrame:CGRectMake(0, 80, WIDTH(self.view), WIDTH(self.view)/10)];
    views.backgroundColor = [UIColor whiteColor];
    
    UITextField * field = [[UITextField alloc] initWithFrame:CGRectMake(8, 0, WIDTH(views)-16, HEIGHT(views))];
    field.backgroundColor = [UIColor clearColor];
    field.placeholder = @"输入日省项";
    field.delegate = self;
    [field setFont:[UIFont systemFontOfSize:HEIGHT(field)*2/5]];
    [field setTextColor:[UIColor colorWithHexString:@"333333"]];
    [field addTarget:self action:@selector(addDaylogName:) forControlEvents:UIControlEventEditingChanged];
    [views addSubview:field];
    [self.view addSubview:views];
}

- (void)addDaylogName:(UITextField *)textFiled
{
    name = textFiled.text;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField isFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
