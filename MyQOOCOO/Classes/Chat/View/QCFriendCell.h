//
//  QCFriendCell.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/3.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "QCFriendModel.h"
@class QCFriendCell;
@protocol QCFriendCellDelegate <NSObject>

-(void)friendCell:(QCFriendCell *)cell clickAvatar:(User *)userModel;
-(void)friendCell:(QCFriendCell *)cell clickTagButton:(NSString *)tag;
-(void)friendCell:(QCFriendCell *)cell clickAttention:(NSInteger)index user:(User *)user;

@end

@interface QCFriendCell : UITableViewCell

@property(retain,nonatomic)UIButton *avatarbtn;
@property(retain,nonatomic)UILabel *nickName;
@property(retain,nonatomic)UIButton * attentionBtn;
@property (nonatomic,weak) id <QCFriendCellDelegate> delegate;
@property (nonatomic,retain)User * userModel;
@property (nonatomic,retain)QCFriendModel * friendModel;


@end
