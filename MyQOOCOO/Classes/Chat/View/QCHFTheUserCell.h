//
//  QCHFTheUserCell.h
//  MyQOOCOO
//
//  Created by Wind on 15/12/3.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface QCHFTheUserCell : UITableViewCell
+(instancetype)QCHFTheUserCell:(UITableView *)tableView;
@property (strong, nonatomic) IBOutlet UIImageView *avatarUrlImage;
@property (strong, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (strong, nonatomic) IBOutlet UIView *markView1;
@property (strong, nonatomic) IBOutlet UIView *markView2;
@property (strong, nonatomic) IBOutlet UIView *markView3;
@property (strong, nonatomic) IBOutlet UIButton *isFriendBu;
@property (strong, nonatomic) IBOutlet UILabel *marksLabel1;
@property (strong, nonatomic) IBOutlet UILabel *marksLabel2;
@property (strong, nonatomic) IBOutlet UILabel *marksLabel3;
@property (strong, nonatomic) IBOutlet UIImageView *searchLine;
@property (strong, nonatomic) IBOutlet UIImageView *chatLine;

@property (strong, nonatomic) IBOutlet UIImageView *theSexIge;
@property (strong, nonatomic) IBOutlet UILabel *age;

@end
