//
//  QCViewController.h
//  MyQOOCOO
//
//  Created by Devin on 15/12/31.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"

#import "VideoCollectionViewCell.h"

#import "CaptureViewController.h"

#import "PlayViewController.h"

@interface DevinVideoViewController : QCBaseVC

@property (nonatomic,copy)void (^VideoSelectedBlock)(NSURL * url);
@end
