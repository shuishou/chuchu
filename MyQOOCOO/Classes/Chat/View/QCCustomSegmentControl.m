//
//  QCSegmentController.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/28.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCCustomSegmentControl.h"

@interface QCCustomSegmentControl()
@property (nonatomic , strong)UIButton *selectedBtn;
@property (strong, nonatomic) UIButton *groupBtn;
@end

@implementation QCCustomSegmentControl

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushGroupList:) name:@"HFUserPushGroupList" object:nil];
        
        [self setUpBtnItems];
    }
    return self;
}

- (void)pushGroupList:(NSNotification *)not
{
//    UIButton * bu = [UIButton new];
//    bu.tag = [not.object integerValue];
    [self tabBarBtnItemClick:_groupBtn];
}

-(void)setUpBtnItems{
    //1,创建聊天控制器
    UIButton *messageBtn = [[UIButton alloc]init];
    [self setUpBtnItemWith:messageBtn normalImageName:@"new" selectedImageName:@"news_pre"];
    
    //2,创建功能控制器
    _groupBtn = [[UIButton alloc]init];
    [self setUpBtnItemWith:_groupBtn normalImageName:@"bf" selectedImageName:@"bf_pre"];
}

-(void)setUpBtnItemWith:(UIButton *)btn normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName{
    
    //设置按钮的图片
    [btn setImage:[UIImage resizeImgWithName:normalImageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage resizeImgWithName:selectedImageName] forState:UIControlStateSelected];

    
    //添加按钮点击事件
    [btn addTarget:self action:@selector(tabBarBtnItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //给btn添加tag标签
    btn.tag = self.subviews.count;
    if (btn.tag == 0) {
        [self tabBarBtnItemClick:btn];
    }
    
    [self addSubview:btn];
}

#pragma mark - 创建的点击事件
-(void)tabBarBtnItemClick:(UIButton *)btn{
    self.selectedBtn.selected = NO;
    //却换视图控制器的事情,应该交给controller来做
    //最好这样写, 先判断该代理方法是否实现

    if ([self.delegate respondsToSelector:@selector(segmented:selectedFrom:to:)]) {
        [self.delegate segmented:self selectedFrom:self.selectedBtn.tag to:btn.tag];
    }
    btn.selected = YES;
    self.selectedBtn = btn;
    
    
}

#pragma mark - 布局的子控件
-(void)layoutSubviews{
    [super layoutSubviews];
    [self setUpFrame];
}
-(void)setUpFrame{
    CGFloat btnW = (self.width ) / (self.subviews.count);
    CGFloat btnH = 44;
    
    NSInteger index = 0;
    for (UIButton *btn in self.subviews) {
        
        btn.frame = CGRectMake((btnW ) * index , 0, btnW, btnH);
        index ++;
        
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HFUserPushGroupList" object:nil];
}

@end
