//
//  QCQinniuUploader.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/23.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCQiNiuUploadHelper.h"
#import <AVFoundation/AVFoundation.h>

@interface QCQinniuUploader : NSObject

// 上传音频源文件
+ (void)uploadVocieFile:(NSURL*)videoUrl progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure;


// 上传音频DATA
+ (void)uploadVideo:(NSURL*)videoUrl progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure;

// 上传音频
+ (void)uploadVocie:(NSURL*)voiceUrl progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure;

/**
 *  上传图片
 *
 *  @param image    需要上传的image
 *  @param progress 上传进度block
 *  @param success  成功block 返回url地址
 *  @param failure  失败block
 */
+ (void)uploadImage:(id )image progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure;

// 上传多张图片,按队列依次上传
+ (void)uploadImages:(NSArray *)imageArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *urlArray))success failure:(void (^)())failure;

// 获取七牛上传token
+ (void)getQiniuUploadToken:(void (^)(NSString *token))success failure:(void (^)())failure;


@end
