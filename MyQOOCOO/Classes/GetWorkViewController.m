//
//  GetWorkViewController.m
//  MyQOOCOO
//
//  Created by Nikola on 16/6/13.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "GetWorkViewController.h"
#import "HACursor.h"
#import "diaomaoViewController.h"
//#import "ListViewController.h"
#import "fdafViewController.h"
#import "SDCycleScrollView.h"
#import "QCAddUserMarkVC.h"

@interface GetWorkViewController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,captureViewControllerDelegate,UIActionSheetDelegate>
{
    NSMutableArray *scrollimages;
    UIView *ContentView;
    UIView *PriceView;
    UIButton *SendBtn;
    UITableView *tableVIew;
    UIActionSheet*Figures;
    SDCycleScrollView *cycleScrollView;
}
@property (strong,nonatomic) UIScrollView *SetWorkView;

@end

@implementation GetWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[@"发布技能",@"约单",@"进行中",@"待验收",@"返工",@"完工"];
    HACursor *cursor = [[HACursor alloc]init];
//    UIView *fff = [[UIView alloc] initWithFrame:CGRectMake(5, 25, 375, 1)];
//    fff.backgroundColor = [UIColor blackColor];
//    [cursor addSubview:fff];
    cursor.frame = CGRectMake(0, 64, self.view.width,40);
    cursor.backgroundColor = normalTabbarColor;
    cursor.titles = self.titles;
    cursor.pageViews = [self createPageViews];
    //设置根滚动视图的高度
    cursor.rootScrollViewHeight = self.view.frame.size.height -105;
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
}
- (NSMutableArray *)createPageViews{
    NSMutableArray *pageViews = [NSMutableArray array];
    for (NSInteger i = 0; i < self.titles.count; i++) {
        if(i == 0){
//            UITableView *textView = [[UITableView alloc]init];
//            textView.delegate = self;
//            textView.dataSource = self;
//            textView.tag = i;
            
            self.SetWorkView = [[UIScrollView alloc] init];
            self.SetWorkView.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height);
            self.SetWorkView.delegate = self;
            self.SetWorkView.contentSize = CGSizeMake(Main_Screen_Width, Main_Screen_Height*3);
//            self.SetWorkView.pagingEnabled = YES;
            self.SetWorkView.scrollEnabled = YES;
            [pageViews addObject:self.SetWorkView];
            
            [self createWorkUI];
            [self createHasUI];
            
        }else{
//            diaomaoViewController*diaomao = [[diaomaoViewController alloc] init];
//            [pageViews addObject:diaomao];
            UIView *vief = [[UIView alloc] init];
            [pageViews addObject:vief];
        }
        
    }
    return pageViews;
}
BOOL flag;
- (void)ClickSetWorkBtn{
    
    if (flag) {
        ContentView.hidden = YES;
        PriceView.hidden = YES;
        SendBtn.hidden = YES;
        tableVIew.hidden = NO;
        flag *= -1;
    }else{
        ContentView.hidden = NO;
        PriceView.hidden = NO;
        SendBtn.hidden = NO;
        tableVIew.hidden = YES;
        flag = 1;
    }
}
- (void)createHasUI{
    tableVIew = [[UITableView alloc] initWithFrame:CGRectMake(0, SendBtn.frame.origin.y+SendBtn.frame.size.height + 10, Main_Screen_Width, Main_Screen_Height)];
    tableVIew.delegate = self;
    tableVIew.dataSource = self;
    [self.SetWorkView addSubview:tableVIew];
}
- (void)createWorkUI{
    
    
    //发布任务^
    UIButton *SetWorkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    SetWorkBtn.frame = CGRectMake(10, 10, 80, 40);
    [SetWorkBtn setTitle:@"发布任务" forState:UIControlStateNormal];
    [SetWorkBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [SetWorkBtn addTarget:self action:@selector(ClickSetWorkBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.SetWorkView addSubview:SetWorkBtn];
    
    //内容
    ContentView = [[UIView alloc] initWithFrame:CGRectMake(10, 50, Main_Screen_Width-20, 500)];
    ContentView.userInteractionEnabled = YES;
    ContentView.backgroundColor = [UIColor whiteColor];
    ContentView.layer.cornerRadius = 8;
    ContentView.clipsToBounds = YES;
    
//    ContentView.layer.shadowOffset = CGSizeMake(1, 1);
//    ContentView.layer.shadowColor = kGlobalTitleColor.CGColor;
//    ContentView.layer.shadowRadius = 5;
//    ContentView.layer.shadowOpacity = 1;
    [self.SetWorkView addSubview:ContentView];
    
    //轮播图
//    NSArray*igearr = @[[UIImage imageNamed:@"img_bg"],
//                       [UIImage imageNamed:@"img_bg"],
//                       [UIImage imageNamed:@"img_bg"],
//                       [UIImage imageNamed:@"img_bg"]
//                       ];
//
//    
//    if (scrollimages.count==0||scrollimages==nil) {
//        cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ContentView.frame.size.width, ContentView.frame.size.height/3) imagesGroup:igearr];
//        
//    }else{
//        cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ContentView.frame.size.width, ContentView.frame.size.height/3) imagesGroup:scrollimages];
//        
//        
//    }
//    cycleScrollView.delegate = self;
//    cycleScrollView.autoScrollTimeInterval = 2.5;
//    cycleScrollView.pageControlAliment =SDCycleScrollViewPageContolAlimentCenter;
//    [ContentView addSubview:cycleScrollView];
    self.picArr=[[NSMutableArray alloc]init];
    self.picV = [[QCPicScrollView alloc]init];
    CGSize photosSize=[QCPicScrollView photoViewSizeWithPictureCount:self.picArr.count];
    //    CGSize recordSize=[QCrecordView recordViewSizeWithArrCount:self.recordArr.count];
    
    self.picV.frame=(CGRect){0,15,photosSize.width*self.picArr.count,photosSize.height};
    [ContentView addSubview:self.picV];
    
    //添加“内容“UIImageView
    UIImageView *contentImg = [[UIImageView alloc] initWithFrame:CGRectMake(-8, -8, 70, 40)];
    contentImg.backgroundColor = kGlobalTitleColor;
    contentImg.layer.cornerRadius = 8;
    contentImg.clipsToBounds = YES;
    UILabel *contentText = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 50, 30)];
    contentText.text = @"内容";
    contentText.textColor = [UIColor whiteColor];
    [contentImg addSubview:contentText];
    [ContentView addSubview:contentImg];
    
    
    //添加删除ICON和添加图片ICON
    UIImageView *DeleteIc = [[UIImageView alloc] initWithFrame:CGRectMake(30, cycleScrollView.frame.size.height-80/2, 80, 80)];
    DeleteIc.userInteractionEnabled = YES;
    DeleteIc.image = [UIImage imageNamed:@"fabuicondelete.png"];
    UITapGestureRecognizer *TapDelete = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapDeltBtn)];
    [DeleteIc addGestureRecognizer:TapDelete];
    [ContentView addSubview:DeleteIc];
    UIImageView *AddIc = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-30-80-20, cycleScrollView.frame.size.height-80/2, 80, 80)];
    AddIc.userInteractionEnabled = YES;
    AddIc.image = [UIImage imageNamed:@"fabuicon_Plus.png"];
    UITapGestureRecognizer *TapAddIc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapAddIcBtn)];
    [AddIc addGestureRecognizer:TapAddIc];
    [ContentView addSubview:DeleteIc];
    [ContentView addSubview:AddIc];
    
    //添加详细内容
    
    
    
    //添加价格
    PriceView = [[UIView alloc] initWithFrame:CGRectMake(10, ContentView.frame.size.height + 65, Main_Screen_Width-20, 500)];
    PriceView.userInteractionEnabled = YES;
    PriceView.backgroundColor = [UIColor whiteColor];
    PriceView.layer.cornerRadius = 8;
    PriceView.clipsToBounds = YES;
    [self.SetWorkView addSubview:PriceView];
    
    //添加“价格“UIImageView
    UIImageView *priceImg = [[UIImageView alloc] initWithFrame:CGRectMake(-8, -8, 70, 40)];
    priceImg.backgroundColor = kGlobalTitleColor;
    priceImg.layer.cornerRadius = 8;
    priceImg.clipsToBounds = YES;
    UILabel *priceText = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 50, 30)];
    priceText.text = @"价格";
    priceText.textColor = [UIColor whiteColor];
    [priceImg addSubview:priceText];
    [PriceView addSubview:priceImg];
    
    
    //发布
    SendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    SendBtn.frame = CGRectMake(40, PriceView.frame.size.height+PriceView.frame.origin.y + 30, Main_Screen_Width - 40*2, 50);
    [SendBtn setTitle:@"发布并交10%保证金" forState:UIControlStateNormal];
    SendBtn.backgroundColor = kGlobalTitleColor;
    [SendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    SendBtn.layer.cornerRadius = 25;
    SendBtn.clipsToBounds = YES;
    [self.SetWorkView addSubview:SendBtn];
    
}
#pragma mark - 删除内容图片
- (void)TapDeltBtn{
    ;
}
#pragma mark - 添加图片
- (void)TapAddIcBtn{
    
    NSLog(@"进入");
    QCAddUserMarkVC *add=[[QCAddUserMarkVC alloc]init];
//    add.groupId = [n.userInfo[@"groupId"] integerValue];
//    add.groupType = [n.userInfo[@"groupType"] integerValue];
    [self.navigationController  pushViewController:add animated:YES];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableVIew dequeueReusableCellWithIdentifier:@"fdfdfd"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fdfdfd"];
    }
    return cell;
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
