//
//  QCCommonCollectionViewCell.m
//  MyQOOCOO
//
//  Created by lanou on 16/1/4.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCCommonCollectionViewCell.h"

@implementation QCCommonCollectionViewCell


//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        self.backV=[[UIView alloc]init];
        self.lb=[[UILabel alloc]init];
        self.deleteIge=[[UIImageView alloc]init];
        
        self.backgroundColor=[UIColor clearColor];
        
        
        
//        [self creatreMyCell];
        
        
    }
    return self;
}


-(void)setType:(int)type
{
    _type = type;
    [self creatreMyCell ];
    
    
}


-(void)creatreMyCell
{

    if (self.type==0) {
        
//     self.backV=[[UIView alloc]init];
    self.backV.backgroundColor=[UIColor whiteColor];
    self.backV.layer.borderWidth=0.5;
    self.backV.layer.cornerRadius=5;
    self.backV.layer.masksToBounds=YES;
    self.backV.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
    [self.contentView addSubview:self.backV];
    
//        self.lb=[[UILabel alloc]init];
    self.lb.textColor=RandomColor;
    self.lb.font=[UIFont systemFontOfSize:16];
    self.lb.textAlignment=NSTextAlignmentCenter;
    [self.backV addSubview:self.lb];
    
    
//    self.deleteIge=[[UIImageView alloc]init];
    self.deleteIge.image=[UIImage imageNamed:@"but_deletelatel"];
    self.deleteIge.hidden=YES;
    [self.backV bringSubviewToFront:self.deleteIge];
    [self.backV addSubview:self.deleteIge];
    }else{
        
        if (self.type != 5) {
            
//        self.backV=[[UIView alloc]init];
        self.backV.backgroundColor=[UIColor whiteColor];
        self.backV.layer.borderWidth=0.5;
        self.backV.layer.cornerRadius=5;
        self.backV.layer.masksToBounds=YES;
        self.backV.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
        [self.contentView addSubview:self.backV];
        
//        self.lb=[[UILabel alloc]init];
        self.lb.textColor=RandomColor;
        self.lb.font=[UIFont systemFontOfSize:16];
        self.lb.textAlignment=NSTextAlignmentCenter;
        [self.backV addSubview:self.lb];

        }else{
        
            self.deleteIge=[[UIImageView alloc]init];
            self.deleteIge.image=[UIImage imageNamed: @"Add_tags"];
            
            [self.contentView addSubview:self.deleteIge];
        
        }
        
        
        
        
        
    
    }

    
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
     if (self.type==0) {
    self.backV.frame=CGRectMake(5, 5, self.bounds.size.width-10, self.bounds.size.height-10);
    
    self.lb.frame=CGRectMake(0, 0, self.backV.bounds.size.width, self.backV.bounds.size.height);
    
         self.deleteIge.translatesAutoresizingMaskIntoConstraints = NO;
         NSLayoutConstraint * traling = [NSLayoutConstraint constraintWithItem:self.deleteIge attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.backV attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-5];
         NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:self.deleteIge attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backV attribute:NSLayoutAttributeTop multiplier:1.0 constant:5];
         NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem:self.deleteIge attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:20];
         NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:self.deleteIge attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:20];
         [self.backV addConstraints:@[traling,top,width,height]];
         
         [self.backV bringSubviewToFront:self.deleteIge];

    }else{
        if (self.type!=5) {
            self.backV.frame=CGRectMake(5, 5, self.bounds.size.width-10, self.bounds.size.height-10);
            
            self.lb.frame=CGRectMake(0, 0, self.backV.bounds.size.width, self.backV.bounds.size.height);
        }else{
        
            self.deleteIge.frame=CGRectMake(5, 5, self.bounds.size.width-10, self.bounds.size.height-10);
        
        
        }
        
        
    }
}

@end
