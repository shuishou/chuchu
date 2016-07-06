//
//  myCollectionCellCollectionViewCell.m
//  waterFallTest
//
//  Created by Fly_Fish_King on 15/7/20.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "myCollectionCell.h"

@interface myCollectionCell()


@end

@implementation myCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 60, 30)];
        [self.contentView addSubview:_label];
    }
    return self;
}

@end
