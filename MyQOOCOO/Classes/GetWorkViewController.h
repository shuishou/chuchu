//
//  GetWorkViewController.h
//  MyQOOCOO
//
//  Created by Nikola on 16/6/13.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//


#import "GetWorkViewController.h"
#import "QCPicScrollView.h"
@interface GetWorkViewController : QCBaseVC
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
