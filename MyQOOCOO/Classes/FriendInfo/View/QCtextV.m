//
//  QCtextV.m
//  MyQOOCOO
//
//  Created by lanou on 16/3/17.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCtextV.h"

@implementation QCtextV

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }


    return self;
}



-(void)setModel:(QCGetUserMarkModel *)model
{
    _model = model;
    
    if (model.type!=5) {
        
    self.lb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        self.lb.text=model.title;
    self.lb.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
    self.lb.layer.borderWidth=0.5;
    self.lb.layer.cornerRadius=3;
    self.lb.textColor=RandomColor;
    self.lb.layer.masksToBounds=YES;
    self.lb.textAlignment=NSTextAlignmentCenter;
    self.lb.font=[UIFont systemFontOfSize:13];
    self.lb.adjustsFontSizeToFitWidth = YES;
        self.lb.numberOfLines = 0;
    self.lb.minimumFontSize = 6;
        [self addSubview:self.lb];
        
        
        self.deleteImage=[[UIImageView alloc]init];
        self.deleteImage.hidden=YES;
        self.deleteImage.image=[UIImage imageNamed:@"but_deletelatel"];
        [self addSubview:self.deleteImage];
        self.deleteImage.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint * traling = [NSLayoutConstraint constraintWithItem:self.deleteImage attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
        NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:self.deleteImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem:self.deleteImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:20];
        NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:self.deleteImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:20];
        [self addConstraints:@[traling,top,width,height]];

        
    }else{
        self.imagev=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        self.imagev.image=[UIImage imageNamed:@"Add_tags"];
        [self addSubview:self.imagev];

    
    }

    
    [self setNeedsDisplay];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
