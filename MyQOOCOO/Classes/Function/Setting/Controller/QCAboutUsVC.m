//
//  QCAboutUsVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/2.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCAboutUsVC.h"

@interface QCAboutUsVC ()

@end

@implementation QCAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAboutView];
}

- (void)initAboutView
{
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH(self.view) - (WIDTH(self.view)/3-10))/2, 64+20, WIDTH(self.view)/3-10, WIDTH(self.view)/3-10)];
    [imageview setImage:[UIImage imageNamed:@"ios-template-120"]];
    [self.view addSubview:imageview];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, MaxY(imageview)+16, WIDTH(self.view)-32, 10)];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    titleLabel.font = [UIFont systemFontOfSize:WIDTH(titleLabel)/22];
    titleLabel.text = @"出处有四大模块的内容, 自由工作、自由创业、自有实习、兴趣社交。""出处""源于生活, 又高于生活, 在我们的平台里有分享生活的人, 也有创造生活的人, 他们可以一边旅行一边接项目工作, 也可以身兼多职为多个公司工作, 给每一个有梦想有才华的人提供广阔舞台。英雄不问出处, 若你有才, 那请你来""出创意, 处朋友"", 召唤有个性的时代自由人。全新的工作方式, 让你的生活焕然一新, 我们渴望倾听群众生活心声, 实现就业、创业、创圈子的自由平台。";
    [titleLabel sizeToFit];
    [self.view addSubview:titleLabel];
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
