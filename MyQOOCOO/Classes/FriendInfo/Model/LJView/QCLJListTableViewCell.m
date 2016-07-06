//
//  QCLJListTableViewCell.m
//  MyQOOCOO
//
//  Created by lanou on 16/3/15.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCLJListTableViewCell.h"
#import "QCGetUserMarkModel.h"

@implementation QCLJListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.bgV=[[UIView alloc]init];
        
        
        self.picV = [[QCPicScrollView alloc]init];
        self.textV=[[QCtextsView alloc]init];
        
        self.picArr=[[NSMutableArray alloc]init];
        self.textArr=[[NSMutableArray alloc]init];
    }
    return self;
}

-(void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr=dataArr;
    [_picArr removeAllObjects];
    [_textArr removeAllObjects];
   
    for (int i=0; i<dataArr.count; i++) {
        QCGetUserMarkModel *model=dataArr[i];
        
        if (model.type==2||model.type==3||model.type==4) {
            [_picArr addObject:model];
        }
        if (model.type==1) {
            [_textArr addObject:model];
        }
    }
    
    [self creatreMyCell];
}

-(void)creatreMyCell
{
    self.bgV.backgroundColor=[UIColor whiteColor];
    self.bgV.layer.cornerRadius=5;
    self.bgV.layer.masksToBounds=YES;
    [self.contentView addSubview:self.bgV];
    
    if (!self.isfens) {
        QCGetUserMarkModel *model=[[QCGetUserMarkModel alloc]init];
        model.type = 5;
        model.groupId=self.groudId;
        
        if (self.textArr.count==0) {
            if (self.picArr.count==0) {
                [self.textArr addObject:model];
                
            }else{
                //图片，视频不为空
                [self.picArr addObject:model];
            }
        }else{
            //文字不为空
            [self.textArr addObject:model];
        }
    }else{
        self.textV.flag = 100;
        self.textV.userInteractionEnabled = NO;
    }

    self.picV.dynamicImgPaths = self.picArr;
    [self.bgV addSubview:self.picV];
    
    self.textV.indexpath = self.indexpath;
    self.textV.codeArr = self.textArr;
    [self.bgV addSubview:self.textV];

 }

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat photoX = 10;
    CGFloat photoY = 10;
    CGSize textSize=[QCtextsView textViewSizeWithArrCount:self.textArr.count];
    CGSize photosSize=[QCPicScrollView photoViewSizeWithPictureCount:self.picArr.count];
//    CGSize recordSize=[QCrecordView recordViewSizeWithArrCount:self.recordArr.count];


    self.bgV.frame=CGRectMake(10, -15, self.bounds.size.width-20, self.bounds.size.height+16);
    self.picV.frame=(CGRect){0,15,photosSize.width*self.picArr.count,photosSize.height};
    self.textV.frame=(CGRect){photoX,photoY+self.picV.frame.size.height+10,textSize};
//    self.recordV.frame=(CGRect){photoX,photoY+self.picV.frame.size.height+self.textV.frame.size.height+20,recordSize};
    
}
@end
