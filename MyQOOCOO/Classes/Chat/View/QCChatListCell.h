//
//  QCSingleChatCell.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/4.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCChatListCell : UITableViewCell
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImageView *placeholderImage;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detailMsg;
@property (nonatomic, strong) NSString *time;
@property (strong, nonatomic) UIImageView * deleteImage;
@property (strong, nonatomic) UIImageView * whiteImage;
@property (strong, nonatomic) UIImageView * Cline;
@property (nonatomic) NSInteger unreadCount;
+(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
