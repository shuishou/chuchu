//
//  QCCommonCollectionViewCell.h
//  MyQOOCOO
//
//  Created by lanou on 16/1/4.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCCommonCollectionViewCell : UICollectionViewCell


@property(nonatomic,strong)UIView*backV;

@property(nonatomic,strong)UILabel *lb;


@property(nonatomic,strong)UIImageView*deleteIge;


@property(nonatomic,assign)int type;

@end
