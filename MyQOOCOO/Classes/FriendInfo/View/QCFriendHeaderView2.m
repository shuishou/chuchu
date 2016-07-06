//
//  QCFriendHeaderView2.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/11/8.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCFriendHeaderView2.h"

@implementation QCFriendHeaderView2

- (void)awakeFromNib {
    // Initialization code
    self.avatar.userInteractionEnabled = YES;
    self.qrBtn.userInteractionEnabled = YES;
    self.diandiBtn.userInteractionEnabled = YES;
    self.nuhongquanBtn.userInteractionEnabled = YES;
    self.lunkuBtn.userInteractionEnabled = YES;
    self.friendBtn.userInteractionEnabled = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setUser:(User *)user{
    if (user.uid == 0) {
        self.talkLabal.text = nil;
        self.chuhaoLabel.text = nil;
    }else{
        // ------头像
        //        设置用户图片
        NSString *thumbnailUrl = user.avatarUrl;
        self.avatar.layer.cornerRadius = 40;
        self.avatar.layer.masksToBounds = YES;
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        
        BOOL isCache = [manager diskImageExistsForURL:[NSURL URLWithString: thumbnailUrl]];
        if(!isCache){
            [self.avatar sd_setImageWithURL:[NSURL URLWithString: thumbnailUrl] placeholderImage:[UIImage imageNamed:@"default-avatar_1"]];
        }else {
            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbnailUrl];
            self.avatar.image = image;
        }

        // ------说说
        self.talkLabal.text = user.nickname;
        // ------处好
        self.chuhaoLabel.text = @"chuhao888";
    }
}


@end
