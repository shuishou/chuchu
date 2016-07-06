//
//  myCell.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/24.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myInterestCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *interestingName;
@property (weak, nonatomic) IBOutlet UIView *interestingIcon;

+ (instancetype)myCellWithTableView:(UITableView *) tableView;

@end
