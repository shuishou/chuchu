//
//  QCDDDeatailTopView.m
//  MyQOOCOO
//
//  Created by 贤荣 on 15/12/25.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCDDDeatailTopView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "OkamiPhotoView.h"
#define kMovieUrlNotification @"MovieUrlNotification"

@interface QCDDDeatailTopView ()
@property (weak, nonatomic) IBOutlet UIView *bgV;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *content;

@property (weak, nonatomic) IBOutlet UIImageView *picV;

@property (weak, nonatomic) IBOutlet UILabel *picCountLabel;

@property (nonatomic,strong) NSArray * arr;//图片URL数组
@property (nonatomic,strong) NSArray * movieArr;//电影URL数组，第一个为缩略图，第二个为视频URL

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picViewHConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rxConstaint;
@property (weak, nonatomic) IBOutlet UIView *rxBgV;
@property (weak, nonatomic) IBOutlet UILabel *L1;
@property (weak, nonatomic) IBOutlet UILabel *L2;
@property (weak, nonatomic) IBOutlet UILabel *L3;
@property (weak, nonatomic) IBOutlet UILabel *L4;
@property (weak, nonatomic) IBOutlet UILabel *L5;
@property (weak, nonatomic) IBOutlet UILabel *L6;
@property (weak, nonatomic) IBOutlet UILabel *L7;
@property (weak, nonatomic) IBOutlet UILabel *L8;
@property (weak, nonatomic) IBOutlet UIImageView *M1;
@property (weak, nonatomic) IBOutlet UIImageView *M2;
@property (weak, nonatomic) IBOutlet UIImageView *M3;
@property (weak, nonatomic) IBOutlet UIImageView *M4;
@property (weak, nonatomic) IBOutlet UIImageView *M5;
@property (weak, nonatomic) IBOutlet UIImageView *M6;
@property (weak, nonatomic) IBOutlet UIImageView *M7;
@property (weak, nonatomic) IBOutlet UIImageView *M8;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@property (nonatomic,weak) OkamiPhotoView * photoVew;
@end

@implementation QCDDDeatailTopView

+(instancetype)topView{
    return [[[NSBundle mainBundle]loadNibNamed:@"QCDDDeatailTopView" owner:nil options:nil]lastObject];
}

-(void)awakeFromNib{
    self.bgV.layer.cornerRadius = 8;
    self.bgV.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 22;
    self.icon.layer.masksToBounds = YES;
    
    self.picV.userInteractionEnabled =YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick:)];
    [self.picV addGestureRecognizer:tap];
    
    self.M1.layer.borderWidth = 0.5;
    self.M1.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
    self.M2.layer.borderWidth = 0.5;
    self.M2.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
    self.M3.layer.borderWidth = 0.5;
    self.M3.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
    self.M4.layer.borderWidth = 0.5;
    self.M4.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
    self.M5.layer.borderWidth = 0.5;
    self.M5.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
    self.M6.layer.borderWidth = 0.5;
    self.M6.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
    self.M7.layer.borderWidth = 0.5;
    self.M7.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
    self.M8.layer.borderWidth = 0.5;
    self.M8.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
    
}

-(void)setDianDi:(QCDiandiListModel *)dianDi{
    _dianDi = dianDi;
    
    //头像
    [self.icon sd_setImageWithURL:[NSURL URLWithString:dianDi.user.avatar] placeholderImage:[UIImage imageNamed:@"ios-template-1024(1)"]];
    
    //昵称
    self.name.text = dianDi.user.nickname;
    
    //发送时间
    self.time.text = dianDi.createTime;
    
//     地址
    if (dianDi.address.length>0) {
        self.address.text = dianDi.address;
    }
    
    //正文
    if (dianDi.type==2) {
        //来自日醒
        NSData *JSONData = [dianDi.content dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        //         CZLog(@"%@",dic);
        
        self.content.font = [UIFont systemFontOfSize:12];
        self.content.text = [NSString stringWithFormat:@"来自日省(%@)",dic[@"day"]];
        
        NSString *keyStr = dic[@"key"];
        NSArray * tempArr = [keyStr componentsSeparatedByString:@","];
        NSMutableArray * Arr =[tempArr mutableCopy];
        for (int i = 0; i<Arr.count; i++) {
            switch (i) {
                case 0:
                    self.L1.text = Arr[0];
                    self.L1.hidden = NO;
                    self.M1.hidden = NO;
                    break;
                case 1:
                    self.L2.text = Arr[1];
                    self.L2.hidden = NO;
                    self.M2.hidden = NO;
                    break;
                case 2:
                    self.L3.text = Arr[2];
                    self.L3.hidden = NO;
                    self.M3.hidden = NO;
                    break;
                case 3:
                    self.L4.text = Arr[3];
                    self.L4.hidden = NO;
                    self.M4.hidden = NO;
                    break;
                case 4:
                    self.L5.text = Arr[4];
                    self.L5.hidden = NO;
                    self.M5.hidden = NO;
                    break;
                case 5:
                    self.L6.text = Arr[5];
                    self.L6.hidden = NO;
                    self.M6.hidden = NO;
                    break;
                case 6:
                    self.L7.text = Arr[6];
                    self.L7.hidden = NO;
                    self.M7.hidden = NO;
                    break;
                case 7:
                    self.L8.text = Arr[7];
                    self.L8.hidden = NO;
                    self.M8.hidden = NO;
                    break;
                default:
                    break;
            }
        }
        
        NSString * valueStr = dic[@"value"];
        NSArray * tArr = [valueStr componentsSeparatedByString:@","];
        NSMutableArray * arr =[tArr mutableCopy];
        for (int i = 0; i<arr.count; i++) {
            
            switch (i) {
                case 0:
                    [self swithImage:arr[0] imgV:self.M1];
                    break;
                case 1:
                    [self swithImage:arr[1] imgV:self.M2];
                    break;
                case 2:
                    [self swithImage:arr[2] imgV:self.M3];
                    break;
                case 3:
                    [self swithImage:arr[3] imgV:self.M4];
                    break;
                case 4:
                    [self swithImage:arr[4] imgV:self.M5];
                    break;
                case 5:
                    [self swithImage:arr[5] imgV:self.M6];
                    break;
                case 6:
                    [self swithImage:arr[6] imgV:self.M7];
                    break;
                case 7:
                    [self swithImage:arr[7] imgV:self.M8];
                    break;
                default:
                    break;
            }
        }
        
    }else{
        self.content.text = dianDi.content;
        self.rxBgV.hidden = YES;
        self.rxConstaint.constant = 0;
    }
    
    //    配图
    if (dianDi.coverUrl.length>0 ) {
        
        if (dianDi.contentType ==2) {
            //视频的帖子
            UIImageView * defaultView = [[UIImageView alloc]initWithFrame:self.picV.bounds];
            defaultView.userInteractionEnabled =YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(movieDefaultViewClick)];
            [defaultView addGestureRecognizer:tap];
            defaultView.image = [UIImage imageNamed:@"chat_video_play"];
            [self.picV addSubview:defaultView];
            
             NSArray * movieArr = [dianDi.coverUrl componentsSeparatedByString:@","];
            self.movieArr = movieArr;
            if (movieArr.count>1) {
                 [self.picV sd_setImageWithURL:[NSURL URLWithString:movieArr.firstObject]];
            }
            self.picCountV.hidden = YES;
            self.picCountLabel.hidden = YES;
            
        }else {
            //图片的帖子
            NSArray * tempArr = [dianDi.coverUrl componentsSeparatedByString:@","];
            NSMutableArray * Arr =[tempArr mutableCopy];
            self.arr = Arr;
            if (Arr.count>1) {
                self.picCountLabel.text =[NSString stringWithFormat:@"共%zd张",Arr.count];
            }else{
                self.picCountV.hidden = YES;
                self.picCountLabel.hidden = YES;
            }
//            [self.picV sd_setImageWithURL:[NSURL URLWithString:Arr.firstObject]];
//            self.picV.contentMode = UIViewContentModeScaleAspectFill;
//            self.picV.clipsToBounds = YES;
            
            NSDictionary * textAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
            CGSize maxSize = CGSizeMake(kUIScreenW - 12 * 4, MAXFLOAT);
            CGSize requiredSize = [dianDi.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size;
            self.contentHeight.constant = requiredSize.height;
            self.content.frame = CGRectMake(12, 66, self.frame.size.width-24, requiredSize.height);
            
            
            CGFloat photoX = 18;
            CGFloat photoY = self.content.frame.origin.y + requiredSize.height;
            CGSize photosSize=[OkamiPhotoView photoViewSizeWithPictureCount:Arr.count];
            
            OkamiPhotoView * photoView = [[OkamiPhotoView alloc]initWithFrame:(CGRect){photoX,photoY,photosSize}];
            photoView.dynamicImgPaths=Arr;
            
            self.photoVew = photoView;
            [self addSubview:self.photoVew];
            
            [self bringSubviewToFront:self.picCountV];
            
            
            NSLayoutConstraint * rotateTopConstraint = [NSLayoutConstraint constraintWithItem:self.photoVew attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
            
            rotateTopConstraint.active=YES;
            [self addConstraint:rotateTopConstraint];
        }
        
    }else{//纯文本帖子
        self.picViewHConstraint.constant = 0;
        self.picV.hidden = YES;
        self.picCountV.hidden = YES;
        self.picCountLabel.hidden = YES;
        
        NSDictionary * textAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
        CGSize maxSize = CGSizeMake(kUIScreenW - 12 * 4, MAXFLOAT);
        CGSize requiredSize = [dianDi.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size;
        self.contentHeight.constant = requiredSize.height;
        self.content.frame = CGRectMake(12, 66, self.frame.size.width-24, requiredSize.height);
        
        
    }
}

#pragma mark - 集成图片浏览器
-(void)imgClick:(UITapGestureRecognizer*)recognizer{
    
        MJPhotoBrowser * brower = [[MJPhotoBrowser alloc]init];
        NSMutableArray *mjPhotos = [NSMutableArray array];
        NSInteger imgCount = self.arr.count;
        for (NSInteger i = 0; i< imgCount; i++) {
            
            NSString * picUrl = self.arr[i];
            MJPhoto *mjPhoto =[[MJPhoto alloc]init];
            mjPhoto.url = [NSURL URLWithString:picUrl];
            mjPhoto.srcImageView = self.picV;
            [mjPhotos addObject:mjPhoto];
        }
        brower.photos = mjPhotos;
        [brower show];

}

// 播放视频
-(void)movieDefaultViewClick{
    
    if (self.movieArr.count >1) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kMovieUrlNotification object:nil userInfo:@{@"MovieUrl":self.movieArr.lastObject}];
    }
   
}

//日行心情图
-(void)swithImage:(NSString*)num imgV:(UIImageView*)imgV{
    
    switch (num.intValue) {
        case 0:
            imgV.image =[UIImage imageNamed:@"rixing3@2x"];
            break;
            
        case 1:
            imgV.image =[UIImage imageNamed:@"rixing2@2x"];
            break;
            
        case 2:
            imgV.image =[UIImage imageNamed:@"rixing1@2x"];
            break;
            
        default:
            break;
    }
}

@end
