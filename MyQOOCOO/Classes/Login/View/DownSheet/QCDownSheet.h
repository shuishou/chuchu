//
//  QCDownSheet.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/10.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCDownSheet : UIView<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    UITableView *_tableView;
    NSArray *_listData;
    
}
//根据它的高度和cell数量来改变View的大小
-(id)initWithlist:(NSArray *)list height:(CGFloat )height;
//在哪里显示View
-(void)showInView:(UIViewController *) inViewVC;

@end
