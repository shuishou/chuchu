//
//  QCFuntionController2.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/22.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//
#define functionBtnW [UIScreen mainScreen].bounds.size.width / 3

#import "QCFuntionController2.h"
#import "QCNavigationVC.h"
#import "myHeaderView.h"
#import "QCDiandiViewController.h"
#import "QCFaxiequanViewController.h"
#import "QCLunKuViewController.h"
#import "QCRixingVC.h"
#import "QCSearchViewController.h"
#import "QCNewSearchVC.h"

//功能控制器
#import "QCHFMoreVC.h"
#import "QCDiandiViewController.h"
#import "QCSearchViewController.h"
#import "QCHFAdvancedSearchViewController.h"
#import "QCLunKuViewController.h"
#import "QCFaxiequanViewController.h"
#import "QCHFRixingVC.h"
#import "QCPaihuoViewController.h"
#import "PopViewController.h"
#import "QCSegmentControl.h"
#import "QCGroupListVC.h"
#import "QCShakeViewController.h"
#import "QCEncounterViewController.h"
#import "QCStarViewController.h"
#import "QCSingleTVC.h"
#import "MyQRViewController.h"
#import "LBXScanView.h"
#import "QCScanViewController.h"

#import "QCFunctionBtn.h"
#import "QCLoginVC.h"

//设置
#import "QCSettingVC.h"
//个人资料
#import "QCFriendInfoVC.h"
//账户
#import "QCAccount.h"

@interface QCFuntionController2 ()<settingDelegate,UITableViewDataSource,UITableViewDelegate>
{
    //右键弹框选择
    PopViewController *_popVC;
    
    UIView * funtionView;
    
    myHeaderView *headerView;
    
}
@property (nonatomic , strong)myHeaderView *headerView;
@property (nonatomic , strong)NSArray *titleArray;
@property (nonatomic , strong)NSArray *imageArray;
@property (nonatomic , strong)UIButton *functionBtn;
@property (nonatomic , strong)NSArray *functionBtnArray;
@property (nonatomic , strong)QCBaseTableView *tableView;

@property (strong, nonatomic) NSMutableArray * qiYongArr;

@property (nonatomic,strong) UIButton * diandiBtn;//点滴按钮

@property (nonatomic,weak) UIImageView * imgV;

@end

@implementation QCFuntionController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LoginSession *sessionS = [[ApplicationContext sharedInstance] getLoginSession];
//    UIImageView * ima = [[UIImageView alloc]init];
//    NSURL*url=[NSURL URLWithString:sessionS.user.avatarUrl];
//    NSLog(@"%@",url);
//    [ima sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ios-template-1024(1)"]];
    
    _tableView = [[QCBaseTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.data = [[NSMutableArray alloc]init];
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    
//    //初始化右边按钮
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addBarBtnImg:@"add4" highlightedImg:@"add4" target:self action:@selector(addMore:)];
//    
//    //初始化左边按钮
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem addBarBtnImg:@"Search" highlightedImg:@"Search" target:self action:@selector(searchMarkUser:)];
    
    
    
    UIView*topv=[[UIView alloc]init];
    topv.frame=CGRectMake(0, 0, self.view.frame.size.width, 64);
    self.navigationItem.titleView=topv;
    
    UIButton *btns = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *normalImgs = [UIImage imageNamed:@"Search"];
    
    [btns setImage:normalImgs forState:UIControlStateNormal];
    [btns setImage:[UIImage imageNamed:@"Search"] forState:UIControlStateHighlighted];
    
    btns.frame = CGRectMake(topv.frame.size.width-85, (topv.frame.size.height-30)/2,30, 30);
    [btns addTarget:self action:@selector(searchMarkUser:) forControlEvents:UIControlEventTouchUpInside];
    
    [topv addSubview:btns];
    
    UIButton *btns2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *normalImgs2 = [UIImage imageNamed:@"add4"];
    
    [btns2 setImage:normalImgs2 forState:UIControlStateNormal];
    [btns2 setImage:[UIImage imageNamed:@"add4"] forState:UIControlStateHighlighted];
    
    btns2.frame = CGRectMake(topv.frame.size.width-50, (topv.frame.size.height-30)/2, 30, 30);
    [btns2 addTarget:self action:@selector(addMore:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [topv addSubview:btns2];
    
    UIButton *btns3 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *normalImgs3 = [UIImage imageNamed:@"set"];
    
    [btns3 setImage:normalImgs3 forState:UIControlStateNormal];
    [btns3 setImage:[UIImage imageNamed:@"set"] forState:UIControlStateHighlighted];
    
    btns3.frame = CGRectMake(10, (topv.frame.size.height-30)/2, 30, 30);
    [btns3 addTarget:self action:@selector(settingVC) forControlEvents:UIControlEventTouchUpInside];
    
    
    [topv addSubview:btns3];

    
    
    
    
    
    //为什么headerView占据了cell的空间
    headerView = [[myHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, HEIGHT(self.view)-WIDTH(self.view)-64-49)];
    headerView.setdelegate = self;
//    [headerView.iconBtn setImage:ima.image forState:UIControlStateNormal];
    self.tableView.tableHeaderView = headerView;
}

//单独设置功能导航栏的样式
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    //设置导航栏背景颜色
    QCNavigationVC *nav = (QCNavigationVC *)self.navigationController;
    nav.myNavigationBar.image = [UIImage imageWithColor:funcBarColor andSize:CGSizeMake(Main_Screen_Width, 44)];
    //设置导航栏的字体
    [nav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,itemFont,NSFontAttributeName ,nil]];
    
    
    //    [nav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
    //                                               [UIColor whiteColor], UITextAttributeTextColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,itemFont, UITextAttributeFont,nil]];
    
    LoginSession *session = [[ApplicationContext sharedInstance] getLoginSession];
    if (![session isValidate]) {
        QCLoginVC *loginVC = [[QCLoginVC alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    
    NSUserDefaults * userDefaultsFu = [NSUserDefaults standardUserDefaults];
    
    _qiYongArr = [userDefaultsFu objectForKey:@"已启用功能"];
    NSArray *weiArr = [userDefaultsFu objectForKey:@"未启用功能"];
    if (_qiYongArr.count == 0 && weiArr.count == 0) {
        _qiYongArr = [NSMutableArray array];
        NSArray * arr = @[@"点滴", @"论库", @"发泄圈", @"日省", @"我要派活", @"我要接活"];
        
        //       NSArray * arr = [userDefaults objectForKey:@"已启用功能"]
        [_qiYongArr addObjectsFromArray:arr];
    }
    
    if (self.tableView) {
        [self.tableView reloadData];
    }
    
    //     读取点滴是否有更新
    [self readDiandiStatus];
    [self getData];
    
}

#pragma mark - 实现segment的点击跳转功能
-(void)segmented:(UIView *)btn selectedFrom:(NSInteger)from to:(NSInteger)to{
    if (_popVC.show) {
        [_popVC dismiss];
    }
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

- (void)searchMarkUser:(UIBarButtonItem *)bar
{
    if (_popVC.show) {
        [_popVC dismiss];
    }
    
    QCNewSearchVC * vc = [[QCNewSearchVC alloc] init];
    vc.title=@"推荐搜索";
    [self.navigationController pushViewController:vc animated:YES];
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


#pragma mark - headerView设置
-(void)settingVC{
    QCSettingVC *settingVC = [[QCSettingVC alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}
-(void)changeIcon{
    QCProfileViewController2*friendInfoVC=[[QCProfileViewController2 alloc]init];
    [self.navigationController pushViewController:friendInfoVC animated:YES];
}

-(void)changeSex{
    NSLog(@"变男变女");
}


//     读取点滴是否有更新
-(void)readDiandiStatus{
    //    读取应用设置提醒开关状态
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *nei = [defaults objectForKey:@"设置内圈更新"];
    NSString *wai = [defaults objectForKey:@"设置外圈消息"];
    
    [NetworkManager requestWithURL:RECORD_HASUPDATE parameter:nil success:^(id response) {
        NSString * innerUpdate = response[@"innerUpdate"];
        NSString * outUpdate = response[@"outUpdate"];
        
    if ((innerUpdate.boolValue && !nei.boolValue) || (outUpdate.boolValue && !wai.boolValue)) {
        UIImageView * imgV =[[UIImageView alloc]init];
        imgV.frame = CGRectMake(80, 20, 10, 10);
        imgV.image = [UIImage imageNamed:@"Circle@2x"];
        self.imgV = imgV;
        [self.diandiBtn addSubview:imgV];
    }

    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    QCNavigationVC *nav = (QCNavigationVC *)self.navigationController;
    nav.myNavigationBar.image = [UIImage imageWithColor:normalTabbarColor andSize:CGSizeMake(Main_Screen_Width, 44)];
    //设置导航栏的字体
    [nav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:normalItemColor,NSForegroundColorAttributeName,itemFont,NSFontAttributeName, nil]];
    
    //    [nav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
    //                                               normalItemColor, UITextAttributeTextColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,itemFont, UITextAttributeFont,nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark 功能按钮排版
- (UIView *)funtionButtonView
{
    CGFloat heights;
    
    heights = _qiYongArr.count/3+1;
    
    funtionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view))];
    
    for (int i = 1; i < _qiYongArr.count+1; i++) {
        
        //按钮
        UIButton * bu = [UIButton buttonWithType:UIButtonTypeCustom];
        bu.backgroundColor = [UIColor whiteColor];
        bu.frame = CGRectMake(WIDTH(funtionView)/3*((i-1)%3), HEIGHT(funtionView)/3*((i-1)/3), WIDTH(funtionView)/3, HEIGHT(funtionView)/3);
        bu.tag = i-1;
        [bu addTarget:self action:@selector(clickToList:) forControlEvents:UIControlEventTouchUpInside];
        
        //按钮图
        UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(bu)/3, (HEIGHT(bu)-WIDTH(bu)/3-(WIDTH(bu)/3)/2-13)/2, WIDTH(bu)/3, WIDTH(bu)/3)];
        imageV.image = [UIImage imageNamed:_qiYongArr[i-1]];
        
                
        //按钮文本
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, Y(imageV)+HEIGHT(imageV) + 13, WIDTH(bu), HEIGHT(imageV)/2)];
        label.font = [UIFont systemFontOfSize:HEIGHT(label)*4/5];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _qiYongArr[i-1];
        
        [bu addSubview:label];
        [bu addSubview:imageV];
        
//         点滴增加圆圈
        NSString * str = _qiYongArr[bu.tag];
        if ([str isEqualToString:@"点滴"]) {
            self.diandiBtn = bu;
        }
        
        
        UIImageView * line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT(bu)-1, WIDTH(bu), 1)];
        line1.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
        [bu addSubview:line1];
        
        if (i == 1 || i%3==1) {
            UIImageView * line2 = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(bu)-1, 0, 1, HEIGHT(bu))];
            line2.backgroundColor = line1.backgroundColor;
            [bu addSubview:line2];
        }
        else if (i == 2 || i%3 == 2)
        {
            UIImageView * line3 = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(bu)-1, 0, 1, HEIGHT(bu))];
            line3.backgroundColor = line1.backgroundColor;
            [bu addSubview:line3];
        }
        
        [funtionView addSubview:bu];
    }
    
    UIButton * addBu = [UIButton buttonWithType:UIButtonTypeCustom];
    addBu.frame = CGRectMake(WIDTH(funtionView)/3*(((_qiYongArr.count+1)-1)%3), HEIGHT(funtionView)/3*(((_qiYongArr.count+1)-1)/3), WIDTH(funtionView)/3, HEIGHT(funtionView)/3);
    UIImageView * addImage = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH(addBu)-WIDTH(addBu)/2)/2, (HEIGHT(addBu)-HEIGHT(addBu)/2.1)/2.1, WIDTH(addBu)/2.1, WIDTH(addBu)/2.1)];
    [addBu addSubview:addImage];
    [addImage setImage:[UIImage imageNamed:@"but_addimg"]];
    UIImageView * lineA = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(addBu)-1, 0, 1, HEIGHT(addBu))];
    lineA.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [addBu addSubview:lineA];
    
    UIImageView * lineAd = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT(addBu)-1, WIDTH(addBu), 1)];
    lineAd.backgroundColor = lineA.backgroundColor;
    [addBu addSubview:lineAd];
    
    [funtionView addSubview:addBu];
    [addBu addTarget:self action:@selector(addFuntion:) forControlEvents:UIControlEventTouchUpInside];
    
    return funtionView;
}

#pragma mark - Tableview data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HEIGHT(funtionView);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

//#warning mark 设置section的headerView是不会随着cell一起滚动的,所以直接设置UIView.tableView.tableHeaderview

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    return 250;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    CZLog(@"%zd",section);
//
//    return self.headerView;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView * views = [self funtionButtonView];
    [cell.contentView addSubview:views];
    
    return cell;
}

- (void)addFuntion:(UIButton *)bu
{
    QCHFMoreVC *moreVc =  [[QCHFMoreVC alloc]init];
    moreVc.title = @"功能管理";
    [self.navigationController pushViewController:moreVc animated:YES];
}

- (void)clickToList:(UIButton *)bu
{
    NSString * str = _qiYongArr[bu.tag];
    
    if ([str isEqualToString:@"点滴"]) {
        [self.imgV removeFromSuperview];
        QCDiandiViewController *diandiVc =  [[QCDiandiViewController alloc]init];
        [self.navigationController pushViewController:diandiVc animated:YES];
    }
//    else if ([str isEqualToString:@"添加搜索"])
//    {
//        QCSearchViewController *seachVc =  [[QCSearchViewController alloc]init];
//        [self.navigationController pushViewController:seachVc animated:YES];
//    }
    else if ([str isEqualToString:@"论库"])
    {
        QCLunKuViewController *seachVc =  [[QCLunKuViewController alloc]init];
        [self.navigationController pushViewController:seachVc animated:YES];
    }
    else if ([str isEqualToString:@"发泄圈"])
    {
        QCFaxiequanViewController *seachVc =  [[QCFaxiequanViewController alloc]init];
        [self.navigationController pushViewController:seachVc animated:YES];
    }
    else if ([str isEqualToString:@"日省"])
    {
        QCHFRiXingVC *seachVc =  [[QCHFRiXingVC alloc]init];
        seachVc.title = @"日省";
        [self.navigationController pushViewController:seachVc animated:YES];
    }
    else if ([str isEqualToString:@"我要派活"])
    {
        QCPaihuoViewController*paihuo=[[QCPaihuoViewController alloc]init];
        paihuo.type=4;
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:paihuo];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        QCPaihuoViewController*paihuo=[[QCPaihuoViewController alloc]init];
        paihuo.type=5;
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:paihuo];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - 请求数据
-(void)getData
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    
    dic[@"uid"]=@(sessions.user.uid);
   
    [NetworkManager requestWithURL:USERINFO_DETAIL parameter:dic success:^(id response) {
        NSLog(@"%@",response);
        NSDictionary *dict = (NSDictionary *)response;
        NSLog(@"dict====%@",dict);
        NSInteger sex=[response[@"sex"] integerValue];
        if (sex ==0) {
            headerView.sexImage.image=[UIImage imageNamed:@"LJ形状-1"];
        }else{
            headerView.sexImage.image=[UIImage imageNamed:@"LJ形状-2"];
        }
        [headerView.heardImage sd_setImageWithURL:[NSURL URLWithString:dict[@"avatarRawUrl"]] placeholderImage:[UIImage imageNamed:@"ios-template-1024(1)"]];
        headerView.signMessage.text = dict[@"nickname"];
        
//        headerView.signMessage.frame = CGRectMake((self.view.frame.size.width-(headerView.signMessage.text.length*20))/2, MaxY(headerView.heardImage)+((HEIGHT(headerView)-MaxY(headerView.heardImage)-(HEIGHT(headerView.heardImage)/3+8))/2)/2, headerView.signMessage.text.length*15+20, 14);
//        headerView.sexImage.frame =CGRectMake(((self.view.frame.size.width-(headerView.signMessage.text.length*10))/2)+(headerView.signMessage.text.length*10),MaxY(headerView.heardImage)+((HEIGHT(headerView)-MaxY(headerView.heardImage)-(HEIGHT(headerView.heardImage)/3+8))/2)/2, 14, 14);
        
        headerView.signMessage.frame = CGRectMake(10, MaxY(headerView.heardImage)+((HEIGHT(headerView)-MaxY(headerView.heardImage)-(HEIGHT(headerView.heardImage)/3+8))/2)/2, self.view.frame.size.width/2 + 20, 14);
        headerView.sexImage.frame =CGRectMake(self.view.frame.size.width/2 + 40,MaxY(headerView.heardImage)+((HEIGHT(headerView)-MaxY(headerView.heardImage)-(HEIGHT(headerView.heardImage)/3+8))/2)/2, 14, 14);
        
//        headerView.signMessage.frame = CGRectMake((SCREEN_W-([dict[@"nickname"]length]*(HEIGHT(headerView.signMessage)*3/4+26)))/2, MaxY(headerView.heardImage)+((HEIGHT(headerView)-MaxY(headerView.heardImage)-(HEIGHT(headerView.heardImage)/3+8))/2)/2, [dict[@"nickname"]length]*(HEIGHT(headerView.signMessage)*3/4+8), HEIGHT(headerView.heardImage)/4);
//        headerView.signMessage.backgroundColor = [UIColor blueColor];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
}




@end
