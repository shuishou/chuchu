//
//  QC_LJCollectionViewCell.m
//  MyQOOCOO
//
//  Created by lanou on 15/12/29.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QC_LJCollectionViewCell.h"

@implementation QC_LJCollectionViewCell

//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
//        self.voiceige=[[UIImageView alloc]init];
//        self.imagev=[[UIImageView alloc]init];
//        self.deleteIge=[[UIImageView alloc]init];
//        self.backv=[[UIView alloc]init];
//        self.titlelb=[[UILabel alloc]init];
//        self.msLb=[[UILabel alloc]init];

       self.backgroundColor=[UIColor whiteColor];
        
        
     
        //[self creatreMyCell];
        
        
    }
    return self;
}

-(void)setType:(int)type
{
    _type=type;
    [self creatreMyCell ];
    
    
}



-(void)creatreMyCell
{

    if (self.type==2) {
     //带图标签
    
    self.backv=[[UIView alloc]init];
    self.backv.backgroundColor=[UIColor whiteColor];
    self.backv.layer.borderWidth=0.5;
    self.backv.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
    self.backv.layer.cornerRadius=5;
    [self.contentView addSubview:self.backv];
    
    self.imagev=[[UIImageView alloc]init];
    //self.imagev.backgroundColor=[UIColor redColor];
    [self.backv addSubview:self.imagev];
    
    
    
    self.titlelb=[[UILabel alloc]init];
    self.titlelb.backgroundColor=[UIColor blackColor];
    self.titlelb.textColor=[UIColor whiteColor];
    self.titlelb.font=[UIFont systemFontOfSize:16];
    self.titlelb.textAlignment=NSTextAlignmentCenter;

    [self.backv addSubview:self.titlelb];
    }else if (self.type==4){
    //录音标签
        
        self.backv=[[UIView alloc]init];
        self.backv.backgroundColor=[UIColor whiteColor];
        self.backv.layer.borderWidth=0.5;
        self.backv.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
        self.backv.layer.cornerRadius=5;
        [self.contentView addSubview:self.backv];

        self.imagev=[[UIImageView alloc]init];
        self.imagev.backgroundColor=[UIColor blackColor];
        self.imagev.layer.cornerRadius=5;
        [self.backv addSubview:self.imagev];

        self.voiceige=[[UIImageView alloc]init];
        self.voiceige.image=[UIImage imageNamed:@"fsadf-asfds"];
        [self.imagev addSubview:self.voiceige];
        
        self.msLb=[[UILabel alloc]init];
        self.msLb.textColor=[UIColor whiteColor];
        self.msLb.font=[UIFont systemFontOfSize:16];
        self.msLb.textAlignment=NSTextAlignmentRight;
        self.msLb.text=@"1'";
        //self.msLb.backgroundColor=[UIColor redColor];
        [self.imagev addSubview:self.msLb];

        
    
    
       self.titlelb=[[UILabel alloc]init];
        self.titlelb.backgroundColor=[UIColor blackColor];
        self.titlelb.textColor=[UIColor whiteColor];
        self.titlelb.font=[UIFont systemFontOfSize:16];
        self.titlelb.textAlignment=NSTextAlignmentCenter;
        [self.backv addSubview:self.titlelb];
    
    }else if (self.type==1){
        //单文字标签
        
        self.backv=[[UIView alloc]init];
        self.backv.backgroundColor=[UIColor whiteColor];
        self.backv.layer.borderWidth=0.5;
        self.backv.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
        self.backv.layer.cornerRadius=5;
        [self.contentView addSubview:self.backv];

        
        
        self.titlelb=[[UILabel alloc]init];
        self.titlelb.backgroundColor=[UIColor clearColor];
        self.titlelb.textColor=RandomColor;
        self.titlelb.font=[UIFont systemFontOfSize:16];
        self.titlelb.textAlignment=NSTextAlignmentCenter;
        //self.titlelb.text=@"什么鬼";
        [self.backv addSubview:self.titlelb];

        
        
        
        
    }else if (self.type==3){
        
        //视频标签
        
        self.backv=[[UIView alloc]init];
        self.backv.backgroundColor=[UIColor whiteColor];
        self.backv.layer.borderWidth=0.5;
        self.backv.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
        self.backv.layer.cornerRadius=5;
        [self.contentView addSubview:self.backv];
        
        self.imagev=[[UIImageView alloc]init];
        //self.imagev.backgroundColor=[UIColor blackColor];
        [self.backv addSubview:self.imagev];
        
        self.voiceige=[[UIImageView alloc]init];
        self.voiceige.image=[UIImage imageNamed:@"LJbg_videl"];
        [self.imagev addSubview:self.voiceige];
        
        self.msLb=[[UILabel alloc]init];
        //self.msLb.text=@"1'";
        self.msLb.font=[UIFont systemFontOfSize:16];
        self.msLb.textAlignment=NSTextAlignmentRight;
        self.msLb.textColor=[UIColor whiteColor];
        [self.voiceige addSubview:self.msLb];
        
        self.titlelb=[[UILabel alloc]init];
        self.titlelb.backgroundColor=[UIColor blackColor];
        self.titlelb.textColor=[UIColor whiteColor];
        self.titlelb.font=[UIFont systemFontOfSize:16];
        //self.titlelb.text=@"123";
        self.titlelb.textAlignment=NSTextAlignmentCenter;
        [self.imagev addSubview:self.titlelb];
        
        
    }else if (self.type==5){
        //添加
        
        self.imagev=[[UIImageView alloc]init];
        self.imagev.image=[UIImage imageNamed:@"Add_tags"];
        //self.imagev.backgroundColor=[UIColor blackColor];
        [self.contentView addSubview:self.imagev];

        
    }
    
    
    if (self.type!=5) {
        self.deleteIge=[[UIImageView alloc]init];
        self.deleteIge.image=[UIImage imageNamed:@"but_deletelatel"];
        self.deleteIge.hidden=YES;
        
        [self.backv addSubview:self.deleteIge];
        self.deleteIge.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint * traling = [NSLayoutConstraint constraintWithItem:self.deleteIge attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.backv attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-5];
        NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:self.deleteIge attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backv attribute:NSLayoutAttributeTop multiplier:1.0 constant:5];
        NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem:self.deleteIge attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:20];
        NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:self.deleteIge attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:20];
        [self.backv addConstraints:@[traling,top,width,height]];
        
        [self.backv bringSubviewToFront:self.deleteIge];
       
        
    }


}


-(void)layoutSubviews
{
  
    [super layoutSubviews];
//      [self creatreMyCell ];
    if (self.type==2) {
        //带图标签
        self.backv.frame=CGRectMake(10, 10, self.bounds.size.width-20, self.bounds.size.height-20);
        self.imagev.frame=CGRectMake(5, 5, self.backv.bounds.size.width-10, self.backv.bounds.size.height-10);
        self.titlelb.frame=CGRectMake(5, self.backv.bounds.size.height-30, self.backv.bounds.size.width-10,25);
    }else if (self.type==4){
        //录音标签
        self.backv.frame=CGRectMake(10, 10, self.bounds.size.width-20, self.bounds.size.height-20);
        self.imagev.frame=CGRectMake(5, 50, self.backv.bounds.size.width-10,30);
        
        self.voiceige.frame=CGRectMake(0, 0, 30, 30);
        self.msLb.frame=CGRectMake(30, 0, self.imagev.bounds.size.width-35,30);
        
        self.titlelb.frame=CGRectMake(5, self.backv.bounds.size.height-30, self.backv.bounds.size.width-10,25);

        
        
        
        
        
    }else if (self.type==1){
        //文字标签
        
        self.backv.frame=CGRectMake(10, 10, self.bounds.size.width-20, self.bounds.size.height-20);
        
        self.titlelb.frame=CGRectMake(5, 60, self.backv.bounds.size.width-10,30);
        
        
        
        
    }else if (self.type==3){
        //视频标签
        
        self.backv.frame=CGRectMake(10, 10, self.bounds.size.width-20, self.bounds.size.height-20);
        self.imagev.frame=CGRectMake(5, 5, self.backv.bounds.size.width-10,self.backv.bounds.size.height-10);
        
        self.voiceige.frame=CGRectMake(0, 50, self.backv.bounds.size.width-10,30);
        self.msLb.frame=CGRectMake(30, 0, self.voiceige.bounds.size.width-40,30);
        
        self.titlelb.frame=CGRectMake(0, self.imagev.bounds.size.height-25, self.imagev.bounds.size.width,25);

        
        
        
    }else if (self.type==5){
        //添加
        self.imagev.frame=CGRectMake(20, (self.bounds.size.height-30)/2, self.bounds.size.width-40, 30);
        
    }

    
    if (self.type!=5) {
        //self.deleteIge.frame=CGRectMake(self.backv.bounds.size.width, 0, 20, 20);

        NSLog(@"%f",self.backv.bounds.size.width);

    }

    
}
@end
