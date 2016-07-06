//
//  QCCommentToolBar.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/28.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCTextView.h"
#import "QCDoodleStatus.h"
#import "QCYellModel.h"

@interface QCCommentToolBar : UIView

@property (nonatomic,strong)UIButton *agreeBtn;

@property (nonatomic,strong)UIButton *disagreeBtn;

@property (nonatomic,strong)UITextField *textField;

@property (nonatomic,strong)QCDoodleStatus *qcStatus;

@property (nonatomic,strong)QCYellModel *yellModel;

@end
