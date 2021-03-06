//
//  QCCreateTaskViewController.m
//  MyQOOCOO
//
//  Created by Zhou Shaolin on 16/7/6.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCCreateTaskViewController.h"
#import "HACursor.h"
#import "diaomaoViewController.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "WPHotspotLabel.h"
#import "fdafViewController.h"
#import "SDCycleScrollView.h"
#import "QCAddUserMarkVC.h"

@interface QCCreateTaskViewController ()

@end

@interface QCCreateTaskViewController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,captureViewControllerDelegate,UIActionSheetDelegate>
{
    NSMutableArray *scrollimages;
    UIView *ContentView;
    UIView *PriceView;
    UIButton *SendBtn;
    UITableView *tableVIew;
    UIActionSheet*Figures;
    SDCycleScrollView *cycleScrollView;
    HACursor *cursor;
}
@property (strong,nonatomic) UIScrollView *SetWorkView;
@property (assign, nonatomic) BOOL showList;
@property (assign, nonatomic) BOOL isOffline;
@property (strong,nonatomic) UIView *hostView;
@property (strong,nonatomic) UILabel *addrTitleLabel;
@property (strong,nonatomic) UILabel *addrValueLabel;
@property (strong,nonatomic) UIButton *onlineButton;
@property (strong,nonatomic) UIButton *offlineButton;
@property (strong,nonatomic) WPHotspotLabel *hintLabel;
@property (strong,nonatomic) UIButton *freeReleaseButton;
@end

@implementation QCCreateTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"快速派活";
    UILabel*titleLb=[[UILabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 90)/2, 0, 90, 30)];
    titleLb.text=@"快速派活";
    _isOffline = NO;
    titleLb.textColor=UIColorFromRGB(0xed6664);
    titleLb.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLb;
    self.titles = @[@"发布任务",@"约单",@"进行中",@"待验收",@"返工",@"完工"];
    cursor = [[HACursor alloc]initWithCursorMode];
    cursor.frame = CGRectMake(0, 0, self.view.width,40);
    cursor.backgroundColor = normalTabbarColor;
    cursor.titles = self.titles;
    cursor.pageViews = [self createPageViews];
    //设置根滚动视图的高度
    cursor.rootScrollViewHeight = self.view.frame.size.height -105;
    cursor.titleNormalColor = UIColorFromRGB(0x9ca0a9);
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
            self.hostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height -64)];
//            _hostView.backgroundColor = [UIColor redColor];

            [pageViews addObject:_hostView];
            
            [self createWorkUI];
            [self createHasUI];
            if (_showList) {
                _SetWorkView.hidden = YES;
                tableVIew.hidden = NO;
            }
            else {
                _SetWorkView.hidden = NO;
                tableVIew.hidden = YES;
            }
            
        }else{
            //            diaomaoViewController*diaomao = [[diaomaoViewController alloc] init];
            //            [pageViews addObject:diaomao];
            UIView *vief = [[UIView alloc] init];
//            vief.backgroundColor = [UIColor redColor];
            [pageViews addObject:vief];
        }
        
    }
    return pageViews;
}


- (void)clickSetWorkBtn:(UIButton*)sender{
    _showList = !_showList;
    sender.selected = _showList;
    if (_showList) {
        _SetWorkView.hidden = YES;
        tableVIew.hidden = NO;
    }
    else {
        _SetWorkView.hidden = NO;
        tableVIew.hidden = YES;
    }
}

- (void)createHasUI{
    tableVIew = [[UITableView alloc] initWithFrame:CGRectMake(0, 38, Main_Screen_Width, Main_Screen_Height - 38 - 64 - 45)];
    tableVIew.delegate = self;
    tableVIew.dataSource = self;
    [self.hostView addSubview:tableVIew];
}
- (void)createWorkUI{
    
    //发布任务^
    self.SetWorkView = [[UIScrollView alloc] init];
    //            _SetWorkView.backgroundColor = [UIColor redColor];
    self.SetWorkView.frame = CGRectMake(0, 38, Main_Screen_Width, Main_Screen_Height - 38 - 64 - 45);
    self.SetWorkView.delegate = self;
    //            self.SetWorkView.pagingEnabled = YES;
    self.SetWorkView.scrollEnabled = YES;
    
    UIButton *SetWorkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    SetWorkBtn.frame = CGRectMake(10, 16, 68, 16);
    [SetWorkBtn setTitle:@"发布任务" forState:UIControlStateNormal];
    [SetWorkBtn setTitleColor:UIColorFromRGB(0x9ca0a9) forState:UIControlStateNormal];
    [SetWorkBtn addTarget:self action:@selector(clickSetWorkBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [SetWorkBtn setImage:[UIImage imageNamed:@"showList"] forState:UIControlStateNormal];
    [SetWorkBtn setImage:[UIImage imageNamed:@"showRelease"] forState:UIControlStateSelected];
    SetWorkBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    SetWorkBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [SetWorkBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [SetWorkBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [SetWorkBtn setImageEdgeInsets:UIEdgeInsetsMake(2, 54, 0, 0)];
    [SetWorkBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -9 , 0, 0)];
    
    
    [self.hostView addSubview:SetWorkBtn];
    
    [self.hostView addSubview:_SetWorkView];
    //内容
    ContentView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, Main_Screen_Width-20, 500)];
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
    if (self.picArr.count == 0) {
        photosSize = CGSizeMake(self.view.frame.size.width - 20, 160);
    }
    self.picV.frame=(CGRect){0,15,photosSize.width*self.picArr.count,photosSize.height};
    [ContentView addSubview:self.picV];
    
    //添加“内容“UIImageView
    UIImageView *contentImg = [[UIImageView alloc] initWithFrame:CGRectMake(-8, -8, 70, 40)];
    contentImg.backgroundColor = kGlobalTitleColor;
    contentImg.layer.cornerRadius = 8;
    contentImg.clipsToBounds = YES;
    UILabel *contentText = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 46, 30)];
    contentText.text = @"内 容";
    contentText.font = [UIFont systemFontOfSize:14];
    contentText.textColor = [UIColor whiteColor];
    [contentImg addSubview:contentText];
    [ContentView addSubview:contentImg];
    
    
    //添加删除ICON和添加图片ICON
    UIImageView *DeleteIc = [[UIImageView alloc] initWithFrame:CGRectMake(30, _picV.frame.size.height-80/2, 80, 80)];
    DeleteIc.userInteractionEnabled = YES;
    DeleteIc.image = [UIImage imageNamed:@"fabuicondelete.png"];
    UITapGestureRecognizer *TapDelete = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapDeltBtn)];
    [DeleteIc addGestureRecognizer:TapDelete];
    [ContentView addSubview:DeleteIc];
    UIImageView *AddIc = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-30-80-20, _picV.frame.size.height-80/2, 80, 80)];
    AddIc.userInteractionEnabled = YES;
    AddIc.image = [UIImage imageNamed:@"fabuicon_Plus.png"];
    UITapGestureRecognizer *TapAddIc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapAddIcBtn)];
    [AddIc addGestureRecognizer:TapAddIc];
    [ContentView addSubview:DeleteIc];
    [ContentView addSubview:AddIc];
    
    //添加详细内容
    UIButton* jobButton = [[UIButton alloc] initWithFrame:CGRectMake((Main_Screen_Width - 20 - 70 ) * 0.5, 225, 70, 35)];

    [jobButton setTitle:@"职业" forState:UIControlStateNormal];
    jobButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    jobButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [jobButton setTitleColor:UIColorFromRGB(0x9ca0a9) forState:UIControlStateNormal];
    jobButton.clipsToBounds = YES;
    jobButton.layer.cornerRadius = 4;
    jobButton.layer.masksToBounds = YES;
    jobButton.layer.borderWidth = 1;
    jobButton.layer.borderColor = UIColorFromRGB(0x9ca0a9).CGColor;
    [ContentView addSubview:jobButton];
    
    UITextField* textFiled = [[UITextField alloc] initWithFrame:CGRectMake((Main_Screen_Width - 20 - 280 ) * 0.5, 280, 280, 20)];
    textFiled.placeholder = @"* 请输入标题,如:模特兼职、心理咨询   0/8";
    textFiled.textColor = UIColorFromRGB(0x9ca0a9);
    textFiled.font = [UIFont systemFontOfSize:12];
    textFiled.textAlignment = NSTextAlignmentCenter;
    textFiled.borderStyle = UITextBorderStyleNone;
    [ContentView addSubview:textFiled];
    
    UIImageView* seprateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 325, Main_Screen_Width - 20, 1)];
    seprateImageView.image = [UIImage imageNamed:@"curSep"];
    seprateImageView.clipsToBounds = YES;
    seprateImageView.contentMode = UIViewContentModeScaleAspectFill;
    [ContentView addSubview:seprateImageView];
    
    UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 325 + 20, Main_Screen_Width - 40, ContentView.frame.size.height - 325 - 40)];

    textView.textColor = UIColorFromRGB(0x9ca0a9);
    textView.font = [UIFont systemFontOfSize:12];
    [ContentView addSubview:textView];
    UILabel *textViewHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 325 + 20, Main_Screen_Width - 40, ContentView.frame.size.height - 325 - 40)];
    
    textViewHintLabel.textColor = UIColorFromRGB(0x9ca0a9);
    textViewHintLabel.font = [UIFont systemFontOfSize:12];
    [ContentView addSubview:textViewHintLabel];
    textViewHintLabel.textAlignment = NSTextAlignmentCenter;
    textViewHintLabel.numberOfLines = 0;
    textViewHintLabel.text = @"详细描述: \n1.技能介绍 \n2.技能内容 \n3.服务时间\n\n0/250";
    //添加价格
    PriceView = [[UIView alloc] initWithFrame:CGRectMake(10, ContentView.frame.size.height + 15, Main_Screen_Width - 20, 470)];
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
    priceText.text = @"价 格";
    priceText.textColor = [UIColor whiteColor];
    contentText.font = [UIFont systemFontOfSize:14];
    [priceImg addSubview:priceText];
    [PriceView addSubview:priceImg];
    
    UILabel *unitTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 75, 60, 16)];
    unitTitleLabel.textColor = kGlobalTitleColor;
    unitTitleLabel.font = [UIFont systemFontOfSize:12];
    unitTitleLabel.text = @"单价（元）";
    [PriceView addSubview:unitTitleLabel];
    
    UITextField *unitValueField = [[UITextField alloc] initWithFrame:CGRectMake((Main_Screen_Width - 20 - 100) * 0.5, 60, 100, 45)];
    unitValueField.textColor = kGlobalTitleColor;
    unitValueField.font = [UIFont systemFontOfSize:50];
    unitValueField.text = @"999";
    [PriceView addSubview:unitValueField];
    
    UILabel *perTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width - 20 - 15 - 85, 75, 15, 16)];
    perTitleLabel.textColor = kGlobalTitleColor;
    perTitleLabel.font = [UIFont systemFontOfSize:12];
    perTitleLabel.text = @"每";
    perTitleLabel.textAlignment = NSTextAlignmentCenter;
    [PriceView addSubview:perTitleLabel];
    
    UITextField *hourField = [[UITextField alloc] initWithFrame:CGRectMake(Main_Screen_Width - 20 - 15 - 70, 75, 30, 16)];
    hourField.textColor = kGlobalTitleColor;
    hourField.font = [UIFont systemFontOfSize:12];
    hourField.textAlignment = NSTextAlignmentRight;
    hourField.text = @"";
    [PriceView addSubview:hourField];
    
    UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width - 20 - 15 - 40, 75, 5, 16)];
    starLabel.textColor = kGlobalTitleColor;
    starLabel.font = [UIFont systemFontOfSize:12];
    starLabel.text = @"*";
    starLabel.textAlignment = NSTextAlignmentCenter;
    [PriceView addSubview:starLabel];
    
    UILabel * hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width - 20 - 15 - 30, 75, 30, 16)];
    hourLabel.textColor = kGlobalTitleColor;
    hourLabel.font = [UIFont systemFontOfSize:12];
    starLabel.textAlignment = NSTextAlignmentRight;
    hourLabel.text = @"小时";
    [PriceView addSubview:hourLabel];
    
    UILabel *quanlityTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 158, 30, 16)];
    quanlityTitleLabel.textColor = UIColorFromRGB(0x9ca0a9);
    quanlityTitleLabel.font = [UIFont systemFontOfSize:12];
    quanlityTitleLabel.text = @"数量";
    [PriceView addSubview:quanlityTitleLabel];
    
    UITextField *quanlityValueField = [[UITextField alloc] initWithFrame:CGRectMake((Main_Screen_Width - 20 - 100) * 0.5, 145, 100, 45)];
    quanlityValueField.textColor = UIColorFromRGB(0x9ca0a9);
    quanlityValueField.font = [UIFont systemFontOfSize:50];
    quanlityValueField.text = @"111";
    quanlityValueField.textAlignment = NSTextAlignmentCenter;
    [PriceView addSubview:quanlityValueField];
    
    UILabel *totalTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 245, 30, 16)];
    totalTitleLabel.textColor = UIColorFromRGB(0x9ca0a9);
    totalTitleLabel.font = [UIFont systemFontOfSize:12];
    totalTitleLabel.text = @"合计";
    totalTitleLabel.textAlignment = NSTextAlignmentLeft;
    [PriceView addSubview:totalTitleLabel];
    
    UILabel *totalValueLabel = [[UILabel alloc] initWithFrame:CGRectMake((Main_Screen_Width - 20 - 100) * 0.5, 225, 100, 45)];
    totalValueLabel.textColor = UIColorFromRGB(0x9ca0a9);
    totalValueLabel.font = [UIFont systemFontOfSize:50];
    totalValueLabel.text = @"111";
    totalValueLabel.textAlignment = NSTextAlignmentCenter;
    [PriceView addSubview:totalValueLabel];
    
    UIImageView* sepratePriceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 300, Main_Screen_Width - 20, 1)];
    sepratePriceImageView.image = [UIImage imageNamed:@"curSep"];
    sepratePriceImageView.clipsToBounds = YES;
    sepratePriceImageView.contentMode = UIViewContentModeScaleAspectFill;
    [PriceView addSubview:sepratePriceImageView];
    
    UILabel *expireTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 340, 40, 16)];
    expireTitleLabel.textColor = UIColorFromRGB(0x9ca0a9);
    expireTitleLabel.font = [UIFont systemFontOfSize:12];
    expireTitleLabel.text = @"工期至";
    expireTitleLabel.textAlignment = NSTextAlignmentLeft;
    [PriceView addSubview:expireTitleLabel];
    
    UIButton* dateButton = [[UIButton alloc] initWithFrame:CGRectMake((Main_Screen_Width - 20 - 156 ) * 0.5, 331,156, 35)];
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年  MM月    dd日"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
//    NSDate *formattedDate = [dateFormatter dateFromString:dateString];
    
    [dateButton setTitle:dateString forState:UIControlStateNormal];
    dateButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    dateButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [dateButton setTitleColor:UIColorFromRGB(0x9ca0a9) forState:UIControlStateNormal];
    dateButton.clipsToBounds = YES;
    dateButton.layer.cornerRadius = 4;
    dateButton.layer.masksToBounds = YES;
    dateButton.layer.borderWidth = 1;
    dateButton.layer.borderColor = UIColorFromRGB(0x9ca0a9).CGColor;
    [PriceView addSubview:dateButton];
    
    self.onlineButton = [[UIButton alloc] initWithFrame:CGRectMake(((Main_Screen_Width - 20) * 0.5 - 60) * 0.5, 340 + 48, 60, 50)];
    
    self.offlineButton = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width - 20 - 60 -((Main_Screen_Width - 20) * 0.5 - 32) * 0.5, 340 + 48, 60, 50)];
    
    [_onlineButton setImage:[UIImage imageNamed:@"online"] forState:UIControlStateNormal];
    [_onlineButton setImage:[UIImage imageNamed:@"online_h"] forState:UIControlStateSelected];
    [_onlineButton setTitle:@"线上合作" forState:UIControlStateNormal];
    _onlineButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_onlineButton setTitleColor:UIColorFromRGB(0x9ca0a9) forState:UIControlStateNormal];
    _onlineButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [onlineButton setBackgroundColor:[UIColor redColor]];
    [_onlineButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_onlineButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [_onlineButton setImageEdgeInsets:UIEdgeInsetsMake(0, 14, 0, 0)];
    [_onlineButton setTitleEdgeInsets:UIEdgeInsetsMake(32, -26 , 0, 0)];

    [_offlineButton setImage:[UIImage imageNamed:@"offline"] forState:UIControlStateNormal];
    
    [_offlineButton setImage:[UIImage imageNamed:@"offline_h"] forState:UIControlStateSelected];
    
    [_offlineButton setTitle:@"线下合作" forState:UIControlStateNormal];
    _offlineButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_offlineButton setTitleColor:UIColorFromRGB(0x9ca0a9) forState:UIControlStateNormal];
    _offlineButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [offlineButton setBackgroundColor:[UIColor redColor]];
    [_offlineButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_offlineButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [_offlineButton setImageEdgeInsets:UIEdgeInsetsMake(0, 14, 0, 0)];
    [_offlineButton setTitleEdgeInsets:UIEdgeInsetsMake(32, -26 , 0, 0)];
    
    _onlineButton.selected = YES;
    [PriceView addSubview:_onlineButton];
    [PriceView addSubview:_offlineButton];
    _onlineButton.tag = 1;
    _offlineButton.tag = 2;
    [_onlineButton addTarget:self action:@selector(negoiationAction:) forControlEvents:UIControlEventTouchUpInside];
    [_offlineButton addTarget:self action:@selector(negoiationAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _addrTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 340 + 100 + 20, 50, 16)];
    _addrTitleLabel.textColor = UIColorFromRGB(0x9ca0a9);
    _addrTitleLabel.font = [UIFont systemFontOfSize:12];
    _addrTitleLabel.text = @"合作地址";
    _addrTitleLabel.textAlignment = NSTextAlignmentLeft;
    [PriceView addSubview:_addrTitleLabel];
    
    _addrValueLabel = [[UILabel alloc] initWithFrame:CGRectMake((Main_Screen_Width - 20 - 156) * 0.5, 460, 156, 16)];
    _addrValueLabel.textColor = UIColorFromRGB(0x9ca0a9);
    _addrValueLabel.font = [UIFont systemFontOfSize:12];
    _addrValueLabel.text = @"111";
    _addrValueLabel.textAlignment = NSTextAlignmentCenter;
    [PriceView addSubview:_addrValueLabel];
    _addrTitleLabel.hidden = YES;
    _addrValueLabel.hidden = YES;
    _hintLabel = [[WPHotspotLabel alloc] initWithFrame:CGRectMake((Main_Screen_Width - 208) / 2.0, PriceView.frame.size.height+PriceView.frame.origin.y + 15, 208, 34)];
    _hintLabel.numberOfLines = 0;
    _hintLabel.backgroundColor = [UIColor clearColor];
    [self.SetWorkView addSubview:_hintLabel];
    __weak __typeof(&*self)weakSelf = self;
    NSDictionary* style = @{@"body":[UIFont fontWithName:@"HelveticaNeue" size:10.0],
                            @"help":[WPAttributedStyleAction styledActionWithAction:^{
                                
                            }],
                            @"settings":[WPAttributedStyleAction styledActionWithAction:^{
                                NSLog(@"Settings action");
                            }],
                            @"link": UIColorFromRGB(0x2d91ee)};
    _hintLabel.textColor = UIColorFromRGB(0x999999);
//    hintLabel.backgroundColor = [UIColor redColor];
    _hintLabel.attributedText = [@"同意<help>《合作协议》</help>每次合作平台将收取5%佣金\n预付款分为70%货款和30%保证金" attributedStringWithStyleBook:style];
    [self.SetWorkView addSubview:_hintLabel];
    //发布
    CGFloat sepWidth = (Main_Screen_Width - 100 - 156) / 3.0;
    SendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    SendBtn.frame = CGRectMake(2 * sepWidth + 100, PriceView.frame.size.height+PriceView.frame.origin.y + 80, 156, 45);
//    [SendBtn setTitle:@"发布并交预付款" forState:UIControlStateNormal];
    [SendBtn setImage:[UIImage imageNamed:@"payRelease"] forState:UIControlStateNormal];
//    SendBtn.backgroundColor = kGlobalTitleColor;
    [SendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    SendBtn.layer.cornerRadius = 25;
    SendBtn.clipsToBounds = YES;
    [self.SetWorkView addSubview:SendBtn];
    
    _freeReleaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _freeReleaseButton.frame = CGRectMake(sepWidth, PriceView.frame.size.height+PriceView.frame.origin.y + 80, 100, 45);
//    [freeReleaseBtn setTitle:@"免费发布" forState:UIControlStateNormal];
    [_freeReleaseButton setImage:[UIImage imageNamed:@"freeRelease"] forState:UIControlStateNormal];
//    freeReleaseBtn.backgroundColor = kGlobalTitleColor;
    [_freeReleaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _freeReleaseButton.layer.cornerRadius = 25;
    _freeReleaseButton.clipsToBounds = YES;
    [self.SetWorkView addSubview:_freeReleaseButton];
    
    self.SetWorkView.contentSize = CGSizeMake(Main_Screen_Width, PriceView.frame.size.height+PriceView.frame.origin.y + 80 + 80);
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

-(void)negoiationAction:(UIButton*)button {
    if (button.tag == 1) {
        if (_isOffline == YES) {
            
            PriceView.frame = CGRectMake(10, ContentView.frame.size.height + 15, Main_Screen_Width - 20, 470);
            self.SetWorkView.contentSize = CGSizeMake(Main_Screen_Width, PriceView.frame.size.height+PriceView.frame.origin.y + 80 + 80);
            _isOffline = NO;
            _onlineButton.selected = YES;
            _offlineButton.selected = NO;
            CGFloat sepWidth = (Main_Screen_Width - 100 - 156) / 3.0;
            SendBtn.frame = CGRectMake(2 * sepWidth + 100, PriceView.frame.size.height+PriceView.frame.origin.y + 80, 156, 45);
            _freeReleaseButton.frame = CGRectMake(sepWidth, PriceView.frame.size.height+PriceView.frame.origin.y + 80, 100, 45);
            _hintLabel.frame = CGRectMake((Main_Screen_Width - 208) / 2.0, PriceView.frame.size.height+PriceView.frame.origin.y + 15, 208, 34);
            _addrTitleLabel.hidden = YES;
            _addrValueLabel.hidden = YES;
        }
    }
    else if (button.tag == 2) {
        if (_isOffline == NO) {
            _addrTitleLabel.hidden = NO;
            _addrValueLabel.hidden = NO;
            PriceView.frame = CGRectMake(10, ContentView.frame.size.height + 15, Main_Screen_Width - 20, 470 + 40);
            self.SetWorkView.contentSize = CGSizeMake(Main_Screen_Width, PriceView.frame.size.height+PriceView.frame.origin.y + 80 + 80);
            _isOffline = YES;
            _onlineButton.selected = NO;
            _offlineButton.selected = YES;
            CGFloat sepWidth = (Main_Screen_Width - 100 - 156) / 3.0;
            SendBtn.frame = CGRectMake(2 * sepWidth + 100, PriceView.frame.size.height+PriceView.frame.origin.y + 80, 156, 45);
            _freeReleaseButton.frame = CGRectMake(sepWidth, PriceView.frame.size.height+PriceView.frame.origin.y + 80, 100, 45);
            
            _hintLabel.frame = CGRectMake((Main_Screen_Width - 208) / 2.0, PriceView.frame.size.height+PriceView.frame.origin.y + 15 + 10, 208, 34);
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableVIew dequeueReusableCellWithIdentifier:@"fdfdfd"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fdfdfd"];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, 44)];
        label.tag = 1;
        [cell addSubview:label];
    }
    UILabel* label = (UILabel*)[cell viewWithTag:1];
    label.text = @"test";
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