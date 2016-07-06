//
//  QCLJRiXingVC.m
//  MyQOOCOO
//
//  Created by lanou on 16/3/22.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCHFRiXingVC.h"

#import "QCAddRixingVC.h"

#import "QCDayLogModel.h"
@interface QCHFRiXingVC ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    UIScrollView *scroll;
    
    
    UIView * headerView;
    UIView * dateView;
    UITableView * tableViews;
    int j;
    int v;
    
    UIView * addDayLogView;
    UIView * sameDianDiView;
    NSString * dayDate1;
    NSString * dayDate2;
    NSString * dayDate3;
    NSString * dayDate4;
    NSString * dayDate5;
    NSString * dayDate6;
    NSString * dayDate7;
    
    NSDate *currentDate;
    NSDateFormatter *dateFormatter;
    
    UIView * dayLogView;
    UIView * titleView;
    UIView * sameToDDView;
    UIButton * currentButton;
    UIView * titleViews;
    
    NSString * selectDate;
}
@property (strong, nonatomic) NSArray * nameArray;
/**日省项*/
@property (strong, nonatomic) NSMutableArray * dayLogDataArr;
/**日省内容*/
@property (strong, nonatomic) NSMutableArray * dayLogNameArr;

@property (strong, nonatomic) NSMutableArray * dayDate1Arr;
@property (strong, nonatomic) NSMutableArray * dayDate2Arr;
@property (strong, nonatomic) NSMutableArray * dayDate3Arr;
@property (strong, nonatomic) NSMutableArray * dayDate4Arr;
@property (strong, nonatomic) NSMutableArray * dayDate5Arr;
@property (strong, nonatomic) NSMutableArray * dayDate6Arr;
@property (strong, nonatomic) NSMutableArray * dayDate7Arr;
@end

@implementation QCHFRiXingVC
static int i=0;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _dayLogDataArr = [NSMutableArray array];
    _dayLogNameArr = [NSMutableArray array];
    _dayDate1Arr = [NSMutableArray array];
    _dayDate2Arr = [NSMutableArray array];
    _dayDate3Arr = [NSMutableArray array];
    _dayDate4Arr = [NSMutableArray array];
    _dayDate5Arr = [NSMutableArray array];
    _dayDate6Arr = [NSMutableArray array];
    _dayDate7Arr = [NSMutableArray array];
    
    currentDate = [NSDate date];//获取当前时间，日期
    j = 0;
    v = 0;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    
    [self initHeaderView];
    [self initAddDayLog];
    [self initSameToDianDi];
    [self initTableView];
    [self initDateView];
    [self initDayLogData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dayLogView.hidden = NO;
    
    UIBarButtonItem * keepBar =[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(keepDayLog:)];
    self.navigationItem.rightBarButtonItem = keepBar;
}

- (void)keepDayLog:(UIBarButtonItem *)bar
{
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, YES, 0.0);
    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    CGRect rect =CGRectMake(0, 0, self.view.frame.size.width*3, self.view.frame.size.height*3);//这里可以设置想要截图的区域
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);//保存图片到照片库
    NSData *imageViewData = UIImagePNGRepresentation(sendImage);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pictureName= [NSString stringWithFormat:@"库牌日省%d.png",i];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:pictureName];
    NSLog(@"%@", savedImagePath);
    [imageViewData writeToFile:savedImagePath atomically:YES];//保存照片到沙盒目录
    CGImageRelease(imageRefRect);
    
    [OMGToast showText:@"保存成功,请到相册查看"];
    i++;
}

- (void)initHeaderView
{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH(self.view), WIDTH(self.view)/4-10)];
    headerView.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    
    self.nameArray = @[@"满意", @"一般", @"不满意"];
    
    for (int i = 1; i < 4; i++) {
        
        NSString * name = [NSString stringWithFormat:@"rixing%d", i];
        
        UIImage * image = [UIImage imageNamed:name];
        
        UIView * views = [[UIView alloc] initWithFrame:CGRectMake(WIDTH(headerView)/3*((i-1)%3), 0, WIDTH(headerView)/3, HEIGHT(headerView))];
        
        //按钮图
        UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(views)/2-(WIDTH(views)/4)/2, (HEIGHT(views)-WIDTH(views)/4-((WIDTH(views)/4)/2+13))/2, WIDTH(views)/4, WIDTH(views)/4)];
        imageV.image = image;
        
        
        //按钮文本
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(imageV)+13, WIDTH(views), HEIGHT(imageV)/2)];
        //        label.backgroundColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:HEIGHT(label)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"333333"];
        label.text = _nameArray[i-1];
        
        [views addSubview:label];
        
        [views addSubview:imageV];
        
        [headerView addSubview:views];
        
    }
    
    [self.view addSubview:headerView];
}

- (void)initDateView
{
    dateView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(headerView), WIDTH(self.view), WIDTH(self.view)/13)];
    dateView.backgroundColor = kLoginbackgoundColor;
    
    for (int i = 1; i < 8; i++) {
        //按钮文本
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(scroll)/8+WIDTH(scroll)/8*((i-1)%8), 0, WIDTH(scroll)/8, WIDTH(self.view)/13)];
        label.font = [UIFont systemFontOfSize:HEIGHT(label)/2];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor=kLoginbackgoundColor;
        label.textColor = [UIColor whiteColor];
        
#pragma -mark 计算一天的时间间隔
        NSTimeInterval time = 24 * 60 * 60;
        //将时间间隔跟当前时间进行计算
        NSDate * lastdata = [currentDate dateByAddingTimeInterval:-time*(i-1)];
        NSString *dateString = [dateFormatter stringFromDate:lastdata];
        
        label.text = dateString;
        switch (i) {
            case 1:
                dayDate1 = dateString;
                break;
            case 2:
                dayDate2 = dateString;
                break;
            case 3:
                dayDate3 = dateString;
                break;
            case 4:
                dayDate4 = dateString;
                break;
            case 5:
                dayDate5 = dateString;
                break;

            case 6:
                dayDate6 = dateString;
                break;

            case 7:
                dayDate7 = dateString;
                break;

            default:
                break;
        }
        [scroll addSubview:label];
        
    }
    
//    [self.view addSubview:dateView];
}

- (void)initTableView
{
    
    scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, MaxY(headerView), WIDTH(self.view)/5*8, HEIGHT(self.view)-HEIGHT(headerView)-HEIGHT(dateView)-64)];
    
    //设置可滚动范围
    scroll.contentSize=CGSizeMake( WIDTH(self.view)/5*8+(WIDTH(self.view)/5*8-self.view.frame.size.width),0);
    scroll.backgroundColor=[UIColor whiteColor];
    scroll.scrollEnabled = YES;
    
    //分页显示
    scroll.pagingEnabled=NO;
    
    //滑动到第一页和最后一页是否允许继续滑动
    
    scroll.bounces=NO;
    
    //取消滚动条
    
    scroll.showsHorizontalScrollIndicator=NO;//水平(横)
    
    scroll.showsVerticalScrollIndicator=NO;//垂直(竖)
    
    scroll.showsVerticalScrollIndicator = FALSE;
    scroll.showsHorizontalScrollIndicator = FALSE;
    
    //指定代理人
    scroll.delegate=self;
    
    //偏移量(重要)一开始显示到第几张
    scroll.contentOffset=CGPointMake(0,0);
    

    [self.view addSubview:scroll];
    
        UIView*topv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(scroll)/8, WIDTH(self.view)/13)];
        topv.backgroundColor=kLoginbackgoundColor;
        [scroll addSubview:topv];
    

    tableViews = [[UITableView alloc] initWithFrame:CGRectMake(0,  WIDTH(self.view)/13, WIDTH(scroll), HEIGHT(scroll)) style:UITableViewStylePlain];
    tableViews.delegate = self;
    tableViews.dataSource = self;
    tableViews.bounces = NO;
    tableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViews.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    
    [scroll addSubview:tableViews];
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(scroll), 8)];
    footerView.backgroundColor = [UIColor colorWithRed:233.0/255 green:233.0/255 blue:233.0/255 alpha:1];
    [tableViews setTableFooterView:footerView];
}

#pragma -mark 日省项
- (void)initDayLogData
{
    NSString *timeSp = [NSString stringWithFormat:@"%lld", (long long)[currentDate timeIntervalSince1970]*1000];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"timestamp"] = timeSp;
    
    [NetworkManager requestWithURL:DAYLOGLIST parameter:dic success:^(id response) {
        
        NSDictionary * dic = response;
        CZLog(@"%@",response);
        NSArray * arr = [dic objectForKey:@"list"];
        
        [_dayLogDataArr removeAllObjects];
        [_dayDate1Arr removeAllObjects];
        [_dayDate2Arr removeAllObjects];
        [_dayDate3Arr removeAllObjects];
        [_dayDate4Arr removeAllObjects];
        [_dayDate5Arr removeAllObjects];
        [_dayDate6Arr removeAllObjects];
        [_dayDate7Arr removeAllObjects];
        [_dayLogNameArr removeAllObjects];
        if (arr.count > 0) {
            
            [_dayLogDataArr addObjectsFromArray:arr];
            
            for (NSDictionary * dics in arr) {
                
                [_dayLogNameArr addObject:dics[@"title"]];
                NSArray * arrs = dics[@"records"];
                
                for (NSDictionary * diced in arrs) {
                    NSString * str = diced[@"times"];
                    long long da = [str longLongValue]/1000;
                    NSDate *dayDates = [NSDate dateWithTimeIntervalSince1970:da];
                    NSString *confromTimespStr = [dateFormatter stringFromDate:dayDates];
                    
                    if ([confromTimespStr isEqualToString:dayDate1]) {
                        [_dayDate1Arr addObject:diced[@"value"]];
                    }
                    else if ([confromTimespStr isEqualToString:dayDate2])
                    {
                        [_dayDate2Arr addObject:diced[@"value"]];
                    }
                    else if ([confromTimespStr isEqualToString:dayDate3])
                    {
                        [_dayDate3Arr addObject:diced[@"value"]];
                    }
                    else if ([confromTimespStr isEqualToString:dayDate4])
                    {
                        [_dayDate4Arr addObject:diced[@"value"]];
                    }
                    else if ([confromTimespStr isEqualToString:dayDate5])
                    {
                        [_dayDate5Arr addObject:diced[@"value"]];
                    }

                    else if ([confromTimespStr isEqualToString:dayDate6])
                    {
                        [_dayDate6Arr addObject:diced[@"value"]];
                    }

                    else if ([confromTimespStr isEqualToString:dayDate7])
                    {
                        [_dayDate7Arr addObject:diced[@"value"]];
                    }

                }
                
            }
            
            [tableViews reloadData];
        }
        else
        {
            [tableViews reloadData];
            return ;
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
    
}



- (UIView *)DayLogListViewAtIndex:(NSInteger) index
{
    UIView * dayLogListV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(scroll), WIDTH(self.view)/8)];
    dayLogListV.backgroundColor = [UIColor whiteColor];
    for (int i = 1; i < 9; i++) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(WIDTH(dayLogListV)/8*((i-1)%8), 0, WIDTH(dayLogListV)/8, HEIGHT(dayLogListV))];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH(view), HEIGHT(view))];
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:HEIGHT(titleLabel)/3];
        titleLabel.userInteractionEnabled = YES;
        titleLabel.tag = index;
        
        NSDictionary * dic = _dayLogDataArr[index];
        
        titleLabel.text = dic[@"title"];
#pragma -mark 长按删除
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressBtn:)];
        [longPressGesture setDelegate:self];
        //允许15秒中运动
        longPressGesture.allowableMovement=NO;
        //所需触摸1次
        longPressGesture.numberOfTouchesRequired=1;
        longPressGesture.minimumPressDuration=0.5;//默认0.5秒
        [titleLabel addGestureRecognizer:longPressGesture];
        
        if (i == 1) {
            [view addSubview:titleLabel];
        }
        else
        {
            UIImageView * imageD = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, WIDTH(view)-16, HEIGHT(view)-16)];
            imageD.tag = index;
            imageD.layer.masksToBounds = NO;
            imageD.contentMode = UIViewContentModeScaleAspectFit;
            imageD.userInteractionEnabled = YES;
            [view addSubview:imageD];
            
            NSArray * arr = dic[@"records"];
            if (arr.count>0) {
                for (NSDictionary * dics in arr) {
                    NSString * str = dics[@"times"];
                    long long da = [str longLongValue];
                    NSDate *dayDates = [NSDate dateWithTimeIntervalSince1970:da/1000];
                    NSString *confromTimespStr = [dateFormatter stringFromDate:dayDates];
                    
                    if ([confromTimespStr isEqualToString:dayDate1]) {
                        if (i == 2) {
                            if ([dics[@"value"] integerValue] == 0) {
                                imageD.image = [UIImage imageNamed:@"rixing3"];
                            }
                            else if ([dics[@"value"] integerValue] == 1){
                                imageD.image = [UIImage imageNamed:@"rixing2"];
                            }
                            else if ([dics[@"value"] integerValue] == 2)
                            {
                                imageD.image = [UIImage imageNamed:@"rixing1"];
                            }
                        }
                    }
                    else if ([confromTimespStr isEqualToString:dayDate2])
                    {
                        if (i == 3) {
                            if ([dics[@"value"] integerValue] == 0) {
                                imageD.image = [UIImage imageNamed:@"rixing3"];
                            }
                            else if ([dics[@"value"] integerValue] == 1){
                                imageD.image = [UIImage imageNamed:@"rixing2"];
                            }
                            else if ([dics[@"value"] integerValue] == 2)
                            {
                                imageD.image = [UIImage imageNamed:@"rixing1"];
                            }
                        }
                    }
                    else if ([confromTimespStr isEqualToString:dayDate3])
                    {
                        if (i == 4) {
                            if ([dics[@"value"] integerValue] == 0) {
                                imageD.image = [UIImage imageNamed:@"rixing3"];
                            }
                            else if ([dics[@"value"] integerValue] == 1){
                                imageD.image = [UIImage imageNamed:@"rixing2"];
                            }
                            else if ([dics[@"value"] integerValue] == 2)
                            {
                                imageD.image = [UIImage imageNamed:@"rixing1"];
                            }
                        }
                    }
                    else if ([confromTimespStr isEqualToString:dayDate4])
                    {
                        if (i == 5) {
                            if ([dics[@"value"] integerValue] == 0) {
                                imageD.image = [UIImage imageNamed:@"rixing3"];
                            }
                            else if ([dics[@"value"] integerValue] == 1){
                                imageD.image = [UIImage imageNamed:@"rixing2"];
                            }
                            else if ([dics[@"value"] integerValue] == 2)
                            {
                                imageD.image = [UIImage imageNamed:@"rixing1"];
                            }
                        }
                    }
                    else if ([confromTimespStr isEqualToString:dayDate5])
                    {
                        if (i == 6) {
                            if ([dics[@"value"] integerValue] == 0) {
                                imageD.image = [UIImage imageNamed:@"rixing3"];
                            }
                            else if ([dics[@"value"] integerValue] == 1){
                                imageD.image = [UIImage imageNamed:@"rixing2"];
                            }
                            else if ([dics[@"value"] integerValue] == 2)
                            {
                                imageD.image = [UIImage imageNamed:@"rixing1"];
                            }
                        }
                    }
                    else if ([confromTimespStr isEqualToString:dayDate6])
                    {
                        if (i == 7) {
                            if ([dics[@"value"] integerValue] == 0) {
                                imageD.image = [UIImage imageNamed:@"rixing3"];
                            }
                            else if ([dics[@"value"] integerValue] == 1){
                                imageD.image = [UIImage imageNamed:@"rixing2"];
                            }
                            else if ([dics[@"value"] integerValue] == 2)
                            {
                                imageD.image = [UIImage imageNamed:@"rixing1"];
                            }
                        }
                    }
                    else if ([confromTimespStr isEqualToString:dayDate7])
                    {
                        if (i == 8) {
                            if ([dics[@"value"] integerValue] == 0) {
                                imageD.image = [UIImage imageNamed:@"rixing3"];
                            }
                            else if ([dics[@"value"] integerValue] == 1){
                                imageD.image = [UIImage imageNamed:@"rixing2"];
                            }
                            else if ([dics[@"value"] integerValue] == 2)
                            {
                                imageD.image = [UIImage imageNamed:@"rixing1"];
                            }
                        }
                    }



                    
                }
            }
            
            if (i == 2) {
                if (imageD.image == nil) {
#pragma -mark 轻点添加
                    UITapGestureRecognizer * sDayLogTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDayLog:)];
                    [imageD addGestureRecognizer:sDayLogTap];
                }
                else
                {
#pragma -mark 轻点替换
                    UITapGestureRecognizer * rDayLogTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(replaceDayLog:)];
                    [imageD addGestureRecognizer:rDayLogTap];
                }
                
            }
            else{
                
                UITapGestureRecognizer * notdayLogTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noTDayLog:)];
                [imageD addGestureRecognizer:notdayLogTap];
            }
            
            
        }
        
        
        UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT(view)-1, WIDTH(view), 1)];
        line.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
        [view addSubview:line];
        
        [dayLogListV addSubview:view];
    }
    return dayLogListV;
}


#pragma -mark 删除行
- (void)longPressBtn:(UILongPressGestureRecognizer *)longPress
{
    if ([longPress state] == UIGestureRecognizerStateEnded) {
        //长按事件开始"
        //do something
        
    }
    else if ([longPress state] == UIGestureRecognizerStateBegan)
    {
        [self initDayLogview:longPress.view.tag];
    }
    
}

- (void)initDayLogview:(NSInteger)indexs
{
    dayLogView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view))];
    dayLogView.backgroundColor = kColorRGBA(52,52,52,0.3);
    dayLogView.userInteractionEnabled = YES;
    [self.navigationController.view addSubview:dayLogView];
    
    titleView = [[UIView alloc] initWithFrame:CGRectMake(30, (HEIGHT(dayLogView)-HEIGHT(dayLogView)/3)/2, WIDTH(dayLogView)-60, HEIGHT(dayLogView)/3)];
    titleView.backgroundColor = [UIColor whiteColor];
    [dayLogView addSubview:titleView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT(titleView)/2-(HEIGHT(titleView)/5)/2-10, WIDTH(titleView), HEIGHT(titleView)/5)];
    label.text = @"删除当前行";
    label.textColor = [UIColor colorWithHexString:@"333333"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:HEIGHT(label)*2/5];
    [titleView addSubview:label];
    
    UIButton * cancelBu = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBu.frame = CGRectMake(0, HEIGHT(titleView)-HEIGHT(titleView)/5, WIDTH(titleView)/2, HEIGHT(titleView)/5);
    [cancelBu setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBu.titleLabel setFont:[UIFont systemFontOfSize:HEIGHT(cancelBu)*2/5]];
    [cancelBu setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [cancelBu actionButton:^(UIButton *sender) {
        
        [dayLogView removeFromSuperview];
        
    }];
    [titleView addSubview:cancelBu];
    
    UIButton * doneBu = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBu.frame = CGRectMake(MaxX(cancelBu), Y(cancelBu), WIDTH(cancelBu), HEIGHT(cancelBu));
    [doneBu.titleLabel setFont:[UIFont systemFontOfSize:HEIGHT(doneBu)*2/5]];
    [doneBu setTitle:@"确定" forState:UIControlStateNormal];
    [doneBu setTitleColor:[UIColor colorWithHexString:@"#2ab6f4"] forState:UIControlStateNormal];
    [doneBu actionButton:^(UIButton *sender) {
        
        NSDictionary * dic = _dayLogDataArr[indexs];
        
        [self initDeleteDayLog:dic[@"id"]];
        
    }];
    [titleView addSubview:doneBu];
    
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT(titleView)-HEIGHT(cancelBu)-0.5, WIDTH(titleView), 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"E0E0E0"];
    [titleView addSubview:line];
    
    
    //#pragma -mark 轻点消失
    //    UITapGestureRecognizer * dismissTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissTap:)];
    //    [dayLogView addGestureRecognizer:dismissTap];
}

#pragma -mark 同步到点滴
- (void)initSameToDD
{
    sameToDDView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view))];
    sameToDDView.backgroundColor = kColorRGBA(52,52,52,0.3);
    sameToDDView.userInteractionEnabled = YES;
    [self.navigationController.view addSubview:sameToDDView];
    
    titleViews = [[UIView alloc] initWithFrame:CGRectMake(0,  0, [UIScreen mainScreen].bounds.size.width-60, 280)];
    titleViews.center = sameToDDView.center;
    titleViews.backgroundColor = [UIColor whiteColor];
    [sameToDDView addSubview:titleViews];
    
    UIButton * cancelBu = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBu.frame = CGRectMake(0, 0, WIDTH(titleViews)/4, HEIGHT(titleViews)/5);
    [cancelBu setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBu.titleLabel setFont:[UIFont systemFontOfSize:HEIGHT(cancelBu)/4]];
    [cancelBu setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [cancelBu actionButton:^(UIButton *sender) {
        
        [sameToDDView removeFromSuperview];
        
    }];
    [titleViews addSubview:cancelBu];
    
    UILabel * titleLa = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(cancelBu), 0, WIDTH(titleViews)/2, HEIGHT(titleViews)/5)];
    titleLa.text = @"同步选择日期到点滴";
    titleLa.textAlignment = NSTextAlignmentCenter;
    [titleLa setFont:[UIFont systemFontOfSize:HEIGHT(titleLa)/4]];
    [titleLa setTextColor:[UIColor colorWithHexString:@"333333"]];
    [titleViews addSubview:titleLa];
    
    UIButton * doneBu = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBu.frame = CGRectMake(MaxX(titleLa), Y(cancelBu), WIDTH(cancelBu), HEIGHT(cancelBu));
    [doneBu.titleLabel setFont:[UIFont systemFontOfSize:HEIGHT(doneBu)/4]];
    [doneBu setTitle:@"确定" forState:UIControlStateNormal];
    [doneBu setTitleColor:[UIColor colorWithHexString:@"#2ab6f4"] forState:UIControlStateNormal];
    [doneBu actionButton:^(UIButton *sender) {
        
        if (selectDate.length > 0) {
            
            if ([selectDate isEqualToString:dayDate1]) {
                if (_dayDate1Arr.count > 0) {
                    
                    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                    dic[@"day"] = selectDate;
                    //把数组转换成字符串
                    dic[@"key"] = [_dayLogNameArr componentsJoinedByString:@","];
                    dic[@"value"] = [_dayDate1Arr componentsJoinedByString:@","];
                    dic[@"keyCount"] = @"0";
                    //字典转字符串
                    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    
                    [self initSameToDianDiData:str];
                }
                else
                {
                    [OMGToast showText:@"日省内容不能为空"];
                }
            }
            else if ([selectDate isEqualToString:dayDate2])
            {
                if (_dayDate2Arr.count > 0) {
                    
                    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                    dic[@"day"] = selectDate;
                    //把数组转换成字符串
                    dic[@"key"] = [_dayLogNameArr componentsJoinedByString:@","];
                    dic[@"value"] = [_dayDate2Arr componentsJoinedByString:@","];
                    dic[@"keyCount"] = @"0";
                    //字典转字符串
                    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    
                    [self initSameToDianDiData:str];
                }
                else
                {
                    [OMGToast showText:@"日省内容不能为空"];
                }
            }
            else if ([selectDate isEqualToString:dayDate3])
            {
                if (_dayDate3Arr.count > 0) {
                    
                    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                    dic[@"day"] = selectDate;
                    //把数组转换成字符串
                    dic[@"key"] = [_dayLogNameArr componentsJoinedByString:@","];
                    dic[@"value"] = [_dayDate3Arr componentsJoinedByString:@","];
                    dic[@"keyCount"] = @"0";
                    //字典转字符串
                    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    
                    [self initSameToDianDiData:str];
                }
                else
                {
                    [OMGToast showText:@"日省内容不能为空"];
                }
            }
            else if ([selectDate isEqualToString:dayDate4])
            {
                if (_dayDate4Arr.count > 0) {
                    
                    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                    dic[@"day"] = selectDate;
                    //把数组转换成字符串
                    dic[@"key"] = [_dayLogNameArr componentsJoinedByString:@","];
                    dic[@"value"] = [_dayDate4Arr componentsJoinedByString:@","];
                    dic[@"keyCount"] = @"0";
                    //字典转字符串
                    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    
                    [self initSameToDianDiData:str];
                }
                
                else
                {
                    [OMGToast showText:@"日省内容不能为空"];
                }
            }
            else if ([selectDate isEqualToString:dayDate5])
            {
                if (_dayDate5Arr.count > 0) {
                    
                    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                    dic[@"day"] = selectDate;
                    //把数组转换成字符串
                    dic[@"key"] = [_dayLogNameArr componentsJoinedByString:@","];
                    dic[@"value"] = [_dayDate5Arr componentsJoinedByString:@","];
                    dic[@"keyCount"] = @"0";
                    //字典转字符串
                    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    
                    [self initSameToDianDiData:str];
                }
                
                else
                {
                    [OMGToast showText:@"日省内容不能为空"];
                }
            }

            else if ([selectDate isEqualToString:dayDate6])
            {
                if (_dayDate6Arr.count > 0) {
                    
                    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                    dic[@"day"] = selectDate;
                    //把数组转换成字符串
                    dic[@"key"] = [_dayLogNameArr componentsJoinedByString:@","];
                    dic[@"value"] = [_dayDate6Arr componentsJoinedByString:@","];
                    dic[@"keyCount"] = @"0";
                    //字典转字符串
                    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    
                    [self initSameToDianDiData:str];
                }
                
                else
                {
                    [OMGToast showText:@"日省内容不能为空"];
                }
            }

            else if ([selectDate isEqualToString:dayDate7])
            {
                if (_dayDate7Arr.count > 0) {
                    
                    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                    dic[@"day"] = selectDate;
                    //把数组转换成字符串
                    dic[@"key"] = [_dayLogNameArr componentsJoinedByString:@","];
                    dic[@"value"] = [_dayDate7Arr componentsJoinedByString:@","];
                    dic[@"keyCount"] = @"0";
                    //字典转字符串
                    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    
                    [self initSameToDianDiData:str];
                }
                
                else
                {
                    [OMGToast showText:@"日省内容不能为空"];
                }
            }

            
        }
        else
        {
            [OMGToast showText:@"请选择日期"];
        }
        
        
    }];
    [titleViews addSubview:doneBu];
    
    
    NSArray * dateArr = @[dayDate1, dayDate2, dayDate3, dayDate4,dayDate5,dayDate6,dayDate7];
    for (int i = 1; i < 8; i++) {
        //CGRectMake(0, (HEIGHT(titleViews)-HEIGHT(titleViews)/8)/4*((i-1)/1) + HEIGHT(titleViews)/8, WIDTH(titleViews), HEIGHT(titleViews)/8)
        UIButton * dateBu = [UIButton buttonWithType:UIButtonTypeCustom];
        dateBu.frame = CGRectMake(0, HEIGHT(titleViews)/8*i, WIDTH(titleViews), HEIGHT(titleViews)/8);
        dateBu.titleLabel.font = [UIFont systemFontOfSize:15];
        dateBu.titleLabel.textAlignment = NSTextAlignmentCenter;
        [dateBu setTitle:dateArr[i-1] forState:UIControlStateNormal];
        dateBu.tag = i - 1;
        [dateBu addTarget:self action:@selector(sameToDD:) forControlEvents:UIControlEventTouchUpInside];
        [dateBu setTitleColor:[UIColor colorWithHexString:@"#2ab6f4"] forState:UIControlStateSelected];
        [dateBu setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [titleViews addSubview:dateBu];
        
//        UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT(dateBu)-0.5, WIDTH(titleViews), 0.5)];
//        line.backgroundColor = [UIColor colorWithHexString:@"E0E0E0"];
//        [dateBu addSubview:line];
    }
}

- (void)sameToDD:(UIButton *)bu
{
#pragma 改变当前 button 颜色,其他保持原状
    currentButton.selected = NO;
    currentButton = bu;
    currentButton.selected  = YES;
    
    selectDate = bu.titleLabel.text;
    //    CZLog(@"%@", bu.titleLabel.text);
}

- (void)initSameToDianDiData:(NSString *)content
{
    [sameToDDView removeFromSuperview];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"permission"] = @"1";
    dic[@"contentType"] = @"1";
    dic[@"content"] = content;
    dic[@"type"] = @"2";
    dic[@"ranges"] = @"1";
    
    
    [NetworkManager requestWithURL:RECORD_CREATE_URL parameter:dic success:^(id response) {
        CZLog(@"%@", response);
        [OMGToast showText:@"同步成功"];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
}

#pragma -mark 删除日省项
- (void)initDeleteDayLog:(NSString *)dayLogId
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"dayLogId"] = dayLogId;
    
    [NetworkManager requestWithURL:DELETEDAYLOG parameter:dic success:^(id response) {
        CZLog(@"%@", response);
        [self initDayLogData];
        [dayLogView removeFromSuperview];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
}

- (void)selectDayLog:(UITapGestureRecognizer *)tap
{
    //根据日期返回NSDate
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    [comps setDay:currentDate.day];
    [comps setMonth:currentDate.month];
    [comps setYear:currentDate.year];
    NSCalendar * cale = [NSCalendar currentCalendar];
    NSDate * d = [cale dateFromComponents:comps];
    NSString *timeSp = [NSString stringWithFormat:@"%lld", (long long)[d timeIntervalSince1970]*1000];
    
    NSDictionary * dic = _dayLogDataArr[tap.view.tag];
    
    [self initaddDayLogRecord:timeSp logId:dic[@"id"] value:@"2"];
}

- (void)replaceDayLog:(UITapGestureRecognizer *)tap
{
    
    
    NSDictionary * dic = _dayLogDataArr[tap.view.tag];
    NSArray * arr = dic[@"records"];
    
    for (NSDictionary * rDic in arr) {
        NSString * str = rDic[@"times"];
        long long da = [str longLongValue];
        NSDate *dayDates = [NSDate dateWithTimeIntervalSince1970:da/1000];
        NSString *confromTimespStr = [dateFormatter stringFromDate:dayDates];
        
        NSString * va;
        if ([rDic[@"value"] intValue] == 2)
        {
            va = @"1";
        }
        else if ([rDic[@"value"] intValue] == 1)
        {
            va = @"0";
        }
        else
        {
            va = @"2";
        }
        
        if ([confromTimespStr isEqualToString:dayDate1])
        {
            
            [self initUpdateDayLogRecord:rDic[@"id"] value:va];
        }
    }
}

- (void)noTDayLog:(UITapGestureRecognizer *)tap
{
    [OMGToast showText:@"设置不能超过一天"];
}

#pragma -mark 修改日省项记录
- (void)initUpdateDayLogRecord:(NSString *)recordId value:(NSString *)value;
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"recordId"] = recordId;
    dic[@"value"] = value;
    
    [NetworkManager requestWithURL:UPDATEDAYLOGRECORD parameter:dic success:^(id response) {
        CZLog(@"%@", response);
        [self initDayLogData];
        [tableViews reloadData];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
}

#pragma -mark 添加日省项纪录
- (void)initaddDayLogRecord:(NSString *)timestamp logId:(NSString *)logId value:(NSString *)value
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"timestamp"] = timestamp;
    dic[@"logId"] = logId;
    dic[@"value"] = value;
    
    [NetworkManager requestWithURL:ADDDATLOGRECORD parameter:dic success:^(id response) {
        CZLog(@"%@", response);
        
        [self initDayLogData];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [tableViews reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
}

- (void)initAddDayLog
{
    addDayLogView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view)/8.5)];
    UIImageView * addImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, HEIGHT(addDayLogView)/2-(HEIGHT(addDayLogView)/2)/2, HEIGHT(addDayLogView)/2, HEIGHT(addDayLogView)/2)];
    [addImage setImage:[UIImage imageNamed:@"addshi"]];
    [addDayLogView addSubview:addImage];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(addImage)+8, Y(addImage), HEIGHT(addImage)*10, HEIGHT(addImage))];
    label.textColor = [UIColor colorWithHexString:@"333333"];
    label.text = @"添加日省项（长按可以删除）";
    label.font = [UIFont systemFontOfSize:HEIGHT(label)*2/3];
    [addDayLogView addSubview:label];
}

- (void)initSameToDianDi
{
    sameDianDiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view)/8.5)];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(13, HEIGHT(sameDianDiView)/2-(HEIGHT(sameDianDiView)/2)/2, HEIGHT(sameDianDiView)/2*5, HEIGHT(sameDianDiView)/2)];
    label.textColor = [UIColor colorWithHexString:@"333333"];
    label.text = @"同步到点滴";
    label.font = [UIFont systemFontOfSize:HEIGHT(label)*2/3];
    [sameDianDiView addSubview:label];
}

#pragma -mark tableDelete
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _dayLogDataArr.count;
    }
    else if (section == 1)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dayLogDataArr.count > 0) {
        if (indexPath.section == 0) {
            UIView * vi = [self DayLogListViewAtIndex:indexPath.row];
            [cell.contentView addSubview:vi];
            return cell;
        }
        else if (indexPath.section == 1)
        {
            [cell.contentView addSubview:addDayLogView];
            return cell;
        }
        else
        {
            [cell.contentView addSubview:sameDianDiView];
            return cell;
        }
    }
    else
    {
        if (indexPath.section == 0) {
            return cell;
        }
        else if (indexPath.section == 1)
        {
            [cell.contentView addSubview:addDayLogView];
            return cell;
        }
        else
        {
            [cell.contentView addSubview:sameDianDiView];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (_dayLogDataArr.count < 8) {
            QCAddRixingVC * vc = [[QCAddRixingVC alloc] init];
            vc.title = @"添加日省项";
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [OMGToast showText:@"添加日省项不能超过8个"];
        }
    }
    else if (indexPath.section == 2)
    {
        [self initSameToDD];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 13;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_dayLogDataArr.count>0) {
            return WIDTH(self.view)/8;
        }
        else
        {
            return 0;
        }
        
    }
    else if (indexPath.section == 1)
    {
        return HEIGHT(addDayLogView);
    }
    else
    {
        return HEIGHT(sameDianDiView);
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
