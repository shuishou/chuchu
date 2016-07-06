//
//  QCNewFeatureVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/9.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCNewFeatureVC.h"
#import "QCTabBarController.h"
#import "QCLoginVC.h"

@interface QCNewFeatureVC ()<UIScrollViewDelegate>
@property (nonatomic , strong)UIPageControl *pageControl;

@end

@implementation QCNewFeatureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = [NSArray arrayWithObjects:@"记录你生活中的点滴",@"发泄你心中的不满,随手涂鸦,随你吼叫",@"标签让你找人找人更容易,还有帅哥美女推荐哦",@"吾日三省吾身", nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //ScrollView添加UIImageView
    //1.ScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    //1.添加4个UIImageView
    CGFloat imgW = scrollView.width;
    CGFloat imgH = scrollView.height;
    CGFloat imgX = 0;
    CGFloat imgY = 0;
    
    for (int i = 0; i < 4; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        NSString *imgName =[NSString stringWithFormat:@"new_feature%d",i];
        imgView.image = [UIImage imageNamed:imgName];
        //设置imgView frm
        imgX = (i) * imgW;
        imgView.frame = CGRectMake(imgX, imgY, imgW, imgH);
        [scrollView addSubview:imgView];
        
        UILabel *textLabel = [[UILabel alloc]init];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.numberOfLines = 2;
//        textLabel.text = [array objectAtIndex:i];
        textLabel.frame = CGRectMake(60 + imgW * i, SCREEN_H - 180, SCREEN_W - 120, 90);
        [scrollView addSubview:textLabel];
        
        //最近一个ImageView 添加 BeginView
        if (i == 3) {
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W/2 - 80, SCREEN_H - 120, 160, 42)];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn setImage:[UIImage imageNamed:@"normal_@2X.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"hover_@2X.png"]  forState:UIControlStateHighlighted];
//            [btn setTitle:@"开启出处" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
//            [btn.layer setBorderWidth:1];
//            
//            [btn.layer setBorderColor:[UIColor whiteColor].CGColor];
            imgView.userInteractionEnabled = YES;
            [imgView addSubview:btn];

        }
    }
    
    //设置contentSize
    scrollView.contentSize = CGSizeMake(imgW * 4, imgH);
    
    //设置翻页属性
    scrollView.pagingEnabled = YES;
    
    //设置pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    CGFloat bottomMargin = 60;
    CGFloat pageControlH = 30;
    CGFloat pageControlY = self.view.height - pageControlH - bottomMargin;
    pageControl.frame = CGRectMake(0,  pageControlY , self.view.width, pageControlH);
    
    //设置页数
    pageControl.numberOfPages = 4;
    
    //设置颜色
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
//    pageControl.
    [self.view addSubview:pageControl];
    
    self.pageControl = pageControl;
}

#pragma mark - 进入库牌
-(void)login:(UIButton *)sender{
    //保存当前的版本号
    [NSUserDefaults saveCurrentVersion];
     LoginSession *session = [[ApplicationContext sharedInstance] getLoginSession];
    if ([session isValidate]) {
        QCTabBarController *tabVC = [[QCTabBarController alloc]init];
        self.view.window.rootViewController = tabVC;
    }else{
        QCLoginVC *loginVC = [[QCLoginVC alloc]init];
        self.view.window.rootViewController = loginVC;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    MethodLog
    //设置页码
    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.width;
    
    if(self.pageControl.currentPage == 3){
        self.pageControl.hidden = YES;
    }else{
        self.pageControl.hidden = NO;
    }
    //    CZLog(@"%f",scrollView.contentOffset.x);
}

@end
