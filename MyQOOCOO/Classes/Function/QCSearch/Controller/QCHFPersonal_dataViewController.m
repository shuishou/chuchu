//
//  QCHFPersonal_dataViewController.m
//  MyQOOCOO
//
//  Created by Wind on 15/12/3.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCHFPersonal_dataViewController.h"

@interface QCHFPersonal_dataViewController ()
{
    UITableView * tableview;
}
@end

@implementation QCHFPersonal_dataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initTableView];
}

- (void)initData
{
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"uid"] = self.Uid;
    
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:GETMARKGROUP parameter:dic success:^(id response) {
        
        if (!response) {
            return ;
        }
        
        
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        NSLog(@"错误%@", description);
    }];
}

- (void)initTableView
{
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view)) style:UITableViewStylePlain];
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
