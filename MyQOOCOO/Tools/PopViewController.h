//
//  PopViewController.h
//  PopView
//
//  Created by wzp on 15/10/14.
//  Copyright © 2015年 wzp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PopViewController : UIButton<UITableViewDelegate,UITableViewDataSource>

-(instancetype)initWithItems:(NSArray *)items;

@property(assign,nonatomic)BOOL show;

-(void)showInView:(UIView *)view selectedIndex:(void(^)(NSInteger selectedIndex))selectedBlock;

-(void)dismiss;

@end
