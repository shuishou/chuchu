//
//  QCFriendHeaderView.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/3.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

//个人资料

#import "QCFriendHeaderView.h"
#import "QCDiandiViewController.h"
#import "QCLunKuViewController.h"
#import "QCYellListVC.h"
#import "QCQRCodeVC.h"
#import "QCPersonInfoVC.h"
#import "QCCustomBtn.h"


@interface QCFriendHeaderView(){
    UIButton *_avatarBtn;
    UIButton *_scanBtn;
    UILabel *_nickName;
    UILabel *_chuhaoLabel;
    QCCustomBtn *_diandiBtn;
    QCCustomBtn *_friendBtn;
    QCCustomBtn *_nuhongquanBtn;
    QCCustomBtn *_lunkuBtn;
    UIView *_bgView;
}

@end

@implementation QCFriendHeaderView

-(instancetype)initWithFrame:(CGRect)frame navigationController:(UINavigationController *)navigationController{
    if (self = [super initWithFrame:frame]) {
        [self initHeaderView];
        self.navigationController = navigationController;
    }
    return self;
}

-(void)setUser:(User *)user{
    //从服务器获取用户信息
    if (user.uid ==0 ) {
        _nickName.text = @"用户未登录";
        
    }else{
        _nickName.text = user.nickname;
        //        设置用户图片
        NSString *thumbnailUrl = user.avatarUrl;
        _avatarBtn.layer.cornerRadius = 44;
        _avatarBtn.layer.masksToBounds = YES;
        CZLog(@"avatarUrl = %@",user.avatarUrl);
        [_avatarBtn.imageView sd_setImageWithURL:[NSURL URLWithString: thumbnailUrl] placeholderImage:[UIImage imageNamed:@"default-avatar_1"]];
//        SDWebImageManager *manager = [SDWebImageManager sharedManager];
//        BOOL isCache = [manager diskImageExistsForURL:[NSURL URLWithString: thumbnailUrl]];
//        if(!isCache){
//            [_avatarBtn.imageView sd_setImageWithURL:[NSURL URLWithString: thumbnailUrl] placeholderImage:[UIImage imageNamed:@"default-avatar_1"]];
//        }else {
//            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbnailUrl];
//            _avatarBtn.imageView.image = image;
//        }
    }
}

-(void)initHeaderView{
   
    //设置背景颜色
    UIColor *bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_bg"]];
    [self setBackgroundColor:bgColor];
    
    //头像
    _avatarBtn = [[UIButton alloc]init];
    [_avatarBtn setBackgroundImage:[UIImage imageNamed:@"default-avatar_1"] forState:UIControlStateNormal];
    _avatarBtn.userInteractionEnabled = YES;
    [_avatarBtn addTarget:self action:@selector(avatarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_avatarBtn];
    [_avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(16);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    
    //扫描
    _scanBtn = [[UIButton alloc]init];
    [_scanBtn setBackgroundImage:[UIImage imageNamed:@"qr_code"] forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(scanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_scanBtn];
    [_scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.top.equalTo(self.mas_top).offset(12);
        make.size.mas_equalTo(CGSizeMake(32,32));
    }];
    
    //昵称
    _nickName = [[UILabel alloc]init];
    NSString *name = @"文化大湿";
    _nickName.text = name;
    _nickName.textColor = kPersonNickNameLabelColor;
    _nickName.font = kPersonNickNameLabelFont;
    _nickName.numberOfLines = 1;
    [self addSubview:_nickName];
    
    _nickName.size = [name boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:kPersonNickNameLabelFont,NSFontAttributeName, nil] context:nil].size;
    
    [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarBtn.mas_bottom).offset(16);
        make.centerX.mas_equalTo(self.mas_centerX);
        
    }];
    
    //背景View
    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = UIColorFromRGB(0x583A3D);
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(@47);
        
    }];
    
    //点滴
    _diandiBtn = [QCCustomBtn setupFunctionBtn:@"but_diandi" highLightedImageName:@"but_diandi" title:@"点滴" index:0 btnH:47];
    [_diandiBtn addTarget:self action:@selector(diandiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_diandiBtn];
    //发泄圈
    _nuhongquanBtn = [QCCustomBtn setupFunctionBtn:@"but_diandi" highLightedImageName:@"but_diandi" title:@"发泄圈" index:1 btnH:47];
    [_nuhongquanBtn addTarget:self action:@selector(nuhongBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_nuhongquanBtn];
    //论库
    _lunkuBtn = [QCCustomBtn setupFunctionBtn:@"but_diandi" highLightedImageName:@"but_diandi" title:@"论库" index:2 btnH:47];
    [_lunkuBtn addTarget:self action:@selector(lunkuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_lunkuBtn];
    //好友
    _friendBtn = [QCCustomBtn setupFunctionBtn:@"but_diandi" highLightedImageName:@"but_diandi" title:@"好友" index:3 btnH:47];
    [_bgView addSubview:_friendBtn];
}



#pragma mark - 代理
-(void)avatarBtnClick:(UIButton *)btn{
    QCPersonInfoVC *personInfoVC = [[QCPersonInfoVC alloc]init];
    [self.navigationController pushViewController:personInfoVC animated:YES];
    CZLog(@"点击头像")
}
-(void)scanBtnClick:(UIButton *)btn {
    QCQRCodeVC *QRCodeVC = [[QCQRCodeVC alloc]init];
    [self.navigationController pushViewController:QRCodeVC animated:YES];
    CZLog(@"扫描");
}
-(void)diandiBtnClick:(UIButton *)btn {
    QCDiandiViewController *diandiVC = [[QCDiandiViewController alloc]init];
    [self.navigationController pushViewController:diandiVC animated:YES];
    CZLog(@"点滴");
}
-(void)nuhongBtnClick:(UIButton *)btn{
    QCYellListVC *yellVC = [[QCYellListVC alloc]init];
    [self.navigationController pushViewController:yellVC animated:YES];
    CZLog(@"发泄圈");
}
-(void)lunkuBtnClick:(UIButton *)btn{
    QCLunKuViewController *lunkuVC = [[QCLunKuViewController alloc]init];
    [self.navigationController pushViewController:lunkuVC animated:YES];
    CZLog(@"论库");
}
-(void)friendBtnClick:(UIButton *)btn{
    CZLog(@"好友");
}

#pragma mark - 个人信息保存
-(void)safePersonInfo:(id)sender{
    
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
