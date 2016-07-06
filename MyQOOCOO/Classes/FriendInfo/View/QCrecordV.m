//
//  QCrecordV.m
//  MyQOOCOO
//
//  Created by lanou on 16/3/16.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCrecordV.h"


@implementation QCrecordV

-(instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
//        self.layer.borderWidth=0.5;
//        self.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
//        self.layer.cornerRadius=3;
//        self.layer.masksToBounds=YES;
//        self.backgroundColor=[UIColor clearColor];

        
        
        
        
    }
    return self;
}

-(void)setRecordmodel:(QCGetUserMarkModel *)recordmodel
{
    _recordmodel=recordmodel;
    if (recordmodel.type!=5) {
        
        self.layer.borderWidth=0.5;
        self.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
        self.layer.cornerRadius=3;
        self.layer.masksToBounds=YES;
        self.backgroundColor=[UIColor clearColor];

        
        
    self.bgV=[[UIView alloc]initWithFrame:CGRectMake(0,self.bounds.size.height-30, self.bounds.size.width, 25)];
    self.bgV.backgroundColor=[UIColor blackColor];
    self.bgV.alpha=0.5;
    [self addSubview:self.bgV];
    
    self.textLB=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bgV.size.width, 25)];
    self.textLB.backgroundColor=[UIColor clearColor];
    self.textLB.textColor=[UIColor whiteColor];
    self.textLB.font=[UIFont systemFontOfSize:14];
    self.textLB.textAlignment=NSTextAlignmentCenter;
    self.textLB.text=recordmodel.title;
    self.textLB.adjustsFontSizeToFitWidth = YES;
    self.textLB.minimumFontSize = 6;
    [self.bgV addSubview:self.textLB];
    
    
    self.playBgV=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, self.bounds.size.width-10, 30)];
    self.playBgV.backgroundColor=[UIColor blackColor];
    self.playBgV.alpha=0.5;
    self.playBgV.layer.cornerRadius=2;
    self.playBgV.layer.masksToBounds=YES;
    [self addSubview:self.playBgV];
    
    self.imagev=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.imagev.image=[UIImage imageNamed:@"fsadf-asfds"];
    [self.playBgV addSubview:self.imagev];
    
    
    self.msLb=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, self.bounds.size.width-30-10, 30)];
    self.msLb.backgroundColor=[UIColor clearColor];
    self.msLb.textColor=[UIColor whiteColor];
    self.msLb.font=[UIFont systemFontOfSize:14];
    self.msLb.textAlignment=NSTextAlignmentRight;
    self.msLb.text=[NSString stringWithFormat:@"%d'",recordmodel.durations];
    [self.playBgV addSubview:self.msLb];
        
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
        self.imagev=[[UIImageView alloc]initWithFrame:CGRectMake(0, (self.bounds.size.height-self.bounds.size.width)/2, self.bounds.size.width, self.bounds.size.width)];
        self.imagev.image=[UIImage imageNamed:@"iconfont-add"];
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
