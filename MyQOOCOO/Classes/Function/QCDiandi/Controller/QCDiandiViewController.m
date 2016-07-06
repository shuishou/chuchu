//
//  DiandiViewController.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/22.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCDiandiViewController.h"
#import "QCWaiQuanVC.h"
#import "QCNeiQuanVC.h"
#import "QCRiZhiVC.h"
#import "QCSendDiandiVC.h"
#import "PopViewController.h"
#import "QCDiandiListModel.h"
#import "QCUserViewController2.h"
#import <MediaPlayer/MediaPlayer.h>
#define kMovieUrlNotification @"MovieUrlNotification"

@interface QCDiandiViewController ()
{
    UISegmentedControl *_segmentControl;
    UIViewController *_currentVC;
    QCWaiQuanVC *_waiquanVC;
    QCNeiQuanVC *_neiquanVC;
    QCRiZhiVC *_diaryVC;
    PopViewController *_popVC;
}

@property (nonatomic,weak) UIImageView * imgV;

@end

@implementation QCDiandiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"点滴";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addBarBtnImg:@"edit" highlightedImg:nil target:self action:@selector(diandiKind:)];
   
    
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem addBarBtnImg:@"Arrow" highlightedImg:@"Arrow" target:self action:@selector(touchleftBtn)];
    
    [self setupSegment];
 
    [self setupChildVC];
    
//    //     读取点滴内圈是否有更新
    [self readDiandiStatus];
    
//    通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playMovie:) name:kMovieUrlNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avatarPushToUser:) name:@"avatarpush" object:nil];

}

//     读取点滴是否有更新
-(void)readDiandiStatus{
//    读取应用设置提醒开关状态
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *nei = [defaults objectForKey:@"设置内圈更新"];

    [NetworkManager requestWithURL:RECORD_HASUPDATE parameter:nil success:^(id response) {
        NSString * innerUpdate = response[@"innerUpdate"];
        if (innerUpdate.boolValue && !nei.boolValue) {
            UIImageView * imgV =[[UIImageView alloc]init];
            imgV.frame = CGRectMake(150, 2, 10, 10);
            imgV.image = [UIImage imageNamed:@"but_eva@2x"];
            [_segmentControl addSubview:imgV];
            self.imgV = imgV;
             }
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        
    }];
}

// 播放点滴列表的网络视频
-(void)playMovie:(NSNotification*)n{
    CZLog(@"%@",n.userInfo[@"MovieUrl"]);
    NSURL *url = [NSURL URLWithString:n.userInfo[@"MovieUrl"]];
     CZLog(@"%@",url);
    MPMoviePlayerViewController * movieVc = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [movieVc.moviePlayer prepareToPlay];
    movieVc.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [self presentViewController:movieVc animated:YES completion:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 发送点滴类型
-(void)diandiKind:(UIButton *)sender{
    if (!_popVC) {
        _popVC = [[PopViewController alloc] initWithItems:@[@"发点滴",@"短视频"]];
    }
    if (_popVC.show) {
        [_popVC dismiss];
    }else{
        [_popVC showInView:self.view selectedIndex:^(NSInteger selectedIndex) {
            if (selectedIndex == 0) {
                QCSendDiandiVC *sendDiandiVC = [[QCSendDiandiVC alloc]init];
                sendDiandiVC.title = @"写点滴";
                sendDiandiVC.isVideo = NO;
                [self.navigationController pushViewController:sendDiandiVC animated:YES];
            }else if (selectedIndex == 1){
                QCSendDiandiVC *sendDiandiVC = [[QCSendDiandiVC alloc]init];
                sendDiandiVC.title = @"短视频";
                sendDiandiVC.isVideo = YES;
                [self.navigationController pushViewController:sendDiandiVC animated:YES];
            }
        }];
    }
}

#pragma mark - segment
-(void)setupSegment{
    _segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"外圈",@"内圈",@"日记"]];
    _segmentControl.tintColor = kGlobalTitleColor;
    [_segmentControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [_segmentControl setWidth:80 forSegmentAtIndex:1];
    [_segmentControl setWidth:80 forSegmentAtIndex:0];
    [_segmentControl setWidth:80 forSegmentAtIndex:2];
    _segmentControl.selectedSegmentIndex = 0;
    [_segmentControl addTarget:self action:@selector(exchangeItems:) forControlEvents:UIControlEventValueChanged];

    UIView * titleV = [[UIView alloc]init];
    titleV.frame = CGRectMake(0, 64, kUIScreenW, 60);
    titleV.backgroundColor = normalTabbarColor;
    [self.view addSubview:titleV];
    [titleV addSubview:_segmentControl];
    
    
    [_segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
}
-(void)exchangeItems:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex ==0) {
        [self transitionFromViewController:_currentVC toViewController:_waiquanVC duration:.25 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
        } completion:^(BOOL finished) {
            [self.view addSubview:_waiquanVC.view];
            [_waiquanVC didMoveToParentViewController:self];
        }];
        _currentVC = _waiquanVC;
    }if (sender.selectedSegmentIndex == 1) {
        [self.imgV removeFromSuperview];
        [self transitionFromViewController:_currentVC toViewController:_neiquanVC duration:.25 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
        } completion:^(BOOL finished) {
            [self.view addSubview:_neiquanVC.view];
            [_neiquanVC didMoveToParentViewController:self];
        }];
        _currentVC = _neiquanVC;
    }if (sender.selectedSegmentIndex == 2) {
        [self transitionFromViewController:_currentVC toViewController:_diaryVC duration:.25 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
        } completion:^(BOOL finished) {
            [self.view addSubview:_diaryVC.view];
            [_diaryVC didMoveToParentViewController:self];
        }];
        _currentVC = _diaryVC;
    }
    
}

#pragma mark - childVC
-(void)setupChildVC{
    if (!_waiquanVC) {
        _waiquanVC = [[QCWaiQuanVC alloc]init];
        _waiquanVC.view.frame = CGRectMake(0, 102, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        _waiquanVC.uid = self.uid;
        [self addChildViewController:_waiquanVC];
    }
    if (!_neiquanVC) {
        _neiquanVC = [[QCNeiQuanVC alloc]init];
        _neiquanVC.view.frame = CGRectMake(0, 102, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        _neiquanVC.uid = self.uid;
        [self addChildViewController:_neiquanVC];
    }
    if (!_diaryVC) {
        _diaryVC = [[QCRiZhiVC alloc]init];
        _diaryVC.view.frame = CGRectMake(0, 102, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        _diaryVC.uid = self.uid;
        [self addChildViewController:_diaryVC];
    }
    _currentVC = _waiquanVC;
    [self exchangeItems:_segmentControl];
}

-(void)touchleftBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_popVC dismiss];
}

-(void)avatarPushToUser:(NSNotification*)n
{
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    QCDiandiListModel *model=n.userInfo[@"model"];
    if (sessions.user.uid == model.author) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        QCUserViewController2*vc=[[QCUserViewController2 alloc]init];        
        vc.uid=model.author;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
