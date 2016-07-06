//
//  QCProfileViewController.m
//  MyQOOCOO
//
//  Created by lanou on 15/12/25.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCProfileViewController.h"
#import "QCCollectionV.h"
#import "User.h"
#import "QCDiandiViewController.h"
#import "QCFaxiequanViewController.h"
#import "QCLunKuViewController.h"
#import "QCAddUserMarkVC.h"
#import "QRcodeVC.h"
#import "QCUserDataVC.h"
#import "QCTextVC.h"
//#import "MPMoviePlayerViewController.h"

#import "LBXScanView.h"
#import "PopViewController.h"
#import "QCGroupListVC.h"
#import "QCShakeViewController.h"
#import "QCEncounterViewController.h"
#import "QCStarViewController.h"
#import "QCSingleTVC.h"
#import "QCScanViewController.h"
#import "QCHFAdvancedSearchViewController.h"

#import "QCNewSearchVC.h"


#import "QCFreeController.h"

#import "QCSearchViewController.h"




@interface QCProfileViewController ()
{


    UIScrollView*scrollBaV;
    UIView * bgViews;
    UIImageView*userHead;//用户头像
    UILabel*userName;//用户名
    UILabel*userNum;//处号
    UIImageView*userigev;//用户图
     UIButton *infoView;
    UIImageView*sexImage;
    
    
    UIView*popBox;
    UIView*popView;
    
    UIView*addTig;
    PopViewController *_popVC;
    
    UIView*userphoto;
    
    
}

@end

@implementation QCProfileViewController


-(void)viewWillAppear:(BOOL)animated
{
     self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    sectionheader文字
    mySectionArr = [NSMutableArray array];
    //    每个section展开收起状态标识符
    openedInSectionArr = [NSMutableArray array];
    
    
    self.personMarkArr=[NSMutableArray array];
    self.userMarkArr=[NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushtoAdd:) name:@"CVpush" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commturns) name:@"commturn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushtovoide:) name:@"CVpushToVoide" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushtotext:) name:@"CVpushToText" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteTags:) name:@"delete" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changFace) name:@"changFace" object:nil];
    
    [self showView];
    [self getData];
    [self userLabelled ];
}

-(void)showView
{

    if (self.isRootVC) {
        self.title=@"贴标签";
        //    //初始化右边按钮
        //    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addBarBtnImg:@"add3" highlightedImg:@"add3" target:self action:@selector(addMore:)];
        //
        //
        //    //初始化左边按钮
        //    self.navigationItem.leftBarButtonItem = [UIBarButtonItem addBarBtnImg:@"icon_sousuo" highlightedImg:@"icon_sousuo" target:self action:@selector(searchMarkUser:)];
        
        
        UIView*topv=[[UIView alloc]init];
        topv.frame=CGRectMake(0, 0, self.view.frame.size.width, 64);
        self.navigationItem.titleView=topv;
        
        
        UILabel*titleLb=[[UILabel alloc]initWithFrame:CGRectMake((topv.bounds.size.width-90)/2, (topv.frame.size.height-30)/2, 90, 30)];
        titleLb.text=@"贴标签";
        titleLb.textColor=UIColorFromRGB(0xed6664);
        titleLb.textAlignment=NSTextAlignmentCenter;
        [topv addSubview:titleLb];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *normalImg = [UIImage imageNamed:@"icon_sousuo"];
        [btn setImage:normalImg forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_sousuo"] forState:UIControlStateHighlighted];
        
        btn.frame = CGRectMake(topv.frame.size.width-120, (topv.frame.size.height-60)/2,60, 60);
        [btn addTarget:self action:@selector(searchMarkUser:) forControlEvents:UIControlEventTouchUpInside];
        
        [topv addSubview:btn];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *normalImg2 = [UIImage imageNamed:@"add3"];
        
        [btn2 setImage:normalImg2 forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"add3"] forState:UIControlStateHighlighted];
        
        btn2.frame = CGRectMake(topv.frame.size.width-60, (topv.frame.size.height-30)/2, 30, 30);
        [btn2 addTarget:self action:@selector(addMore:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [topv addSubview:btn2];

    }else{
    
    self.navigationItem.title = @"个人资料";
    }
    
    
    scrollBaV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*5)];
    [self.view addSubview: scrollBaV];
    //设置可滚动范围
//    scrollBaV.contentSize=CGSizeMake(0, self.view.frame.size.height);
    
    scrollBaV.backgroundColor=self.view.backgroundColor;
    
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
    
    
    
    //一开始显示到第几张
    scrollBaV.contentOffset=CGPointMake(0,0);

    
    [self showTopView];
    [self showTableV];
    // Do any additional setup after loading the view.
}
-(void)showTableV
{
    
    
    TBframe=CGRectMake(0, self.view.frame.size.height/3+ 20, scrollBaV.bounds.size.width, tbH);
    
    bottomTb=[[UITableView alloc]initWithFrame:TBframe style:UITableViewStylePlain];
    bottomTb.backgroundColor=[UIColor whiteColor];
    bottomTb.delegate=self;
    bottomTb.dataSource=self;
    bottomTb.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [bottomTb setSeparatorInset:UIEdgeInsetsZero];
    bottomTb.allowsSelection= NO;
    bottomTb.scrollEnabled =NO;
    bottomTb.separatorColor=[UIColor clearColor];
    [scrollBaV addSubview:bottomTb];
    
   
    
    
    addTig=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/3+ 20+tbH+ 10, scrollBaV.bounds.size.width, 37)];
    addTig.backgroundColor=[UIColor whiteColor];
    [scrollBaV addSubview:addTig];
    
    UIImageView*addTigImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, ( addTig.bounds.size.height-18)/2, 18, 18)];
    addTigImage.image=[UIImage imageNamed:@"add1"];
    [addTig addSubview:addTigImage];
    
    UILabel*lb=[[UILabel alloc]initWithFrame:CGRectMake(10+addTig.bounds.size.height, 0, addTig.bounds.size.width/2, addTig.bounds.size.height)];
    lb.font=[UIFont systemFontOfSize:16];
    lb.text=@"添加自创类";
    [addTig addSubview:lb];
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addTapView:)];
    tap.numberOfTapsRequired =1;
    [addTig addGestureRecognizer:tap];


}


-(void)showTopView
{
    userphoto=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3)];
    [scrollBaV addSubview:userphoto];
    userigev=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, userphoto.bounds.size.width, userphoto.bounds.size.height)];
    userigev.image=[UIImage imageNamed:@"img_bg"];
    [userphoto addSubview:userigev];
    
    
    userHead=[[UIImageView alloc]initWithFrame:CGRectMake((userphoto.bounds.size.width-(userphoto.bounds.size.height/5*2))/2, 10, 89,89)];
    
   
    userHead.image=[UIImage imageNamed:@"login_user_default_logo"];
    //userHead.backgroundColor=[UIColor redColor];
    userHead.layer.cornerRadius=45;
    userHead.layer.masksToBounds=YES;
    userHead.backgroundColor=[UIColor clearColor];
    userHead.userInteractionEnabled=YES;
    [userphoto addSubview:userHead];
    
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchuserHead:)];
    tap.numberOfTapsRequired =1;
    [userHead addGestureRecognizer:tap];

    
    
    //性别,年龄
    infoView = [[UIButton alloc]initWithFrame:CGRectMake(MaxX(userHead)-WIDTH(userHead)/3, CGRectGetMaxY(userHead.frame) - HEIGHT(userHead)/4, (HEIGHT(userHead)/4)*2.5, HEIGHT(userHead)/4)];
    
    infoView.backgroundColor = kColorRGBA(219, 89, 92, 1);
    infoView.layer.masksToBounds = YES;
    infoView.layer.cornerRadius = HEIGHT(infoView)/2;
    infoView.layer.borderWidth = 1;
    infoView.layer.borderColor = kColorRGBA(255, 255, 255, 1).CGColor;
    [infoView setTitle:@"已认证" forState:UIControlStateNormal];
    infoView.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(infoView)*3/5];
    [userphoto addSubview:infoView];

    
    
    
    
    
    
    userName=[[UILabel alloc]init];
//              WithFrame:CGRectMake(0, userphoto.bounds.size.height/5*2+20+5, userName.text.length*15, 14)];
    userName.text=@"";
    userName.textColor=[UIColor whiteColor];
    userName.font=[UIFont systemFontOfSize:14];
    userName.textAlignment=NSTextAlignmentCenter;
    [userphoto addSubview:userName];
    
    
    
    
    sexImage=[[UIImageView alloc]init];
//              WithFrame:CGRectMake(userName.text.length*15,userphoto.bounds.size.height/5*2+20+5, 14, 14)];
    sexImage.userInteractionEnabled=YES;
    sexImage.backgroundColor=[UIColor clearColor];
    [userphoto addSubview:sexImage];

    
    
    userNum=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/3-47-34+5, self.view.bounds.size.width, 14)];
    userNum.text=@"处号:";
    userNum.textColor=[UIColor whiteColor];
    userNum.font=[UIFont systemFontOfSize:14];
    userNum.textAlignment=NSTextAlignmentCenter;
    [userphoto addSubview:userNum];

    
    UIButton*scanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    scanBtn.frame=CGRectMake(scrollBaV.bounds.size.width-40, 10, 30, 30);
    [scanBtn setImage:[UIImage imageNamed:@"LJ_code"] forState:UIControlStateNormal];

    [scanBtn addTarget:self action:@selector(scanBtnCliack) forControlEvents:UIControlEventTouchUpInside];
    [scrollBaV addSubview:scanBtn];

    
    //背景View
    bgViews = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/3-47, self.view.frame.size.width, 47)];
    bgViews.backgroundColor = UIColorFromRGB(0x583A3D);
    [scrollBaV addSubview:bgViews];
    bgViews.alpha=0.5;
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/3-47, self.view.frame.size.width, 47)];
    bgView.backgroundColor = [UIColor clearColor];
    [scrollBaV addSubview:bgView];
   

    
    NSArray*igeArr=[NSArray arrayWithObjects:@"but_diandi",@"nuhouquan",@"lunku",@"but_gf",@"icon_white_zyr", nil];
    NSArray*titleArr=[NSArray arrayWithObjects:@"点滴",@"发泄圈",@"论库",@"好友",@"自由人", nil];
    for (int i=0; i<5; i++) {
        UIView*tempv=[[UIView alloc]initWithFrame:CGRectMake(bgView.bounds.size.width/5*i, 0, bgView.bounds.size.width/5, bgView.bounds.size.height)];
        tempv.tag=i;
        [bgView addSubview:tempv];
        
        tempv.userInteractionEnabled=YES;
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
        tap.numberOfTapsRequired =1;
        [tempv addGestureRecognizer:tap];
        
        UIImageView*tempigev=[[UIImageView alloc]initWithFrame:CGRectMake((tempv.bounds.size.width-(tempv.bounds.size.height/2))/2,0, tempv.bounds.size.height/2, tempv.bounds.size.height/2)];
        tempigev.image=[UIImage imageNamed:igeArr[i]];
        [tempv addSubview:tempigev];
        
        UILabel*templb=[[UILabel alloc]initWithFrame:CGRectMake(0, tempv.bounds.size.height/2,tempv.bounds.size.width, tempv.bounds.size.height/2)];
        templb.text=titleArr[i];
        templb.textColor=[UIColor whiteColor];
        templb.textAlignment=NSTextAlignmentCenter;
        templb.font=[UIFont systemFontOfSize:14];
        [tempv addSubview:templb];
        
    }
    
    
    
}

-(void)addTapView:(UITapGestureRecognizer *)tapGestureRecognizer
{
    NSLog(@"添加");
    [self popUpBox];
}

- (void)tapView:(UITapGestureRecognizer *)tapGestureRecognizer
{
    QCDiandiViewController*dian;
    QCFaxiequanViewController*faxie;
    QCLunKuViewController*lunku;
    
    if (tapGestureRecognizer.view.tag==0) {
        NSLog(@"点滴");
        dian=[[QCDiandiViewController alloc]init];
        LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
        dian.uid=[NSString stringWithFormat:@"%ld",sessions.user.uid];
        [self.navigationController pushViewController:dian animated:YES];
    } else if (tapGestureRecognizer.view.tag==1){
        NSLog(@"怒吼");
        faxie=[[QCFaxiequanViewController alloc]init];
        LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
        faxie.uid=[NSString stringWithFormat:@"%ld",sessions.user.uid];
        [self.navigationController pushViewController:faxie animated:YES];

    }else if (tapGestureRecognizer.view.tag==2){
        NSLog(@"轮库");
        lunku=[[QCLunKuViewController alloc]init];
        LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
        lunku.uid=[NSString stringWithFormat:@"%ld",sessions.user.uid];

        [self.navigationController pushViewController:lunku  animated:YES];

    }else if (tapGestureRecognizer.view.tag==3){
        NSLog(@"好友");
        
//        [self.navigationController popToRootViewControllerAnimated:YES];
        self.tabBarController.selectedIndex = 1;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HFUserPushGroupList" object:
         @"1"];
    }else if (tapGestureRecognizer.view.tag==4){
        NSLog(@"自由人");
    
//        self.tabBarController.selectedIndex = 0;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"HFUserPushGroupList" object:
//         @"1"];
        {
             LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
            QCFreeController*vc=[[QCFreeController alloc]init];
            vc.isBlack=YES;
            vc.uid=sessions.user.uid;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark
-(void)scanBtnCliack
{
    NSLog(@"扫");

    QRcodeVC*code=[[QRcodeVC alloc]init];
    code.isType=NO;
    [self.navigationController pushViewController:code animated:YES];
}


#pragma -mark tableview的代理方法

//section头高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 57;
}

//section头内容
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView*header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 57)];
    header.backgroundColor=[UIColor whiteColor];
    header.tag = 100 + section;
    
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [longPressGestureRecognizer addTarget:self action:@selector(popDeleteBox:)];
    [longPressGestureRecognizer setMinimumPressDuration:2];
    [longPressGestureRecognizer setAllowableMovement:50.0];
    [header addGestureRecognizer:longPressGestureRecognizer];

    
    
    UILabel*myLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width/5, 57)];
    myLable.text=mySectionArr[section];
    myLable.font=[UIFont systemFontOfSize:13];
    myLable.backgroundColor=[UIColor clearColor];
    
    myLable.textColor=[UIColor blackColor];
    [header addSubview:myLable];
    
    sectionimagev=[[UIImageView alloc]initWithFrame:CGRectMake(header.bounds.size.width-30,(header.bounds.size.height-20)/2,20,20)];
    
        
     if (section!=2) {
    UIButton*OthersBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [OthersBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    OthersBtn.frame=CGRectMake(header.bounds.size.width-30-(self.view.frame.size.width/5), 0, self.view.frame.size.width/5, 57);
    [OthersBtn setTitle:@"设置权限" forState: UIControlStateNormal];
   
    if (self.personMarkArr.count>0) {
        QCPersonMarkModel*data=self.personMarkArr[section];
            
    
        OthersBtn.tag=data.Id;
       }
    
    [OthersBtn setTitleColor:RGBA_COLOR(118, 168, 244, 1) forState: UIControlStateNormal];
    OthersBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [OthersBtn addTarget:self action:@selector(OthersBtn:) forControlEvents:UIControlEventTouchUpInside];
    //OthersBtn.backgroundColor=[UIColor redColor];
    [header addSubview:OthersBtn];
    
    
     }
    
    if ([[openedInSectionArr objectAtIndex:section] intValue] == 1) {
        
        
        sectionimagev.image=[UIImage imageNamed:@"but_down-arrow"];
        
        
    }else{
        sectionimagev.image=[UIImage imageNamed:@"but_uparrow"];
        
        
    }
    
    [header addSubview:sectionimagev];
    
    UIView*line=[[UIView alloc]initWithFrame:CGRectMake(0, -0.5, header.bounds.size.width, 0.5)];
    line.backgroundColor=self.view.backgroundColor;
    [header addSubview:line];
    
    
    UIView*line2=[[UIView alloc]initWithFrame:CGRectMake(0, header.bounds.size.height-0.5, header.bounds.size.width, 0.5)];
    line2.backgroundColor=self.view.backgroundColor;
    [header addSubview:line2];
    
    UITapGestureRecognizer*singleRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    singleRecognizer.numberOfTapsRequired=1;
    [singleRecognizer setNumberOfTouchesRequired:1];
    [header addGestureRecognizer:singleRecognizer];
    
    
    return header;
    
}


#pragma mark 展开收缩section中cell 手势监听
-(void)singleTap:(UITapGestureRecognizer*)recognizer
{
    NSLog(@"点点点");
    NSInteger didSection=recognizer.view.tag;
    
    tbH=bottomTb.frame.size.height;
    NSMutableArray*temparr2 =[self.userMarkArr[didSection - 100] mutableCopy];
    float a=temparr2.count/3;
    float heights;
    if (didSection - 100==2) {
        [temparr2 removeLastObject];
        
    }

    if (a<1) {
        if (temparr2.count>0) {
            heights = 170;
        }else {
            
            heights = 0;
        }
    }else {
        if (temparr2.count%3!=0&&temparr2.count>3) {
            heights = 170*(int)a+170;
        }else{
           heights = 170*(int)a;
        }
    }
    
   
    CGSize size=scrollBaV.contentSize;
    
    
    
    if ([[openedInSectionArr objectAtIndex:(int)didSection - 100] intValue] == 0) {
        [openedInSectionArr replaceObjectAtIndex:didSection - 100 withObject:@"1"];
        NSLog(@"%ld打开",didSection);
        
        [bottomTb  reloadSections: [NSIndexSet indexSetWithIndex:didSection-100] withRowAnimation:UITableViewRowAnimationNone];
        
        [UIView animateWithDuration:0.2 animations:^{
            
           
                
                bottomTb.frame=CGRectMake(0, self.view.frame.size.height/3+ 20, scrollBaV.bounds.size.width, tbH+heights);
                [bottomTb reloadData];
                addTig.frame=CGRectMake(0,self.view.frame.size.height/3+ 20+tbH+heights+10, scrollBaV.bounds.size.width, 37);

               
                
             scrollBaV.contentSize=CGSizeMake(0, size.height+heights);
            
            
        }];
        
    }
    else
    {
        [openedInSectionArr replaceObjectAtIndex:(int)didSection - 100 withObject:@"0"];
        NSLog(@"%ld关闭",didSection);
        
        
        
        [bottomTb reloadSections:[NSIndexSet indexSetWithIndex:didSection-100] withRowAnimation:UITableViewRowAnimationNone];
        [UIView animateWithDuration:0.2 animations:^{
            
            bottomTb.frame=CGRectMake(0, self.view.frame.size.height/3+ 20, scrollBaV.bounds.size.width, tbH-heights);
            [bottomTb reloadData];
            addTig.frame=CGRectMake(0,self.view.frame.size.height/3+ 20+tbH-heights+10, scrollBaV.bounds.size.width, 37);
            
            
                scrollBaV.contentSize=CGSizeMake(0, size.height-heights);
            
                         
            
            
        }];
        
    }
    
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString*indentifier=@"cell";
     NSString *indentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    
    
    
    
    CGRect rect = cell.frame;
    NSMutableArray*temparr2 =[self.userMarkArr[indexPath.section] mutableCopy];
    if (indexPath.section==2) {
        [temparr2 removeLastObject];
        
    }
    float a=temparr2.count/3;
    if (a<1) {
        if (indexPath.section==2&&temparr2.count<1) {
            rect.size.height = 0;
        }else{
        rect.size.height = 170;
        }
    }else {
        if (temparr2.count%3!=0&&temparr2.count>3) {
            rect.size.height = 170*(int)a+170;
        }else{
            rect.size.height = 170*(int)a;
        }
    }
    
    
    
    
    cell.frame = rect;
    
    
    
    
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
    QCCollectionV* cv=[[QCCollectionV alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, rect.size.height) collectionViewLayout:layout];
    NSMutableArray*temparr =[self.userMarkArr[indexPath.section] mutableCopy];
    if (indexPath.section==2) {
        [temparr removeLastObject];

    }
    cv.dataArr=temparr;
    cv.isAdd=YES;
    cv.inSection=indexPath.section;
    [cv reloadData];
    [cell addSubview:cv];
    
    
    
    
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",(long)indexPath.row);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"cell height %f",cell.frame.size.height);
    
    return cell.frame.size.height+30;
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section{
    
    //    判断section的展开收起状态
    if ([[openedInSectionArr objectAtIndex:section] intValue] == 1) {
        return 1;
    }
    
    return 0;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    //多少个分区
    return [mySectionArr count];
}



#pragma -mark 弹出框
-(void)popUpBox
{

    popView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, scrollBaV.bounds.size.width, scrollBaV.bounds.size.height)];
    popView.backgroundColor= [UIColor blackColor];
    [self.view addSubview:popView];
    popView.alpha=0.6;
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popViewTap:)];
    tap.numberOfTapsRequired =1;
    [popView addGestureRecognizer:tap];

    
    popBox=[[UIView alloc]initWithFrame:CGRectMake(30, (self.view.frame.size.height-270)/2, self.view.frame.size.width-60, 270)];
    popBox.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:popBox];
    
    UILabel*titlelb=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, popBox.bounds.size.width, 18)];
    titlelb.text=@"添加自创类";
    titlelb.textAlignment=NSTextAlignmentCenter;
    titlelb.font=[UIFont systemFontOfSize:18];
    [popBox addSubview:titlelb];
    
    
    UIView*choiceV1=[[UIView alloc]initWithFrame:CGRectMake((popBox.bounds.size.width-100)/2, 70, 100, 20)];
    //choiceV1.backgroundColor=[UIColor redColor];
    [popBox addSubview:choiceV1];
    showOthers=@"1";

    UITapGestureRecognizer*choiceRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choiceTap:)];
    choiceRecognizer.numberOfTapsRequired=1;
    [choiceRecognizer setNumberOfTouchesRequired:1];
    [choiceV1 addGestureRecognizer:choiceRecognizer];

    
    
    
    imagevs=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    imagevs.image=[UIImage imageNamed:@"offs"];
    [choiceV1 addSubview:imagevs];
    
    UILabel*publicLB=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, choiceV1.bounds.size.width-30, 20)];
    publicLB.text=@"所有人";
    publicLB.font=[UIFont systemFontOfSize:14];
    [choiceV1 addSubview:publicLB];
    
    
    UIView*choiceV2=[[UIView alloc]initWithFrame:CGRectMake((popBox.bounds.size.width-100)/2, 110, 100, 20)];
    //choiceV2.backgroundColor=[UIColor greenColor];
    [popBox addSubview:choiceV2];
    
    
    
    UITapGestureRecognizer*choiceRecognizer2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choiceTap2:)];
    choiceRecognizer2.numberOfTapsRequired=1;
    [choiceRecognizer2 setNumberOfTouchesRequired:1];
    [choiceV2 addGestureRecognizer:choiceRecognizer2];

    
    
    imagevs2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    imagevs2.image=[UIImage imageNamed:@"no"];
    [choiceV2 addSubview:imagevs2];

    UILabel*privateLB=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, choiceV2.bounds.size.width-30, 20)];
    privateLB.text=@"仅自己";
    privateLB.font=[UIFont systemFontOfSize:14];
    [choiceV2 addSubview:privateLB];


    
    boxtf=[[UITextField alloc]initWithFrame:CGRectMake(30,  popBox.frame.size.height-105, popBox.bounds.size.width-60, 50)];
    boxtf.layer.borderWidth=0.5;
    boxtf.delegate=self;
    boxtf.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
    boxtf.placeholder=@"请输入类名";
    [popBox addSubview:boxtf];
    

    UIButton*choiceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [choiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    choiceBtn.frame=CGRectMake(0, popBox.frame.size.height-45, popBox.frame.size.width/2, 45);
    [choiceBtn setTitle:@"取消" forState: UIControlStateNormal];
    [choiceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    choiceBtn.tag=1;
    choiceBtn.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
    choiceBtn.layer.borderWidth=0.5;
    [choiceBtn addTarget:self action:@selector(choiceBtnCliack:) forControlEvents:UIControlEventTouchUpInside];
    [popBox addSubview:choiceBtn];
    
    UIButton*choiceBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
    [choiceBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    choiceBtn2.frame=CGRectMake(popBox.frame.size.width/2, popBox.frame.size.height-45, popBox.frame.size.width/2, 45);
    [choiceBtn2 setTitle:@"确定" forState: UIControlStateNormal];
    [choiceBtn2 setTitleColor:RGBA_COLOR(118, 168, 244, 1) forState:UIControlStateNormal];
    choiceBtn2.tag=2;
    choiceBtn2.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
    choiceBtn2.layer.borderWidth=0.5;

    [choiceBtn2 addTarget:self action:@selector(choiceBtnCliack:) forControlEvents:UIControlEventTouchUpInside];
    [popBox addSubview:choiceBtn2];


    
   

    
    


}


-(void)popDeleteBox:(UILongPressGestureRecognizer*)longResture
{
    if (longResture.state==UIGestureRecognizerStateBegan) {

    popView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, scrollBaV.bounds.size.width, scrollBaV.bounds.size.height)];
    popView.backgroundColor= [UIColor blackColor];
    [self.view addSubview:popView];
    popView.alpha=0.6;
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popViewTap:)];
    tap.numberOfTapsRequired =1;
    [popView addGestureRecognizer:tap];
    
    
    popBox=[[UIView alloc]initWithFrame:CGRectMake(30, (self.view.frame.size.height-270)/2, self.view.frame.size.width-60, 270)];
    popBox.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:popBox];
    
        UILabel*titlelb=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, popBox.bounds.size.width, 18)];
        titlelb.text=@"确认删除";
        titlelb.textAlignment=NSTextAlignmentCenter;
        titlelb.font=[UIFont systemFontOfSize:18];
        [popBox addSubview:titlelb];
        
        
        UILabel*tisLb=[[UILabel alloc]initWithFrame:CGRectMake(0, (popBox.bounds.size.height-18)/2, popBox.bounds.size.width, 18)];
        tisLb.text=@"是否删除该大类";
        tisLb.textAlignment=NSTextAlignmentCenter;
        tisLb.font=[UIFont systemFontOfSize:16];
        [popBox addSubview:tisLb];
        
        
        
        
        
    UIButton*choiceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [choiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    choiceBtn.frame=CGRectMake(0, popBox.frame.size.height-45, popBox.frame.size.width/2, 45);
    [choiceBtn setTitle:@"取消" forState: UIControlStateNormal];
    [choiceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    choiceBtn.tag=1;
    choiceBtn.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
    choiceBtn.layer.borderWidth=0.5;
    [choiceBtn addTarget:self action:@selector(closeBtnCliack) forControlEvents:UIControlEventTouchUpInside];
    [popBox addSubview:choiceBtn];
    
    UIButton*choiceBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
    [choiceBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    choiceBtn2.frame=CGRectMake(popBox.frame.size.width/2, popBox.frame.size.height-45, popBox.frame.size.width/2, 45);
    [choiceBtn2 setTitle:@"确定" forState: UIControlStateNormal];
    [choiceBtn2 setTitleColor:RGBA_COLOR(118, 168, 244, 1) forState:UIControlStateNormal];
    choiceBtn2.tag=longResture.view.tag;
    choiceBtn2.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
    choiceBtn2.layer.borderWidth=0.5;
    
        [choiceBtn2 addTarget:self action:@selector(deleteBtnCliack:) forControlEvents:UIControlEventTouchUpInside];
    [popBox addSubview:choiceBtn2];
    

    }
}

-(void)closeBtnCliack
{
    [popView removeFromSuperview];
    
    [popBox removeFromSuperview];
    
    
}

-(void)deleteBtnCliack:(UIButton*)bt
{

    
    [popView removeFromSuperview];
    
    [popBox removeFromSuperview];
    
    [self deleteUserMark:bt.tag];

}



-(void)choiceTap:(UITapGestureRecognizer*)tap
{

    imagevs.image=[UIImage imageNamed:@"offs"];
    imagevs2.image=[UIImage imageNamed:@"no"];

    showOthers=@"1";

}

-(void)choiceTap2:(UITapGestureRecognizer*)tap
{
    imagevs.image=[UIImage imageNamed:@"no"];
    imagevs2.image=[UIImage imageNamed:@"offs"];

    showOthers=@"2";
    
}


-(void)choiceBtnCliack:(UIButton*)bt
{
    if (bt.tag==1) {
        
    } else if(bt.tag==2){
        [self addUserMarl ];
    }

    [popView removeFromSuperview];
    
    [popBox removeFromSuperview];


}
-(void)popViewTap:(UITapGestureRecognizer*)tap
{
    [tap.view removeFromSuperview];

    [popBox removeFromSuperview];

}

-(void)OthersBtn:(UIButton*)bt
{
    NSLog(@"设置权限");
    [self othersBox:bt.tag];

}

-(void)OthersBtnCliack:(UIButton*)bt
{
    
    [popView removeFromSuperview];
    
    [popBox removeFromSuperview];
    
    
}

-(void)OthersBtnCliacks:(UIButton*)bt
{
    
    [self markOthers:bt.tag ];
    [popView removeFromSuperview];
    
    [popBox removeFromSuperview];
    
    
}



-(void)othersBox:(NSInteger)tag
{
    
    popView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, scrollBaV.bounds.size.width, scrollBaV.bounds.size.height)];
    popView.backgroundColor= [UIColor blackColor];
    [self.view addSubview:popView];
    popView.alpha=0.6;
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popViewTap:)];
    tap.numberOfTapsRequired =1;
    [popView addGestureRecognizer:tap];

    popBox=[[UIView alloc]initWithFrame:CGRectMake(30, (self.view.frame.size.height-270)/2, self.view.frame.size.width-60, 270)];
    popBox.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:popBox];
    
    UILabel*titlelb=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, popBox.bounds.size.width, 18)];
    titlelb.text=@"设置权限";
    titlelb.textAlignment=NSTextAlignmentCenter;
    titlelb.font=[UIFont systemFontOfSize:18];
    [popBox addSubview:titlelb];
    
    
    UIView*choiceV1=[[UIView alloc]initWithFrame:CGRectMake((popBox.bounds.size.width-100)/2, 70, 100, 20)];
    //choiceV1.backgroundColor=[UIColor redColor];
    [popBox addSubview:choiceV1];
    showOthers=@"1";
    UITapGestureRecognizer*choiceRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choiceTap:)];
    choiceRecognizer.numberOfTapsRequired=1;
    [choiceRecognizer setNumberOfTouchesRequired:1];
    [choiceV1 addGestureRecognizer:choiceRecognizer];

    
    imagevs=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    imagevs.image=[UIImage imageNamed:@"offs"];
    [choiceV1 addSubview:imagevs];
    
    UILabel*publicLB=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, choiceV1.bounds.size.width-30, 20)];
    publicLB.text=@"所有人";
    publicLB.font=[UIFont systemFontOfSize:14];
    [choiceV1 addSubview:publicLB];
    
    
    UIView*choiceV2=[[UIView alloc]initWithFrame:CGRectMake((popBox.bounds.size.width-100)/2, 110, 100, 20)];
    //choiceV2.backgroundColor=[UIColor greenColor];
    [popBox addSubview:choiceV2];
    
    
    
    UITapGestureRecognizer*choiceRecognizer2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choiceTap2:)];
    choiceRecognizer2.numberOfTapsRequired=1;
    [choiceRecognizer2 setNumberOfTouchesRequired:1];
    [choiceV2 addGestureRecognizer:choiceRecognizer2];
    
    
    
    imagevs2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    imagevs2.image=[UIImage imageNamed:@"no"];
    [choiceV2 addSubview:imagevs2];
    
    UILabel*privateLB=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, choiceV2.bounds.size.width-30, 20)];
    privateLB.text=@"仅自己";
    privateLB.font=[UIFont systemFontOfSize:14];
    [choiceV2 addSubview:privateLB];

    
    
    UIButton*choiceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [choiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    choiceBtn.frame=CGRectMake(0, popBox.frame.size.height-45, popBox.frame.size.width/2, 45);
    [choiceBtn setTitle:@"取消" forState: UIControlStateNormal];
    [choiceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    choiceBtn.tag=1;
    choiceBtn.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
    choiceBtn.layer.borderWidth=0.5;
    [choiceBtn addTarget:self action:@selector(OthersBtnCliack:) forControlEvents:UIControlEventTouchUpInside];
    [popBox addSubview:choiceBtn];
    
    UIButton*choiceBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
    [choiceBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    choiceBtn2.frame=CGRectMake(popBox.frame.size.width/2, popBox.frame.size.height-45, popBox.frame.size.width/2, 45);
    [choiceBtn2 setTitle:@"确定" forState: UIControlStateNormal];
    [choiceBtn2 setTitleColor:RGBA_COLOR(118, 168, 244, 1) forState:UIControlStateNormal];
    choiceBtn2.tag=tag;
    choiceBtn2.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
    choiceBtn2.layer.borderWidth=0.5;
    
    [choiceBtn2 addTarget:self action:@selector(OthersBtnCliacks:) forControlEvents:UIControlEventTouchUpInside];
    [popBox addSubview:choiceBtn2];
    

    
}

-(void)pushtoAdd:(NSNotification*)n
{
    QCAddUserMarkVC*add=[[QCAddUserMarkVC alloc]init];
    add.groupId=[n.userInfo[@"groupId"] integerValue];
    
    [self.navigationController  pushViewController:add animated:YES];

}




#pragma -mark 请求数据

-(void)getData
{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    
    dic[@"uid"]=@(sessions.user.uid);
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:USERINFO_DETAIL parameter:dic success:^(id response) {
        
        
        qcFriend = [QCFriendInfoModel mj_objectWithKeyValues:response];
        qcFriend.relation=[QCFriendRelationModel mj_objectWithKeyValues:[response valueForKey:@"relation"]];
        NSString*longstr=[[NSString alloc]init];
        longstr=[[response valueForKey:@"relation"] valueForKey:@"id"];
        qcFriend.relation.Id=[longstr integerValue] ;
        
        
        self.userDic=response;
        
                    
                    [scrollBaV removeFromSuperview];
                    [self showView];
                    scrollBaV.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height*2);
                    userName.text=qcFriend.nickname;
                    userNum.text=[NSString stringWithFormat:@"处号:%@",qcFriend.userno];
                    [infoView setTitle:[NSString stringWithFormat:@"%d岁",qcFriend.age] forState:UIControlStateNormal];
        userName.frame=CGRectMake((self.view.frame.size.width-(userName.text.length*15))/2, userphoto.bounds.size.height/5*2+20+5, userName.text.length*15, 14);
        sexImage.frame=CGRectMake(((self.view.frame.size.width-(userName.text.length*15))/2)+(userName.text.length*15),userphoto.bounds.size.height/5*2+20+5, 14, 14);
        
        
        
        
        if (qcFriend.sex==0) {
            sexImage.image=[UIImage imageNamed:@"LJ形状-1"];
        }else{
        
            sexImage.image=[UIImage imageNamed:@"LJ形状-2"];

        }
        
                    NSURL*url=[NSURL URLWithString:qcFriend.avatarUrl];
                    
                    [userHead sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"login_user_default_logo"]];
        
        
        
            
            [MBProgressHUD hideHUD];
            
        
     
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        
        [MBProgressHUD hideHUD];
    }];
    
    
    
}

//标签大类
-(void)userLabelled
{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    
    dic[@"uid"]=@(sessions.user.uid);
    
    //[MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:GETMARKGROUP parameter:dic success:^(id response) {
        
        
        //        personMark = [QCPersonMarkModel objectWithKeyValues:response];
        
//        [self.personMarkArr removeAllObjects];
//        [self.userMarkArr removeAllObjects];
        self.personMarkArr=[[NSMutableArray alloc]init];
        self.userMarkArr=[[NSMutableArray alloc]init];
        NSArray* temparr=response;
        if (temparr.count > 0) {
            if (self.isRootVC) {
            scrollBaV.contentSize=CGSizeMake(0,  self.view.frame.size.height/3+30+(57*temparr.count)+self.view.frame.size.height+64+64+54);
   
            }else{
                
            

            scrollBaV.contentSize=CGSizeMake(0,  self.view.frame.size.height/3+30+(57*temparr.count)+self.view.frame.size.height+64+64);
            }
            NSLog(@"%f",scrollBaV.contentSize.height);

            
            for (int i=0; i<temparr.count; i++) {
                personMark = [QCPersonMarkModel mj_objectWithKeyValues:temparr[i]];
                personMark.Id=[[temparr[i] valueForKey:@"id"] integerValue];
                [self.personMarkArr addObject:personMark];
                [self.userMarkArr addObject:[@[] mutableCopy]];
            }
            
            
            NSMutableArray*temptitle=[[NSMutableArray alloc]init];
            NSMutableArray*tagArr=[[NSMutableArray alloc]init];
            
            for (int i=0; i<[self.personMarkArr count]; i++) {
                QCPersonMarkModel*tempQCp=self.personMarkArr[i];
                [temptitle addObject:tempQCp.title];
                [tagArr addObject:@"0"];
                [self getMarksByGroupId:tempQCp.Id];
                
                
            }
            
            mySectionArr=temptitle;
            openedInSectionArr=tagArr;
            tbH=mySectionArr.count*57;
            bottomTb.frame=CGRectMake(0, self.view.frame.size.height/3+ 20, scrollBaV.bounds.size.width, tbH);
            [bottomTb reloadData];
            addTig.frame=CGRectMake(0,self.view.frame.size.height/3+ 20+tbH+10, scrollBaV.bounds.size.width, 37);
        }
        else
        {
            // [MBProgressHUD hideHUD];
            return ;
        }
        
        
      
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        
        //[MBProgressHUD hideHUD];
    }];
       
}



-(void)getMarksByGroupId:(long)GroupId
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    dic[@"groupId"]=@(GroupId);
    dic[@"page"]=@0;
    
    
    [NetworkManager requestWithURL:QUERYTAG parameter:dic success:^(id response) {
        
        NSLog(@"%@",response);
        NSMutableArray*temparr=[[NSMutableArray alloc]initWithArray:response];
        NSLog(@"temparr====%@",temparr);
        NSMutableArray*userArr=[[NSMutableArray alloc]init];
        
        for (int i=0; i<temparr.count; i++) {
            
            QCGetUserMarkModel*getUserMark=[[QCGetUserMarkModel alloc]init];
            getUserMark=[QCGetUserMarkModel mj_objectWithKeyValues:temparr[i]];
            getUserMark.ID=[[temparr[i] valueForKey:@"id"] integerValue];
//            getUserMark.level=[[temparr[i] valueForKey:@"level"] integerValue];
            [userArr addObject:getUserMark];
            
        }
        NSInteger index = [self indexForGroupID:GroupId];
        NSMutableArray * array=[[NSMutableArray alloc]init];
        array = self.userMarkArr[index];
        [array addObjectsFromArray:userArr];
        
        QCGetUserMarkModel*tempData=[[QCGetUserMarkModel alloc]init];
        tempData.type=5;
        tempData.groupId=GroupId;
        [array addObject:tempData];
        [bottomTb reloadData];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        
        
    }];
    
    
}

- (NSInteger) indexForGroupID:(long) groupID
{
    __block NSInteger idx2 = 0;
    [self.personMarkArr enumerateObjectsUsingBlock:^(QCPersonMarkModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.Id ==groupID ) {
            idx2 = idx;
        }
    }];
    return idx2;
}

#pragma -mark 添加标签大类
-(void)addUserMarl
{

    NSMutableDictionary * dic = [NSMutableDictionary dictionary];

    
    
    dic[@"title"]=boxtf.text;
    dic[@"type"]=@0;
    dic[@"showOthers"]=showOthers;
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:USERINFO_ADDMARKGROUP parameter:dic success:^(id response) {
        
        [self userLabelled];
        
          [MBProgressHUD hideHUD];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
        
    }];
   
        



}

#pragma -mark 设置权限
-(void)markOthers:(NSInteger)markGroupId
{

    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    //    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    //
    dic[@"markGroupId"]=@(markGroupId);//
    dic[@"showOthers"]=showOthers;//权限
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:USERINFO_SETPERMISSIONS parameter:dic success:^(id response) {
        
        
        
        [MBProgressHUD hideHUD];
        [OMGToast showText:@"权限设置成功"];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
        [OMGToast showText:@"权限设置失败"];
        
    }];


}


#pragma -mark 删除标签大类
-(void)deleteUserMark:(NSInteger)index
{
   
    QCPersonMarkModel*data=self.personMarkArr[index-100];
    
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    //    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    //
    dic[@"markGroupId"]=@(data.Id);//
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:USERINFO_DELETEMARKGROUP parameter:dic success:^(id response) {
        
        
        [self userLabelled];
        [MBProgressHUD hideHUD];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
        
    }];
    
    
}
#pragma -mark 删除标签
-(void)deleteTagwith:(NSInteger)ID
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    //    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
    //
    dic[@"userMarkId"]=@(ID);//
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:USERINFO_DELETPUSERMARK parameter:dic success:^(id response) {
        [self userLabelled];
        
        [MBProgressHUD hideHUD];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
        
    }];
}

-(void)commturns
{
//    [self.personMarkArr removeAllObjects];
//    [self.userMarkArr removeAllObjects];

    [self userLabelled];
}
#pragma mark - 点击头像
-(void)touchuserHead:(UITapGestureRecognizer*)Tap
{

    QCUserDataVC*dataVC=[[QCUserDataVC alloc]init];
    dataVC.title=@"修改资料";

    dataVC.markfriend= [self.userMarkArr[1] mutableCopy];
    dataVC.groupId=[[self.personMarkArr[1] valueForKey:@"Id"] integerValue];
    dataVC.myData=qcFriend;
    [self.navigationController pushViewController:dataVC animated:YES];
}

-(void)pushtovoide:(NSNotification*)n
{
    QCGetUserMarkModel*data=n.userInfo[@"data"];
    NSURL*url=[NSURL URLWithString:data.url];
    
    MPMoviePlayerViewController * movieVc = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [movieVc.moviePlayer prepareToPlay];
    movieVc.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [self presentViewController:movieVc animated:YES completion:nil];
}

-(void)pushtotext:(NSNotification*)n
{
    QCGetUserMarkModel*data=n.userInfo[@"data"];
    QCTextVC*tc=[[QCTextVC alloc]init];
    tc.str=data.title;
    [self.navigationController pushViewController:tc animated:YES];
}

-(void)deleteTags:(NSNotification*)n
{
    NSInteger inSection=[n.userInfo[@"inSection"] integerValue];
    NSInteger index=[n.userInfo[@"index"] integerValue];
    
    NSMutableArray*tempArr= self.userMarkArr[inSection];
   
    QCGetUserMarkModel*data= tempArr[index];
    [self deleteTagwith:data.ID];
}

-(void)changFace
{
    [self getData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //回收键盘
    [textField  resignFirstResponder];
    return YES;
}

- (void)searchMarkUser:(UIButton *)bar
{
    if (_popVC.show) {
        [_popVC dismiss];
    }
    
    QCNewSearchVC * vc = [[QCNewSearchVC alloc] init];
    vc.title=@"推荐搜索";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 右上角加号按钮-弹出选中框
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

@end
