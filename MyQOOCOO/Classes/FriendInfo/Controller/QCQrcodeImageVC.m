//
//  QCQrcodeImageVC.m
//  MyQOOCOO
//
//  Created by kunge on 16/4/7.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCQrcodeImageVC.h"
#import "NSCreateCode.h"
@interface QCQrcodeImageVC ()


@property(nonatomic,strong)UIImageView *qrcodeImage;

@end

@implementation QCQrcodeImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = @"用户二维码";
    
    [self performSelector:@selector(showQrcodeImage) withObject:self afterDelay:0.5];
    
}

-(void)showQrcodeImage{
    self.qrcodeImage.image = [NSCreateCode createCode:self.uid size:self.qrcodeImage.frame.size.height];
}

-(UIImageView *)qrcodeImage{
    if (_qrcodeImage == nil) {
        _qrcodeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
        _qrcodeImage.center = self.view.center;
        [self.view addSubview:_qrcodeImage];
    }
    return _qrcodeImage;
}

@end
