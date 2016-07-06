//
//  QCDanDiCommentToolBar.h
//  MyQOOCOO
//
//  Created by 贤荣 on 15/12/25.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCDiandiListModel.h"
#import "QCLunkuListModel.h"
@protocol QCDanDiCommentToolBarDelegate <NSObject>
@optional
-(void)sendBtnClick;
@end

@interface QCDanDiCommentToolBar : UIView

@property (weak, nonatomic) IBOutlet UITextField *tf;

+(instancetype)commentToolBar;

@property (nonatomic,assign) id <QCDanDiCommentToolBarDelegate> delegate;

@property (nonatomic , strong)QCDiandiListModel *dianDi;

@property (nonatomic,strong)QCLunkuListModel *lk;

@property(nonatomic,assign)BOOL isFree;

@end
