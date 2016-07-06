//
//  QCHFDDMSRTVCell.h
//  MyQOOCOO
//
//  Created by Wind on 15/12/14.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCHFDDMSRTVCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@property (strong, nonatomic) IBOutlet UIImageView *avatarUrlsImaged;
@property (strong, nonatomic) IBOutlet UILabel *niceNameLabel;
@property (strong, nonatomic) IBOutlet UIView *marksV1;
@property (strong, nonatomic) IBOutlet UILabel *marksLa;
@property (strong, nonatomic) IBOutlet UIView *marksV2;
@property (strong, nonatomic) IBOutlet UILabel *marksLa2;
@property (strong, nonatomic) IBOutlet UIView *marksV3;
@property (strong, nonatomic) IBOutlet UILabel *marksLa3;

+(instancetype)QCHFDDMSRTVCell:(UITableView *)tableView;
@end
