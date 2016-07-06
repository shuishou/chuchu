//
//  QRcodeVC.m
//  MyQOOCOO
//
//  Created by lanou on 16/1/5.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QRcodeVC.h"
#import "User.h"

@interface QRcodeVC ()

@end

@implementation QRcodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"用户二维码";
    
    UIView*backV=[[UIView alloc]initWithFrame:CGRectMake(10, 84,self.view.width-20, self.view.height-104)];
    backV.backgroundColor=[UIColor whiteColor];
    backV.layer.cornerRadius=10;
    [self.view addSubview:backV];
    
    
     LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    
    
    UIImageView*imagev=[[UIImageView alloc]initWithFrame:CGRectMake(10, (backV.bounds.size.height-backV.bounds.size.width-20)/2,backV.bounds.size.width-20, backV.bounds.size.width-20)];
    
    
    NSString*str;
    
    if (_isType==NO) {
        //个人
        str=[NSString stringWithFormat:@"%ld",sessions.user.uid];
    }else{
        //群组
        //格式 "{\"type\":\"1\",\"id\":\"" + groupId + "\"}"
        NSDictionary * dict = @{@"type":@1,@"id":@"1000",@"groupId":self.groupId};
        NSData * data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"string:%@",str);
    }
    
    
    imagev.image = [QRCodeGenerator qrImageForString:str imageSize:imagev.bounds.size.width];
    [backV addSubview:imagev];
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
