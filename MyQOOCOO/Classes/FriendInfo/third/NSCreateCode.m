//
//  NSCreateCode.m
//  Hucii_POS
//
//  Created by MinSen on 16/2/1.
//  Copyright © 2016年 Hucii. All rights reserved.
//

#import "NSCreateCode.h"

@implementation NSCreateCode

+ (UIImage *)createCode:(NSString *)codeStr size:(CGFloat)size
{
    NSCreateCode *codeTemp = [[NSCreateCode alloc] init] ;
    CIImage *image  = [codeTemp createQRForString:codeStr];
    UIImage *result = [codeTemp createNonInterpolatedUIImageFormCIImage:image withSize:size];
    return result;
}

- (CIImage *)createQRForString:(NSString *)qrString {
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 返回CIImage
    return qrFilter.outputImage;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    UIImage *result = [UIImage imageWithCGImage:scaledImage];
    
    CGColorSpaceRelease(cs);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGImageRelease(scaledImage);
    return result;
}
@end
