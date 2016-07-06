//
//  QCFreeController.m
//  MyQOOCOO
//
//  Created by lanou on 16/2/15.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCFreeController.h"
#import "LBXScanView.h"
#import "PopViewController.h"
#import "QCGroupListVC.h"
#import "QCShakeViewController.h"
#import "QCEncounterViewController.h"
#import "QCStarViewController.h"
#import "QCSingleTVC.h"
#import "QCScanViewController.h"
#import "HACursor.h"
#import "QCLKCommentTableView.h"
#import "QCLunkuListModel.h"
#import "QCLunkuDetailListVC.h"
#import "QCSendLunkuVC.h"
#import "QCSearchViewController.h"
#import "QCUserViewController2.h"
#import "QCNewSearchVC.h"

@interface QCFreeController ()
{
    PopViewController *_popVC;
    UIScrollView*scrollBaV;
    
    UIView *moreV;
    UIView *clearBackView;
    QCLKCommentTableView *commentTableView;
    NSInteger page;
    UISearchBar *searBar;
    NSMutableArray *dataArr;
}

@property(nonatomic,strong)NSArray *titleArr;

@end

@implementation QCFreeController 

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dataArr = [NSMutableArray array];
    [self getTypeData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"自由人";
    
    if (self.isBlack) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem addBarBtnImg:@"Arrow" highlightedImg:@"Arrow" target:self action:@selector(popToView)];
    }else{
        UIView*topv=[[UIView alloc]init];
        topv.frame=CGRectMake(0, 0, self.view.frame.size.width, 64);
        self.navigationItem.titleView=topv;
        
        UILabel*titleLb=[[UILabel alloc]initWithFrame:CGRectMake((topv.bounds.size.width-90)/2, (topv.frame.size.height-30)/2, 90, 30)];
        titleLb.text=@"自由人";
        titleLb.textColor=UIColorFromRGB(0xed6664);
        titleLb.textAlignment=NSTextAlignmentCenter;
        [topv addSubview:titleLb];
        
        UIButton *btns = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *normalImgs = [UIImage imageNamed:@"icon_sousuo"];
        
        [btns setImage:normalImgs forState:UIControlStateNormal];
        [btns setImage:[UIImage imageNamed:@"icon_sousuo"] forState:UIControlStateHighlighted];
        
        btns.frame = CGRectMake(topv.frame.size.width-85, (topv.frame.size.height-30)/2,30, 30);
        [btns addTarget:self action:@selector(searchMarkUser:) forControlEvents:UIControlEventTouchUpInside];
        
        [topv addSubview:btns];
        
        UIButton *btns2 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *normalImgs2 = [UIImage imageNamed:@"add3"];
        
        [btns2 setImage:normalImgs2 forState:UIControlStateNormal];
        [btns2 setImage:[UIImage imageNamed:@"add3"] forState:UIControlStateHighlighted];
        
        btns2.frame = CGRectMake(topv.frame.size.width-50, (topv.frame.size.height-30)/2, 30, 30);
        [btns2 addTarget:self action:@selector(addMore:) forControlEvents:UIControlEventTouchUpInside];
        
        [topv addSubview:btns2];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellClick:) name:kLKCellClickNotification2 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(curentTitleTag:) name:@"kurrentTitleBtnTagNotification2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKey) name:@"keyBord" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avatarPushToUser:) name:@"lunkuavatarpush" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lunkuIconTap:) name:@"lunkuIconTap" object:nil];
    
    
    
    UIView*v=[[UIView alloc]initWithFrame:CGRectMake(0, 74, self.view.frame.size.width, 580)];
    v.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:v];
//    v.userInteractionEnabled = YES;
    scrollBaV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 400, 40)];
    [v addSubview: scrollBaV];
    //设置可滚动范围
    scrollBaV.contentSize=CGSizeMake(self.view.frame.size.width*2, 0);
    scrollBaV.backgroundColor=[UIColor clearColor];
    
    self.automaticallyAdjustsScrollViewInsets =NO;
    //分页显示
    scrollBaV.pagingEnabled=YES;
    
    //滑动到第一页和最后一页是否允许继续滑动
    
    scrollBaV.bounces=YES;
    
    //取消滚动条
    
    scrollBaV.showsHorizontalScrollIndicator=NO;//水平(横)
    
    scrollBaV.showsVerticalScrollIndicator=NO;//垂直(竖)
    
    //指定代理人
    scrollBaV.delegate=self;
    
    
    
    //一开始显示到第几张
    scrollBaV.contentOffset=CGPointMake(0,0);

    
    
    //创建一个分段控件
    //初始化需要一个数组 数组里面放每一段的标题
    self.titles = @[@"文案",@"创意",@"程序员",@"律师",@"会计",@"模特",@"合伙人",@"销售员",@"其他"];
//    NSArray *array=[NSArray arrayWithObjects:@"文案",@"创意",@"程序员",@"律师",@"会计",@"模特",@"合伙人",@"销售员",@"其他", nil];
    //    2、滚动标题控制器
    HACursor *cursor = [[HACursor alloc]init];
    cursor.scrollNavBar.isfree=YES;
    cursor.frame = CGRectMake(0, 0, self.view.width,40);
    cursor.backgroundColor = normalTabbarColor;
    cursor.titles = self.titles;
    cursor.pageViews = nil;
    //设置根滚动视图的高度
    cursor.rootScrollViewHeight = self.view.frame.size.height -145;
    cursor.titleNormalColor = [UIColor blackColor];
    cursor.titleSelectedColor = kGlobalTitleColor;
//    cursor.rootScrollViewHeight=0;
    //是否显示排序按钮
    cursor.showSortbutton = NO;
    //默认的最小值是5，小于默认值的话按默认值设置
    cursor.minFontSize = 13;
    //默认的最大值是25，小于默认值的话按默认值设置，大于默认值按设置的值处理
    cursor.maxFontSize = 15;
//    cursor.isGraduallyChangFont = NO;
    //在isGraduallyChangFont为NO的时候，isGraduallyChangColor不会有效果
//    cursor.isGraduallyChangColor = YES;
    [v addSubview:cursor];

    
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
        UIImage *normalImg = [UIImage imageNamed:@"icon_shaixuan"];
    
        [btn setImage:normalImg forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_shaixuan"] forState:UIControlStateHighlighted];
    
        btn.frame = CGRectMake(0, 40, 40, 40);
        [btn addTarget:self action:@selector(addMoreType:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:btn];
//    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    UIImage *normalImg2 = [UIImage imageNamed:@"lunku_searchBtn"];
    
//    [btn2 setImage:normalImg2 forState:UIControlStateNormal];
//    [btn2 setImage:[UIImage imageNamed:@"lunku_searchBtn"] forState:UIControlStateHighlighted];
//    
//    btn2.frame = CGRectMake(self.view.frame.size.width-40, 40, 40, 40);
//    [btn2 addTarget:self action:@selector(searchType) forControlEvents:UIControlEventTouchUpInside];
//    [v addSubview:btn2];
    
    UIButton *btns3 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *normalImgs3 = [UIImage imageNamed:@"edit"];
    
    [btns3 setImage:normalImgs3 forState:UIControlStateNormal];
    [btns3 setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateHighlighted];
    
    btns3.frame = CGRectMake(self.view.frame.size.width-40, 40, 40, 40);
    [btns3 addTarget:self action:@selector(pushVC:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [v addSubview:btns3];

    
    
    searBar = [[UISearchBar alloc]initWithFrame:CGRectMake(40, 45, self.view.frame.size.width-80, 30)];
    searBar.delegate = self;
    searBar.backgroundColor=[UIColor clearColor];
    searBar.placeholder =@"当前搜索";
    searBar.layer.borderWidth=0.5;
    searBar.layer.borderColor=[UIColor colorWithHexString:@"#efefef"].CGColor;
    for (UIView *view in searBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }

    [v addSubview:searBar];

    
    commentTableView = [[QCLKCommentTableView alloc]init];
    page = 1;
    if (self.isBlack) {
        commentTableView.frame=CGRectMake(0, 64+100, self.view.frame.size.width, self.view.frame.size.height-174);
    }else{
         commentTableView.frame=CGRectMake(0, 64+100, self.view.frame.size.width, self.view.frame.size.height-214);
    }
    commentTableView.backgroundColor=self.view.backgroundColor;
    commentTableView.isfree = YES;
    [self.view addSubview:commentTableView];
    
    //        下拉刷新
    [commentTableView addHeaderWithCallback:^{
//        [self resetPageCount];
        page = 1;
        [self getTypeData];
    }];
    
    //        上拉加载更多
    [commentTableView addFooterWithCallback:^{
        page = page+1;
        [self getTypeData];
    }];
}
#pragma mark - setupScrollView
- (NSMutableArray *)createPageViews{
    NSMutableArray *pageViews = [NSMutableArray array];
    for (int i = 1; i <= self.titles.count; i++) {
        QCLKCommentTableView * tableV  = [[QCLKCommentTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SCREEN_H)];
        tableV.backgroundColor = kGlobalBackGroundColor;
        tableV.tag = i;
        tableV.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        
        
        
        
        [pageViews addObject:tableV];
    }
    self.pageViews = pageViews;
    return pageViews;
}
-(void)resetPageCount{
    self.starPage = 2;
    self.animePage = 2;
    self.gamePage = 2;
    self.artPage = 2;
    self.sportPage = 2;
    self.teachPage = 2;
    self.amusementPage = 2;
    self.lifePage = 2;
    self.warPage = 2;
    self.itPage = 2;
    self.emotionPage = 2;
}

-(void)pushVC:(UIButton*)bt
{
    NSLog(@"发布");
    [clearBackView removeFromSuperview];
    QCSendLunkuVC *sendLunkuVC = [[QCSendLunkuVC alloc]init];
    sendLunkuVC.isFree=YES;
    [self.navigationController pushViewController:sendLunkuVC animated:YES];
}

-(void)addMoreType:(UIButton*)bt
{
    NSLog(@"类型");
    [self showMoreType];
    [searBar resignFirstResponder];
}

-(void)hideMoreType{
    [clearBackView removeFromSuperview];
}

-(NSArray *)titleArr{
    if (_titleArr == nil) {
        _titleArr=[[NSArray alloc]initWithObjects:@"全部",@"我要接活",@"我要派活",@"交流", nil];
    }
    return _titleArr;
}

-(void)showMoreType
{
    [clearBackView removeFromSuperview];
    clearBackView = [[UIView alloc] initWithFrame:self.view.bounds];
    clearBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:clearBackView];
    [clearBackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMoreType)]];
    
    moreV=[[UIView alloc]initWithFrame:CGRectMake(0, 154, 160, 200)];
    moreV.layer.borderColor=[UIColor colorWithHexString:@"eaeaea"].CGColor;
    moreV.layer.borderWidth = 0.8;
    moreV.backgroundColor = [UIColor whiteColor];
    moreV.layer.cornerRadius = 5;
    moreV.layer.masksToBounds = YES;
    [clearBackView addSubview:moreV];
    
    for (int i = 0; i < self.titleArr.count; i++) {
        UIButton*tempBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        tempBtn.tag = i;
        [tempBtn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        if (self.funcType == i) {
            [tempBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        tempBtn.frame=CGRectMake(0, moreV.frame.size.height/4*i, moreV.frame.size.width,  moreV.frame.size.height/4);
        [tempBtn addTarget:self action:@selector(searchmoreType:) forControlEvents:UIControlEventTouchUpInside];
        [moreV addSubview:tempBtn];
        
        if (i != 3) {
            UIView*linev=[[UIView alloc]initWithFrame:CGRectMake(5, moreV.frame.size.height/4*(i+1), moreV.frame.size.width-10, 0.5)];
            linev.backgroundColor=[UIColor colorWithHexString:@"eaeaea"];
            [moreV addSubview:linev];
        }
    }

//    clearBackView.hidden = !clearBackView.hidden;
}

-(void)searchmoreType:(UIButton *)bt
{
    
    [bt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    NSLog(@"%ld",(long)bt.tag);

    self.funcType = (int)bt.tag;
    [self getTypeData];
    [clearBackView removeFromSuperview];
    [searBar resignFirstResponder];

}

-(void)searchType
{
    NSLog(@"搜搜搜");
    if ( searBar.text.length > 0 ) {
        [self getTypeData];
    }else{
         [OMGToast showText:@"请输入关键字"];
    }
    [searBar resignFirstResponder];
}

- (void)searchMarkUser:(UIBarButtonItem *)bar
{
    if (_popVC.show) {
        [_popVC dismiss];
    }
    
    QCNewSearchVC * vc = [[QCNewSearchVC alloc] init];
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

- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    QCScanViewController *vc = [QCScanViewController new];
    vc.style = style;
    //vc.isOpenInterestRect = YES;
    vc.title = @"扫一扫";
    vc.isQQSimulator = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)cellClick:(NSNotification*)n{
    QCLunkuDetailListVC * detailVC = [[QCLunkuDetailListVC alloc]init];
    detailVC.lk = n.userInfo[@"model"];
    detailVC.isFree = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)curentTitleTag:(NSNotification*)n{
    NSNumber * index= n.userInfo[@"btnTag"];
    self.curentTag =index.integerValue;
   
//    [commentTableView setContentOffset:CGPointMake(0, 0) animated:YES];
//    [self getTypeData];
    [commentTableView headerBeginRefreshing];
    [searBar resignFirstResponder];
}

#pragma mark  - 网络请求
-(void)getTypeData
{
//类型 type（1文案，2创意，3程序员，4律师，5会计，6模特，7合伙人，8销售员，9互联网）
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    //    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    //
    dic[@"type"] = @(self.curentTag+1);//
    dic[@"keyWord"] = searBar.text;
    dic[@"page"]= @(page);//分页
    if (self.funcType != 0) {
        dic[@"funcType"]=@(self.funcType);//2-派活  1-接活  3-交流 0-所有？
    }
    
    NSString *urlStr = nil;
    if (self.isBlack) {
        urlStr = FeeManWorkOfMember;
        dic[@"destUid"] = @(self.uid);
    }else{
        urlStr = FreeMan;
    }
    
    [MBProgressHUD hideHUD];
//    [MBProgressHUD showMessage:nil background:NO];
    
//    NSLog(@"dic====%@",dic);
//    NSLog(@"--%@",urlStr);
    
//    [NetworkManager requestWithURL:urlStr parameter:dic success:^(id response) {
//        NSMutableArray *newArr = [QCLunkuListModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
//        for (int i = 0; i < [response[@"list"] count]; i++) {
//            NSLog(@"commentCount====%@",response[@"list"][i][@"commentCount"]);
//        }
//        
//        if (page == 1) {
//            [dataArr removeAllObjects];
//            dataArr = [newArr mutableCopy];
//        }else if(page >= 2){
//            for (QCLunkuListModel *model in newArr) {
//                [dataArr addObject:model];
//            }
//        }
//        
//        commentTableView.arr = dataArr;
//        [commentTableView reloadData];
//        
//        [MBProgressHUD hideHUD];
//        [commentTableView footerEndRefreshing];
//        [commentTableView headerEndRefreshing];
//        
//    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
//        CZLog(@"error----------%@", error);
//        [MBProgressHUD hideHUD];
//        [commentTableView footerEndRefreshing];
//        [commentTableView headerEndRefreshing];
//    }];
    [NetworkManager requestWithURL:urlStr parameter:dic success:^(id response) {
                NSMutableArray *newArr = [QCLunkuListModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
                for (int i = 0; i < [response[@"list"] count]; i++) {
                    NSLog(@"commentCount====%@",response[@"list"][i][@"commentCount"]);
                }
        
                if (page == 1) {
                    [dataArr removeAllObjects];
                    dataArr = [newArr mutableCopy];
                }else if(page >= 2){
                    for (QCLunkuListModel *model in newArr) {
                        [dataArr addObject:model];
                    }
                }
        
                commentTableView.arr = dataArr;
                [commentTableView reloadData];
        
                [MBProgressHUD hideHUD];
                [commentTableView footerEndRefreshing];
                [commentTableView headerEndRefreshing];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
                CZLog(@"error----------%@", error);
                [MBProgressHUD hideHUD];
                [commentTableView footerEndRefreshing];
                [commentTableView headerEndRefreshing];
    }];
}


//-(void)cickUserFreeMan
//{
//    //类型 type（1文案，2创意，3程序员，4律师，5会计，6模特，7合伙人，8销售员，9互联网）
//    //funcType (2-派活  1-接活  3-交流)不传参数就是全部
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    dic[@"type"]=@(self.curentTag+1);//
//    dic[@"page"]=@(page);//分页
//    dic[@"destUid"]=@(self.uid);//2-派活  1-接活  3-交流 0-所有？
//
//    [MBProgressHUD showMessage:nil background:NO];
//    [NetworkManager requestWithURL:FeeManWorkOfMember parameter:dic success:^(id response) {
//        NSMutableArray *newArr = [QCLunkuListModel objectArrayWithKeyValuesArray:response[@"list"]];
//        commentTableView.arr=newArr;
//        [commentTableView reloadData];
//        
//        
//        [MBProgressHUD hideHUD];
//        [commentTableView footerEndRefreshing];
//        [commentTableView headerEndRefreshing];
//        
//    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
//        CZLog(@"%@", error);
//        [MBProgressHUD hideHUD];
//        [commentTableView footerEndRefreshing];
//        [commentTableView headerEndRefreshing];
//    }];
//}

-(void)closeKey{
  [searBar resignFirstResponder];
}

-(void)popToView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
  [self getTypeData];
}

-(void)avatarPushToUser:(NSNotification*)n
{
    QCLunkuListModel *model = n.userInfo[@"model"];
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    NSLog(@"model.uid===%ld",model.uid);
    if (model.uid == sessions.user.uid) {
        self.tabBarController.selectedIndex = 3;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HFUserPushGroupList" object:
         @"3"];
        
    }else{
        QCUserViewController2*vc=[[QCUserViewController2 alloc]init];
        vc.uid=model.uid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)lunkuIconTap:(NSNotification*)n
{
    NSInteger uid = [n.userInfo[@"model"] integerValue];
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
//    NSLog(@"model.uid===%ld",model.uid);
    if (uid == sessions.user.uid) {
        if (self.isBlack == YES) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            self.tabBarController.selectedIndex = 3;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HFUserPushGroupList" object:
             @"3"];
        }
    }else{
        QCUserViewController2 *vc=[[QCUserViewController2 alloc]init];
        vc.uid = uid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
