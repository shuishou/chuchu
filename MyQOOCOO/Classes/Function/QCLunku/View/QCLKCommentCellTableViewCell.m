//
//  QCLKCommentCellTableViewCell.m
//  MyQOOCOO
//
//  Created by 贤荣 on 15/12/26.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCLKCommentCellTableViewCell.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "OkamiPhotoView.h"
@interface QCLKCommentCellTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bg;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *auditImage;

@property (weak, nonatomic) IBOutlet UIImageView *picV;
@property (weak, nonatomic) IBOutlet UIView *picCountBg;
@property (weak, nonatomic) IBOutlet UILabel *picCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *typeBtn;//置顶、热门、普通

@property (nonatomic,strong) NSArray * arr;//配图

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
//点赞
@property (weak, nonatomic) IBOutlet UIButton *DZBtn;
- (IBAction)DZBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *DZLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picHConstraint;

@property (nonatomic,assign) int DZcount;

@property (nonatomic,assign) BOOL price;

//@property (nonatomic,weak) OkamiPhotoView * photoVew;
@property (weak, nonatomic) IBOutlet OkamiPhotoView *photoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoHeight;

@end

@implementation QCLKCommentCellTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *reuseId = @"QCLKCommentCellTableViewCell";
    QCLKCommentCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"QCLKCommentCellTableViewCell" owner:nil options:nil]lastObject];
    }
    return cell;
}

-(void)awakeFromNib{
    self.bg.layer.cornerRadius = 8;
    self.bg.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 22;
    self.icon.layer.masksToBounds = YES;
    self.icon.userInteractionEnabled=YES;
    UITapGestureRecognizer *avatartap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lunkuavatarpush)];
    [self.icon addGestureRecognizer:avatartap];
}


-(void)setLk:(QCLunkuListModel *)lk{
    _lk = lk;
    
    //    long long timestamp =[[NSDate date]timeIntervalSince1970]*1000;
    //    帖子类型
    if (lk.topType==0  ) {//置顶 lk.topExpire-timestamp>0
        
    }else if (lk.topType == 1){//热门lk.hotExpire-timestamp > 0
        [self.typeBtn setTitle:@"热门" forState:UIControlStateNormal];
        [self.typeBtn setBackgroundImage:[UIImage imageNamed:@"bg_hot"] forState:UIControlStateNormal];
    }else if (lk.topType == 2){//热门lk.hotExpire-timestamp > 0
        [self.typeBtn setTitle:@"" forState:UIControlStateNormal];
        [self.typeBtn setBackgroundImage:[UIImage imageNamed:@"组-6@3x"] forState:UIControlStateNormal];
    }else{//普通
        //        [self.typeBtn setTitle:@"普通" forState:UIControlStateNormal];
        //        [self.typeBtn setBackgroundImage:[UIImage imageNamed:@"bg_balck"] forState:UIControlStateNormal];
        self.typeBtn.hidden = YES;
    }
    
    if (lk.topType==0  ) {//置顶 lk.topExpire-timestamp>0
        
    }else if (lk.topType == 1){//热门lk.hotExpire-timestamp > 0
        [self.typeBtn setTitle:@"热门" forState:UIControlStateNormal];
        [self.typeBtn setBackgroundImage:[UIImage imageNamed:@"bg_hot"] forState:UIControlStateNormal];
    }else{//普通
        //        [self.typeBtn setTitle:@"普通" forState:UIControlStateNormal];
        //        [self.typeBtn setBackgroundImage:[UIImage imageNamed:@"bg_balck"] forState:UIControlStateNormal];
        self.typeBtn.hidden = YES;
    }
    if (lk.audit==0)
    {

        [self.auditImage setImage:[UIImage imageNamed:@"组-6"]];
    }else if (lk.audit == 2){//热门lk.hotExpire-timestamp > 0
 
        [self.auditImage setImage:[UIImage imageNamed:@"组-6-拷贝"]];
        
    }else
    {
        self.auditImage.hidden=YES;
    }
    
    
    //    姓名
    self.name.text = lk.user.nickname;
    
    //    头像
    [self.icon sd_setImageWithURL:[NSURL URLWithString:lk.user.avatar] placeholderImage:[UIImage imageNamed:@"ios-template-1024(1)"]];
    
    
    
    
    //发送时间
    
    
    self.time.text = lk.createTime;
    
    //标题
    self.title.text = lk.title;
    
    //正文
    self.content.text = lk.content;
    
    
    
    
    
    //配图
    //    if (lk.image.length>0) {
    //        NSArray * tempArr = [lk.image componentsSeparatedByString:@","];
    //        NSMutableArray * Arr =[tempArr mutableCopy];
    //        self.arr = Arr;
    //        if (Arr.count >1) {
    //            self.picCountLabel.text =[NSString stringWithFormat:@"共%zd张",Arr.count];
    //        }else{
    //            self.picCountBg.hidden = YES;
    //            self.picCountLabel.hidden = YES;
    //        }
    //
    //        [self.picV sd_setImageWithURL:[NSURL URLWithString:Arr.firstObject]];
    //        self.picV.contentMode = UIViewContentModeScaleAspectFill;
    //        self.picV.clipsToBounds = YES;
    //    }else{
    //        self.picHConstraint.constant = 0;
    //        self.picV.hidden = YES;
    //        self.picCountBg.hidden = YES;
    //        self.picCountLabel.hidden = YES;
    //    }
    if (lk.image.length>0) {
        NSArray * tempArr = [lk.image componentsSeparatedByString:@","];
        NSMutableArray * Arr =[tempArr mutableCopy];
        
        CGFloat photoX = 18;
        CGFloat photoY = self.content.frame.origin.y+self.content.frame.size.height+10;
        CGSize photosSize=[OkamiPhotoView photoViewSizeWithPictureCount:Arr.count];
        //        self.picV.frame=(CGRect){photoX,photoY,photosSize};
//        OkamiPhotoView * photoView = [[OkamiPhotoView alloc]initWithFrame:(CGRect){photoX,photoY,photosSize}];
        self.photoView.dynamicImgPaths=Arr;
       
      
        
       self.photoHeight.constant=photosSize.height;
//        [self.contentView addSubview:photoView];
//          self.photoView=photoView;
//        self.photoVew = photoView;
//        
//        NSLayoutConstraint * rotateTopConstraint = [NSLayoutConstraint constraintWithItem:self.photoVew attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
//        rotateTopConstraint.active=YES;
//        
//        
//        
//        [self.contentView addConstraint:rotateTopConstraint];
        
        
        if (Arr.count >1) {
            self.picCountLabel.text =[NSString stringWithFormat:@"共%zd张",Arr.count];
        }else{
            self.picCountBg.hidden = YES;
            self.picCountLabel.hidden = YES;
        }
        
    }else{
        self.picHConstraint.constant = 0;
        //        self.picV.hidden = YES;
        self.picCountBg.hidden = YES;
        self.picCountLabel.hidden = YES;
    }
    
    
    
    
    
    //    点赞
    self.DZLabel.text =[NSString stringWithFormat:@"%d",lk.praiseCount];
    if (lk.hasPraise) {
        [self.DZBtn setImage:[UIImage imageNamed:@"but_like_pre"] forState:UIControlStateNormal];
        self.price = YES;
    }
    self.DZcount = lk.praiseCount;
    
    //    评论
    self.commentLabel.text = [NSString stringWithFormat:@"%d",lk.commentCount];
}

#pragma mark - 集成图片浏览器
-(void)lunkuavatarpush
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"lunkuavatarpush" object:nil userInfo:@{@"model":self.lk}];

}

// 点赞
- (IBAction)DZBtnClick:(UIButton *)sender {
    
    self.price = !self.price;
    NSDictionary * parame = @{@"forumId":@(self.lk.id)};
    NSString*url;
    if (self.isFree) {
        url=FeeManPraise;
    }else{
        url=FORUM_PRAISE;
    }
    
    [NetworkManager requestWithURL:url parameter:parame success:^(id response) {
        
        CZLog(@"%@",response);
        self.lk.hasPraise=[response[@"hasPraise"] boolValue];
        self.lk.praiseCount=[response[@"praiseCount"] integerValue];
        if (!self.lk.hasPraise) {
            [sender setImage:[UIImage imageNamed:@"but_like"] forState:UIControlStateNormal];
            if (self.lk.praiseCount==0) {
                self.DZLabel.text= @"0";
            }else{
                self.DZLabel.text= [NSString stringWithFormat:@"%d",self.lk.praiseCount];
            }
        }else{
            [sender setImage:[UIImage imageNamed:@"but_like_pre"] forState:UIControlStateNormal];
            self.DZLabel.text= [NSString stringWithFormat:@"%d",self.lk.praiseCount];
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        
    }];
}


@end
