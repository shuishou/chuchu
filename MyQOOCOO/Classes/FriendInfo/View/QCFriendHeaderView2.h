//
//  QCFriendHeaderView2.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/11/8.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface QCFriendHeaderView2 : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avatar;//头像
@property (strong, nonatomic) IBOutlet UILabel *talkLabal;//说说
@property (strong, nonatomic) IBOutlet UILabel *chuhaoLabel;//处好
@property (strong, nonatomic) IBOutlet UIImageView *qrBtn;//扫描
@property (strong, nonatomic) IBOutlet UIButton *diandiBtn;//点滴
@property (strong, nonatomic) IBOutlet UIButton *nuhongquanBtn;//发泄圈
@property (strong, nonatomic) IBOutlet UIButton *lunkuBtn;//论库
@property (strong, nonatomic) IBOutlet UIButton *friendBtn;//朋友


@property (nonatomic , strong)User  *user;

@end
