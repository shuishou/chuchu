//
//  QCUserViewController.m
//  MyQOOCOO
//
//  Created by lanou on 15/12/11.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCUserViewController.h"
#import "View+MASAdditions.h"
#import "QCFriendInfoModel.h"
#import "SDCycleScrollView.h"
#import "QCRemarksViewController.h"
#import "QCPersonMarkModel.h"
#import "LJAudio.h"
#import "QCGetUserMarkModel.h"
#import "QCCollectionV.h"
#import "QCAddUserMarkVC.h"

#import "QCReportVC.h"
#import "QCSelectContactsVC.h"
#import "QCFreeController.h"
#import "QCChatViewController.h"
#import "UserProfileManager.h"

@interface QCUserViewController ()<SDCycleScrollViewDelegate,LJAudioDelegate>
{

    UIScrollView*scrollBaV;
    UIScrollView*scroll;
     UIView *bgView;
    UITableView*bottomTb;
    BOOL isOpen;
    UIImageView*sectionimagev;
    UIView * btView;
    
    NSMutableArray*mySectionArr;
    NSMutableArray*openedInSectionArr;
    
    QCFriendInfoModel*qcFriend;
    QCPersonMarkModel*personMark;
    
    
    UIImageView*namePic;
    UILabel*namelb;
    UILabel*numberlb;
    UIButton*addFriend;
    
    NSMutableArray *scrollimages;
    
    
    UIButton*playBtn;
    
    UIActionSheet *Figure;
    UIView*bottomV;
    
    
    
    NSInteger fensiTag;
    UIButton *infoView;
    UIImageView*sexImage;
    
}

@end

@implementation QCUserViewController

-(void)viewWillAppear:(BOOL)animated

{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
   
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem addBarBtnImg:@"Arrow" highlightedImg:@"Arrow" target:self action:@selector(touchleftBtn)];

    
    
    
    [LJAudio sharedStreamer].delegate = self;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upData) name:@"upData" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushtoAdd:) name:@"CVpush" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushtovoide:) name:@"CVpushToVoide" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushtotext:) name:@"CVpushToText" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commturns) name:@"commturn" object:nil];
    
    

//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteTags:) name:@"delete" object:nil];


    
    self.personMarkArr=[NSMutableArray array];
    self.userMarkArr=[NSMutableArray array];

//    [self getData ];
    
    [self showView];
    [self getData ];
    
    
}
-(void)showView
{
    
    
    
    self.navigationItem.title = @"用户资料";
    //qcFriend=[[QCFriendInfoModel alloc]init];
    
    //右侧按钮(自定义)
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    //    button.backgroundColor=[UIColor purpleColor];
    [button setImage:[UIImage imageNamed:@"but_Option"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(rightButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    
    
    
    scrollBaV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*99)];
    [self.view addSubview: scrollBaV];
    //设置可滚动范围
//     scrollBaV.contentSize=CGSizeMake(0, self.view.frame.size.height*3);
     scrollBaV.backgroundColor=self.view.backgroundColor;
    
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
    
    UILabel*midtitle=[[UILabel alloc]init];
    if (self.isFriend==NO) {
        midtitle.frame=CGRectMake(10, self.view.frame.size.height/3+10+(47*3), 100, 30);
    }else{
    
        midtitle.frame=CGRectMake(10, self.view.frame.size.height/3+10+(47*4), 100, 30);
    
    }

    midtitle.text=@"标签";
    midtitle.font=[UIFont systemFontOfSize:13];
    [scrollBaV addSubview:midtitle];
    
    [self showMiddView];
    isOpen=YES;
    CGRect frame;
    if (self.isFriend==NO) {
        frame=CGRectMake(0,self.view.frame.size.height/3+10+(47*4)+30, self.view.size.width, 47*90);

    }else{
    
        frame=CGRectMake(0,self.view.frame.size.height/3+10+(47*5)+30, self.view.size.width, 47*90);

    
    }
    
    

    bottomTb=[[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    bottomTb.backgroundColor=[UIColor whiteColor];
    bottomTb.delegate=self;
    bottomTb.dataSource=self;
    bottomTb.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [bottomTb setSeparatorInset:UIEdgeInsetsZero];
    bottomTb.backgroundColor=[UIColor whiteColor];
    bottomTb.allowsSelection= NO;
    bottomTb.scrollEnabled =NO;
    bottomTb.separatorColor=[UIColor clearColor];
    [scrollBaV addSubview:bottomTb];

   
    
//    sectionheader文字
    mySectionArr = [[NSMutableArray alloc] initWithObjects:@"标签1", @"标签2", @"标签3", @"标签4", @"标签5", @"标签6", nil];
    //    每个section展开收起状态标识符
    openedInSectionArr = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0",@"0",@"0",nil];

    
    bottomV=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width, 54)];
    bottomV.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:bottomV];
    [self.view bringSubviewToFront:bottomV];
    
    
    UIButton *btns = [UIButton buttonWithType:UIButtonTypeCustom];
    [btns setTitle:@"发私信" forState:UIControlStateNormal];
    [btns setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btns.backgroundColor=UIColorFromRGB(0xed6664);
    btns.layer.cornerRadius=5;
    btns.layer.masksToBounds=YES;
    btns.frame = CGRectMake((bottomV.bounds.size.width-80)/2,7,80,40);
    [btns addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:btns];
    
    UIView*linev=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bottomV.bounds.size.width, 0.5)];
    linev.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
    [bottomV addSubview:linev];

    // Do any additional setup after loading the view.
}

-(void)sendMessage
{
    NSLog(@"发私信");

    QCChatViewController *chatView = [[QCChatViewController alloc]initWithChatter:qcFriend.hid isGroup:NO];
    chatView.navigationItem.leftBarButtonItem = [UIBarButtonItem addBarBtnImg:@"Arrow" highlightedImg:@"Arrow" target:self action:@selector(touchleftBtn)];
    chatView.isUserPush=YES;
    chatView.title = [[UserProfileManager sharedInstance] getNickNameWithUsername:qcFriend.nickname];
    [self.navigationController pushViewController:chatView animated:YES];}
-(void)showMiddView
{
    [self userLabelled ];
    UIView*middV=[[UIView alloc]init];
    
    if (self.isFriend==NO) {
       middV.frame= CGRectMake(0,self.view.frame.size.height/3+10, self.view.frame.size.width, 47*4);
    }else{
    middV.frame= CGRectMake(0,self.view.frame.size.height/3+10, self.view.frame.size.width, 47*5);
    
    }

        middV.backgroundColor=[UIColor whiteColor];
    [scrollBaV addSubview:middV];
    
    
    NSMutableArray*arr=[[NSMutableArray alloc]initWithObjects:@"点滴",@"发泄圈",@"论库",@"自由人", nil];
    NSMutableArray*arr2=[[NSMutableArray alloc]initWithObjects:@"点滴",@"发泄圈",@"论库",@"自由人",@"添加备注", nil];
    NSMutableArray*igeArr=[[NSMutableArray alloc]initWithObjects:@"LJwater_drip",@"LJvent_roar_2",@"LJdiscussion_2",@"icon_balck_zyr", nil];
    NSMutableArray*igeArr2=[[NSMutableArray alloc]initWithObjects:@"LJwater_drip",@"LJvent_roar_2",@"LJdiscussion_2",@"icon_balck_zyr",@"LJremark_pen", nil];


    if (self.isFriend==NO) {
        
    
    for (int i=0; i<4; i++) {
        
        UIView*btv=[[UIView alloc]initWithFrame:CGRectMake(0, 47*i,self.view.frame.size.width , 47)];
        btv.tag=i;
        [middV addSubview:btv];
        
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchmiddle:)];
        tap.numberOfTapsRequired =1;
        [btv addGestureRecognizer:tap];
        
        
        UIImageView*imagev=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 27, 27)];
        imagev.image=[UIImage imageNamed:igeArr[i]];
        [btv addSubview:imagev];

        UILabel*templb=[[UILabel alloc]initWithFrame:CGRectMake(57, 0,self.view.frame.size.width /3, 47)];
        templb.text=arr[i];
//        templb.textColor=RGBA_COLOR(195, 195, 195, 1);
        templb.font=[UIFont systemFontOfSize:12];
        [btv addSubview:templb];
        
        UIImageView*imagev2=[[UIImageView alloc]initWithFrame:CGRectMake(btv.bounds.size.width-26, 15, 16, 16)];
        imagev2.image=[UIImage imageNamed:@"Small_Arrow"];
        [btv addSubview:imagev2];

        
        
        
    }
    for (int j=0; j<4; j++) {
        
   
    
    UIView*linev=[[UIView alloc]initWithFrame:CGRectMake(0, 47*j, middV.bounds.size.width ,0.5)];
    linev.backgroundColor=self.view.backgroundColor;
    [middV addSubview:linev];

    }
    
    }else{
        for (int i=0; i<5; i++) {
            
            UIView*btv=[[UIView alloc]initWithFrame:CGRectMake(0, 47*i,self.view.frame.size.width , 47)];
            btv.tag=i;
            [middV addSubview:btv];
            
            UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchmiddle:)];
            tap.numberOfTapsRequired =1;
            [btv addGestureRecognizer:tap];
            
            
            UIImageView*imagev=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 27, 27)];
            imagev.image=[UIImage imageNamed:igeArr2[i]];
            [btv addSubview:imagev];
            
            UILabel*templb=[[UILabel alloc]initWithFrame:CGRectMake(57, 0,self.view.frame.size.width /3, 47)];
            templb.text=arr2[i];
//            templb.textColor=RGBA_COLOR(195, 195, 195, 1);
            templb.font=[UIFont systemFontOfSize:12];
            [btv addSubview:templb];
            
            UIImageView*imagev2=[[UIImageView alloc]initWithFrame:CGRectMake(btv.bounds.size.width-26, 15, 16, 16)];
            imagev2.image=[UIImage imageNamed:@"Small_Arrow"];
            [btv addSubview:imagev2];
            
            
            
            
        }
        for (int j=0; j<5; j++) {
            
            
            
            UIView*linev=[[UIView alloc]initWithFrame:CGRectMake(0, 47*j, middV.bounds.size.width ,0.5)];
            linev.backgroundColor=self.view.backgroundColor;
            [middV addSubview:linev];
            
        }

    
    
    
    
    }

}



-(void)touchmiddle:(UITapGestureRecognizer*)v
{
 NSLog(@"%ld",v.view.tag);
    QCDiandiViewController*dian;
    QCFaxiequanViewController*faxie;
    QCLunKuViewController*lunku;
    QCRemarksViewController*rem;

    qcFriend = [QCFriendInfoModel mj_objectWithKeyValues:self.userDic];
    NSString*longstr;
    switch (v.view.tag) {
        case 0:
           //点滴
            dian=[[QCDiandiViewController alloc]init];
            dian.uid=[NSString stringWithFormat:@"%ld",self.uid];
            [self.navigationController pushViewController:dian animated:YES];
            
            break;
        case 1:
        //怒吼圈
            faxie=[[QCFaxiequanViewController alloc]init];
            faxie.uid=[NSString stringWithFormat:@"%ld",self.uid];
            [self.navigationController pushViewController:faxie animated:YES];

            
            break;
            
        case 2:
          //轮库
            lunku=[[QCLunKuViewController alloc]init];
            lunku.uid=[NSString stringWithFormat:@"%ld",self.uid];
            [self.navigationController pushViewController:lunku  animated:YES];
            break;
        case 3:
        {
        
            QCFreeController*qcfree=[[QCFreeController alloc]init];
            qcfree.isBlack=YES;
            qcfree.uid=self.uid;
            [self.navigationController pushViewController:qcfree animated:YES];
        
        }
            break;
        case 4:
            
            
          //添加备注
            
//            qcFriend.relation=[QCFriendRelationModel objectWithKeyValues:[self.userDic valueForKey:@"relation"]];
            longstr=[[NSString alloc]init];
            longstr=[[self.userDic valueForKey:@"relation"] valueForKey:@"id"];
            qcFriend.relation.Id=[longstr integerValue] ;

            rem=[[QCRemarksViewController alloc]init];
            rem.Id=qcFriend.relation.Id;
            rem.uid=qcFriend.uid ;
            [self.navigationController pushViewController:rem  animated:YES];

            break;
            
        default:
            break;
    }

}


-(void)showTopView
{

    
    
        NSArray*igearr = @[[UIImage imageNamed:@"img_bg"],
                           [UIImage imageNamed:@"img_bg"],
                           [UIImage imageNamed:@"img_bg"],
                           [UIImage imageNamed:@"img_bg"]
                           ];
        
        
        SDCycleScrollView *cycleScrollView;
        // 创建不带标题的图片轮播器
        if (scrollimages.count==0||scrollimages==nil) {
            cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3) imagesGroup:igearr];
            
        }else{
            cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3) imagesGroup:scrollimages];
            
            
        }
        cycleScrollView.delegate = self;
        cycleScrollView.autoScrollTimeInterval = 2.0;
        [scrollBaV addSubview:cycleScrollView];
        cycleScrollView.pageControlAliment =SDCycleScrollViewPageContolAlimentRight;
    
    

    
    
    
    
    
    //播放录音
    playBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    playBtn.frame=CGRectMake(scrollBaV.bounds.size.width-40, 10, 30, 30);
    [playBtn setImage:[UIImage imageNamed:@"img_soundlabel"] forState:UIControlStateNormal];
    playBtn.backgroundColor=[UIColor blackColor];
    playBtn.layer.cornerRadius=15;
    playBtn.alpha=0.5;
    [playBtn addTarget:self action:@selector(playBtnCliack) forControlEvents:UIControlEventTouchUpInside];
    [scrollBaV addSubview:playBtn];

    if(self.isFriend==NO)
    {
        playBtn.hidden=YES;
    }else{
        playBtn.hidden=NO;
    }

    
    
    //背景View
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/3-47, self.view.frame.size.width, 47)];
    bgView.backgroundColor = UIColorFromRGB(0x583A3D);
    [scrollBaV addSubview:bgView];
    bgView.alpha=0.4;


    namePic=[[UIImageView alloc]initWithFrame:CGRectMake(10,self.view.frame.size.height/3-42, 37,  37)];
    namePic.image=[UIImage imageNamed:@"login_user_default_logo"];
    namePic.layer.cornerRadius = 19;
    namePic.layer.masksToBounds=YES;
    namePic.contentMode=UIViewContentModeScaleAspectFit;
    [scrollBaV addSubview:namePic];
    
    
    infoView = [[UIButton alloc]initWithFrame:CGRectMake(MaxX(namePic)-WIDTH(namePic)/1.5, CGRectGetMaxY(namePic.frame) - HEIGHT(namePic)/3, (HEIGHT(namePic)/3)*2.5, HEIGHT(namePic)/3)];
        infoView.backgroundColor = kColorRGBA(219, 89, 92, 1);
    infoView.layer.masksToBounds = YES;
    infoView.layer.cornerRadius = HEIGHT(infoView)/2;
    infoView.layer.borderWidth = 1;
    infoView.layer.borderColor = kColorRGBA(255, 255, 255, 1).CGColor;
    [infoView setTitle:@"未认证" forState:UIControlStateNormal];
    infoView.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(infoView)*3/5];
    [scrollBaV addSubview:infoView];

    
    
    namelb=[[UILabel alloc]init];
//tWithFrame:CGRectMake(57, self.view.frame.size.height/3-42, self.view.frame.size.width-110, 18.5);
    namelb.text=@"";
    namelb.font=[UIFont systemFontOfSize:13];
    namelb.textColor=[UIColor whiteColor];
    [scrollBaV addSubview:namelb];
    
    
    sexImage=[[UIImageView alloc]init];
    sexImage.backgroundColor=[UIColor clearColor];
    
    [scrollBaV addSubview:sexImage];

    
    
    
    numberlb=[[UILabel alloc]initWithFrame:CGRectMake(57, self.view.frame.size.height/3-42+18.5, self.view.frame.size.width-110, 18.5)];
    numberlb.text=@"处号：";
    numberlb.textColor=[UIColor whiteColor];
    numberlb.font=[UIFont systemFontOfSize:13];
    [scrollBaV addSubview:numberlb];
    
    addFriend=[UIButton buttonWithType:UIButtonTypeCustom];
    addFriend.backgroundColor=RGBA_COLOR(5, 162, 83, 1);
    [addFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addFriend.frame=CGRectMake(self.view.frame.size.width-53,self.view.frame.size.height/3-42,43,18.5);
    addFriend.titleLabel.textAlignment=NSTextAlignmentCenter;
    addFriend.titleLabel.font=[UIFont systemFontOfSize:9];
    if(self.isFriend==NO)
    {
    [addFriend setTitle:@"+关注"  forState:UIControlStateNormal];
    }else{
    [addFriend setTitle:@"取消关注"  forState:UIControlStateNormal];
    }
    [addFriend addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];

    [scrollBaV addSubview:addFriend];
    
    
}


-(void)playBtnCliack
{
    NSLog(@"播放录音");

    
    
  


        qcFriend = [QCFriendInfoModel mj_objectWithKeyValues:self.userDic];
        qcFriend.relation=[QCFriendRelationModel mj_objectWithKeyValues:[self.userDic valueForKey:@"relation"]];

    


    [self fileDownlowdUseAFN:qcFriend.relation.voiceUrl];
    
    
   

}
-(void)fileDownlowdUseAFN:(NSString*)voiceurl
{
    NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *sessionMan = [[AFURLSessionManager alloc] initWithSessionConfiguration:cfg];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:voiceurl]];
    
    NSURLSessionDownloadTask *dowloadTask = [sessionMan downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        // 2.文件保存的路径
        NSString *fileName = [NSUUID UUID].UUIDString;
        NSString *filePath = [cachesPath stringByAppendingPathComponent:fileName];
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        //        CZLog(@"%@",filePath);
        if (_avPlayer.playing) {
            [_avPlayer stop];
            return;
        }
        
        NSError *errorr = nil;
        NSData * data = [NSData dataWithContentsOfURL:filePath];
        NSLog(@"%zd",data.length);
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data  error:&errorr];
        if (errorr) {
            CZLog(@"%@",errorr);
        }
        //选加载音频的一部份数据到内存
        [player prepareToPlay];
        _avPlayer = player;
        [player play];
        if (error) {
            CZLog(@"%@",error);
            [OMGToast showText:@"网络异常"];
        }
    }];
    // 执行下载的任务
    [dowloadTask resume];
}




-(void)addFriend
{
    NSLog(@"添加取消");
    
    if(qcFriend.mFriends==NO)
    {
        NSMutableDictionary * dics = [NSMutableDictionary dictionary];
        dics[@"destUids"] = [NSString stringWithFormat:@"%ld",qcFriend.uid];

        [addFriend setTitle:@"取消关注"  forState:UIControlStateNormal];

        
        
        [NetworkManager requestWithURL:FRIEND_ADD parameter:dics success:^(id response) {
            qcFriend.mFriends = YES;
            self.isFriend=YES;
            [scrollBaV removeFromSuperview];

            [self getData ];

            [self showView];
            scrollBaV.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height*2);
            
        } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
            NSLog(@"错误信息%@",error);
            [OMGToast showText:@"关注失败"];
            [addFriend setTitle:@"+关注"  forState:UIControlStateNormal];
        }];
        
        
        
    }else{
        
        
        NSMutableDictionary * dics = [NSMutableDictionary dictionary];
        
        dics[@"destUids"] = [NSString stringWithFormat:@"%ld",qcFriend.uid];
        
        [addFriend setTitle:@"+关注"  forState:UIControlStateNormal];
        
        
        
        [NetworkManager requestWithURL:FRIEND_REMOVEFOCUS parameter:dics success:^(id response) {
            
            qcFriend.mFriends = NO;
            self.isFriend=NO;
            [scrollBaV removeFromSuperview];
            [self getData ];

            [self showView];
            scrollBaV.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height*2);

        } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
            NSLog(@"错误信息%@",error);
            [OMGToast showText:@"取消失败"];
            
            
            [addFriend setTitle:@"取消关注"  forState:UIControlStateNormal];
            
            
        }];

    

        

    
    }
    
    

}

-(void)leftBarButtonClick:(UIButton*)btn
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    



}





#pragma -mark tableview的代理方法

//section头高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 47;
}

//section头内容
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView*header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 47)];
    header.backgroundColor=[UIColor whiteColor];
    header.tag = 100 + section;
    
    
    UILabel*myLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width/5, 47)];
    myLable.text=mySectionArr[section];
    myLable.font=[UIFont systemFontOfSize:13];
    myLable.backgroundColor=[UIColor clearColor];
    
    myLable.textColor=[UIColor blackColor];
    
    if ([myLable.text isEqualToString:@"粉丝标签"]) {
        fensiTag=section;
    }
    
    [header addSubview:myLable];
    
    sectionimagev=[[UIImageView alloc]initWithFrame:CGRectMake(header.bounds.size.width-30,(header.bounds.size.height-20)/2,20,20)];
    
    
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
   
    
    NSMutableArray*temparr2 =[self.userMarkArr[didSection - 100] mutableCopy];
     if (didSection - 100!=fensiTag) {
         [temparr2 removeLastObject];
     }
    
    float a=temparr2.count/3;
    float heights;
    if (a<1) {
        if (temparr2.count>0) {
            heights = 170;
        }else {
            
            heights = 0;
        }
    }else {
        if (temparr2.count%3==0) {
            
        heights = 170*(float)a;
        }else{
            heights = 170*(float)(a+1);
        
        }
    }

    CGSize size=scrollBaV.contentSize;
     

    
    
    if ([[openedInSectionArr objectAtIndex:(int)didSection - 100] intValue] == 0) {
        [openedInSectionArr replaceObjectAtIndex:didSection - 100 withObject:@"1"];
        NSLog(@"%ld打开",(long)didSection);
        
        
        [bottomTb  reloadSections: [NSIndexSet indexSetWithIndex:didSection-100] withRowAnimation:UITableViewRowAnimationNone];
        
        [UIView animateWithDuration:0.2 animations:^{
            
                scrollBaV.contentSize=CGSizeMake(0, size.height+heights);

            
            
            
        }];
        
    }
    else
    {
        [openedInSectionArr replaceObjectAtIndex:(int)didSection - 100 withObject:@"0"];
        NSLog(@"%ld关闭",didSection);
        
        
        
        [bottomTb reloadSections:[NSIndexSet indexSetWithIndex:didSection-100] withRowAnimation:UITableViewRowAnimationNone];
        [UIView animateWithDuration:0.2 animations:^{
            

                scrollBaV.contentSize=CGSizeMake(0, size.height-heights);

            
            
        }];
        
    }
    
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString*indentifier=@"cell";
    NSString *indentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];

    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
   
    
    
   
    CGRect rect = cell.frame;
    NSMutableArray*temparr2 =[self.userMarkArr[indexPath.section] mutableCopy];
    if (indexPath.section!=fensiTag) {
        [temparr2 removeLastObject];
    }

    
    float a=temparr2.count/3;
    if (temparr2.count>0||indexPath.section==fensiTag) {
        
    if (a<1) {
        
        rect.size.height = 170;
    }else {
        if (temparr2.count%3!=0&&temparr2.count>3) {
            rect.size.height = 170*(int)a+170;
        }else{
            rect.size.height = 170*(int)a;
        }
    }

    }else{
    
        rect.size.height =0;
    
    
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
    if (indexPath.section!=fensiTag) {
        [temparr removeLastObject];
    }
    cv.dataArr=temparr;
    cv.isAdd=YES;
    cv.isEdite=YES;
    [cv reloadData];
    [cell addSubview:cv];

    
    
    
    cell.backgroundColor=[UIColor redColor];
       return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",(long)indexPath.row);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"cell height %f",cell.frame.size.height);
    
    return cell.frame.size.height;
    
    
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




-(void)upData
{
    [self getData];
}


-(void)pushtoAdd:(NSNotification*)n
{
    QCAddUserMarkVC*add=[[QCAddUserMarkVC alloc]init];
    add.groupId=[n.userInfo[@"groupId"] integerValue];
    
    [self.navigationController  pushViewController:add animated:YES];
    
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






#pragma -mark 请求数据

-(void)getData
{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"uid"]=@(self.uid);
    
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:USERINFO_DETAIL parameter:dic success:^(id response) {
        
        
        qcFriend = [QCFriendInfoModel mj_objectWithKeyValues:response];
        qcFriend.relation=[QCFriendRelationModel mj_objectWithKeyValues:[response valueForKey:@"relation"]];
        NSString*longstr=[[NSString alloc]init];
        longstr=[[response valueForKey:@"relation"] valueForKey:@"id"];
        qcFriend.relation.Id=[longstr integerValue] ;
       
        
        self.userDic=response;
        if (self.userDic.count > 0) {
           

            NSArray*temparr=[[NSArray alloc]init];

            if (qcFriend.nickname!=nil) {
                
                scrollimages=[NSMutableArray array];
                
                
                
                temparr = [qcFriend.relation.imageUrl componentsSeparatedByString:@","];
                if (temparr.count>0) {
                    
                    
                    for (int i=0; i<temparr.count ; i++) {
                        
                        NSString * urlStr = temparr[i];
                        if (urlStr.length > 0) {
                            NSURL*tempurl=[NSURL URLWithString:urlStr];
                            
                            //参1url网址 参2缓存方式(内存) 参3请求超时时间
                            NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:tempurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
                            //设置请求方式(默认是get)
                            request.HTTPMethod=@"GET";
                            //发送请求(同步请求)返回值nsdata
                            //参数1 request
                            //参2 服务器响应信息
                            //参3 错误信息
                            NSURLResponse*response=nil;//服务器响应信息
                            NSError*error=nil;//错误信息
                            //程序会停在这 直到下载结束才会继续执行 所以就导致了App假死现象
                            NSData*data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                            //展示到UIimageview上
                            UIImage*image=[UIImage imageWithData:data];
                            [scrollimages addObject:image];
                        }
                        else
                        {
                            UIImage * image = [UIImage imageNamed:@"img_bg"];
                            [scrollimages addObject:image];
                        }
                        
                        
                    }
                    
                }
                
                    [scrollBaV removeFromSuperview];
                [bottomV removeFromSuperview];
                    [self showView];
                    scrollBaV.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height*2);
                if (qcFriend.relation.note!=NULL) {
                    
                
                    namelb.text=[NSString stringWithFormat:@"%@(%@)",qcFriend.nickname,qcFriend.relation.note];
                }else{
                
                    namelb.text=qcFriend.nickname;
                
                }
                namelb.frame=CGRectMake(57, self.view.frame.size.height/3-42, namelb.text.length*14, 18.5);
                if (qcFriend.sex==0) {
                    sexImage.image=[UIImage imageNamed:@"LJ形状-1"];
                }else{
                    
                    sexImage.image=[UIImage imageNamed:@"LJ形状-2"];
                    
                }

                sexImage.frame=CGRectMake(MaxX(namelb),self.view.frame.size.height/3-42, 18.5, 18.5);
                
                    numberlb.text=[NSString stringWithFormat:@"处号:%@",qcFriend.userno];
                    NSURL*url=[NSURL URLWithString:qcFriend.avatarUrl];
                [infoView setTitle:[NSString stringWithFormat:@"%d岁",qcFriend.age] forState:UIControlStateNormal];
                    [namePic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"login_user_default_logo"]];
                [MBProgressHUD hideHUD];
            }
            
            
            
            [MBProgressHUD hideHUD];
            
        }
        else
        {
            [MBProgressHUD hideHUD];
            return ;
        }
        
        
        

        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        
        [MBProgressHUD hideHUD];
    }];
    
    
    
}

//标签大类
-(void)userLabelled
{

    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"uid"]=@(self.uid);
    
    //[MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:GETMARKGROUP parameter:dic success:^(id response) {
        
        
//        personMark = [QCPersonMarkModel objectWithKeyValues:response];
        
        [self.personMarkArr removeAllObjects];
        [self.userMarkArr removeAllObjects];
        NSArray* temparr=response;
        if (temparr.count > 0) {
            
            if (self.isFriend==NO) {
            scrollBaV.contentSize=CGSizeMake(0, self.view.frame.size.height/3+10+(47*3)+30+(47*temparr.count)+self.view.frame.size.height+114+54);
            } else{
            scrollBaV.contentSize=CGSizeMake(0, self.view.frame.size.height/3+10+(47*4)+30+(47*temparr.count)+self.view.frame.size.height+114+54);
            
            }
            
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
            
            [bottomTb reloadData];
           // [MBProgressHUD hideHUD];
            
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


//#pragma -mark 删除标签
//-(void)deleteTagwith:(NSInteger)ID
//{
//    
//    
//    
//    
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    //    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
//    //
//    dic[@"userMarkId"]=@(ID);//
//    [MBProgressHUD showMessage:nil background:NO];
//    [NetworkManager requestWithURL:USERINFO_DELETPUSERMARK parameter:dic success:^(id response) {
//        
//        
//        [self userLabelled];
//        [MBProgressHUD hideHUD];
//    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
//        CZLog(@"%@", error);
//        [MBProgressHUD hideHUD];
//        
//    }];
//    
//    
//}




-(void)getMarksByGroupId:(long)GroupId
{


    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    dic[@"groupId"]=@(GroupId);
    dic[@"page"]=@0;
    
    
    [NetworkManager requestWithURL:QUERYTAG parameter:dic success:^(id response) {
        NSLog(@"%@",response);
        NSMutableArray*temparr=[[NSMutableArray alloc]initWithArray:response];
        NSMutableArray*userArr=[[NSMutableArray alloc]init];
        
        for (int i=0; i<temparr.count; i++) {
            
        QCGetUserMarkModel*getUserMark=[[QCGetUserMarkModel alloc]init];
        getUserMark=[QCGetUserMarkModel mj_objectWithKeyValues:temparr[i]];
        [userArr addObject:getUserMark];
            
        }
        NSInteger index = [self indexForGroupID:GroupId];
        NSMutableArray * array = self.userMarkArr[index];
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


//-(void)deleteTags:(NSNotification*)n
//{
//    NSInteger inSection=[n.userInfo[@"inSection"] integerValue];
//    NSInteger index=[n.userInfo[@"index"] integerValue];
//    
//    NSMutableArray*tempArr= self.userMarkArr[inSection];
//    
//    QCGetUserMarkModel*data= tempArr[index];
//    [self deleteTagwith:data.ID];
//    
//    
//    
//    
//    
//}



-(void)commturns
{
//   self.navigationController.navigationBar.translucent = NO;
    [self getData];
    
    



}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

-(void)touchleftBtn
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)rightButton{

//    Figure = [[UIActionSheet alloc]
//              initWithTitle:nil
//              delegate:self
//              cancelButtonTitle:@"取消"
//              destructiveButtonTitle:nil
//              otherButtonTitles: @"发送该名片",@"举报",@"添加到桌面",nil];
    Figure = [[UIActionSheet alloc]
              initWithTitle:nil
              delegate:self
              cancelButtonTitle:@"取消"
              destructiveButtonTitle:nil
              otherButtonTitles: @"发送该名片",@"举报",nil];
    
    
    
    [Figure showInView:self.view];


}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    
    
    
    if (buttonIndex == Figure.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    
    switch (buttonIndex) {
        case 0:
            NSLog(@"发送名片");
        {
            QCSelectContactsVC*sc=[QCSelectContactsVC new];
            [self.navigationController pushViewController:sc animated:YES];
        
        }
            break;
        case 1:
            NSLog(@"举报");
        {
            QCReportVC*report=[QCReportVC new];
            report.destId=self.uid;
            [self.navigationController pushViewController:report animated:YES];
        }
            break;
//        case 2:
//            NSLog(@"添加到桌面");
//            
//            
//                        
//            break;
   
            
        default:
            break;
    }
    
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
