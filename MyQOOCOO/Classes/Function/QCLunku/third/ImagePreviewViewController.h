//
//  ImagePreviewViewController.h
//  XSTeachBBS
//
//  Created by Jacky Chan on 9/16/14.
//  Copyright (c) 2014 XSTeach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCBaseVC.h"
@class ImagePreviewViewController;

@protocol ImagePreviewViewControllerDelegate <NSObject>

@optional
- (void)didHideImagePreviewViewController:(ImagePreviewViewController *)ipvc;

@end

@interface ImagePreviewViewController : QCBaseVC<UIScrollViewDelegate>
@property (strong, nonatomic) NSArray* images;
@property (strong, nonatomic) id<ImagePreviewViewControllerDelegate> delegate;

- (id)initWithImages:(NSArray *)images;
- (void)showImageAtIndex:(NSInteger)index inView:(UIView *)view fromView:(UIView *)fromView;
- (void)hide;
- (void)hideToFrame:(CGRect)frame;
@end
