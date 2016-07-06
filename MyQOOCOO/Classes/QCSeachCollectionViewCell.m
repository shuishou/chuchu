//
//  QCSeachCollectionViewCell.m
//  MyQOOCOO
//
//  Created by lanou on 16/2/19.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCSeachCollectionViewCell.h"

@implementation QCSeachCollectionViewCell
//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self) {
        self.imagev=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
//        self.imagev.backgroundColor=[UIColor yellowColor];
        [self.contentView addSubview:self.imagev];
        self.lb=[[UILabel alloc]initWithFrame:CGRectMake(25, 5, self.bounds.size.width-25,20)];
        self.lb.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.lb];
    }
    return self;
}

@end
