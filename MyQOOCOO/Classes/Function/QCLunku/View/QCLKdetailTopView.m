//
//  QCLKdetailTopView.m
//  MyQOOCOO
//
//  Created by 贤荣 on 15/12/28.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCLKdetailTopView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "OkamiPhotoView.h"

@interface QCLKdetailTopView ()

@property (weak, nonatomic) IBOutlet UIView *bgV;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;

@property (weak, nonatomic) IBOutlet UIImageView *picV;
@property (weak, nonatomic) IBOutlet UIView *picVCountBg;
@property (weak, nonatomic) IBOutlet UILabel *picCountLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@property (nonatomic,weak) OkamiPhotoView * photoVew;

@property (nonatomic,strong) NSArray * arr;//配图

@end


@implementation QCLKdetailTopView

+(instancetype)topView{
    return [[[NSBundle mainBundle]loadNibNamed:@"QCLKdetailTopView" owner:nil options:nil]lastObject];
}

-(void)awakeFromNib{
    
    self.bgV.layer.cornerRadius = 8;
    self.bgV.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 22;
    self.icon.layer.masksToBounds = YES;
  
    
    self.picV.userInteractionEnabled =YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick:)];
    [self.picV addGestureRecognizer:tap];
    
}

-(void)setLk:(QCLunkuListModel *)lk{
    _lk = lk;
    
    //头像
    [self.icon sd_setImageWithURL:[NSURL URLWithString:lk.user.avatar] placeholderImage:[UIImage imageNamed:@"ios-template-1024(1)"]];
    
    //昵称
    self.name.text = lk.user.nickname;
    
    //发送时间
    self.time.text = lk.createTime;
    
    //标题
    self.title.text = lk.title;
//    NSLineBreakMode
//    boundingRectWithSize:options:attributes:context
    //正文
    self.content.text = lk.content;
    NSDictionary * textAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGSize maxSize = CGSizeMake(kUIScreenW - 12 * 4, MAXFLOAT);
    CGSize requiredSize = [self.lk.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size;
    self.contentHeight.constant = requiredSize.height;
    self.content.frame = CGRectMake(12, 102, self.frame.size.width-24, requiredSize.height);
    
    //配图
    if (lk.image.length>0) {
        NSArray * tempArr = [lk.image componentsSeparatedByString:@","];
        NSMutableArray * Arr =[tempArr mutableCopy];
        
        CGFloat photoX = 18;
        CGFloat photoY = self.content.frame.origin.y+requiredSize.height+10;
        CGSize photosSize=[OkamiPhotoView photoViewSizeWithPictureCount:Arr.count];
        
        OkamiPhotoView * photoView = [[OkamiPhotoView alloc]initWithFrame:(CGRect){photoX,photoY,photosSize}];
        photoView.dynamicImgPaths=Arr;
        [self addSubview:photoView];
        self.photoVew = photoView;
        
        NSLayoutConstraint * rotateTopConstraint = [NSLayoutConstraint constraintWithItem:self.photoVew attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        
        rotateTopConstraint.active=YES;

        [self addConstraint:rotateTopConstraint];
        
        
        
        if (Arr.count >1) {
            self.picCountLabel.text =[NSString stringWithFormat:@"共%zd张",Arr.count];
        }else{
            self.picVCountBg.hidden = YES;
            self.picCountLabel.hidden = YES;
        }
        
    }else{
        self.picV.hidden = YES;
        self.picVCountBg.hidden = YES;
        self.picCountLabel.hidden = YES;
        
    }
}

#pragma mark - 集成图片浏览器
-(void)imgClick:(UITapGestureRecognizer*)recognizer{
//    
//    MJPhotoBrowser * brower = [[MJPhotoBrowser alloc]init];
//    
//    NSMutableArray *mjPhotos = [NSMutableArray array];
//    NSInteger imgCount = self.arr.count;
//    for (NSInteger i = 0; i< imgCount; i++) {
//        
//        NSString * picUrl = self.arr[i];
//        MJPhoto *mjPhoto =[[MJPhoto alloc]init];
//        mjPhoto.url = [NSURL URLWithString:picUrl];
//        mjPhoto.srcImageView = self.picV;
//        [mjPhotos addObject:mjPhoto];
//    }
//    brower.photos = mjPhotos;
//    [brower show];
}

@end
