//
//  AbreactViewController.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/22.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCFaxiequanViewController.h"
#import "QCEditFaxiequanVC.h"
#import "QCDoodleListVC.h"
#import "QCYellListVC.h"
#import "QCUserViewController2.h"
#import "QCYellModel.h"
#import "QCDoodleStatusFrame.h"
#define kSeleteNuohouNotification @"SeleteNuohouNotification"

@interface QCFaxiequanViewController (){
    UISegmentedControl *_segmentControl;
    QCBaseVC *_currentVC;
    QCDoodleListVC *_dooleListVC;
    QCYellListVC *_yellListVC;
}

@end

@implementation QCFaxiequanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发泄圈";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addBarBtnTitle:@"发泄" target:self action:@selector(faxiequan)];
  
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem addBarBtnImg:@"Arrow" highlightedImg:@"Arrow" target:self action:@selector(touchleftBtn)];

    [self setupSegment];
    [self setupChildViews];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(seleteNuhou) name:kSeleteNuohouNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nuhouavatarpushToUser:) name:@"nuhouavatarpush" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tuyaavatarpushToUser:) name:@"tuyaavatarpush" object:nil];
}

// 发布怒吼返回选中怒吼列表
-(void)seleteNuhou{
    _segmentControl.selectedSegmentIndex = 1;
    [self transitionFromViewController:_currentVC toViewController:_yellListVC duration:.25 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
    } completion:^(BOOL finished) {
        CZLog(@"怒吼");
        
        [self.view addSubview:_yellListVC.view];
        [_yellListVC didMoveToParentViewController:self];
    }];
    _currentVC = _yellListVC;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)faxiequan{
    //进入发泄圈
    QCEditFaxiequanVC *editFaxiequanVC = [[QCEditFaxiequanVC alloc]init];
    [self.navigationController pushViewController:editFaxiequanVC animated:YES];
}

#pragma mark - childViews
-(void)setupChildViews{
    if (!_dooleListVC) {
        _dooleListVC = [[QCDoodleListVC alloc]init];
        _dooleListVC.view.frame = CGRectMake(0, 102, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        _dooleListVC.uid = self.uid;
        [self addChildViewController:_dooleListVC];
    }
    if (!_yellListVC) {
        _yellListVC = [[QCYellListVC alloc]init];
        _yellListVC.view.frame = CGRectMake(0, 102, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        _yellListVC.uid = self.uid;
        [self addChildViewController:_yellListVC];
    }
    _currentVC = _yellListVC;
    [self exchangeItems:_segmentControl];
}

#pragma mark - segment
-(void)setupSegment{
    
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0,64, kUIScreenW,60)];
    titleView.backgroundColor = normalTabbarColor;
    [self.view addSubview:titleView];
    
    _segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"涂鸦",@"怒吼"]];
    _segmentControl.tintColor = kGlobalTitleColor;
    [_segmentControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [_segmentControl setWidth:80 forSegmentAtIndex:1];
    [_segmentControl setWidth:80 forSegmentAtIndex:0];
    _segmentControl.selectedSegmentIndex = 0;
    [_segmentControl addTarget:self action:@selector(exchangeItems:) forControlEvents:UIControlEventValueChanged];
    
    [titleView addSubview:_segmentControl];
  
    [_segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
}

-(void)exchangeItems:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        [self transitionFromViewController:_currentVC toViewController:_dooleListVC duration:.25 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
        } completion:^(BOOL finished) {
            CZLog(@"涂鸦");
            [self.view addSubview:_dooleListVC.view];
            [_dooleListVC didMoveToParentViewController:self];
        }];
        _currentVC = _dooleListVC;
    }if (sender.selectedSegmentIndex == 1) {
        [self transitionFromViewController:_currentVC toViewController:_yellListVC duration:.25 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
        } completion:^(BOOL finished) {
            CZLog(@"怒吼");
           
            [self.view addSubview:_yellListVC.view];
            [_yellListVC didMoveToParentViewController:self];
        }];
        _currentVC = _yellListVC;
    }
    
}
-(void)touchleftBtn
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)tuyaavatarpushToUser:(NSNotification*)n
{
    QCUserViewController2*vc=[[QCUserViewController2 alloc]init];
    QCDoodleStatusFrame*model=n.userInfo[@"model"];
    vc.uid=[model.qcStatus.author integerValue];
    [self.navigationController pushViewController:vc animated:YES];

}
-(void)nuhouavatarpushToUser:(NSNotification*)n
{
    QCUserViewController2*vc=[[QCUserViewController2 alloc]init];
    QCYellModel*model=n.userInfo[@"model"];
    vc.uid=[model.author integerValue];
    [self.navigationController pushViewController:vc animated:YES];

    

}


@end
