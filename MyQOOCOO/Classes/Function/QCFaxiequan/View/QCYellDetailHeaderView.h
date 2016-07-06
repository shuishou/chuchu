//
//  QCYellDetailHeaderView.h
//  MyQOOCOO
//
//  Created by 贤荣 on 15/12/22.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCYellModel.h"

@interface QCYellDetailHeaderView : UIView

@property (nonatomic,strong)QCYellModel *yellModel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
+(instancetype)headerView;


@end
