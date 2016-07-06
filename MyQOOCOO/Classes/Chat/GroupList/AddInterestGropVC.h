//
//  AddInterestGropVC.h
//  MyQOOCOO
//
//  Created by Wind on 15/12/14.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddInterestGropVC : UIViewController
/**讨论组/趣友组组名(编辑状态下传值)*/
@property (strong, nonatomic) NSString * groupName;
/**趣友组组名ID(编辑状态下传值)*/
@property (strong, nonatomic) NSString * HFClassId;
/**是否是编辑状态*/
@property (strong, nonatomic) NSNumber * isEdit;
/**编辑状态传过来的数据(编辑状态下传值)*/
@property (strong, nonatomic) NSMutableArray * dataArray;
@end
