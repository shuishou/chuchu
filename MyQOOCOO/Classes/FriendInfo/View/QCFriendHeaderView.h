//
//  QCFriendHeaderView.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/3.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"


@class QCFriendHeaderView;
@protocol QCFriendHeaderViewDelegate <NSObject>

@optional
-(void)avatarBtnClick:(UIButton *)btn;
-(void)scanBtnClick:(UIButton *)btn;
-(void)diandiBtnClick:(UIButton *)btn;
-(void)nuhongBtnClick:(UIButton *)btn;
-(void)lunkuBtnClick:(UIButton *)btn;
-(void)friendBtnClick:(UIButton *)btn;

@end

@interface QCFriendHeaderView : UIView

-(instancetype)initWithFrame:(CGRect)frame navigationController:(UINavigationController *)navigationController;
@property (nonatomic , strong)UINavigationController *navigationController;
@property (nonatomic,weak) id<QCFriendHeaderViewDelegate> delegate;

// ------用户
@property (strong, nonatomic)User * user;

@end
