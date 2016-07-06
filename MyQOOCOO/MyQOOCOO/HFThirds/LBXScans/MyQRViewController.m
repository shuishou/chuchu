//
//  MyQRViewController.m
//  LBXScanDemo
//
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "MyQRViewController.h"
#import "LBXScanWrapper.h"
#import "LBXAlertAction.h"

@interface MyQRViewController ()

//二维码
@property (nonatomic, strong) UIView *qrView;
@property (nonatomic, strong) UIImageView* qrImgView;

//条形码
@property (nonatomic, strong) UIView *tView;
@property (nonatomic, strong) UIImageView *tImgView;


@end

@implementation MyQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    
    self.view.backgroundColor = [UIColor colorWithHexString:@"E0E0E0"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIView * backgView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, self.view.frame.size.width-20, self.view.frame.size.height-40)];
    backgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgView];
    
    //二维码
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake( (CGRectGetWidth(self.view.frame)-CGRectGetWidth(self.view.frame)*5/8)/2, (CGRectGetHeight(self.view.frame)-CGRectGetWidth(self.view.frame)*5/8)/2, CGRectGetWidth(self.view.frame)*5/8, CGRectGetWidth(self.view.frame)*5/8)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.shadowOffset = CGSizeMake(0, 2);
    view.layer.shadowRadius = 2;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.5;
    
    
    self.qrImgView = [[UIImageView alloc]init];
    _qrImgView.bounds = CGRectMake(0, 0, CGRectGetWidth(view.frame)-12, CGRectGetWidth(view.frame)-12);
    _qrImgView.center = CGPointMake(CGRectGetWidth(view.frame)/2, CGRectGetHeight(view.frame)/2);
    [view addSubview:_qrImgView];
    self.qrView = view;
    
    
    [self createQR1];
    
}


- (void)createQR1
{
    _qrView.hidden = NO;
    _tView.hidden = YES;
    
     UIImage *qrImg = [LBXScanWrapper createQRWithString:self.QRString size:_qrImgView.bounds.size];
    
//    UIImage *logoImg = [UIImage imageNamed:@"logo.JPG"];
    
    _qrImgView.image = [LBXScanWrapper addImageLogo:qrImg centerLogoImage:nil logoSize:CGSizeMake(0, 0)];
    
}

- (void)createQR2
{
    _qrView.hidden = NO;
    _tView.hidden = YES;
    
    UIImage *image = [LBXScanWrapper createQRWithString:@"lbxia20091227@foxmail.com" size:_qrImgView.bounds.size];
    //二维码上色
    _qrImgView.image = [LBXScanWrapper imageBlackToTransparent:image withRed:255.0f andGreen:74.0f andBlue:89.0f];
    
}

- (void)createQR3
{
    _qrView.hidden = NO;
    _tView.hidden = YES;
    
    //生成的不好识别，自己去调好颜色应该就可以识别了
    _qrImgView.image = [LBXScanWrapper createQRWithString:@"lbxia20091227@foxmail.com"
                                                 QRSize:_qrImgView.bounds.size
                                                QRColor:[UIColor colorWithRed:200./255. green:84./255. blue:40./255 alpha:1.0]
                                                bkColor:[UIColor colorWithRed:41./255. green:130./255. blue:45./255. alpha:1.0]];
}

//商品条形码
- (void)createCodeEAN13
{
    _qrView.hidden = YES;
    _tView.hidden = NO;
    
    _tImgView.image = [LBXScanWrapper createCodeWithString:@"6944551723107" size:_qrImgView.bounds.size CodeFomart:AVMetadataObjectTypeEAN13Code];
}

- (void)createCode93
{
    _qrView.hidden = YES;
    _tView.hidden = NO;
    
    //支付宝付款码-条款码
    _tImgView.image = [LBXScanWrapper createCodeWithString:@"283657461695996598" size:_qrImgView.bounds.size CodeFomart:AVMetadataObjectTypeCode128Code];
}



@end
