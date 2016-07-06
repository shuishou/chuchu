//
//  QCPicV.m
//  MyQOOCOO
//
//  Created by lanou on 16/3/16.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCPicV.h"

@implementation QCPicV


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //        1、设置pictureView的内容显示模式
      }
    return self;
}

-(void)setModel:(QCGetUserMarkModel *)model
{
    _model = model;
    self.bgIge=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];

    self.bgIge.contentMode = UIViewContentModeScaleAspectFill;
    self.bgIge.clipsToBounds = YES;
    [self addSubview:self.bgIge];
    self.titleLb=[[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-30, self.bounds.size.width, 30)];

    self.titleLb.text=model.title;
    self.titleLb.textColor=[UIColor whiteColor];
    self.titleLb.textAlignment=NSTextAlignmentCenter;
    self.titleLb.font=[UIFont systemFontOfSize:14];
    [self addSubview:self.titleLb];
    if (model.type!=5) {
        
    
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
    }


    if (model.type==2) {
        
    
    [self.bgIge sd_setImageWithURL:[NSURL URLWithString:model.url]];
    }else if (model.type==5){
        self.bgIge.frame=CGRectMake((self.bounds.size.width-(self.bounds.size.height/2))/2, self.bounds.size.height/4, self.bounds.size.height/2, self.bounds.size.height/2);
        self.bgIge.image=[UIImage imageNamed:@"iconfont-add"];
    }else if(model.type==3){
    [self.bgIge sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
        self.playImageV=[[UIImageView alloc]initWithFrame:CGRectMake((self.bounds.size.width-30)/2, (self.bounds.size.height-30)/2, 30, 30)];
        self.playImageV.image=[UIImage imageNamed:@"LJ-iconfont-play-copy"];
        [self addSubview:self.playImageV];
        
    }else if(model.type==4){
        [self.bgIge sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
        self.playImageV=[[UIImageView alloc]initWithFrame:CGRectMake((self.bounds.size.width-30)/2, (self.bounds.size.height-30)/2, 30, 30)];
        self.playImageV.image=[UIImage imageNamed:@"fsadf-asfds"];
        [self addSubview:self.playImageV];

    
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
