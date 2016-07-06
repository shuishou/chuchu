//
//  MGPopViewController.m
//  myWeibo
//
//  Created by Fly_Fish_King on 15/5/7.
//  Copyright (c) 2015年 Fly_Fish_King. All rights reserved.
//

#import "QCPopViewController.h"

@interface QCPopViewController()

@property (nonatomic,strong) UIView * contentView;

/**
 *  遮盖
 */
@property (nonatomic,strong) UIButton *conver;

//@property (nonatomic,strong) UIImageView * popView;
@end

@implementation QCPopViewController

//-(void)test{
//    UIPopoverController
//}

-(instancetype)initWithContentView:(UIView *)contentView{
    if (self = [super init]) {
        self.contentView = contentView;
        
        //创建popView
        self.contentView = [[UIView alloc] init];
        self.contentView.userInteractionEnabled = YES;
        //设置imageView背景图片
        CGFloat leftMargin = 0;
        CGFloat rightMargin = 0;
        CGFloat topMargin = 0;
        CGFloat bottomMargin = 0;
        CGFloat popW = self.contentView.width + leftMargin + rightMargin;
        CGFloat popH = self.contentView.height + topMargin + bottomMargin;
        self.contentView.size = CGSizeMake(popW, popH);
        
//        //设置contentView x,y
//        self.contentView.x = leftMargin;
//        self.contentView.y = 15;
//        
        //把contentView添加到popView
//        [self.popView addSubview:self.contentView];
        
        //初始化遮盖
        self.conver = [[UIButton alloc] init];
        self.conver.bounds = [UIScreen mainScreen].bounds;
        self.conver.backgroundColor = UIColorFromRGB(0x000000);
                self.conver.alpha = 0.2;
        [self.conver addTarget:self action:@selector(converClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark 遮盖被点击
-(void)converClick{
    //隐藏也是可以
    
    //移除遮盖
    [self.conver removeFromSuperview];
    
    //移除popView
    [self.contentView removeFromSuperview];
}

-(void)showInView:(UIView *)inView{
    
    [self showInView:inView position:CZPopViewPositionBottomCenter];
    
}

-(void)showInView:(UIView *)inView position:(CZPopViewPosition)position{
    
    // 1.显示一个遮盖(在窗口上添加)
    self.conver.x = 0;
    self.conver.y = 0;
    // 获取窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.conver];
    
    // 2.显示popView(往window上添加popView)
//    CGPoint inViewCenter = inView.center;//是在导航栏上中点
    // 2.1导航栏上中点 转化成窗口的中心点
    // 设置导航栏中心点(160,22) ,转化成窗口的中心点(160,42)"20是状态栏高度"
    
    
//#warning toView如果写nil 代表转换成窗口坐标准
    CGPoint inViewCenterPointInWidow = [[inView superview] convertPoint:inView.center toView:nil];
    
    
    // 2.2pop中心点往下移
    inViewCenterPointInWidow.y += self.contentView.height * 0.5 + inView.height * 0.5;
    
    
    [keyWindow addSubview:self.contentView];
    
    if (position == CZPopViewPositionBottomLeft) {//左边
//        //换图片
//        self.popView.image =  [UIImage resizeImgWithName:@"popover_background_left"];
        //调整中心点x
        inViewCenterPointInWidow.x += (self.contentView.width - inView.width) * 0.5;
        
    }else if(position == CZPopViewPositionBottomRight){
//        self.popView.image =  [UIImage resizeImgWithName:@"popover_background_right"];
        inViewCenterPointInWidow.x -= (self.contentView.width - inView.width) * 0.5;
        
    }else if (position == CZPopViewPositionBottomCenter){
//        self.popView.image =  [UIImage resizeImgWithName:@"popover_background"];
        
    }else if(position ==CZPopViewPositionWindowCeter){
        inViewCenterPointInWidow = CGPointMake(SCREEN_W / 2, SCREEN_H /2);
        
    }else if(position ==CZPopViewPositionWindowBottom){
        //这个方法好像有问题
        inViewCenterPointInWidow = CGPointMake(SCREEN_W / 2,  SCREEN_H - self.contentView.height/2);
    }
    
    self.contentView.center = inViewCenterPointInWidow;
    
}


-(void)setAlpha:(CGFloat)alpha{
    if (alpha > 0) {
        //设置遮盖的透明度
        self.conver.backgroundColor = [UIColor blackColor];
        self.conver.alpha = alpha;
    }
}

-(void)dissmiss{
    [self converClick];
}

-(void)showInView1:(UIView *)inView{
    // 0.显示一个遮盖(在窗口上添加)
    self.conver.x = 0;
    self.conver.y = 0;
    // 获取窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.conver];
    
    // 1.显示popView
    NSLog(@"%@",[inView superview]);
    //    self.popView.x = 0;
    //    self.popView.y = 0;
    //设置中心点
    
    CGPoint inViewCenter = inView.center;
    //    inViewCenter.y += self.popView.h * 0.5 + inView.h * 0.5;
//#warning 默认，超出父控件的范围是可以显示,但是接收不了事件
    // 设置超出父控件不显示
    //    [inView superview].clipsToBounds = YES;
//#warning 导航条上添加popView是不可取
    self.contentView.center = inViewCenter;
    [[inView superview] addSubview:self.contentView];
}

@end


#pragma mark - CNPPopupButton Methods
@implementation QCPopoverBtn

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(buttonTouched) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)buttonTouched {
    if (self.QCSelectionHandler) {
        self.QCSelectionHandler(self);
    }
}

- (void)dismissPopupControllerAnimated:(BOOL)flag {

//    if ([self.delegate respondsToSelector:@selector(popupControllerWillDismiss:)]) {
//        [self.delegate popupControllerWillDismiss:self];
//    }
//    [UIView animateWithDuration:flag?0.3:0.0 animations:^{
//        self.maskView.alpha = 0.0;
//        self.popupView.center = [self dismissedPoint];;
//    } completion:^(BOOL finished) {
//        [self.maskView removeFromSuperview];
//        if ([self.delegate respondsToSelector:@selector(popupControllerDidDismiss:)]) {
//            [self.delegate popupControllerDidDismiss:self];
//        }
//    }];
}

@end


