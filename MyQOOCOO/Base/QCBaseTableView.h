//
//  XSBaseTableView.h
//  XSTeachEDU
//
//  Created by xsteach on 14/12/4.
//  Copyright (c) 2014年 xsteach.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderInsetTableView.h"

@protocol TableViewDelegate;

@interface QCBaseTableView : HeaderInsetTableView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, retain) NSMutableArray * data;//为threadView提供数据
@property (nonatomic, copy) NSString *nextLinke;//下一个内容的链接

@property(assign,nonatomic)id<TableViewDelegate> reloadDataDelegate;
-(void)addFooterNoMoreDataWithTitle:(NSString *)hine;
-(void)removeNoMoreDataFooter;
-(void)addFooterNoData;
/**
 *  暂无数据(久方法),提供提示语和图片设置
 *
 *  @param hine      提示语
 *  @param imageName 图片名
 */
//-(void)addFooterNoDataWithTitle:(NSString *)hine withImageName:(NSString *)imageName;
/**
 *  暂无数据(新方法),提供提示语,副提示语,图片名设置
 *
 *  @param hine      主提示语
 *  @param subHine   副提示语
 *  @param imageName 图片名称 //目前此参数设置为@"default" 则为默认图片,方便后期差异化修改;如果参数设置为@""空,则不会显示图片 且文字会上下居中显示
 */
-(void)addFooterNoDataWithTitle:(NSString *)hine withSubTitle:(NSString *)subHine withImage:(NSString *)imageName;
-(void)removeNoDataFooter;
@end

@protocol TableViewDelegate <NSObject>

-(void)TableViewReloadData:(QCBaseTableView *)aTableView;

@end