//
//  LunKuViewController.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/22.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//


#import "QCLunKuViewController.h"
#import "QCSendLunkuVC.h"
#import "QCSearchFriendVC.h"
#import "HACursor.h"
#import "QCLunkuDetailListVC.h"
#import "QCLKCommentTableView.h"
#import "QCLunkuListModel.h"
#import "QCUserViewController2.h"

@interface QCLunKuViewController ()<UISearchBarDelegate>

@property (nonatomic,strong) NSArray * titles;//滚动标签名
@property (nonatomic,strong) NSMutableArray * pageViews;

// 记录页码
@property (nonatomic,assign) int starPage;
@property (nonatomic,assign) int animePage;
@property (nonatomic,assign) int gamePage;
@property (nonatomic,assign) int artPage;
@property (nonatomic,assign) int sportPage;
@property (nonatomic,assign) int teachPage;
@property (nonatomic,assign) int amusementPage;
@property (nonatomic,assign) int lifePage;
@property (nonatomic,assign) int warPage;
@property (nonatomic,assign) int itPage;
@property (nonatomic,assign) int emotionPage;

@property (nonatomic,assign) NSInteger curentTag;

@property (nonatomic,weak) UISearchBar * searBar;

@end

@implementation QCLunKuViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.uid.length>0) {
         [self userDataWithType:self.curentTag+1 keyWord:nil];
    }else{
         [self loadLunkuDataWithType:self.curentTag+1 keyWord:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lunkuIconTap:) name:@"lunkuIconTap" object:nil];
}

-(void)lunkuIconTap:(NSNotification *)notification{
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    NSInteger uid = [notification.userInfo[@"model"] integerValue];
    if (uid == sessions.user.uid) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        QCUserViewController2 *user = [[QCUserViewController2 alloc] init];
        user.uid = uid;
        [self.navigationController pushViewController:user animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"论库";
    [self setupForDismissKeyboard];//点击屏幕键盘退下
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addBarBtnImg:@"but_write" highlightedImg:@"but_write" target:self action:@selector(sendLunkuVC:)];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem addBarBtnImg:@"Arrow" highlightedImg:@"Arrow" target:self action:@selector(touchleftBtn)];

    
    
//    初始化页码
    [self resetPageCount];
    
    // 滚动条
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    //  不允许有重复的标题
    self.titles = @[@"我是民星",@"二次元",@"萌宠社",@"文学塘",@"去哪玩",@"协会商汇",@"热点筒",@"子女教育",@"创业圈",@"柴米油盐",@"前任现任"];//@[@"明星名人",@"动漫",@"游戏",@"文学艺术",@"体育",@"教育人文",@"娱乐",@"时尚生活",@"军事科学",@"数码科技",@"情感"];
    
    //1、搜索框
    UIView * searchBgV = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kUIScreenW,40)];
    searchBgV.backgroundColor = normalTabbarColor;
     [self.view addSubview:searchBgV];
    UISearchBar * searBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0, kUIScreenW - 55 ,40)];
    searBar.delegate = self;
    searBar.placeholder =@"搜索";
    self.searBar = searBar;
//    移除UISearchBar的背景View
    for (UIView *view in searBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    [searchBgV addSubview:searBar];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kUIScreenW - 55,0,55,40);
    [btn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendLunkuVC:) forControlEvents:UIControlEventTouchUpInside];
    [searchBgV addSubview:btn];
    
//    2、滚动标题控制器
    HACursor *cursor = [[HACursor alloc]init];
    cursor.frame = CGRectMake(0, 64+40, self.view.width,40);
    cursor.backgroundColor = normalTabbarColor;
    cursor.titles = self.titles;
    cursor.pageViews = [self createPageViews];
    //设置根滚动视图的高度
    cursor.rootScrollViewHeight = self.view.frame.size.height -145;
    cursor.titleNormalColor = [UIColor blackColor];
    cursor.titleSelectedColor = kGlobalTitleColor;
    //是否显示排序按钮
    cursor.showSortbutton = NO;
    //默认的最小值是5，小于默认值的话按默认值设置
    cursor.minFontSize = 13;
    //默认的最大值是25，小于默认值的话按默认值设置，大于默认值按设置的值处理
    cursor.maxFontSize = 15;
    cursor.isGraduallyChangFont = NO;
    //在isGraduallyChangFont为NO的时候，isGraduallyChangColor不会有效果
    cursor.isGraduallyChangColor = YES;
    [self.view addSubview:cursor];
    
//   3、 网络加载最新列表数据
    for (int i = 1; i<12; i++) {
        if (self.uid.length>0) {
            [self userDataWithType:i keyWord:nil];
        }else{
            [self loadLunkuDataWithType:i keyWord:nil];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellClick:) name:kLKCellClickNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(curentTitleTag:) name:@"kurrentTitleBtnTagNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendReloadData:) name:kReloadLKdataNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKey) name:@"keyBord" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avatarPushToUser:) name:@"lunkuavatarpush" object:nil];

  
}

-(void)cellClick:(NSNotification*)n{
    QCLunkuDetailListVC * detailVC = [[QCLunkuDetailListVC alloc]init];
    detailVC.lk = n.userInfo[@"model"];
    detailVC.isRoot = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)curentTitleTag:(NSNotification*)n{
    NSNumber * index= n.userInfo[@"btnTag"];
    self.curentTag =index.integerValue;
}

-(void)sendReloadData:(NSNotification*)n{
    NSNumber * index= n.userInfo[@"index"];
    if (self.uid.length>0) {
        [self userDataWithType:index.integerValue keyWord:nil];
    }else{
       [self loadLunkuDataWithType:index.integerValue keyWord:nil];
    }
    
}


#pragma mark - setupScrollView
- (NSMutableArray *)createPageViews{
    NSMutableArray *pageViews = [NSMutableArray array];
    for (int i = 1; i <= self.titles.count; i++) {
        QCLKCommentTableView * tableV  = [[QCLKCommentTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SCREEN_H)];
        tableV.backgroundColor = kGlobalBackGroundColor;
        tableV.tag = i;
        tableV.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        
        
//        下拉刷新
        [tableV addHeaderWithCallback:^{
            [self resetPageCount];
            if (self.uid.length>0) {
                [self userDataWithType:self.curentTag+1 keyWord:nil];
            }else{
               [self loadLunkuDataWithType:self.curentTag+1 keyWord:nil];
            }
            
        }];
        
//        上拉加载更多
        [tableV addFooterWithCallback:^{
            if (self.uid.length >0) {
                [self userMoreDataWithType:self.curentTag+1];
            }else{
                [self loadMoreDataWithType:self.curentTag+1];
            }
        }];
        
        
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

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
//    CZLog(@"%@",searchText);
    if (self.uid.length>0) {
        [self userDataWithType:self.curentTag+1 keyWord:searchText];
    }else{
         [self loadLunkuDataWithType:self.curentTag+1 keyWord:searchText];
    }
    
  
}


#pragma mark - 加载新论库数据
/**
 *  加载最新轮库数据
 *
 *  @param type 论库类型 （1明星名人，2动漫，3游戏，4文学艺术，5体育，6教育人文，7娱乐，8时尚生活，9军事科学，10数码科技，11情感）
 *  @param keyWord   可选  String  搜索关键字
 *  @param page   必传  int	当前页数，用于分页
 */
-(void)loadLunkuDataWithType:(NSInteger)type keyWord:(NSString *)keyWord
{
    NSDictionary *parameter;
    if (keyWord) {
       parameter = @{@"type":@(type),@"page":@(1),@"keyWord":keyWord};
    }else{
       parameter = @{@"type":@(type),@"page":@(1)};
    }
    
    [NetworkManager requestWithURL:FORUM_LIST parameter:parameter success:^(id response) {
//        CZLog(@"=  %zd  ==response%@",type, response);
       
        NSMutableArray *newArr = [QCLunkuListModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
    
        switch (type) {
            case 1://明星名人
                _starTV =self.pageViews[0];
                _starTV.arr = newArr;
                [_starTV reloadData];
                [_starTV headerEndRefreshing];
                break;
                
            case 2://动漫
                _animeTV =self.pageViews[1];
                _animeTV.arr = newArr;
                [_animeTV reloadData];
                [_animeTV headerEndRefreshing];
                break;
                
            case 3://游戏
                _gameTV =self.pageViews[2];
                _gameTV.arr = newArr;
                [_gameTV reloadData];
                [_gameTV headerEndRefreshing];
                break;
                
            case 4://文学艺术
                _artTV =self.pageViews[3];
                _artTV.arr = newArr;
                [_artTV reloadData];
                [_artTV headerEndRefreshing];
                break;
                
            case 5://体育
                _sportTV =self.pageViews[4];
                _sportTV.arr = newArr;
                [_sportTV reloadData];
                [_sportTV headerEndRefreshing];
                
                break;
                
            case 6://教育
                _teachTV =self.pageViews[5];
                _teachTV.arr = newArr;
                [_teachTV reloadData];
                [_teachTV headerEndRefreshing];
                break;
                
            case 7://娱乐
                _amusementTV =self.pageViews[6];
                _amusementTV.arr = newArr;
                [_amusementTV reloadData];
                [_amusementTV headerEndRefreshing];
                break;
                
            case 8://时尚生活
                _lifeTV =self.pageViews[7];
                _lifeTV.arr = newArr;
                [_lifeTV reloadData];
                [_lifeTV headerEndRefreshing];
                break;
                
            case 9://战争
                _warTV =self.pageViews[8];
                _warTV.arr = newArr;
                [_warTV reloadData];
                [_warTV headerEndRefreshing];
                break;
                
            case 10://数码科技
                _itTV =self.pageViews[9];
                _itTV.arr = newArr;
                [_itTV reloadData];
                [_itTV headerEndRefreshing];
                break;
                
            case 11://情感
                _emotionTV =self.pageViews[10];
                _emotionTV.arr = newArr;
                [_emotionTV reloadData];
                [_emotionTV headerEndRefreshing];
                break;
                
            default:
                break;
        }
        
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [self endHearder];
    }];
}

#pragma mark - 加载更多库数据
-(void)loadMoreDataWithType:(NSInteger)type{
    
    NSDictionary * parameter;
    switch (type) {
        case 1:
           parameter = @{@"type":@(type),@"page":@(self.starPage)};
            break;
        case 2:
            parameter = @{@"type":@(type),@"page":@(self.animePage)};
            break;
        case 3:
            parameter = @{@"type":@(type),@"page":@(self.gamePage)};
            break;
        case 4:
            parameter = @{@"type":@(type),@"page":@(self.artPage)};
            break;
        case 5:
            parameter = @{@"type":@(type),@"page":@(self.sportPage)};
            break;
        case 6:
            parameter = @{@"type":@(type),@"page":@(self.teachPage)};
            break;
        case 7:
            parameter = @{@"type":@(type),@"page":@(self.amusementPage)};
            break;
        case 8:
            parameter = @{@"type":@(type),@"page":@(self.lifePage)};
            break;
        case 9:
            parameter = @{@"type":@(type),@"page":@(self.warPage)};
            break;
        case 10:
            parameter = @{@"type":@(type),@"page":@(self.itPage)};
            break;
        case 11:
            parameter = @{@"type":@(type),@"page":@(self.emotionPage)};
            break;
            
        default:
            break;
    }
    
    [NetworkManager requestWithURL:FORUM_LIST parameter:parameter success:^(id response) {

//        CZLog(@"===response%@",response);
        NSArray *moreArr = [QCLunkuListModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        if (moreArr.count>0) {
            switch (type) {
                case 1://明星名人
                    _starTV =self.pageViews[0];
                    [_starTV.arr addObjectsFromArray:moreArr];
                    [_starTV reloadData];
                    [_starTV footerEndRefreshing];
                    self.starPage ++;
                    break;
                    
                case 2://动漫
                    _animeTV =self.pageViews[1];
                    [_animeTV.arr addObjectsFromArray:moreArr];
                    [_animeTV reloadData];
                    [_animeTV footerEndRefreshing];
                    self.animePage ++;
                    break;
                    
                case 3://游戏
                    _gameTV =self.pageViews[2];
                    [_gameTV.arr addObjectsFromArray:moreArr];
                    [_gameTV reloadData];
                    [_gameTV footerEndRefreshing];
                    self.gamePage ++;
                    break;
                    
                case 4://文学艺术
                    _artTV =self.pageViews[3];
                    [_artTV.arr addObjectsFromArray:moreArr];
                    [_artTV reloadData];
                    [_artTV footerEndRefreshing];
                    self.artPage ++;
                    break;
                    
                case 5://体育
                    _sportTV =self.pageViews[4];
                    [_sportTV.arr addObjectsFromArray:moreArr];
                    [_sportTV reloadData];
                    [_sportTV footerEndRefreshing];
                    self.sportPage ++;
                    
                    break;
                    
                case 6://教育
                    _teachTV =self.pageViews[5];
                    [_teachTV.arr addObjectsFromArray:moreArr];
                    [_teachTV reloadData];
                    [_teachTV footerEndRefreshing];
                    self.teachPage ++;
                    break;
                    
                case 7://娱乐
                    _amusementTV =self.pageViews[6];
                    [_amusementTV.arr addObjectsFromArray:moreArr];
                    [_amusementTV reloadData];
                    [_amusementTV footerEndRefreshing];
                    self.starPage ++;
                    break;
                    
                case 8://时尚生活
                    _lifeTV =self.pageViews[7];
                    [_lifeTV.arr addObjectsFromArray:moreArr];
                    [_lifeTV reloadData];
                    [_lifeTV footerEndRefreshing];
                    self.lifePage ++;
                    break;
                    
                case 9://战争
                    _warTV =self.pageViews[8];
                    [_warTV.arr addObjectsFromArray:moreArr];
                    [_warTV reloadData];
                    [_warTV footerEndRefreshing];
                    self.starPage ++;
                    break;
                    
                case 10://数码科技
                    _itTV =self.pageViews[9];
                    [_itTV.arr addObjectsFromArray:moreArr];
                    [_itTV reloadData];
                    [_itTV footerEndRefreshing];
                    self.itPage ++;
                    break;
                    
                case 11://情感
                    _emotionTV =self.pageViews[10];
                    [_emotionTV.arr addObjectsFromArray:moreArr];
                    [_emotionTV reloadData];
                    [_emotionTV  footerEndRefreshing];
                    self.emotionPage ++;
                    break;
                    
                default:
                    break;
            }
        }else{
            [OMGToast showText:@"已加载完"];
            [self endFooter];
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [self endFooter];
    }];
}



#pragma mark - 加载用户个人论库数据
-(void)userDataWithType:(NSInteger)type keyWord:(NSString *)keyWord
{
    NSDictionary *parameter;
    if (keyWord) {
        parameter = @{@"type":@(type),@"page":@(1),@"keyWord":keyWord,@"destUid":self.uid};
    }else{
        parameter = @{@"type":@(type),@"page":@(1),@"destUid":self.uid};
    }
    
    [NetworkManager requestWithURL:FORUM_FORUMOFMEMBER parameter:parameter success:^(id response) {
        //        CZLog(@"=  %zd  ==response%@",type, response);
        
        NSMutableArray *newArr = [QCLunkuListModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        
        switch (type) {
            case 1://明星名人
                _starTV =self.pageViews[0];
                _starTV.arr = newArr;
                [_starTV reloadData];
                [_starTV headerEndRefreshing];
                break;
                
            case 2://动漫
                _animeTV =self.pageViews[1];
                _animeTV.arr = newArr;
                [_animeTV reloadData];
                [_animeTV headerEndRefreshing];
                break;
                
            case 3://游戏
                _gameTV =self.pageViews[2];
                _gameTV.arr = newArr;
                [_gameTV reloadData];
                [_gameTV headerEndRefreshing];
                break;
                
            case 4://文学艺术
                _artTV =self.pageViews[3];
                _artTV.arr = newArr;
                [_artTV reloadData];
                [_artTV headerEndRefreshing];
                break;
                
            case 5://体育
                _sportTV =self.pageViews[4];
                _sportTV.arr = newArr;
                [_sportTV reloadData];
                [_sportTV headerEndRefreshing];
                
                break;
                
            case 6://教育
                _teachTV =self.pageViews[5];
                _teachTV.arr = newArr;
                [_teachTV reloadData];
                [_teachTV headerEndRefreshing];
                break;
                
            case 7://娱乐
                _amusementTV =self.pageViews[6];
                _amusementTV.arr = newArr;
                [_amusementTV reloadData];
                [_amusementTV headerEndRefreshing];
                break;
                
            case 8://时尚生活
                _lifeTV =self.pageViews[7];
                _lifeTV.arr = newArr;
                [_lifeTV reloadData];
                [_lifeTV headerEndRefreshing];
                break;
                
            case 9://战争
                _warTV =self.pageViews[8];
                _warTV.arr = newArr;
                [_warTV reloadData];
                [_warTV headerEndRefreshing];
                break;
                
            case 10://数码科技
                _itTV =self.pageViews[9];
                _itTV.arr = newArr;
                [_itTV reloadData];
                [_itTV headerEndRefreshing];
                break;
                
            case 11://情感
                _emotionTV =self.pageViews[10];
                _emotionTV.arr = newArr;
                [_emotionTV reloadData];
                [_emotionTV headerEndRefreshing];
                break;
                
            default:
                break;
        }
        
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [self endHearder];
    }];
}

#pragma mark - 加载更多个人库数据
-(void)userMoreDataWithType:(NSInteger)type{
    
    NSDictionary * parameter;
    switch (type) {
        case 1:
            parameter = @{@"type":@(type),@"page":@(self.starPage),@"destUid":self.uid};
            break;
        case 2:
            parameter = @{@"type":@(type),@"page":@(self.animePage),@"destUid":self.uid};
            break;
        case 3:
            parameter = @{@"type":@(type),@"page":@(self.gamePage),@"destUid":self.uid};
            break;
        case 4:
            parameter = @{@"type":@(type),@"page":@(self.artPage),@"destUid":self.uid};
            break;
        case 5:
            parameter = @{@"type":@(type),@"page":@(self.sportPage),@"destUid":self.uid};
            break;
        case 6:
            parameter = @{@"type":@(type),@"page":@(self.teachPage),@"destUid":self.uid};
            break;
        case 7:
            parameter = @{@"type":@(type),@"page":@(self.amusementPage),@"destUid":self.uid};
            break;
        case 8:
            parameter = @{@"type":@(type),@"page":@(self.lifePage),@"destUid":self.uid};
            break;
        case 9:
            parameter = @{@"type":@(type),@"page":@(self.warPage),@"destUid":self.uid};
            break;
        case 10:
            parameter = @{@"type":@(type),@"page":@(self.itPage),@"destUid":self.uid};
            break;
        case 11:
            parameter = @{@"type":@(type),@"page":@(self.emotionPage),@"destUid":self.uid};
            break;
            
        default:
            break;
    }
    
    [NetworkManager requestWithURL:FORUM_FORUMOFMEMBER parameter:parameter success:^(id response) {
        
        //        CZLog(@"===response%@",response);
        NSArray *moreArr = [QCLunkuListModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        if (moreArr.count>0) {
            switch (type) {
                case 1://明星名人
                    _starTV =self.pageViews[0];
                    [_starTV.arr addObjectsFromArray:moreArr];
                    [_starTV reloadData];
                    [_starTV footerEndRefreshing];
                    self.starPage ++;
                    break;
                    
                case 2://动漫
                    _animeTV =self.pageViews[1];
                    [_animeTV.arr addObjectsFromArray:moreArr];
                    [_animeTV reloadData];
                    [_animeTV footerEndRefreshing];
                    self.animePage ++;
                    break;
                    
                case 3://游戏
                    _gameTV =self.pageViews[2];
                    [_gameTV.arr addObjectsFromArray:moreArr];
                    [_gameTV reloadData];
                    [_gameTV footerEndRefreshing];
                    self.gamePage ++;
                    break;
                    
                case 4://文学艺术
                    _artTV =self.pageViews[3];
                    [_artTV.arr addObjectsFromArray:moreArr];
                    [_artTV reloadData];
                    [_artTV footerEndRefreshing];
                    self.artPage ++;
                    break;
                    
                case 5://体育
                    _sportTV =self.pageViews[4];
                    [_sportTV.arr addObjectsFromArray:moreArr];
                    [_sportTV reloadData];
                    [_sportTV footerEndRefreshing];
                    self.sportPage ++;
                    
                    break;
                    
                case 6://教育
                    _teachTV =self.pageViews[5];
                    [_teachTV.arr addObjectsFromArray:moreArr];
                    [_teachTV reloadData];
                    [_teachTV footerEndRefreshing];
                    self.teachPage ++;
                    break;
                    
                case 7://娱乐
                    _amusementTV =self.pageViews[6];
                    [_amusementTV.arr addObjectsFromArray:moreArr];
                    [_amusementTV reloadData];
                    [_amusementTV footerEndRefreshing];
                    self.starPage ++;
                    break;
                    
                case 8://时尚生活
                    _lifeTV =self.pageViews[7];
                    [_lifeTV.arr addObjectsFromArray:moreArr];
                    [_lifeTV reloadData];
                    [_lifeTV footerEndRefreshing];
                    self.lifePage ++;
                    break;
                    
                case 9://战争
                    _warTV =self.pageViews[8];
                    [_warTV.arr addObjectsFromArray:moreArr];
                    [_warTV reloadData];
                    [_warTV footerEndRefreshing];
                    self.starPage ++;
                    break;
                    
                case 10://数码科技
                    _itTV =self.pageViews[9];
                    [_itTV.arr addObjectsFromArray:moreArr];
                    [_itTV reloadData];
                    [_itTV footerEndRefreshing];
                    self.itPage ++;
                    break;
                    
                case 11://情感
                    _emotionTV =self.pageViews[10];
                    [_emotionTV.arr addObjectsFromArray:moreArr];
                    [_emotionTV reloadData];
                    [_emotionTV  footerEndRefreshing];
                    self.emotionPage ++;
                    break;
                    
                default:
                    break;
            }
        }else{
            [OMGToast showText:@"已加载完"];
            [self endFooter];
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [self endFooter];
    }];
}


#pragma mark - 其它
//创建帖子
-(void)sendLunkuVC:(id)sender{
    QCSendLunkuVC *sendLunkuVC = [[QCSendLunkuVC alloc]init];
    [self.navigationController pushViewController:sendLunkuVC animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)endHearder{
   NSInteger index = self.curentTag;
  QCLKCommentTableView * tableV = self.pageViews[index];
  [tableV headerEndRefreshing];
}

-(void)endFooter{
    NSInteger index = self.curentTag;
    QCLKCommentTableView * tableV = self.pageViews[index];
    [tableV footerEndRefreshing];
}

-(void)searchBtnClick{
    if (self.uid.length>0) {
        [self userDataWithType:self.curentTag+1 keyWord:self.searBar.text];
    }else{
      [self loadLunkuDataWithType:self.curentTag+1 keyWord:self.searBar.text];
    }
}
-(void)touchleftBtn
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)closeKey
{
    [self.searBar  resignFirstResponder];
}

-(void)avatarPushToUser:(NSNotification*)n
{
    QCUserViewController2*vc=[[QCUserViewController2 alloc]init];
    QCLunkuListModel*model=n.userInfo[@"model"];
    vc.uid=model.uid;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
