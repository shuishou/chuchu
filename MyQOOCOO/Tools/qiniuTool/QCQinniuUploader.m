//
//  QCQinniuUploader.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/23.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCQinniuUploader.h"
#import "QiniuSDK.h"
#import "QCQiniuTocken.h"

@interface QCQinniuUploader (){
   
}
@property (nonatomic , strong)NSString *imageUrl;

@end
@implementation QCQinniuUploader

/**
 *  上传录音音频源文件
 *
 *  @param videoUrl 本地录音音频
 *  @param progress nil
 *  @param success  上传七牛成功后返回的音频URL
 *  @param failure  上传失败
 */
+ (void)uploadVocieFile:(NSURL*)voiceUrl progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure
{
    [self getQiniuUploadToken:^(NSString *token) {
        
        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:progress params:nil checkCrc:NO cancellationSignal:nil];
        QNUploadManager *uploadManager = [[QNUploadManager alloc]init];
        
        NSString * urlStr=[[voiceUrl absoluteString]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
       NSString * url =  [urlStr stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        CZLog(@"%@",url);
        
        [uploadManager putFile:url key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
            if (info.statusCode == 200 && resp) {
                NSString *urlBase = QINIU_BASE_URL;
                NSString *url = [NSString stringWithFormat:@"%@%@", urlBase, resp[@"key"]];
                if (success) {
                    success(url);
                }
            }
            else {
                if (failure) {
                    failure();
                }
            }
        } option:opt];
        
    } failure:^{
        if (failure) {
            failure();
        }
    }];
}



/**
 *  上传录音音频data
 *
 *  @param videoUrl 本地录音音频
 *  @param progress nil
 *  @param success  上传七牛成功后返回的音频URL
 *  @param failure  上传失败
 */
+ (void)uploadVocie:(NSURL*)voiceUrl progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure
{
    [self getQiniuUploadToken:^(NSString *token) {
        
        NSData*  data = [NSData dataWithContentsOfURL:voiceUrl];
        if (!data) {
            if (failure) {
                failure();
            }
            return;
        }

        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:progress params:nil checkCrc:NO cancellationSignal:nil];
        QNUploadManager *uploadManager = [[QNUploadManager alloc]init];

        [uploadManager putData:data key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (info.statusCode == 200 && resp) {
                NSString *urlBase = QINIU_BASE_URL;
                NSString *url = [NSString stringWithFormat:@"%@%@", urlBase, resp[@"key"]];
                if (success) {
                    success(url);
                }
            }
            else {
                if (failure) {
                    failure();
                }
            }
        } option:opt];
        
    } failure:^{
        if (failure) {
            failure();
        }
    }];
}



/**
 *  上传视频
 *
 *  @param videoUrl 本地视频的URL
 *  @param progress nil
 *  @param success  上传七牛成功后返回的视频URL
 *  @param failure  上传失败
 */
+ (void)uploadVideo:(NSURL*)videoUrl progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure
{
    [self getQiniuUploadToken:^(NSString *token) {
        
        NSData*  data = [NSData dataWithContentsOfURL:videoUrl];
        if (!data) {
            if (failure) {
                failure();
            }
            return;
        }
        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:progress params:nil checkCrc:NO cancellationSignal:nil];
        QNUploadManager *uploadManager = [[QNUploadManager alloc]init];
        
        [uploadManager putData:data key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (info.statusCode == 200 && resp) {
                NSString *urlBase = QINIU_BASE_URL;
                NSString *url = [NSString stringWithFormat:@"%@%@", urlBase, resp[@"key"]];
                if (success) {
                    success(url);
                }
            }
            else {
                if (failure) {
                    failure();
                }
            }
        } option:opt];
    } failure:^{
        if (failure) {
            failure();
        }
    }];
}


//  上传单张图片，上传音频有问题
+ (void)uploadImage:(id )image progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure
{
    [self getQiniuUploadToken:^(NSString *token) {
        NSMutableData *data = [[NSMutableData alloc]init];
        if ([image isKindOfClass:[UIImage class]]) {
            data = (NSMutableData *)UIImageJPEGRepresentation(image, 0.7);
        }
        if ([image isKindOfClass:[AVAudioRecorder class]]) {
            AVAudioRecorder * recorder = image;
            //data = image;
            data = [[NSData dataWithContentsOfURL:recorder.url] mutableCopy];
        }
        
//        NSData *data = UIImageJPEGRepresentation(image, 0.7);
        if (!data) {
            if (failure) {
                failure();
            }
            return;
        }
        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:progress params:nil checkCrc:NO cancellationSignal:nil];
        QNUploadManager *uploadManager = [[QNUploadManager alloc]init];
    
        [uploadManager putData:data key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (info.statusCode == 200 && resp) {
                NSString *urlBase = QINIU_BASE_URL;
                NSString *url = [NSString stringWithFormat:@"%@%@", urlBase, resp[@"key"]];
                if (success) {
                    success(url);
                }
            }
            else {
                if (failure) {
                    failure();
                }
            }
        } option:opt];
    } failure:^{
        if (failure) {
            failure();
        }
    }];
}

// 上传多张图片
+ (void)uploadImages:(NSArray *)imageArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *urlArray))success failure:(void (^)())failure
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    __block float totalProgress = 0.0f;
    __block float partProgress = 1.0f / [imageArray count];
    __block NSUInteger currentIndex = 0;
    
    QCQiNiuUploadHelper *uploadHelper = [QCQiNiuUploadHelper sharedInstance];
    __weak typeof(uploadHelper) weakHelper = uploadHelper;
    
    uploadHelper.singleFailureBlock = ^() {
        failure();
        return;
    };
    uploadHelper.singleSuccessBlock  = ^(NSString *url) {
        [array addObject:url];
        totalProgress += partProgress;
//        progress(totalProgress);
        currentIndex++;
        if ([array count] == [imageArray count]) {
            success([array copy]);
            CZLog(@"全部图片上传七牛成功");
            return;
        }
        else {
            [self uploadImage:imageArray[currentIndex] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
        }
    };
    [self uploadImage:imageArray[0] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
}


+ (void)getQiniuUploadToken:(void (^)(NSString *))success failure:(void (^)())failure
{
   
    NSDictionary * dic =@{
        @"scope":        @"qiniu-ts-demo:sample.aac",
        @"deadline":             @(1390528576),
        @"persistentOps":        @"avthumb/mp3",
        @"persistentNotifyUrl":  @"http://fake.com/qiniu/notify"
        };
    
    
    //每次都获取七牛的token
    [NetworkManager requestWithURL:QINIU_TOCKEN_URL parameter:dic success:^(id response) {
        
        NSString *qiniuToken = [NSString stringWithString:response];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:qiniuToken forKey:@"qiniuToken"];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"错误qiniuTocken");
    }];
    NSString *qiniuToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"qiniuToken"];
    if (success) {
        success(qiniuToken);
    }
}
@end
