//
//  QCLJListTableViewCell.h
//  MyQOOCOO
//
//  Created by lanou on 16/3/15.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCPicScrollView.h"
#import "QCtextsView.h"
#import "QCrecordView.h"

@interface QCLJListTableViewCell : UITableViewCell<UIScrollViewDelegate>

@property(nonatomic,assign)NSInteger groudId;

@property(nonatomic,assign)BOOL isfens;//是否粉丝标签
@property(nonatomic,strong)UIView *bgV;

@property(nonatomic,strong)NSMutableArray*dataArr;//模型数组
//图片视频
@property(nonatomic,strong)NSMutableArray *picArr;
@property(nonatomic,strong)QCPicScrollView *picV;

//文字标签
@property(nonatomic,strong)NSMutableArray *textArr;
@property(nonatomic,strong)QCtextsView *textV;

//录音添加
//@property(nonatomic,strong)NSMutableArray*recordArr;
//@property(nonatomic,strong)QCrecordView*recordV;

@property(nonatomic,strong)NSIndexPath *indexpath;

@end
