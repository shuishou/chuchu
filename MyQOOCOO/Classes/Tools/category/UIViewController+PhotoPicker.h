//
//  UIViewController+PhotoPicker.h
//
//
//  Created by Liangq on 14-8-11.
//  Copyright (c) 2014年 fenguo. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AHKActionSheet.h"



@interface UIViewController (PhotoPicker)<UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>


- (void)showPhotoPickerWithClip:(BOOL)clip;

- (BOOL)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;

- (NSString *)getImagePathWithName:(NSString *)imageName;

- (NSString *)base64StringFromImage:(UIImage *)tempImage;

@end
