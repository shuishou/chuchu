//
//  QCDoodleCell.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/20.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCDoodleStatusFrame.h"
#import "QCStatusToolBar.h"
#import "QCStatusPhotosView.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Format.h"

@interface QCDoodleCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic , strong)QCDoodleStatusFrame *qcStatusFrame;

/** 整体内容 */
@property (nonatomic, weak) UIView *originalView;
/** 头像 */
@property (nonatomic, weak) UIImageView *iconV;
/** 昵称 */
@property (nonatomic, weak) UILabel *nickNameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *sendTimeLabel;
/** 正文 */
@property (nonatomic, weak) UILabel *contentLabel;
/** 配图 */
@property (nonatomic, weak) QCStatusPhotosView *photosView;
//单张配图
@property (nonatomic,strong) UIImageView *singelImageView;
/** 工具条 */
@property (nonatomic, weak) QCStatusToolBar *toolbar;

@end
