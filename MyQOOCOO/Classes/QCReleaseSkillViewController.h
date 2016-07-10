//
//  QCCreateTaskViewController.h
//  MyQOOCOO
//
//  Created by Zhou Shaolin on 16/7/6.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QCPicScrollView.h"
@interface QCReleaseSkillViewController : QCBaseVC
//@property (nonatomic, assign) BOOL showNavBar;

@property (nonatomic,strong) NSArray * titles;//滚动标签名
@property (nonatomic,strong) NSMutableArray * pageViews;
@property (nonatomic,assign) NSInteger curentTag;
// 记录页码
@property (nonatomic,assign) int starPage;
@property (nonatomic,assign) int animePage;
@property (nonatomic,assign) int gamePage;
@property (nonatomic,assign) int artPage;
@property (nonatomic,assign) int sportPage;
@property (nonatomic,assign) int teachPage;
@property(nonatomic,strong)QCPicScrollView *picV;
@property(nonatomic,strong)NSMutableArray *picArr;

@end

