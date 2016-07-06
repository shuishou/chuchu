//
//  myView.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/17.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "myHeaderView.h"
#import "QCSettingVC.h"
#import "User.h"

@interface myHeaderView()
@property (weak, nonatomic) IBOutlet UIButton *userIcon;
@property (weak, nonatomic) IBOutlet UIView *userInfo;
@property (weak, nonatomic) IBOutlet UILabel *shuoshuo;

@end

@implementation myHeaderView

-(void)awakeFromNib{
    
}

//从xib加载模型
+(instancetype)initMyHeaderView{
    //    return [NSBundle loadNibNamedFrom:@"myHeaderView"];
    
    return [[[NSBundle mainBundle ] loadNibNamed:@"myHeaderView" owner:nil options:nil] lastObject];
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kGlobalTitleColor;
        [self setupSubView];
    }
    
    return self;
}

-(void)setupSubView{
    LoginSession *sessionS = [[ApplicationContext sharedInstance] getLoginSession];
    //头像
    _heardImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_W-(WIDTH(self)/5+5))/2, 3, WIDTH(self)/5+5, WIDTH(self)/5+5)];
//    [_heardImage addTarget:self action:@selector(changeIcon:) forControlEvents:UIControlEventTouchUpInside];
    _heardImage.layer.cornerRadius = HEIGHT(_heardImage)/2;
    _heardImage.clipsToBounds = YES;
    [_heardImage sd_setImageWithURL:[NSURL URLWithString:sessionS.user.avatarUrl] placeholderImage:[UIImage imageNamed:@"ios-template-1024(1)"]];
    _heardImage.userInteractionEnabled=YES;
    [self addSubview:_heardImage];
    
    UITapGestureRecognizer * Tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeIcon:)];
    [_heardImage addGestureRecognizer:Tap];
    
    //性别,年龄
    UIButton *infoView = [[UIButton alloc]initWithFrame:CGRectMake(MaxX(_heardImage)-WIDTH(_heardImage)/3, CGRectGetMaxY(_heardImage.frame) - HEIGHT(_heardImage)/4, (HEIGHT(_heardImage)/4)*2.5, HEIGHT(_heardImage)/4)];
    NSString *ageLabel = @"未认证";
    infoView.backgroundColor = kColorRGBA(219, 89, 92, 1);
    infoView.layer.masksToBounds = YES;
    infoView.layer.cornerRadius = HEIGHT(infoView)/2;
    infoView.layer.borderWidth = 1;
    infoView.layer.borderColor = kColorRGBA(255, 255, 255, 1).CGColor;
    [infoView setTitle:ageLabel forState:UIControlStateNormal];
    infoView.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(infoView)*3/5];
    [self addSubview:infoView];
    
    //签名
    _signMessage = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_W-(sessionS.user.nickname.length*(HEIGHT(_signMessage)*3/4+15)))/2, MaxY(_heardImage)+((HEIGHT(self)-MaxY(_heardImage)-(HEIGHT(_heardImage)/3+8))/2)/2, sessionS.user.nickname.length*(HEIGHT(_signMessage)*3/4+12), HEIGHT(_heardImage)/4)];
    
    if (sessionS.user.nickname.length > 0) {
        _signMessage.text = sessionS.user.nickname;
    }else{
        _signMessage.text = @"出处";
    }
    
    //    _signMessage.text = @"突然想到了理想";
    _signMessage.textColor = [UIColor whiteColor];
    _signMessage.numberOfLines = 1;
    _signMessage.backgroundColor = [UIColor clearColor];
    _signMessage.font = [UIFont systemFontOfSize:HEIGHT(_signMessage)*3/4];
    _signMessage.textAlignment = NSTextAlignmentRight;
    [self addSubview:_signMessage];
    
    
//         [self getData];

    self.sexImage=[[UIImageView alloc]initWithFrame:CGRectMake(MaxX(_signMessage)-20, MaxY(_heardImage)+((HEIGHT(self)-MaxY(_heardImage)-(HEIGHT(_heardImage)/3+8))/2)/2, HEIGHT(_heardImage)/4, HEIGHT(_heardImage)/4)];
    self.sexImage.userInteractionEnabled = YES;
    self.sexImage.backgroundColor=[UIColor clearColor];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeSex:)];
    [self.sexImage addGestureRecognizer:tap];
    [self addSubview:self.sexImage];

    
    //设置
//    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT(self)-(HEIGHT(_heardImage)/3+8), SCREEN_W, HEIGHT(_heardImage)/3+8)];
//    backView.backgroundColor = [UIColor clearColor];
//    [self addSubview:backView];
//    
//    
//    _settingBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, HEIGHT(backView))];
//    [_settingBtn setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
//    [_settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _settingBtn.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(_settingBtn)*2/5];
//    [_settingBtn setTitle:@"设置" forState:UIControlStateNormal];
//    [_settingBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
////    [_settingBtn setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
//    [_settingBtn addTarget:self action:@selector(settingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [backView addSubview:_settingBtn];
    //    //竖线
    //    UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_W / 2, 0, 0.5, 44)];
    //    verticalLine.backgroundColor = UIColorFromRGB(0x000000);
    //    verticalLine.alpha = 0.1;
    //    [backView addSubview:verticalLine];
    //横向
//    UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 0.5)];
//    horizontalLine.backgroundColor = UIColorFromRGB(0x000000);
//    horizontalLine.alpha = 0.1;
//    [backView addSubview:horizontalLine];
//    
//    //自身的高度
//    _headHeight = CGRectGetMaxY(backView.frame);
    
    
}


//#pragma -mark 请求数据
//
//-(void)getData
//{
//    
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    LoginSession *sessions = [[ApplicationContext sharedInstance] getLoginSession];
//    
//    dic[@"uid"]=@(sessions.user.uid);
//    //    [MBProgressHUD showMessage:nil background:NO];
//    [NetworkManager requestWithURL:USERINFO_DETAIL parameter:dic success:^(id response) {
//        
//        NSLog(@"%@",response);
//        NSInteger sex=[response[@"sex"] integerValue];
//        
//        if (sex==0) {
//            self.sexImage.image=[UIImage imageNamed:@"found_icon_man"];
//        }else{
//            self.sexImage.image=[UIImage imageNamed:@"LJ_con_woman"];
//        }
//        
//        
//        //        [MBProgressHUD hideHUD];
//        
//        
//        
//    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
//        CZLog(@"%@", error);
//        
//        //        [MBProgressHUD hideHUD];
//    }];
//    
//    
//    
//}

#pragma mark - 私有方法
-(void)changeIcon:(id)sender{
    CZLog(@"更改头像");
    if ([self.setdelegate respondsToSelector:@selector(changeIcon)]) {
        [self.setdelegate changeIcon];
    }
}

-(void)changeSex:(id)sender{
    CZLog(@"更改性别");
    if ([self.setdelegate respondsToSelector:@selector(changeSex)]) {
        [self.setdelegate changeSex];
    }
}

#pragma mark - 设置
-(void)settingBtnClick:(id)sender{
    if ([self.setdelegate respondsToSelector:@selector(settingVC)]) {
        [self.setdelegate settingVC];
    }
}

@end
