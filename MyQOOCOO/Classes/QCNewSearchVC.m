//
//  QCNewSearchVC.m
//  MyQOOCOO
//
//  Created by lanou on 16/2/17.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCNewSearchVC.h"
#import "QCHFASViewController.h"
#import "QCHFAdvancedSearchViewController.h"
#import "QCCommonCollectionView.h"
#import "QCSeachCollectionViewCell.h"
#import "QCSearchModel.h"
#import "QCSearchRecommendModel.h"


#import "QCAllSearchTableViewCell.h"


//搜索结果跳转
#import "QCUserViewController2.h"
//#import "QCLunKuViewController.h"
//#import "QCDiandiViewController.h"
//#import "QCFaxiequanViewController.h"
//#import "QCRixingVC.h"
//#import "QCFreeController.h"
#import "QCLunkuDetailListVC.h"
#import "QCDiandiDetailVC.h"
#import "QCDetailDoodleVC.h"

//模型
#import "QCLunkuListModel.h"
#import "QCDiandiListModel.h"
#import "QCDoodleStatus.h"
#import "QCFriendAccout.h"
#import "QCHFUserModel.h"
#import "QCDoodleStatusFrame.h"

//展示的tableView
#import "QCLKCommentTableView.h"
#import "QCDianDiTableView.h"
#import "QCFaXieQuanTableView.h"
#import "QCHFTheUserCell.h"





@implementation QCNewSearchVC
{
    UIScrollView*scrollBaV;
    UIView*animatedV;
    
    NSString*mytype;
    
    UIView*moreV;
    UITextField*tf;
    
    NSArray*titleArr;
    BOOL ismoreOpen;
    
    QCCommonCollectionView* Commoncv;
    
    NSMutableArray*titleArr2;
    
    NSMutableArray*searchUserArr;
    
    UITableView*tableViews;
    
    QCLKCommentTableView*commentTableView;
    QCDianDiTableView*diandiTableView;
    QCFaXieQuanTableView*faxiequanTableView;
    
    
    
    NSMutableArray*_isfriendArr;
     BOOL isFriends;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"搜索";
    self.view.backgroundColor=[UIColor whiteColor ];
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem addBarBtnImg:@"Arrow" highlightedImg:@"Arrow" target:self action:@selector(popToView)];
    
    UIButton*rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.frame=CGRectMake(0, 0, 60, 40);
    rightBtn.font=[UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"高级搜索" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0xed6664) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(touchright) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellClick:) name:kLKCellClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellClick2:) name:kLKCellClickNotification2 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushtoDianDi:) name:@"pushToDianDi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushtoFaxiequan:) name:@"pushToFaXieQuan" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changText:) name:@"changeText" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyBord) name:@"closeKeyBord" object:nil];
    

    tf=[[UITextField alloc]initWithFrame:CGRectMake(10, 74, self.view.frame.size.width-100, 40)];
    tf.backgroundColor=RGBA_COLOR(237, 237, 237, 1);
    tf.placeholder=@"  请输入关键字进行搜索";
    tf.layer.cornerRadius=5;
    tf.layer.masksToBounds=YES;
    tf.delegate=self;
    tf.returnKeyType =UIReturnKeySearch;
    [self.view addSubview:tf];
    
    UIButton*Btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Btn.backgroundColor=[UIColor clearColor];
    Btn.frame=CGRectMake(self.view.frame.size.width-90, 74, 90, 40);
    Btn.font=[UIFont systemFontOfSize:16];
    [Btn setTitle:@"推荐搜索" forState:UIControlStateNormal];
    [Btn setTitleColor:UIColorFromRGB(0xed6664) forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(touchMore) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn];
    
    scrollBaV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 124, 680, 40)];
    
    [self.view addSubview: scrollBaV];
    //设置可滚动范围
//    scrollBaV.contentSize=CGSizeMake(690+self.view.frame.size.width, 0);
    scrollBaV.backgroundColor=RGBA_COLOR(237, 237, 237, 1);
    self.automaticallyAdjustsScrollViewInsets =NO;
    //分页显示
    scrollBaV.pagingEnabled=NO;
    
    //滑动到第一页和最后一页是否允许继续滑动
    
    scrollBaV.bounces=YES;
    
    //取消滚动条
    
    scrollBaV.showsHorizontalScrollIndicator=NO;//水平(横)
    
    scrollBaV.showsVerticalScrollIndicator=NO;//垂直(竖)
    
    //指定代理人
    scrollBaV.delegate=self;
    scrollBaV.contentOffset=CGPointMake(0,0);
    animatedV=[[UIView alloc]init];
    animatedV.backgroundColor=UIColorFromRGB(0xed6664);
    animatedV.layer.cornerRadius=5;
    animatedV.layer.masksToBounds=YES;
    [scrollBaV addSubview:animatedV];


    [self setBtn];
   
    
    UIButton*Btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    [Btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Btn2.backgroundColor=[UIColor colorWithHexString:@"#eaeaea"];
    Btn2.frame=CGRectMake(self.view.frame.size.width-70,124, 70, 40);
    Btn2.font=[UIFont systemFontOfSize:14];
    [Btn2 setTitle:@"展开(13)" forState:UIControlStateNormal];
    [Btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [Btn2 addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn2];

    
    UILabel*bottomLB=[[UILabel alloc]initWithFrame:CGRectMake(10, 164+5,self.view.frame.size.width, 20)];
    bottomLB.text=@"热门推荐";
    bottomLB.textColor=[UIColor grayColor];
    bottomLB.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:bottomLB];
    
    UIView*lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 164+30, self.view.frame.size.width, 0.5)];
    lineview.backgroundColor=[UIColor grayColor];
    [self.view addSubview:lineview];
    
    
   
    
    //创建一个布局类
    UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];
    //设置最小行间距
    layout.minimumLineSpacing=2;
    //这是最小列间距
    layout.minimumInteritemSpacing=2;
    //设置垂直滚动
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    //设置外面上下左右的间距
    layout.sectionInset=UIEdgeInsetsMake(1, 1, 1, 1);
    //借助布局类创建一个UICollectionView
    Commoncv=[[QCCommonCollectionView alloc]initWithFrame:CGRectMake(0, 164+31, self.view.frame.size.width, self.view.frame.size.height-195) collectionViewLayout:layout];
    Commoncv.isSearch=YES;
    

    [self.view addSubview:Commoncv];
    
    [self tableViewinit];
    
    [self moreVinit];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}


-(void)tableViewinit
{
    tableViews=[[UITableView alloc]initWithFrame:CGRectMake(0, 164+5,self.view.frame.size.width, self.view.frame.size.height-170)];
    tableViews.hidden=YES;
    tableViews.delegate =self;
    tableViews.dataSource = self ;
    tableViews.rowHeight = 75;
    tableViews.showsVerticalScrollIndicator = NO;
    tableViews.showsHorizontalScrollIndicator = NO;
    tableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.scrollEnabled = YES;
    tableViews.allowsSelection= YES;
//    tableView.userInteractionEnabled=YES;
//    tableView.bounces=NO;
    //self.contentInset = UIEdgeInsetsMake(12.5, 0, 0, 0);
    tableViews.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableViews];


    commentTableView=[[QCLKCommentTableView alloc]initWithFrame:tableViews.frame];
    commentTableView.hidden=YES;
    [self.view addSubview:commentTableView];

    diandiTableView=[[QCDianDiTableView alloc]initWithFrame:tableViews.frame];
    diandiTableView.hidden=YES;
    [self.view addSubview:diandiTableView];


    faxiequanTableView=[[QCFaXieQuanTableView alloc]initWithFrame:tableViews.frame style:UITableViewStylePlain];
    faxiequanTableView.hidden=YES;
    [self.view addSubview:faxiequanTableView];



}

-(void)moreVinit
{

    moreV=[[UIView alloc]initWithFrame:CGRectMake(5, 165, self.view.frame.size.width-10, 130)];
    moreV.backgroundColor=[UIColor whiteColor];
    moreV.layer.borderWidth=1;
    moreV.hidden=YES;
    moreV.layer.borderColor=[UIColor colorWithHexString:@"#efefef"].CGColor;
    [self.view addSubview:moreV];
    
    //UICollectionView
    //创建一个布局类
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //设置最小行间距
    layout.minimumLineSpacing=2;
    //这是最小列间距
    layout.minimumInteritemSpacing=2;
    //设置垂直滚动
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    //设置外面上下左右的间距
    layout.sectionInset=UIEdgeInsetsMake(1, 1, 1, 1);
    //借助布局类创建一个UICollectionView
    UICollectionView*morecv=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, moreV.bounds.size.width, moreV.bounds.size.height) collectionViewLayout:layout];
    
    //注册cell UICollectionView的cell必须注册
    [morecv registerClass:[QCSeachCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    //注册header
    [morecv registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    
    //设置代理
    morecv.delegate=self;
    morecv.dataSource=self;
    morecv.backgroundColor=[UIColor whiteColor];
    [moreV addSubview:morecv];
}

-(void)setBtn
{
    titleArr=[[NSArray alloc]initWithObjects:@"基本信息",@"交友标签",@"粉丝标签",@"我要派活",@"我要接活",@"处号",@"手机号",@"昵称",@"论库",@"自由人",@"点滴",@"发泄圈",@"好友", nil];
    NSInteger btnWhit = 0;
    for (int i=0; i<titleArr.count; i++) {
        UIButton*Btn=[UIButton buttonWithType:UIButtonTypeCustom];
        Btn.backgroundColor=[UIColor clearColor];
        Btn.tag=i;
        NSString*str=titleArr[i];
        if (str.length==2) {
                    Btn.frame=CGRectMake(btnWhit, 0, 40, 40);
            btnWhit=btnWhit+40;

        }else if(str.length==3){
        
           
        Btn.frame=CGRectMake(btnWhit, 0, 50, 40);
             btnWhit=btnWhit+50;
        }else if(str.length==4){
            
        Btn.frame=CGRectMake(btnWhit, 0, 70, 40);
            btnWhit=btnWhit+70;
        }
        
        Btn.font=[UIFont systemFontOfSize:14];
        [Btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [Btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [Btn addTarget:self action:@selector(touchType:) forControlEvents:UIControlEventTouchUpInside];
        [scrollBaV addSubview:Btn];
        
 
    }
   
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    if (width==375) {
       scrollBaV.contentSize=CGSizeMake(btnWhit+width, 0);
    }else{
        scrollBaV.contentSize=CGSizeMake(btnWhit+375+70, 0);
    }
    NSLog(@"%ld",(long)btnWhit);
}
-(void)touchType:(UIButton*)Btn
{
    for (UIButton*bt in scrollBaV.subviews) {
        if ([bt isKindOfClass:[UIButton class] ]) {
            
        
        if (bt!=Btn) {
            [bt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        }
    }
    
    mytype=Btn.titleLabel.text;
    
    switch (Btn.tag) {
        case 0:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(0, 5, 70, 30);
            }];
        }
            break;
        case 1:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(70, 5, 70, 30);
            }];
        }
            break;
        case 2:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(140, 5, 70, 30);
            }];
        }
            break;
        case 3:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(210, 5, 70, 30);
            }];
        }
            break;
        case 4:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(280, 5, 70, 30);
            }];
        }
            break;
        case 5:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(350, 5, 40, 30);
            }];
        }
            break;
        case 6:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(390, 5, 50, 30);
            }];
        }
            break;
        case 7:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(440, 5, 40, 30);
            }];
        }
            break;
        case 8:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(480, 5, 40, 30);
            }];
        }
            break;
        case 9:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(520, 5, 50, 30);
            }];
        }
            break;
        case 10:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(570, 5, 40, 30);
            }];
        }
            break;
          case 11:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(610, 5, 50, 30);
            }];
        }
            break;
        case 12:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(660, 5, 40, 30);
            }];
        }
            break;
        default:
            break;
    }

    [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (tf.text.length>0) {
        [self getSearchData];
        tableViews.hidden=YES;
        commentTableView.hidden=YES;
        faxiequanTableView.hidden=YES;
        diandiTableView.hidden=YES;

    }else{

    [self searchRecommendData ];
    }
    [UIView animateWithDuration:0.3 animations:^{
        moreV.alpha=0.0;
    } completion:^(BOOL finished) {
        moreV.hidden=YES;
        
    }];
    ismoreOpen=NO;

//     [tf resignFirstResponder];
    
    tableViews.hidden=YES;
    commentTableView.hidden=YES;
    faxiequanTableView.hidden=YES;
    diandiTableView.hidden=YES;
}



-(void)touchright
{
    QCHFASViewController * vc = [[QCHFASViewController alloc] init];
    vc.title = @"高级搜索";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)touchMore
{

    QCHFAdvancedSearchViewController *vc=[[QCHFAdvancedSearchViewController alloc]init];
    vc.title=@"推荐搜索";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showMore
{
    if (ismoreOpen==NO) {
        
        moreV.hidden=NO;
        [UIView animateWithDuration:0.3 animations:^{
            moreV.alpha=1.0;
        }];
        ismoreOpen=YES;
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            moreV.alpha=0.0;
        } completion:^(BOOL finished) {
            moreV.hidden=YES;
            
        }];
        ismoreOpen=NO;
        
    }

     [tf resignFirstResponder];
}

-(void)popToView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark 网络请求
-(void)searchRecommendData
{

    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"type"]=mytype;//
    

    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:searchSurport parameter:dic success:^(id response) {
        NSArray*tempArr=[NSArray arrayWithArray:response];
        titleArr2=[[NSMutableArray alloc]init];
                for (int i=0; i<tempArr.count; i++) {
                QCSearchRecommendModel *model=[[QCSearchRecommendModel alloc]init];
                model=[QCSearchRecommendModel mj_objectWithKeyValues:tempArr[i]];
                [titleArr2 addObject:model.key];
                    
                }

        Commoncv.textArr=titleArr2;
        [Commoncv reloadData];
        tableViews.hidden=YES;
        
        [MBProgressHUD hideHUD];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];


}

-(void)getSearchData
{
    searchUserArr=[[NSMutableArray alloc]init];
//    “点滴”：返回点滴列表record，详情见6.1；
//    “发泄圈”：返回发泄圈列表topic，详见5.2；
//    “自由人”：返回自由人列表work，详见17.1；
//    “论库”：返回论库列表forum，详见7.1；
//    “日省”：返回日省项和该日省项的记录值day_log,详见8.1；
//    其他返回用户信息user_info，返回值字段参照10.1

    if (mytype!=nil) {
        
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    //    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    //
    dic[@"type"]=mytype;//
    dic[@"key"]=tf.text;

    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:allSearch parameter:dic success:^(id response) {
        NSLog(@"%@",response);
        
        
        if ([mytype isEqualToString:@"自由人"]||[mytype isEqualToString:@"论库"]) {
             NSMutableArray*arr=[NSMutableArray array];
            if ([mytype isEqualToString:@"自由人"]) {
                commentTableView.isfree=YES;
                 arr= [QCLunkuListModel mj_objectArrayWithKeyValuesArray:response[@"work"]];
            }else{
                commentTableView.isfree=NO;
                arr= [QCLunkuListModel mj_objectArrayWithKeyValuesArray:response[@"forum"]];
            }
        
                commentTableView.arr=arr;
                if (arr.count>0) {
                    [tf resignFirstResponder];
        
                commentTableView.hidden=NO;
                [commentTableView reloadData];
                }else {
                commentTableView.hidden=YES;
                }

        }else if ([mytype isEqualToString:@"点滴"]){
            NSMutableArray*arr=[NSMutableArray array];
            
            arr= [QCDiandiListModel mj_objectArrayWithKeyValuesArray:response[@"record"]];
            diandiTableView.modelArr=arr;
            if (arr.count>0) {
                 [tf resignFirstResponder];
                diandiTableView.hidden=NO;
                [diandiTableView reloadData];
            }else {
                diandiTableView.hidden=YES;
            }
        }else if ([mytype isEqualToString:@"日省"]){
            
        }
        else if ([mytype isEqualToString:@"发泄圈"]){
        
            NSMutableArray*arr=[NSMutableArray array];
            
            arr= [QCDoodleStatus mj_objectArrayWithKeyValuesArray:response[@"topic"]];
            
            if (arr.count>0) {
                 [tf resignFirstResponder];
                NSArray *newFrames = [self stausFramesWithStatuses:arr];
                //把模型数组转为frame数组
//                    [faxiequanTableView.doodleStatusFrames addObjectsFromArray:newFrames];
                faxiequanTableView.doodleStatusFrames=[newFrames mutableCopy];
                faxiequanTableView.hidden=NO;
                    [faxiequanTableView reloadData];
            }else {
               faxiequanTableView.hidden=YES;
                
            }
        }else{
            _isfriendArr=[[NSMutableArray alloc]init];
            
            searchUserArr= [QCHFUserModel mj_objectArrayWithKeyValuesArray:response[@"user_info"]];
            if (searchUserArr.count>0) {
                for (int i=0; i<searchUserArr.count; i++) {
                    QCHFUserModel*model=searchUserArr[i];
                    [ _isfriendArr addObject:model.isFriends];
                }
                tableViews.hidden=NO;
                [tableViews reloadData];
            }else {
                tableViews.hidden=YES;
            }
        }

        [MBProgressHUD hideHUD];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];

    }else{
    
        [OMGToast  showText:@"请选择一个类型"];
    }
}

// 将HWStatus模型转为HWStatusFrame模型
- (NSArray *)stausFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray *frames = [NSMutableArray array];
    for (QCDoodleStatus *status in statuses) {
        QCDoodleStatusFrame *f = [[QCDoodleStatusFrame alloc] init];
        f.qcStatus = status;
        [frames addObject:f];
    }
    return frames;
}




#pragma -mark UICollectionView 的代理方法
//多少小方块
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return titleArr.count;
}

//item什么样子

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QCSeachCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.imagev.image=[UIImage imageNamed:@"but_search"];
    cell.lb.text=titleArr[indexPath.row];
    return cell;
}


//控制每个小方块的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((moreV.bounds.size.width-12)/4, 30);
    
}


//点击的低级分区的第几个item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"你点击了第%ld分区的第%ld个item",(long)indexPath.section,(long)indexPath.row);
     [tf resignFirstResponder];
    
    for (UIButton*bt in scrollBaV.subviews) {
        if ([bt isKindOfClass:[UIButton class] ]) {
            
            
//            if (bt!=Btn) {
//                [bt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//            }
            if (bt.tag==indexPath.row) {
                
            
            [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else{
            [bt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }

        }
    }
    
    mytype=titleArr[indexPath.row];
    
    switch (indexPath.row) {
        case 0:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(0, 5, 70, 30);
            }];
            
        }
            break;
        case 1:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(70, 5, 70, 30);
            }];
        }
            break;
        case 2:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(140, 5, 70, 30);
            }];
            
        }
            
            break;
        case 3:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(210, 5, 40, 30);
            }];
            
        }
            
            break;
        case 4:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(250, 5, 40, 30);
            }];
        }
            
            break;
        case 5:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(290, 5, 40, 30);
            }];
        }
            
            break;
        case 6:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(330, 5, 50, 30);
            }];
        }
            
            break;
        case 7:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(380, 5, 40, 30);
            }];
        }
            
            break;
        case 8:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(420, 5, 40, 30);
            }];
        }
            
            break;
        case 9:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(460, 5, 50, 30);
            }];
        }
            
            break;
        case 10:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(510, 5, 40, 30);
            }];
        }
            
            break;
        case 11:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(550, 5, 50, 30);
            }];
        }
            
            break;
        case 12:
        {
            [UIView animateWithDuration:0.2 animations:^{
                animatedV.frame=CGRectMake(600, 5, 40, 30);
            }];
        }
            
            
            break;
//        case 13:
//        {
//            [UIView animateWithDuration:0.2 animations:^{
//                animatedV.frame=CGRectMake(640, 5, 40, 30);
//            }];
//        }
//            
//            
//            break;
            
        default:
            break;
    }
    
    
    [self searchRecommendData ];

    [UIView animateWithDuration:0.3 animations:^{
        moreV.alpha=0.0;
    } completion:^(BOOL finished) {
        moreV.hidden=YES;
        
    }];
    ismoreOpen=NO;
    
    tableViews.hidden=YES;
    commentTableView.hidden=YES;
    faxiequanTableView.hidden=YES;
    diandiTableView.hidden=YES;

    
}
#pragma mark - uitextField的代理方法

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    [self getSearchData];
    tableViews.hidden=YES;
    commentTableView.hidden=YES;
    faxiequanTableView.hidden=YES;
    diandiTableView.hidden=YES;

    return YES;
}



-(void)changText:(NSNotification*)n
{
    tf.text = titleArr2[[n.userInfo[@"index"] integerValue]];
    [self getSearchData];
}

#pragma mark - tableview的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return searchUserArr.count;


}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QCHFTheUserCell * cell = [QCHFTheUserCell QCHFTheUserCell:tableViews];
    
    if (searchUserArr.count > 0) {
        QCFriendAccout * models = searchUserArr[indexPath.row];
        [cell.avatarUrlImage sd_setImageWithURL:[NSURL URLWithString:models.avatarUrl] placeholderImage:[UIImage imageNamed:@"icon"]];
        cell.nicknameLabel.text = models.nickname;
        if ([_isfriendArr[indexPath.row] boolValue]) {
            cell.isFriendBu.selected = YES;
        }
        else
        {
            cell.isFriendBu.selected = NO;
        }
        cell.isFriendBu.tag = indexPath.row;
        
        if (models.marks.length > 0) {
            NSArray * markArr = [models.marks componentsSeparatedByString:@","];
            
            if (markArr.count > 2) {
                cell.marksLabel1.text = markArr[markArr.count-1];
                cell.marksLabel2.text = markArr[markArr.count-2];
                cell.marksLabel3.text = markArr[markArr.count-3];
            }
            else if (markArr.count > 1)
            {
                cell.marksLabel1.text = markArr[markArr.count-1];
                cell.marksLabel2.text = markArr[markArr.count-2];
            }
            else
            {
                cell.marksLabel1.text = markArr[0];
            }
            
            if (cell.marksLabel1.text.length < 1) {
                cell.markView1.hidden = YES;
            }
            if (cell.marksLabel2.text.length < 1) {
                cell.markView2.hidden = YES;
            }
            if (cell.marksLabel3.text.length < 1) {
                cell.markView3.hidden = YES;
            }
        }
        else
        {
            cell.markView1.hidden = YES;
            cell.markView2.hidden = YES;
            cell.markView3.hidden = YES;
        }
        
        [cell.isFriendBu actionButton:^(UIButton *sender){
#pragma -mark 根据判断数组,获取对应的 BOOL 值
            isFriends = [_isfriendArr[cell.isFriendBu.tag] boolValue];
            
            if (isFriends)
            {
                [self isfriendRemoveAction:models button:cell.isFriendBu];
            }
            else
            {
                [self isfriendAddAction:models button:cell.isFriendBu];
            }
            
        }];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",(long)indexPath.row);
    QCUserViewController2*user=[[QCUserViewController2 alloc]init];
    QCHFUserModel*um=searchUserArr[indexPath.row] ;
    user.uid =[um.uid longLongValue];
    user.isFriend=[_isfriendArr[indexPath.row] boolValue];
    [self.navigationController pushViewController:user animated:YES];
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [tf resignFirstResponder];
}

#pragma -mark 关注
- (void)isfriendAddAction:(QCFriendAccout *)model button:(UIButton *)bu
{
    NSMutableDictionary * dics = [NSMutableDictionary dictionary];
    dics[@"destUids"] = model.uid;
    
#pragma -mark 一旦 BOOL 值有改变,通过 button的 tag标记数组里对应的下标进行替换数组的元素
    bu.selected = YES;
    isFriends = YES;
    
    [NetworkManager requestWithURL:FRIEND_ADD parameter:dics success:^(id response) {
        [_isfriendArr replaceObjectAtIndex:bu.tag withObject:[NSNumber numberWithBool:isFriends]];
        //        [self searchDownData];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        NSLog(@"错误信息%@",error);
        [OMGToast showText:@"关注失败"];
        bu.selected = NO;
        isFriends = NO;
    }];
}

#pragma -mark 取消关注
- (void)isfriendRemoveAction:(QCFriendAccout *)model button:(UIButton *)bu
{
    NSMutableDictionary * dics = [NSMutableDictionary dictionary];
    dics[@"destUids"] = model.uid;
    
    bu.selected = NO;
    isFriends = NO;
    
    [NetworkManager requestWithURL:FRIEND_REMOVEFOCUS parameter:dics success:^(id response) {
        NSLog(@"%@",response);
        [_isfriendArr replaceObjectAtIndex:bu.tag withObject:[NSNumber numberWithBool:isFriends]];
        //        [self searchDownData];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        NSLog(@"错误信息%@",error);
        [OMGToast showText:@"取消失败"];
        bu.selected = YES;
        isFriends = YES;
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)cellClick:(NSNotification*)n{
    QCLunkuDetailListVC * detailVC = [[QCLunkuDetailListVC alloc]init];
    detailVC.lk = n.userInfo[@"model"];
    detailVC.isFree=NO;
//    detailVC.isRoot = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)cellClick2:(NSNotification*)n{
    QCLunkuDetailListVC * detailVC = [[QCLunkuDetailListVC alloc]init];
    detailVC.lk = n.userInfo[@"model"];
    detailVC.isFree=YES;
//    detailVC.isRoot = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)pushtoDianDi:(NSNotification*)n
{

    QCDiandiDetailVC *VC = [[QCDiandiDetailVC alloc] init];
    VC.dianDi = n.userInfo[@"model"];
    [self.navigationController pushViewController:VC animated:YES];

}

-(void)pushtoFaxiequan:(NSNotification*)n
{
        QCDetailDoodleVC *detailStatusVC = [[QCDetailDoodleVC alloc]init];
        QCDoodleStatusFrame *qcstatusF = n.userInfo[@"model"];
        detailStatusVC.qcStatus = qcstatusF.qcStatus;
        [self.navigationController pushViewController:detailStatusVC animated:YES];


}

-(void)closeKeyBord
{
[tf resignFirstResponder];
}


//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    if (![tf isExclusiveTouch]) {
//        [tf resignFirstResponder];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
