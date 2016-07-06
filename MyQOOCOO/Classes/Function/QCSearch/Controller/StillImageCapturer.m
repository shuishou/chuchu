//
//  DSFacialGestureCameraCapturer.m
//  Beautiful Travel
//
//  Created by Apple on 15/11/28.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "StillImageCapturer.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface StillImageCapturer() <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic) dispatch_queue_t videoDataOutputQueue;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, readwrite) double lastSampleTimestamp;

@property (nonatomic, readwrite) float sampleRate;

@end

@implementation StillImageCapturer
+ (instancetype) imageCaptureWithSampleRate:(CGFloat)sampleRate PreviewView:(UIView *)previewView responceBlock:(StillImageCapturerResponseBlock)block
{
    StillImageCapturer * capture = [StillImageCapturer new];
    [capture setAVCaptureAtSampleRate:sampleRate withCameraPreviewView:previewView responceBlock:block];
    return capture;
}

-(void)setAVCaptureAtSampleRate:(float)sampleRate withCameraPreviewView:(UIView *)cameraPreviewView responceBlock:(StillImageCapturerResponseBlock)block
{
    self.sampleRate = sampleRate;
    self.responceBlock = block;
    self.session = nil;
    self.session = [AVCaptureSession new];
    self.session.sessionPreset = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone ? AVCaptureSessionPreset640x480 : AVCaptureSessionPresetPhoto;
    NSError * error;
    AVCaptureDeviceInput *deviceInput = [self getCaptureDeviceInput:&error];
    
    if (error) {
        [self teardownAVCapture];
        if (self.responceBlock) {
            _responceBlock(nil,error);
        }
        return;
    }
    
    if ( [self.session canAddInput:deviceInput] ){
        [self.session addInput:deviceInput];
    }
    
    self.videoDataOutput = [AVCaptureVideoDataOutput new];
    
    self.videoDataOutput.videoSettings = @{ (id)kCVPixelBufferPixelFormatTypeKey : @(kCMPixelFormat_32BGRA) };
    self.videoDataOutput.alwaysDiscardsLateVideoFrames = YES;

    self.videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [self.videoDataOutput setSampleBufferDelegate:self queue:self.videoDataOutputQueue];
    
    if ( [self.session canAddOutput:self.videoDataOutput] ){
        [self.session addOutput:self.videoDataOutput];
    }
    
    [[self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
    
    if (cameraPreviewView)
    {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        self.previewLayer.backgroundColor = [[UIColor blackColor] CGColor];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        CALayer *rootLayer = cameraPreviewView.layer;
        rootLayer.masksToBounds = YES;
        self.previewLayer.frame = cameraPreviewView.frame;
        [rootLayer addSublayer:self.previewLayer];
    }
    [self.session startRunning];
}

-(AVCaptureDeviceInput *)getCaptureDeviceInput:(NSError **)error;
{
    AVCaptureDevice *device;
    
    AVCaptureDevicePosition desiredPosition = AVCaptureDevicePositionBack;
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if (d.position == desiredPosition) {
            device = d;
            _isUsingFrontCamera = YES;
            break;
        }
    }
    if( nil == device )
    {
        _isUsingFrontCamera = NO;
        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    //获取输入设备
    return [AVCaptureDeviceInput deviceInputWithDevice:device error:error];
}

- (void)teardownAVCapture
{
    self.videoDataOutput = nil;
    if (self.videoDataOutputQueue) {
        self.videoDataOutputQueue = nil;
    }
    
    [self.session stopRunning];
    self.session = nil;
}


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    if (!self.lastSampleTimestamp){
        self.lastSampleTimestamp = CACurrentMediaTime();
    }
    else{
        double now = CACurrentMediaTime();
        double timePassedSinceLastSample = now - self.lastSampleTimestamp;
        
        if (timePassedSinceLastSample < self.sampleRate)
            return;
        self.lastSampleTimestamp = now;
    }
    
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer
                                                      options:(__bridge NSDictionary *)attachments];
    if (attachments) {
        CFRelease(attachments);
    }
    if (_responceBlock) {
        _responceBlock(ciImage,nil);
    }
}


@end
