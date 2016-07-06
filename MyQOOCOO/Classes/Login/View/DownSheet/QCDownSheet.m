//
//  QCDownSheet.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/10.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCDownSheet.h"

@implementation QCDownSheet
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(id)initWithlist:(NSArray *)list height:(CGFloat)height{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        self.backgroundColor = RGBA_COLOR(160, 160, 160, 0);
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, SCREEN_H, SCREEN_W - 20, (44*[list count])+24) style:UITableViewStyleGrouped];
        _tableView.layer.cornerRadius = 5;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        [self addSubview:_tableView];
        _listData = list;
        //添加动画
        [self animateData];
        
    }
    return self;
}
//把自己添加到父控件上面去
-(void)showInView:(UIViewController *)inViewVC{
    if (inViewVC == nil) {
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    }else{
        [inViewVC.view addSubview:self];
    }
    
}
//显示动画效果
-(void)animateData{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCancel)];
    [self addGestureRecognizer:gesture];
    //动画
    [UIView animateWithDuration:.25 animations:^{
        self.backgroundColor = RGBA_COLOR(160, 160, 160, .5);
        [_tableView setFrame:CGRectMake(_tableView.x, SCREEN_H - _tableView.y, _tableView.width, _tableView.height)];
    } completion:^(BOOL finished) {
        
    }];
}
//手势结束后把自己从父控件移除
-(void)tapCancel{
    [UIView animateWithDuration:.25 animations:^{
        [_tableView setFrame:CGRectMake(0, SCREEN_H, SCREEN_W, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];//把整个弹框从父控件移除
    }];
}
//判断是否可接收点击事件
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:self.class]) {
        return YES;
    }
    return NO;
}

#pragma mark - tableViewdatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 12;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}
@end
