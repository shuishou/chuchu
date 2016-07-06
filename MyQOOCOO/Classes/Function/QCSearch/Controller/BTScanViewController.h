//
//  BTScanViewController.h
//  Beautiful Travel
//
//  Created by Apple on 15/11/28.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BTVoidIdBlock)(id obj);
@interface BTScanViewController : UIViewController
@property (nonatomic,copy) BTVoidIdBlock handler;
- (void) setHandler:(BTVoidIdBlock)handler;
@end
