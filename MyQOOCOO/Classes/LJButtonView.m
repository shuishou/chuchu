//
//  LJButtonView.m
//  MyQOOCOO
//
//  Created by lanou on 16/2/16.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "LJButtonView.h"

@implementation LJButtonView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSet];
    }
    return self;
    
}

#pragma mark 初始化参数
-(void)initSet{
    
    self.backgroundColor = [UIColor clearColor];
    self.imagev=[[UIImageView alloc]init];
    self.label=[[UILabel alloc]init];
}

- (void)drawRect:(CGRect)rect {
    
    self.imagev.frame=CGRectMake(10, (self.bounds.size.height-20)/2, 20,20);
    [self addSubview:self.imagev];
    self.label.frame=CGRectMake(35, 0, self.bounds.size.width/2 +10, self.bounds.size.height);
    self.label.textAlignment=NSTextAlignmentLeft;
    self.label.textColor=[UIColor blackColor];
    self.label.font=[UIFont systemFontOfSize:11];
    [self addSubview:self.label];
}

@end
