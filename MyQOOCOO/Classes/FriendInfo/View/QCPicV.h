//
//  QCPicV.h
//  MyQOOCOO
//
//  Created by lanou on 16/3/16.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCGetUserMarkModel.h"

@interface QCPicV : UIView



@property (nonatomic,strong) QCGetUserMarkModel*model;
@property (nonatomic,strong) UIImageView *bgIge;
@property (nonatomic,strong)UILabel*titleLb;
@property (nonatomic,strong) UIImageView*playImageV;
@property(nonatomic,strong)UIImageView*deleteImage;

@end
