//
//  QCDDDeatailTopView.h
//  MyQOOCOO
//
//  Created by 贤荣 on 15/12/25.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCDiandiListModel.h"

@interface QCDDDeatailTopView : UIView

@property (nonatomic,strong)QCDiandiListModel *dianDi;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIView *picCountV;


+(instancetype)topView;

@end
