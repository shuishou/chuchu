//
//  QCSearchMainCell.h
//  MyQOOCOO
//
//  Created by wzp on 15/10/9.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCSearchMainCellItem : UIView
@property(retain,nonatomic)NSDictionary * infoDic;
@end

@class QCSearchMainCell;
@protocol QCSearchMainCellDelegate <NSObject>

-(void)searchMainCell:(QCSearchMainCell *)cell selectedIndex:(NSInteger)index;

@end
@interface QCSearchMainCell : UITableViewCell

@property(retain,nonatomic)QCSearchMainCellItem * leftItem;
@property(retain,nonatomic)QCSearchMainCellItem * rightItem;
@property(assign,nonatomic)id<QCSearchMainCellDelegate> delegate;

@end
