//
//  DoodleDetailHeadView.h
//  MyQOOCOO
//
//  Created by 贤荣 on 15/12/12.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCDoodleStatus.h"

@interface DoodleDetailHeadView : UIView

@property (nonatomic,strong) QCDoodleStatus * qcStatus;
/** 头像 */
@property (nonatomic, weak) UIImageView *iconV;

@end
