//
//  QCLKdetailTopView.h
//  MyQOOCOO
//
//  Created by 贤荣 on 15/12/28.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCLunkuListModel.h"

@interface QCLKdetailTopView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (nonatomic,strong)QCLunkuListModel *lk;

+(instancetype)topView;

@end
