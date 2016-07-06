//
//  QCSeniorCollectionViewCell.h
//  MyQOOCOO
//
//  Created by lanou on 16/1/4.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCSeniorCollectionViewCell : UICollectionViewCell


@property(nonatomic,strong)UIView*backV;
@property(nonatomic,strong)UIImageView*picImagev;
@property(nonatomic,strong)UIImageView*imagev2;
@property(nonatomic,strong)UILabel*msLb;

@property(nonatomic,strong)UIImageView*deleteIge;




@property(nonatomic,assign)NSInteger type;
@end
