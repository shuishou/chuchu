//
//  QCRixingTableView2.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/1.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

//typedef enum {
//    kScrollMethodWithLeft = 0,//左边滚动
//    kScrollMethodWithRight,//右边滚动
//    kScrollMethodWithAll
//}ScrollMethod;

#import <UIKit/UIKit.h>

@interface QCRixingTableView2 : UITableView
@property ( nonatomic , assign) float viewHeight;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) UIScrollView *leftScrollView;
@property (nonatomic, strong) UIScrollView *rightScrollView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSDictionary *trDictionary;
@property (nonatomic, strong) NSArray *leftDataKeys;
@property (nonatomic, strong) NSArray *rightDataKeys;

@end
