//
//  XSUtIls.m
//  XSTeachEDU
//
//  Created by xsteach on 14/12/5.
//  Copyright (c) 2014年 xsteach.com. All rights reserved.
//

#import "XSUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>

@implementation XSUtils

+(UIImage *)setRoleImage:(NSString *)role
{
    UIImage *image;
    if ([role isEqualToString:@"Try"]) {
        image = [UIImage imageNamed:@"icon_student_try"];
    }
    else if ([role isEqualToString:@"A"]) {
        image = [UIImage imageNamed:@"icon_admin"];
    }
    else if ([role isEqualToString:@"C"]) {
        image = [UIImage imageNamed:@"icon_class_adviser"];
    }
    else if ([role isEqualToString:@"D"]) {
        image = [UIImage imageNamed:@"icon_dean"];
    }
    else if ([role isEqualToString:@"G"]) {
        image = [UIImage imageNamed:@"icon_group_leader"];
    }
    else if ([role isEqualToString:@"S"]) {
        image = [UIImage imageNamed:@"icon_student"];
    }
    else if ([role isEqualToString:@"T"]) {
        image = [UIImage imageNamed:@"icon_teacher"];
    }
    else if ([role isEqualToString:@"M"]) {
        image = [UIImage imageNamed:@"icon_master"];
    }
    else if ([role isEqualToString:@"V"]) {
        image = [UIImage imageNamed:@"md-svip"];
    }else{
        image = [UIImage imageNamed:@"icon_student_try"];
    }
    return image;
 
}

+(NSString *)formatData:(NSString *)data
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[data intValue]];
    // 1.获得年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:confromTimesp];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day]) { // 今天
        formatter.dateFormat = @"HH:mm";
    } else if ([cmp1 year] == [cmp2 year]) { // 今年
        formatter.dateFormat = @"MM-dd";
    } else {
        formatter.dateFormat = @"yyyy-MM-dd";
    }
    
    NSString *time = [formatter stringFromDate:confromTimesp];
    
    return time;
}

+(NSString *)formatTimeLong:(NSString *)time_long
{
    NSString *time = nil;

    // mod by lbl [time_long为空时崩溃] ----2014-12-23 start
    if ( [time_long length] == 0 || [time_long isEqualToString:@"0"])
    {
        return time = @"";
    }
    // mod by lbl [time_long为空时崩溃] ----2014-12-23 end
    
    NSArray *str = [time_long componentsSeparatedByString:@":"];
    
    NSString *hour = [str objectAtIndex:0];
    NSString *minute = [str objectAtIndex:1];
    NSString *second = [str objectAtIndex:2];
    if ([hour integerValue ] == 0) {
        time = [NSString stringWithFormat:@"%@:%@",minute,second];
    }
    else time = [NSString stringWithFormat:@"%@",str];
    
    return time;
}


+(NSString *)getOrigImageUrl:(NSString *)newUrl
{
    if ([newUrl length] == 0)
        return @"";
    
    NSMutableString *origUrl = [[NSMutableString alloc] init];
    NSRange range = [newUrl rangeOfString:@"@"];
    if (range.location != NSNotFound)
    {
        [origUrl appendString:[newUrl substringToIndex:range.location]];
    }
    else
    {
        [origUrl appendString:newUrl];
    }
    
    [origUrl stringByReplacingOccurrencesOfString:@"http://i" withString:@"http://f"];
    
    return origUrl;
}

+(NSString *)getNewImageUrl:(NSString *)origUrl
{
    
    if ([origUrl hasSuffix:@".gif"]) {
        return origUrl;
    }
    
    NSRange range = [origUrl rangeOfString:@"@"];
    if (range.location != NSNotFound )
    {
        return origUrl;
    }
    if([origUrl hasPrefix:@"http://www"]){
        origUrl = [origUrl stringByReplacingOccurrencesOfString:@"http://www.xsteach.com" withString:@"http://i.xsteach.cn"];
        origUrl = [NSString stringWithFormat:@"%@@600h_480w_80Q",origUrl];
        return origUrl;
    }
    
    if ([origUrl hasSuffix:@".jpg"]||[origUrl hasSuffix:@".png"]) {
        NSString *newUrl = [origUrl stringByReplacingOccurrencesOfString:@"http://f" withString:@"http://i"];
        newUrl = [NSString stringWithFormat:@"%@@600h_480w_80Q",newUrl];
        
        return newUrl;
    }else{
        return origUrl;
    }
    /*
#ifdef XS_DEV_ENV
    
    return origUrl;
#else
    
    
#endif*/
}

+(NSString *)getMD5String:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, strlen(cStr), result );
    
    NSString *retStr = [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
    return [retStr lowercaseString];
}

+(NSString *)getHXUserWithUID:(NSString *)userId
{
    NSString *userName = [NSString stringWithFormat:@"%@%@",kHXUserName,userId];
    userName = [XSUtils getMD5String:userName];
    
    return userName;
}

+(NSString *)getVideoIDWithUrl:(NSString *)vedioUrl
{
    NSString *video_url = vedioUrl;
    video_url = [video_url stringByReplacingOccurrencesOfString:@"http://player.polyv.net/videos/" withString:@""];
    video_url = [video_url stringByReplacingOccurrencesOfString:@".swf" withString:@""];
    NSString *vid = video_url;
    
    return vid;
}


+(NSString *)getCurrentTime{
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0llu", recordTime];
    return timeString;
}

+(NSString *)getHttpUserAgent
{
    // xsteach/1.0 (iphone 8.1.3)
    NSString *appVertion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *devType = [[UIDevice currentDevice] model];
    NSString *sysVertion = [[UIDevice currentDevice] systemVersion];
    
    NSString *str = [NSString stringWithFormat:@"xsteach/%@ (%@ %@)", appVertion, devType, sysVertion];
    
    return str;
}
+(BOOL)cameraLimit{
    NSString * mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        NSLog(@"相机权限受限");
        
        return NO;
        
    }else{
        return YES;
    }
}
+(BOOL)microphoneLimit{
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    __block BOOL blockGranted;
    [avSession requestRecordPermission:^(BOOL granted) {
        blockGranted = granted;
    }];
    if (!blockGranted)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

+(BOOL)isCookeValue
{
    NSUserDefaults * defaultsData = [NSUserDefaults standardUserDefaults];
    NSString * cookieValue = [defaultsData objectForKey:@"cookieValue"];
    if (cookieValue == nil || [cookieValue isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}

@end
