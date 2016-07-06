//
//  QCTextVC.m
//  MyQOOCOO
//
//  Created by lanou on 16/1/10.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCTextVC.h"

@interface QCTextVC ()

@end

@implementation QCTextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"文字放大";
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UILabel*lb=[[UILabel alloc]initWithFrame:CGRectMake(40, self.view.frame.size.height/2-15, self.view.frame.size.width-80, 30)];
    lb.textAlignment=NSTextAlignmentCenter;
    lb.font=[UIFont systemFontOfSize:30];
    lb.text=self.str;
    [self.view addSubview:lb];
    
    
    // Do any additional setup after loading the view.
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
