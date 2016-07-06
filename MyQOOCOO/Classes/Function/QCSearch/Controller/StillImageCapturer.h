//
//  DSFacialGestureCameraCapturer.h
//  Beautiful Travel
//
//  Created by Apple on 15/11/28.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CIImage;
@class UIView;
typedef void (^StillImageCapturerResponseBlock)(CIImage *ciImage,NSError * error);
@interface StillImageCapturer : NSObject
@property (nonatomic,copy) StillImageCapturerResponseBlock responceBlock;
@property (nonatomic, readonly) BOOL isUsingFrontCamera;
+ (instancetype) imageCaptureWithSampleRate:(CGFloat) sampleRate PreviewView:(UIView*) previewView responceBlock:(StillImageCapturerResponseBlock) block;
- (void)teardownAVCapture;
@end
