//
//  SearchViewController.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/22.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCSearchViewController.h"
#import "QCShakeViewController.h"
#import "QCScanViewController.h"
#import "QCEncounterViewController.h"
#import "QCStarViewController.h"
#import "QCSingleTVC.h"
#import "MyQRViewController.h"
#import "HFSearchFriendListVc.h"
#import "QCHFUserModel.h"
#import "QCHFAdvancedSearchViewController.h"
@interface QCSearchViewController ()<UITextFieldDelegate>
{
    UIView * footView;
    NSString * HFText;
}
/**数据*/
@property (strong, nonatomic) NSMutableArray * dataArrays;
@end

@implementation QCSearchViewController
@dynamic tableView;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"一起按";
    self.dataArrays = [NSMutableArray array];
    
    //监听键盘弹出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowNotificationded:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardRemoveed:) name:UIKeyboardWillHideNotification object:nil];
    
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.data = [@[@{@"name":@"摇一摇",@"image":@"but_shake"},
//                             @{@"name":@"扫一扫",@"image":@"but_sweep"},
//                             @{@"name":@"偶遇",@"image":@"but_ouyu"},
//                             @{@"name":@"潮星",@"image":@"but_star"},
//                             @{@"name":@"单身",@"image":@"but_Single"},
//                             @{@"name":@"搜索",@"image":@"but_search"}]
//                           mutableCopy];
//    self.tableView.bounces = NO;
//    [self.tableView registerClass:[QCSearchMainCell class] forCellReuseIdentifier:NSStringFromClass([QCSearchMainCell class])];
//    [self showSearchView];
    [self showFootderView];
    
}

- (void)showSearchView
{
    UIView * searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 44)];
    searchView.backgroundColor = [UIColor clearColor];
    UILabel * searchLa = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.view.frame.size.width-16, 28)];
    searchLa.backgroundColor = [UIColor whiteColor];
    searchLa.textAlignment = NSTextAlignmentCenter;
    searchLa.textColor = [UIColor colorWithHexString:@"999999"];
    searchLa.text = @"搜索";
    searchLa.font = [UIFont systemFontOfSize:15];
    searchLa.layer.masksToBounds = YES;
    searchLa.layer.cornerRadius = 5;
    [searchView addSubview:searchLa];
    self.tableView.tableHeaderView = searchView;
    
    searchLa.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchViewTapped1:)];
    tap1.cancelsTouchesInView = NO;
    [searchLa addGestureRecognizer:tap1];
}

- (void)showFootderView
{
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT(self.view)-WIDTH(self.view)/8, WIDTH(self.view), WIDTH(self.view)/8)];
    footView.backgroundColor = [UIColor whiteColor];
    UITextField * textfiled = [[UITextField alloc] initWithFrame:CGRectMake(6, 6, WIDTH(footView)*3/4-12, HEIGHT(footView)-12)];
    textfiled.font = [UIFont systemFontOfSize:HEIGHT(textfiled)/2];
    [textfiled setValue:[UIColor colorWithHexString:@"999999"] forKeyPath:@"_placeholderLabel.textColor"];
    textfiled.textColor = [UIColor colorWithHexString:@"333333"];
    textfiled.placeholder = @"输入暗号,30秒内有效";
    textfiled.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    textfiled.layer.masksToBounds = YES;
    textfiled.layer.cornerRadius = 6;
    textfiled.delegate = self;
    textfiled.keyboardType = UIKeyboardTypeNumberPad;
    [textfiled addTarget:self action:@selector(searchBy:) forControlEvents:UIControlEventEditingChanged];
    [footView addSubview:textfiled];
    
    
    UIButton * bu = [UIButton buttonWithType:UIButtonTypeCustom];
    bu.frame = CGRectMake(MaxX(textfiled)+8, Y(textfiled), WIDTH(footView)-WIDTH(textfiled)-25, HEIGHT(textfiled));
    bu.backgroundColor = kLoginbackgoundColor;
    [bu setTitle:@"一起按" forState:UIControlStateNormal];
    bu.layer.masksToBounds = YES;
    bu.layer.cornerRadius = 6;
    bu.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(bu)/2];
    [bu actionButton:^(UIButton *sender) {
        if (HFText.length > 0) {
            [self initSearchByTogether];
        }
        else
        {
            [self.view endEditing:YES];
            [OMGToast showText:@"请输入数字"];
        }
    }];
    [footView addSubview:bu];
    
    UIImageView * line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(footView), 0.5)];
    line1.backgroundColor = [UIColor colorWithHexString:@"999999"];
    [footView addSubview:line1];
    
    UIImageView * line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT(footView)-0.5, WIDTH(footView), 0.5)];
    line2.backgroundColor = [UIColor colorWithHexString:@"999999"];
    [footView addSubview:line2];
    
    [self.view addSubview:footView];
}

- (void)searchBy:(UITextField *)field
{
    HFText = field.text;
}

#pragma -mark 一起按
- (void)initSearchByTogether
{
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"code"] = HFText;
    
    [NetworkManager requestWithURL:SEARCHBYTOGETHER parameter:dic success:^(id response) {
        
        NSArray * arr = response;
        NSMutableArray * dataArrs = [NSMutableArray array];
        NSMutableArray * isfriendArr = [NSMutableArray array];
        if (arr.count > 0) {
            if (arr.count > 0) {
                for (NSDictionary * dic in arr) {
                    
                    NSNumber * isF = [dic objectForKey:@"isFriends"];
                    
                    QCHFUserModel * model = [[QCHFUserModel alloc] init];
                    model = [QCHFUserModel mj_objectWithKeyValues:dic];
                    model.isFriends = [NSString stringWithFormat:@"%@", isF];
                    [dataArrs addObject:model];
                    [isfriendArr addObject:isF];
                }
            }
            HFSearchFriendListVc * vc = [[HFSearchFriendListVc alloc] init];
            vc.isAn = @1;
            vc.dataArray = dataArrs;
            vc.isfriendArr = isfriendArr;
            vc.title = @"搜素结果";
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [OMGToast showText:@"没有找到一起按的人"];
        }
        [self.view endEditing:YES];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        
    }];
}

//键盘将要弹出的方法
-(void)keyBoardWillShowNotificationded:(NSNotification *)not
{
    
    //获取键盘高度
    NSDictionary *dic = not.userInfo;
    //获取坐标
    CGRect rc = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //键盘高度
    CGFloat f = rc.size.height;
    
    //调整输入框的位置
    [UIView animateWithDuration:0.1 animations:^{
        footView.frame = CGRectMake(0, self.view.frame.size.height-f-HEIGHT(footView), WIDTH(footView), WIDTH(self.view)/8);
    }];
}

//键盘消失的方法
-(void)keyBoardRemoveed:(NSNotification *)not
{
    //调整输入框的位置
    [UIView animateWithDuration:0.1 animations:^{
        footView.frame = CGRectMake(0, HEIGHT(self.view)-WIDTH(self.view)/8, WIDTH(footView), WIDTH(self.view)/8);
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //回收键盘
    [textField  resignFirstResponder];
    return YES;
}

- (void)searchViewTapped1:(UITapGestureRecognizer *)taps
{
    HFSearchFriendListVc * friendListVc = [[HFSearchFriendListVc alloc] init];
    UINavigationController * friendNa = [[UINavigationController alloc] initWithRootViewController:friendListVc];
    friendListVc.hidesBottomBarWhenPushed = YES;
    [self presentViewController:friendNa animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableView.data.count%2==0?(self.tableView.data.count/2):(self.tableView.data.count%2+1);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QCSearchMainCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QCSearchMainCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger indexLeft = indexPath.row*2;
    NSInteger indexRight = indexPath.row*2+1;
    
    cell.leftItem.hidden = YES;
    cell.rightItem.hidden = YES;
    
    if (indexLeft<self.tableView.data.count) {
        cell.leftItem.hidden = NO;
        NSDictionary * infoDicLeft = self.tableView.data[indexLeft];
        cell.leftItem.infoDic = infoDicLeft;
        cell.leftItem.tag = indexLeft;
        cell.delegate = self;
    }
    
    if (indexRight<self.tableView.data.count) {
        cell.rightItem.hidden = NO;
        NSDictionary * infoDicRight = self.tableView.data[indexRight];
        cell.rightItem.infoDic = infoDicRight;
        cell.rightItem.tag = indexRight;
        cell.delegate = self;
    }
    
    return cell;
}
-(void)searchMainCell:(QCSearchMainCell *)cell selectedIndex:(NSInteger)index{
    switch (index) {
        case 0:{
            QCShakeViewController * shake = [[QCShakeViewController alloc]init];
            [self.navigationController pushViewController:shake animated:YES];
            break;
        }
        case 1:{
            [self weixinStyle];
            break;
        }
        case 2:{
            QCEncounterViewController * encounter = [[QCEncounterViewController alloc]init];
            [self.navigationController pushViewController:encounter animated:YES];
            
            break;
        }
        case 3:{
            QCStarViewController * star = [[QCStarViewController alloc] init];
            [self.navigationController pushViewController:star animated:YES];
            break;
        }
        case 4:{
            QCSingleTVC * single = [[QCSingleTVC alloc] init];
            [self.navigationController pushViewController:single animated:YES];
            break;
        }
        case 5:{
            QCHFAdvancedSearchViewController * vc = [[QCHFAdvancedSearchViewController alloc] init];
            vc.title = @"搜索";
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        default:
            break;
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
    UIImage *imgLine = [UIImage imageNamed:@"CodeScan.bundle/qrcode_Scan_weixin_Line"];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
