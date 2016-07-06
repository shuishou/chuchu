//
//  QCSelectContactsTableViewCell.m
//  MyQOOCOO
//
//  Created by lanou on 16/1/28.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCSelectContactsTableViewCell.h"

@implementation QCSelectContactsTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatreMyCell];
    }
    return self;
}


-(void)creatreMyCell
{
    self.pointImage=[[UIImageView alloc]init];
    [self.contentView addSubview:self.pointImage];
    
    self.userImage=[[UIImageView alloc]init];
    self.userImage.layer.cornerRadius = 25;
//    self.userImage.backgroundColor=[UIColor redColor];
    self.userImage.clipsToBounds = YES;

    [self.contentView addSubview:self.userImage];
    
    self.userName=[[UILabel alloc]init];
//    self.userName.backgroundColor=[UIColor greenColor];
    [self.contentView addSubview:self.userName];
    
    self.v=[[UIView alloc]init];
    self.v.backgroundColor=[UIColor grayColor];
    self.v.alpha=0.5;
    [self.contentView bringSubviewToFront:self.v];

    [self.contentView addSubview:self.v];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.pointImage.frame=CGRectMake(15, 25, 20, 20);
    self.userImage.frame=CGRectMake(45, 10, 50, 50);
    self.userName.frame=CGRectMake(105, 20,self.bounds.size.width/2 , 20);
    self.v.frame=CGRectMake(0, self.bounds.size.height- 0.5, self.bounds.size.width, 0.5);
}

@end
