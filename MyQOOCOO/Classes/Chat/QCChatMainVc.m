//
//  QCChatMainVc.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/31.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCChatMainVc.h"
#import "QCChatView.h"
//segment
#import "QCCustomSegmentControl.h"
#import "PopViewController.h"
#import "QCHFAdvancedSearchViewController.h"

//add
#import "QCFriendMainVC.h"
#import "QCSearchViewController.h"
#import "QCShakeViewController.h"
#import "QCScanViewController.h"
#import "QCEncounterViewController.h"
#import "QCStarViewController.h"
#import "QCSingleTVC.h"
#import "QCGroupListVC.h"

#import "QCLoginVC.h"

#import "QCNewSearchVC.h"

#import "MyQRViewController.h"
#import "LBXScanView.h"
#import <objc/message.h>
@interface QCChatMainVc()<QCSegmentControlDelegate,UITableViewDataSource,UITableViewDelegate>
{
    QCCustomSegmentControl *_segmentControl;
    QCChatListVC *_chatVc;
    QCFriendMainVC *_groupVc;
    QCBaseVC *_currentVc;
    NSInteger _selectedIndex;
    //右键弹框选择
    PopViewController *_popVC;
    UITableView *_addTableView;
    
    
}
@end

@implementation QCChatMainVc


-(void)loadView{
    self.view = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LoginSession *session = [[ApplicationContext sharedInstance] getLoginSession];
    if (![session isValidate]) {
        QCLoginVC *loginVC = [[QCLoginVC alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    //标题
    //初始化右边按钮
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addBarBtnImg:@"add3" highlightedImg:@"add3" target:self action:@selector(addMore:)];
    
    
    UIView*topv=[[UIView alloc]init];
    topv.frame=CGRectMake(0, 0, 88, 44);
//    topv.backgroundColor=[UIColor redColor];
    
    
    
    UIButton *btns = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *normalImgs = [UIImage imageNamed:@"icon_sousuo"];
    
    [btns setImage:normalImgs forState:UIControlStateNormal];
    [btns setImage:[UIImage imageNamed:@"icon_sousuo"] forState:UIControlStateHighlighted];
    
    btns.frame = CGRectMake(topv.frame.size.width/2-44, (topv.frame.size.height-44)/2,44, 44);
    [btns addTarget:self action:@selector(searchMarkUser:) forControlEvents:UIControlEventTouchUpInside];
    
    [topv addSubview:btns];
    
    UIButton *btns2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *normalImgs2 = [UIImage imageNamed:@"add3"];
    
    [btns2 setImage:normalImgs2 forState:UIControlStateNormal];
    [btns2 setImage:[UIImage imageNamed:@"add3"] forState:UIControlStateHighlighted];
    
    btns2.frame = CGRectMake(topv.frame.size.width/2, (topv.frame.size.height-44)/2, 44, 44);
    [btns2 addTarget:self action:@selector(addMore:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [topv addSubview:btns2];
    
    
    UIBarButtonItem *segmentBtn = [[UIBarButtonItem alloc]initWithCustomView:topv];
    self.navigationItem.rightBarButtonItem = segmentBtn;

    
    
    
    
     //自定义导航栏左边的segment
    [self customSegmented];
    
    //添加自控制器
    [self setupChildVC];
    
    CZLog(@"%@", NSHomeDirectory());

    
}


//添加两个控制器在主控制器上面
-(void)setupChildVC{
    
    if (!_chatVc) {
        _chatVc = [[QCChatListVC alloc]init];
        _chatVc.view.frame = CGRectMake(0, 64, SCREEN_W, SCREEN_H-64-44);
        [self addChildViewController:_chatVc];
        
    }
    if (!_groupVc) {
        _groupVc = [[QCFriendMainVC alloc]initWithType:kFriendGroupTpyeNormal];
        _groupVc.view.frame = CGRectMake(0, 64, SCREEN_W, SCREEN_H-64-44);
        [self addChildViewController:_groupVc];
    }
    [self.view addSubview:_chatVc.view];
    [_chatVc didMoveToParentViewController:self];
    _currentVc = _chatVc;
    
    
}

#pragma mark - 实现segment的点击跳转功能
-(void)segmented:(UIView *)btn selectedFrom:(NSInteger)from to:(NSInteger)to{
    if (_popVC.show) {
        [_popVC dismiss];
    }
    _selectedIndex = to;
    if (_selectedIndex == 0) {
        
        if (_currentVc!=_chatVc) {
            [self transitionFromViewController:_currentVc toViewController:_chatVc duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:nil];
            _currentVc = _chatVc;
        }
        
    }else{
        if (_currentVc != _groupVc) {
            [self transitionFromViewController:_currentVc toViewController:_groupVc duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:nil];
            _currentVc = _groupVc;
        }
    }
    
    
}
-(void)customSegmented{
    QCCustomSegmentControl *qcSegment = [[QCCustomSegmentControl alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
//    qcSegment.backgroundColor=[UIColor greenColor];

    qcSegment.delegate = self;
    
    UIBarButtonItem *segmentBtn = [[UIBarButtonItem alloc]initWithCustomView:qcSegment];
    self.navigationItem.leftBarButtonItem = segmentBtn;
}

- (void)searchMarkUser:(UIBarButtonItem *)bar
{
    if (_popVC.show) {
        [_popVC dismiss];
    }
    
    QCNewSearchVC * vc = [[QCNewSearchVC alloc] init];
    vc.title=@"推荐搜索";
    [self.navigationController pushViewController:vc animated:YES];
}

//右键弹出选中框
-(void)addMore:(UIButton *)btn{
    if (!_popVC) {
        _popVC = [[PopViewController alloc] initWithItems:@[@"发起群聊",@"摇一摇",@"扫一扫",@"偶遇",@"潮星",@"单身",@"一起按"]];
    }
    
    if (_popVC.show) {
        [_popVC dismiss];
    }else{
        [_popVC showInView:self.view selectedIndex:^(NSInteger selectedIndex) {
            //
            switch (selectedIndex) {
                case 0:{
                    
                    QCGroupListVC * creatGroupChat = [[QCGroupListVC alloc] init];
                    creatGroupChat.hidesBottomBarWhenPushed = YES;
                    creatGroupChat.title = @"发起群聊";
                    creatGroupChat.isQunLiao = @1;
                    [self.navigationController pushViewController:creatGroupChat animated:YES];
                }
                    break;
                case 1:{
                    QCShakeViewController * shake = [[QCShakeViewController alloc] init];
                    shake.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:shake animated:YES];
                }
                    break;
                case 2:{
                    [self weixinStyle];
                }
                    break;
                case 3:{
                    QCEncounterViewController * encounter = [[QCEncounterViewController alloc] init];
                    [self.navigationController pushViewController:encounter animated:YES];
                }
                    break;
                case 4:{
                    QCStarViewController * star = [[QCStarViewController alloc]init];
                    [self.navigationController pushViewController:star animated:YES];
                }
                    break;
                case 5:{
                    QCSingleTVC * single = [[QCSingleTVC alloc] init];
                    [self.navigationController pushViewController:single animated:YES];
                }
                    break;
                case 6:{
                    QCSearchViewController *seachVc =  [[QCSearchViewController alloc]init];
                    [self.navigationController pushViewController:seachVc animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }];
    }
}


- (void)weixinStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 18;
    style.photoframeAngleH = 18;
    style.isNeedShowRetangle = YES;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    style.colorAngle = [UIColor whiteColor];
    
    
    //qq里面的线条图片
    UIImage *imgLine = [UIImage imageNamed:@"椭圆-1"];
    
    // imgLine = [self createImageWithColor:[UIColor colorWithRed:120/255. green:221/255. blue:71/255. alpha:1.0]];
    
    style.animationImage = imgLine;
    
    
    
    
    [self openScanVCWithStyle:style];
}

#pragma mark -非正方形，可以用在扫码条形码界面

- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


- (void)notSquare
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 4;
    style.photoframeAngleW = 28;
    style.photoframeAngleH = 16;
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_LineStill;
    
    
    style.animationImage = [self createImageWithColor:[UIColor redColor]];
    //非正方形
    //设置矩形宽高比
    style.whRatio = 4.3/2.18;
    
    //离左边和右边距离
    style.xScanRetangleOffset = 30;
    
    
    [self openScanVCWithStyle:style];
}

- (void)myQR
{
    MyQRViewController *vc = [[MyQRViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    QCScanViewController *vc = [QCScanViewController new];
    vc.style = style;
    //vc.isOpenInterestRect = YES;
    vc.title = @"扫一扫";
    vc.isQQSimulator = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

//        _popVC = [[PopViewController alloc] initWithItems:@[@"发起群聊",@"添加搜索",@"摇一摇",@"扫一扫",@"偶遇",@"潮星",@"单身"]];
//    case 1:{
//        QCSearchViewController *searchVC = [[QCSearchViewController alloc]init];
//        [self.navigationController pushViewController:searchVC animated:YES];
//    }
//        break;
