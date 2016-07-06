//
//  QCAllSearchTableViewCell.m
//  MyQOOCOO
//
//  Created by lanou on 16/2/19.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCAllSearchTableViewCell.h"

@implementation QCAllSearchTableViewCell
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
    self.heardImageV=[[UIImageView alloc]init];
    self.heardImageV.layer.cornerRadius=20;
    self.heardImageV.layer.masksToBounds=YES;
//    self.heardImageV.backgroundColor=[UIColor blackColor];
    [self.contentView addSubview:self.heardImageV];
    
    self.userName=[[UILabel alloc]init];
    self.userName.font=[UIFont systemFontOfSize:13];
//    self.userName.backgroundColor=[UIColor redColor];
    [self.contentView addSubview:self.userName];
    
    self.fromType=[[UILabel alloc]init];
    self.fromType.font=[UIFont systemFontOfSize:13];
//    self.fromType.backgroundColor=[UIColor greenColor];
    [self.contentView addSubview:self.fromType];
    

    self.linev=[[UIView alloc]init];
    _linev.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
    [self.contentView addSubview:_linev];

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.heardImageV.frame=CGRectMake(10, 20, 40, 40);
    
    self.userName.frame=CGRectMake(70, 30, 120, 20);
    
    self.fromType.frame=CGRectMake(self.bounds.size.width-90, 30, 90, 20);
    

    self.linev.frame=CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width,1);
    
}
@end
