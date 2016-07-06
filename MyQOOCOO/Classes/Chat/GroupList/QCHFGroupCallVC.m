//
//  QCHFGroupCallVC.m
//  MyQOOCOO
//
//  Created by Wind on 15/12/5.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCHFGroupCallVC.h"
#import "NYSegmentedControl.h"

@interface QCHFGroupCallVC ()
{
    NYSegmentedControl *foursquareSegmentedControl;
}
@property (nonatomic, strong) NYSegmentedControl *four;
@property (nonatomic, weak) UIButton *button;
@end

@implementation QCHFGroupCallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initBar];
    [self initVC];
}


- (void)initBar{
    
    self.view.backgroundColor = [UIColor clearColor];
    UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, WIDTH(self.view), WIDTH(self.view)/8)];
    imageV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageV];
    
    foursquareSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"群聊组", @"讨论组"]];
    self.four = foursquareSegmentedControl;
    foursquareSegmentedControl.titleTextColor = kLoginbackgoundColor;
    foursquareSegmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    foursquareSegmentedControl.segmentIndicatorBackgroundColor = kLoginbackgoundColor;
    foursquareSegmentedControl.backgroundColor = [UIColor whiteColor];
    foursquareSegmentedControl.borderWidth = 1.5f;
    foursquareSegmentedControl.segmentIndicatorBorderWidth = 1.5f;
    foursquareSegmentedControl.segmentIndicatorBorderColor = [UIColor whiteColor];
    [foursquareSegmentedControl sizeToFit];
    //    foursquareSegmentedControl.cornerRadius = CGRectGetHeight(foursquareSegmentedControl.frame) / 2.0f;
    foursquareSegmentedControl.usesSpringAnimations = YES;
    [foursquareSegmentedControl setDataSource:(id<NYSegmentedControlDataSource>)self];
    [foursquareSegmentedControl addTarget:self action:@selector(ChangeVC:) forControlEvents:UIControlEventValueChanged];
    foursquareSegmentedControl.frame =CGRectMake(0, 64, self.view.bounds.size.width-2, WIDTH(self.view)/8);
    foursquareSegmentedControl.layer.cornerRadius = 5;
    foursquareSegmentedControl.layer.borderWidth = 0.5;
    foursquareSegmentedControl.layer.borderColor = kLoginbackgoundColor.CGColor;
    [self.view addSubview:foursquareSegmentedControl];
    
    // Add the control to your view
    //    self.navigationItem.titleView = foursquareSegmentedControl;
    
    
}



-(void)ChangeVC:(id)sender{
    NYSegmentedControl *control=(NYSegmentedControl*)sender;
    switch (control.selectedSegmentIndex) {
        case 0:
            [self.view bringSubviewToFront:self.qunZuListVc.view];
            [self.view bringSubviewToFront:self.button];
            break;
        case 1:
            [self.view bringSubviewToFront:self.taoLunZuListVc.view];
            [self.view bringSubviewToFront:self.button];
            break;
        default:
            break;
    }
}
-(void)initVC{
    self.qunZuListVc = [[QCQunZuTVC alloc]init];
    self.taoLunZuListVc = [[QCTaoLunZuTVC alloc]init];
    
    
    [self addChildViewController:self.qunZuListVc];
    [self addChildViewController:self.taoLunZuListVc];
    
    
    [self.view addSubview:self.qunZuListVc.view];
    [self.view addSubview:self.taoLunZuListVc.view];
    
    
    CGRect rect = self.view.bounds;
    rect.origin.y +=64+HEIGHT(foursquareSegmentedControl);
    rect.size.height -= 64+HEIGHT(foursquareSegmentedControl);
    
    NSLog(@"%f", rect.size.height);
    self.qunZuListVc.view.frame=self.taoLunZuListVc.view.frame=rect;
    
    [self.view bringSubviewToFront:self.qunZuListVc.view];
    
    
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
