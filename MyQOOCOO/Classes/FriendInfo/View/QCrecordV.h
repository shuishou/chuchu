//
//  QCrecordV.h
//  MyQOOCOO
//
//  Created by lanou on 16/3/16.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCGetUserMarkModel.h"

@interface QCrecordV : UIView

@property(nonatomic,retain)UIView*bgV;
@property(nonatomic,strong)UILabel*textLB;
@property(nonatomic,strong)UIImageView*imagev;
@property(nonatomic,strong)UILabel*msLb;
@property(nonatomic,strong)UIImageView*playBgV;


@property(nonatomic,strong)UIImageView*deleteImage;


@property(nonatomic,strong)QCGetUserMarkModel*recordmodel;

@end
