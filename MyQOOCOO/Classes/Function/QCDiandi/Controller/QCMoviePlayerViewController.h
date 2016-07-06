//
//  QCMoviePlayerViewController.h
//  MyQOOCOO
//
//  Created by 贤荣 on 16/1/8.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QCMoviePlayerViewController;

@protocol QCMoviePlayerViewControllerDelegate <NSObject>

-(void)moviePlayerViewController:(QCMoviePlayerViewController *)movieVc didFinishedCaptureImage:(UIImage *)image;

@end

@interface QCMoviePlayerViewController : UIViewController
/**
 *  视频的路径
 */
@property (nonatomic,strong) NSURL * videoURL;

/**
 *  截图的时间
 */
@property (nonatomic,strong) NSArray * imagesAtTimes;

@property (nonatomic,weak) id<QCMoviePlayerViewControllerDelegate> delegate;


@end
