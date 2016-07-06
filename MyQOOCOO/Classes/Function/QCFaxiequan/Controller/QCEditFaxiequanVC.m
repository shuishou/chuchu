//
//  QCEditFaxiequanVCViewController.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/20.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCEditFaxiequanVC.h"
#import "QCDoodleVC.h"
#import "QCYellVC.h"
#import "QCQinniuUploader.h"
#import "RecordAudio.h"
#define kSeleteNuohouNotification @"SeleteNuohouNotification"

@interface QCEditFaxiequanVC (){
    UISegmentedControl *_segmentControl;
    QCDoodleVC *_doodleVC;
    QCYellVC *_yellVC;
    QCBaseVC *_currentVC;
}
@property (nonatomic , strong)NSString *fileUrl;

@end

@implementation QCEditFaxiequanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发泄";
    [self setupSegment];
    [self setupChildViews];
    
}
#pragma mark - childViews
//-(void)sendVent{
//    CZLog(@"发送发泄圈");
//}
-(void)setupChildViews{
    if (!_doodleVC) {
        _doodleVC = [[QCDoodleVC alloc]init];
        _doodleVC.view.frame = CGRectMake(0,102, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        [self addChildViewController:_doodleVC];
    }
    if (!_yellVC) {
        _yellVC = [[QCYellVC alloc]init];
        _yellVC.view.frame = CGRectMake(0,102, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        [self addChildViewController:_yellVC];
    }
    _currentVC = _yellVC;
    [self exchangeItems:_segmentControl];
}

#pragma mark - 涂鸦和怒吼控制器的切换
-(void)setupSegment{
    
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0,64, kUIScreenW,60)];
    titleView.backgroundColor = normalTabbarColor;
    [self.view addSubview:titleView];
    
    _segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"涂鸦",@"怒吼"]];
    
    _segmentControl.tintColor = kGlobalTitleColor;
    [_segmentControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18],NSFontAttributeName, nil] forState:UIControlStateNormal];
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
        [self transitionFromViewController:_currentVC toViewController:_doodleVC duration:.25 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
        } completion:^(BOOL finished) {
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem addBarBtnTitle:@"发送涂鸦" target:self action:@selector(sendDoodle)];
            [self.view addSubview:_doodleVC.view];
            [_doodleVC didMoveToParentViewController:self];
        }];
        _currentVC = _doodleVC;
    }if (sender.selectedSegmentIndex == 1) {
        [self transitionFromViewController:_currentVC toViewController:_yellVC duration:.25 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
        } completion:^(BOOL finished) {
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem addBarBtnTitle:@"发送怒吼" target:self action:@selector(sendYell)];
            [self.view addSubview:_yellVC.view];
            [_yellVC didMoveToParentViewController:self];
        }];
        _currentVC = _yellVC;
    }
    
}

#pragma mark - 发送涂鸦
-(void)sendDoodle{
    //判断是否有图片,有则上传七牛,没有则直接发送
    NSString *content = _doodleVC.contentField.text;
//    NSDictionary *parameter;
    if (_doodleVC.drawView.isDraw) {
        if (content && content.length > 0) {
            [self popupLoadingView:@"正在发送涂鸦"];
            [self uploadImageToQiuniu];
        }else{
            [OMGToast showText:@"请输入内容"];
        }
    }else{
        [OMGToast showText:@"请先涂鸦"];
    }
//    if (!_doodleVC.drawView.isDraw) {
//        parameter = @{@"content":content,@"type":@1};
//        [self popupLoadingView:@"正在发送涂鸦"];
//        [NetworkManager requestWithURL:TOPIC_CREATE_URL parameter:parameter success:^(id response) {
//            [self hideLoadingView];
//            [OMGToast showText:@"发送成功"];
//            [self.navigationController popViewControllerAnimated:YES];
//        } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
//            [self hideLoadingView];
//            [OMGToast showText:@"发送失败"];
//        }];
//    }
    
}

//有图上传七牛
-(void)uploadImageToQiuniu{
    UIImage *uploadImage = [_doodleVC.drawView converViewToImage:_doodleVC.drawView];
    [QCQinniuUploader uploadImage:uploadImage progress:^(NSString *key, float percent) {
        //        CZLog(@"===key=%@",key);
    } success:^(NSString *url) {
        CZLog(@"===url=%@",url);//上传成功获取到七牛返回来的url
        _fileUrl = url;
        NSString *content = _doodleVC.contentField.text;
        NSDictionary *parameter;
        parameter = @{@"content":content,@"fileUrl":_fileUrl,@"type":@1};
        
        [NetworkManager requestWithURL:TOPIC_CREATE_URL parameter:parameter success:^(id response) {
            [self hideLoadingView];
            [OMGToast showText:@"发送成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
            [self hideLoadingView];
            [OMGToast showText:@"发送失败"];
        }];
        
    } failure:^{
         [self hideLoadingView];
        [OMGToast showText:@"网络异常"];
    }];
}


#pragma mark - 发送怒吼
-(void)sendYell{
    //    1、先把音频上传到七牛服务器
    
//    NSString *recordPath = [NSString stringWithFormat:@"%@/Documents/orderwav", NSHomeDirectory()];
    NSString *recordPath=[[NSUserDefaults standardUserDefaults] objectForKey:@"filePath1"];
 
    NSData * a =[NSData dataWithContentsOfFile:recordPath];
    NSData *data = EncodeWAVEToAMR(a,1,16);
    
    [[NSFileManager defaultManager]createFileAtPath:recordPath contents:data attributes:nil];
   
    NSURL * url = [NSURL fileURLWithPath:recordPath];
    
    
    
    [QCQinniuUploader uploadVocieFile:url progress:nil success:^(NSString *url) {
        CZLog(@"%@",url);
        //    2、发送音频URL到服务器
        NSString *content = _yellVC.highestDecibel;//最高分贝
//        NSLog(@"content===%@",content);
        int durations =  (int)_yellVC.cTime;//时间
        NSDictionary *dict = @{@"content":content,@"fileUrl":url,@"type":@2,@"durations":@(durations)};
        [self popupLoadingView:@"正在发送怒吼"];
        [NetworkManager requestWithURL:TOPIC_CREATE_URL parameter:dict success:^(id response) {
            [self hideLoadingView];
            [OMGToast showText:@"发送成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:kSeleteNuohouNotification object:nil];
            
        } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
            [self hideLoadingView];
        }];

    } failure:^{
         [OMGToast showText:@"上传音频失败"];
    }];
}


@end
