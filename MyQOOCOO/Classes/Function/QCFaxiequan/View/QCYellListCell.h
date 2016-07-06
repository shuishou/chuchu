//
//  QCYellListCell.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/11/2.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCYellModel.h"

@protocol QCYellListCellDelegate <NSObject>
@optional
-(void)commentBtnClick;
@end

@interface QCYellListCell : UITableViewCell

@property (nonatomic,strong)QCYellModel *yellModel;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;//头像
+(instancetype)collectTableViewCellWithTableView:(UITableView *)tableView;

@property (nonatomic,weak) id <QCYellListCellDelegate> delegate;

@end
