//
//  QCSeniorCollectionViewCell.m
//  MyQOOCOO
//
//  Created by lanou on 16/1/4.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCSeniorCollectionViewCell.h"

@implementation QCSeniorCollectionViewCell
//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
//       self.backV=[[UIView alloc]init];
//         self.picImagev=[[UIImageView alloc]init];
//        self.msLb=[[UILabel alloc]init];
//        self.imagev2=[[UIImageView alloc]init];
//        self.deleteIge=[[UIImageView alloc]init];
        
        
        
        self.backgroundColor=[UIColor whiteColor];
        
        
        
       // [self creatreMyCell];
        
        
    }
    return self;
}


-(void)setType:(NSInteger)type
{
    _type=type;
    [self creatreMyCell ];
    
    
}

-(void)creatreMyCell
{
       if (self.type==1) {
        //相片
        
        

        self.backV=[[UIView alloc]init];
        self.backV.layer.cornerRadius=5;
       
        [self.contentView addSubview:self.backV];
        

        self.picImagev=[[UIImageView alloc]init];
        self.picImagev.layer.cornerRadius=5;
        self.picImagev.layer.masksToBounds=YES;
    
        [self.backV addSubview:self.picImagev];
        
       
        
        
    }else if (self.type==2){
        //录音

        self.backV=[[UIView alloc]init];
        self.backV.layer.cornerRadius=5;
        
        [self.contentView addSubview:self.backV];

       self.picImagev=[[UIImageView alloc]init];
        self.picImagev.layer.cornerRadius=5;
        self.picImagev.backgroundColor=[UIColor blackColor];
        [self.backV addSubview:self.picImagev];

        

        self.imagev2=[[UIImageView alloc]init];
        self.imagev2.image=[UIImage imageNamed:@"fsadf-asfds"];
        [self.contentView addSubview:self.imagev2];
        

        self.msLb=[[UILabel alloc]init];
        self.msLb.textColor=[UIColor whiteColor];
        [self.contentView addSubview:self.msLb ];
        

        
        
        
        
    }else if (self.type==3){
        //视频
        self.backV=[[UIView alloc]init];
        self.backV.layer.cornerRadius=5;
        [self.contentView addSubview:self.backV];
        

        self.picImagev=[[UIImageView alloc]init];
        self.picImagev.layer.cornerRadius=5;
        self.picImagev.layer.masksToBounds=YES;
        [self.backV addSubview:self.picImagev];
        

        [self.backV addSubview:self.imagev2];
        

        self.msLb=[[UILabel alloc]init];
        self.msLb.textColor=[UIColor whiteColor];
        [self.backV addSubview:self.msLb ];



        
    }else if (self.type==4){
    
    
        self.backV=[[UIView alloc]init];
        self.backV.layer.cornerRadius=5;
        [self.contentView addSubview:self.backV];
        
        

        self.picImagev=[[UIImageView alloc]init];
        self.picImagev.image=[UIImage imageNamed: @"Add_tags"];
        [self.backV addSubview:self.picImagev];
        
//        self.picImagev=[[UIImageView alloc]init];
//        self.picImagev.image=[UIImage imageNamed:@"Add_tags"];
//        
//        [self.contentView addSubview:self.picImagev];
        
        
    }
    
    
    
    
    if (self.type!=4) {
        self.deleteIge=[[UIImageView alloc]init];
        self.deleteIge.image=[UIImage imageNamed:@"but_deletelatel"];
        self.deleteIge.hidden=YES;
        
        [self.backV addSubview:self.deleteIge];
        self.deleteIge.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint * traling = [NSLayoutConstraint constraintWithItem:self.deleteIge attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.backV attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-5];
        NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:self.deleteIge attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backV attribute:NSLayoutAttributeTop multiplier:1.0 constant:5];
        NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem:self.deleteIge attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:20];
        NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:self.deleteIge attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:20];
        [self.backV addConstraints:@[traling,top,width,height]];
        
        [self.backV bringSubviewToFront:self.deleteIge];
        
        
    }
    
    if (self.type!=4) {
        
    
    self.picImagev.contentMode = UIViewContentModeScaleAspectFill;
    self.picImagev.clipsToBounds = YES;
    }

    
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.type==1) {
        self.backV.frame=CGRectMake(5, 5, self.bounds.size.width-10, self.bounds.size.height-10);
        self.picImagev.frame=CGRectMake(0, 0, self.backV.bounds.size.width, self.backV.bounds.size.height);
        

        
        [self.backV bringSubviewToFront:self.deleteIge];
    //相片
    }else if (self.type==2){
    //录音
        self.backV.frame=CGRectMake(5, 5, self.bounds.size.width-10, self.bounds.size.height-10);
        self.picImagev.frame=CGRectMake(0, 0, self.backV.bounds.size.width,self.backV.bounds.size.height);
        self.imagev2.frame=CGRectMake(5, 5, self.picImagev.bounds.size.height, self.picImagev.bounds.size.height);
        self.msLb.frame=CGRectMake(self.picImagev.bounds.size.width-self.picImagev.bounds.size.height, 5, self.picImagev.bounds.size.height,self.picImagev.bounds.size.height);
    

    }else if (self.type==3){
    //视频
        
        self.backV.frame=CGRectMake(5, 5, self.bounds.size.width-10, self.bounds.size.height-10);
        self.picImagev.frame=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        self.imagev2.frame=CGRectMake(0, 0, 30, 30);
        self.msLb.frame=CGRectMake(self.backV.bounds.size.width-30, 0, 30,30);

    

    }else if (self.type==4){
        //添加
        self.backV.frame=CGRectMake(5, 5, self.bounds.size.width-10, self.bounds.size.height-10);
        self.picImagev.frame=CGRectMake(0, 0, self.backV.bounds.size.width, self.backV.bounds.size.height);

    
    }
    
    
 

}





@end
