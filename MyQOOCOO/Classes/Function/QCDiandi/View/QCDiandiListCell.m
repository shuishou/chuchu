//
//  QCDiandiListCell.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/11/3.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCDiandiListCell.h"
#import "ImagePreviewViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "HttpURLMacros.h"


#import "OkamiPhotoView.h"


@interface QCDiandiListCell ()

@property (weak, nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *sendTime;

@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picViewHConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UIView *picCountBgV;
@property (weak, nonatomic) IBOutlet UILabel *picCountText;
@property (weak, nonatomic) IBOutlet OkamiPhotoView *photoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoHeight;

//点赞
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UILabel *DZLabel;
- (IBAction)DZBtnClick;
// 评论
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (nonatomic,strong) NSArray * arr;//图片
@property (nonatomic,strong) NSArray * movieArr;//电影

//来自日醒
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rxConsraint;

//@property (nonatomic,weak) OkamiPhotoView * photoVew;

@property (nonatomic,assign) BOOL price;

@end

@implementation QCDiandiListCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *reuseId = @"QCDiandiListCell";
   QCDiandiListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"QCDiandiListCell" owner:nil options:nil]lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    self.avatar.userInteractionEnabled = YES;
    UITapGestureRecognizer *avatartap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatarpush:)];
    [self.avatar addGestureRecognizer:avatartap];


    self.background.layer.cornerRadius = 8;
    self.background.layer.borderWidth = 1;
    self.background.layer.borderColor = UIColorFromRGB(0xF1F1F1).CGColor;
    self.background.layer.masksToBounds = YES;
    self.background.backgroundColor = [UIColor whiteColor];
    
    _avatar.layer.cornerRadius = 22;
    _avatar.layer.masksToBounds = YES;
    
    self.picView.userInteractionEnabled =YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick:)];
    [self.picView addGestureRecognizer:tap];
    
    self.price = NO;
    
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

-(void)setDiandiListModel:(QCDiandiListModel *)diandiListModel{
    _diandiListModel = diandiListModel;
    
    //头像
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:diandiListModel.user.avatar] placeholderImage:[UIImage imageNamed:@"ios-template-1024(1)"]];

    //昵称
    _nickName.text = diandiListModel.user.nickname;
    
    //发送时间
    _sendTime.text = diandiListModel.createTime;
    
    if (diandiListModel.address) {
        self.address.text = diandiListModel.address;
    }
    //正文
    if (diandiListModel.type==2) {//来自日醒
        
    NSData *JSONData = [diandiListModel.content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
//         CZLog(@"%@",dic);
        
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.text=[NSString stringWithFormat:@"来自日省(%@)",dic[@"day"]];
      
        
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
    
       _contentLabel.text = diandiListModel.content;
        
        self.rxBgV.hidden = YES;
        self.rxConsraint.constant = 0;
    }
    
//    有值即为视频或者图片
    if (diandiListModel.coverUrl.length>0)
    {
        
        if (diandiListModel.contentType==2) {//视频的帖子
            UIImageView * defaultView = [[UIImageView alloc]initWithFrame:self.picView.bounds];
            defaultView.userInteractionEnabled =YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(movieDefaultViewClick)];
            [defaultView addGestureRecognizer:tap];
            defaultView.contentMode = UIViewContentModeCenter;
            defaultView.image = [UIImage imageNamed:@"chat_video_play"];
            [self.picView addSubview:defaultView];
            
            NSArray * movieArr = [diandiListModel.coverUrl componentsSeparatedByString:@","];
            self.movieArr = movieArr;
            if (movieArr.count>1) {
                [self.picView sd_setImageWithURL:[NSURL URLWithString:movieArr.firstObject]];
            }
            self.picCountBgV.hidden = YES;
            self.picCountText.hidden = YES;
            
            self.photoView.hidden=YES;
            self.photoHeight.constant=160;
            
            
        }else if (diandiListModel.contentType==1){//图片的帖子
            NSArray * tempArr = [diandiListModel.coverUrl componentsSeparatedByString:@","];
            NSMutableArray * Arr =[tempArr mutableCopy];
            self.arr = Arr;
//            if (Arr.count>1) {
//                self.picCountText.text =[NSString stringWithFormat:@"共%zd张",Arr.count];
//            }else{
//                self.picCountBgV.hidden = YES;
//                self.picCountText.hidden = YES;
//            }
//            [self.picView sd_setImageWithURL:[NSURL URLWithString:Arr.firstObject]];
//            self.picView.contentMode = UIViewContentModeScaleAspectFill;
//            self.picView.clipsToBounds = YES;
            
      
            CGFloat photoX = 18;
            CGFloat photoY = MaxY(self.contentLabel)+HEIGHT(self.contentLabel)+32; 
            CGSize photosSize=[OkamiPhotoView photoViewSizeWithPictureCount:Arr.count];
            //        self.picV.frame=(CGRect){photoX,photoY,photosSize};
//            OkamiPhotoView * photoView = [[OkamiPhotoView alloc]initWithFrame:(CGRect){photoX,photoY,photosSize}];
            self.photoView.dynamicImgPaths=Arr;
          
             
            if (Arr.count==0) {
                self.photoHeight.constant=0;
            }else{
                self.photoHeight.constant=photosSize.height;
            }
            
//            [self.contentView addSubview:photoView];
//            self.photoView = photoView;
//            NSLayoutConstraint * rotateTopConstraint = [NSLayoutConstraint constraintWithItem:self.photoVew attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
//
//            rotateTopConstraint.active=YES;

            
            if (Arr.count>1) {
                self.picCountText.text =[NSString stringWithFormat:@"共%zd张",Arr.count];
            }else{
                self.picCountBgV.hidden = YES;
                self.picCountText.hidden = YES;

            }

            
            
        }
        
        
        
        
    }else{//纯文本帖子
        self.picViewHConstraint.constant = 0;
        self.picView.hidden = YES;
        self.picCountBgV.hidden = YES;
        self.picCountText.hidden = YES;
        self.photoHeight.constant=0;
        
        if (diandiListModel.type==2)
        {
            self.photoView.hidden=YES;
            self.photoHeight.constant=80;
        }
    }
  
//    点赞
    self.DZLabel.text =[NSString stringWithFormat:@"%d",diandiListModel.praiseCount];
    if (diandiListModel.hasPraise) {
        [self.praiseBtn setImage:[UIImage imageNamed:@"but_like_pre"] forState:UIControlStateNormal];
        self.price = YES;
    }
    
//    评论
    self.commentLabel.text = [NSString stringWithFormat:@"%d",diandiListModel.commentCount];
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
            mjPhoto.srcImageView = self.picView;
            [mjPhotos addObject:mjPhoto];
        }
        brower.photos = mjPhotos;
        [brower show];
}

-(void)avatarpush:(UITapGestureRecognizer*)recognizer{
    
   
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"avatarpush" object:nil userInfo:@{@"model":self.diandiListModel}];

}

    //播放视频
-(void)movieDefaultViewClick{

    if (self.movieArr.count >1) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kMovieUrlNotification object:nil userInfo:@{@"MovieUrl":self.movieArr.lastObject}];
    }
    
}

// 点赞按钮点击
- (IBAction)DZBtnClick {
    self.price = !self.price;
    NSDictionary * parame = @{@"recordId":@(self.diandiListModel.id)};
    [NetworkManager requestWithURL:RECORD_PRAISE parameter:parame success:^(id response) {
        
        CZLog(@"%@",response);
        self.diandiListModel.hasPraise=[response[@"hasPraise"] boolValue];
        self.diandiListModel.praiseCount=[response[@"praiseCount"] integerValue];
        if (!self.price) {
            [self.praiseBtn setImage:[UIImage imageNamed:@"but_like"] forState:UIControlStateNormal];
            self.DZLabel.text= [NSString stringWithFormat:@"%d",self.diandiListModel.praiseCount];
        }else{
            [self.praiseBtn setImage:[UIImage imageNamed:@"but_like_pre"] forState:UIControlStateNormal];
            self.DZLabel.text= [NSString stringWithFormat:@"%d",self.diandiListModel.praiseCount ];
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
    }];
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
