//
//  QCFreeController.h
//  MyQOOCOO
//
//  Created by lanou on 16/2/15.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"
#define kLKCellClickNotification2 @"LKCellClickNotification2"

@interface QCFreeController : QCBaseVC<UIScrollViewDelegate,UISearchBarDelegate>


/**类型**/
@property(nonatomic,assign)int funcType;//2-派活  1-接活  3-交流
@property (nonatomic,assign) NSInteger curentTag;//类型
@property (nonatomic,strong) NSMutableArray * pageViews;
// 记录页码
@property (nonatomic,assign) int starPage;
@property (nonatomic,assign) int animePage;
@property (nonatomic,assign) int gamePage;
@property (nonatomic,assign) int artPage;
@property (nonatomic,assign) int sportPage;
@property (nonatomic,assign) int teachPage;
@property (nonatomic,assign) int amusementPage;
@property (nonatomic,assign) int lifePage;
@property (nonatomic,assign) int warPage;
@property (nonatomic,assign) int itPage;
@property (nonatomic,assign) int emotionPage;
@property (nonatomic,strong) NSArray * titles;//滚动标签名
/**是否返回**/
@property(nonatomic,assign)BOOL isBlack;
@property(nonatomic,assign)long uid;

@end
