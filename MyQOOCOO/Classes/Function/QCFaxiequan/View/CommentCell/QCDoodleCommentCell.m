//
//  QCDoodleCommentCell.m
//  MyQOOCOO
//
//  Created by 贤荣 on 15/12/12.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCDoodleCommentCell.h"

@interface QCDoodleCommentCell ()


@property (weak, nonatomic) IBOutlet UILabel *hf;//回复
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;



@end

@implementation QCDoodleCommentCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *reuseId = @"QCDoodleCommentCell";
    QCDoodleCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"QCDoodleCommentCell" owner:nil options:nil]lastObject];
    }
    return cell;
}

-(void)awakeFromNib{
    self.icon.layer.cornerRadius = 22;
    self.icon.layer.masksToBounds = YES;
    
}

-(void)setReply:(Reply *)reply{
    _reply = reply;

    NSURL * url = [NSURL URLWithString:reply.user.avatar];
    [self.icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ios-template-1024(1)"]];
    
    if (reply.replyUser) {//子评论
        self.name.text = reply.user.nickname;//回复人
        self.rUser.text = reply.replyUser.nickname;//被回复人
    }else{//一级评论
        self.hf.hidden = YES;
        self.rUser.hidden = YES;
        self.name.text = reply.user.nickname;
    }
    
    NSString *timeString = reply.createTime;
    self.time.text = timeString;
    self.content.text = reply.content;
}





@end
