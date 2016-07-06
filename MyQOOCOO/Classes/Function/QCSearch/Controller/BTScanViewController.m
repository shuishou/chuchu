//
//  BTScanViewController.m
//  Beautiful Travel
//
//  Created by Apple on 15/11/28.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BTScanViewController.h"
#import "StillImageCapturer.h"
@interface BTScanViewController()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic) CIDetector * QRCodeDector;
@property (nonatomic, strong) StillImageCapturer *cameraCapturer;
@property (nonatomic,retain) UIImageView * imageView;
@end
@implementation BTScanViewController
- (void) viewDidLoad
{
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.imageView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(seePhoto)];
}

- (void) seePhoto
{
    UIImagePickerController * c = [UIImagePickerController new];
    c.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    c.delegate = self;
    [self presentViewController:c animated:YES completion:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self beginToScan];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.cameraCapturer teardownAVCapture];
    self.cameraCapturer = nil;
}
- (void) beginToScan
{
    self.QRCodeDector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                           context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyLow,CIDetectorTracking:@(YES)}];
    self.cameraCapturer = [StillImageCapturer imageCaptureWithSampleRate:0.3 PreviewView:self.imageView responceBlock:^(CIImage *ciImage, NSError *error) {
        if (!error) {
            //如果获取到二维码信心，停止摄像头，捕捉，并且读取二维码信息
            NSArray * features = [self.QRCodeDector featuresInImage:ciImage];
            for (CIQRCodeFeature * feature in features) {
                if(feature != nil && feature.messageString != nil) {
                    [self.cameraCapturer teardownAVCapture];
                    if (_handler) {
                        _handler(feature.messageString);
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([feature.messageString isWebURL] ) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:feature.messageString]];
                        }
                    });
                }
            }
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
   
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    [self.cameraCapturer teardownAVCapture];
    self.imageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
