//
//  XSUtIls.h
//  XSTeachEDU
//
//  Created by xsteach on 14/12/5.
//  Copyright (c) 2014年 xsteach.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSUtils : NSObject
/**
 *  格式角色图标
 *
 *  @param role 角色字段
 *
 *  @return 角色图片
 */
+(UIImage *)setRoleImage:(NSString *)role;

/**
 *  格式化日期
 *
 *  @param data 日期字段
 *
 *  @return 格式化后的日期
 */
+(NSString *)formatData:(NSString *)data;

/**
 *  格式化时间长度
 */
+(NSString *)formatTimeLong:(NSString *)time_long;


/**
 *@brief 根据title［hi］获取表情文件名
 *
 *@param(IN): emotionTitle 表情title
 *
 
 *@return   : 表情文件名
 */
+(NSString *)getEmotionFileName:(NSString *)emotionTitle;


+(NSString *)getEmotionFilePath:(NSString *)emotionTitle;

/**
 *@brief
 *
 *@param(IN): content 包含表情的文本内容
 *@param(IN):
 *
 
 *@return   : 替换过的文本内容
 */
+(NSString *)replaceEmotionContent:(NSString *)content;

/**
 *@brief 根据表情名字，描述文件名 获取表情格式字符串
 *
 *@param(IN): name 名字 如[YY]
 *@param(IN): chtName 对应的 b_1
 *
 
 *@return   :
 */
+(NSString *)getEmotionStringWithName:(NSString *)name des:(NSString *)chtName;


/**
 *@brief 根据转化过的url，组装原始url
 *
 *@param(IN): newUrl
 *@param(IN):
 *
 
 *@return   : 返回原始url
 */
+(NSString *)getOrigImageUrl:(NSString *)newUrl;

/**
 *@brief 获取新的图片url，压缩图片
 *
 *@param(IN): origUrl 原始url
 *@param(IN):
 *
 
 *@return   :
 */
+(NSString *)getNewImageUrl:(NSString *)origUrl;
/**
 *  md5 加密
 *
 *  @param str 传入需要加密的字符串
 *
 *  @return 返回为已经加密的密文格式字符串
 */

+(NSString *)getMD5String:(NSString *)str;

/**
 *@brief 环信用户名 根据uid 获取
 *
 *@param(IN): userId 用户id
 *@param(IN):
 *
 
 *@return   : 环❤️用户名
 */
+(NSString *)getHXUserWithUID:(NSString *)userId;

/**
 *@brief 根据视频URL获取视频ID
 *
 *@param(IN):
 *@param(IN):
 *
 
 *@return   :
 */
+(NSString *)getVideoIDWithUrl:(NSString *)vedioUrl;
/**
 *  获取当前毫秒时间戳
 *
 *  @return 返回时间戳 (NSString *) 例:1274946874
 */
+(NSString *)getCurrentTime;


/**
 *@brief 构造User-Agent 头
 *
 *@param(IN):
 *
 
 *@return   :
 */
+(NSString *)getHttpUserAgent;
/**
 *  判断相机权限
 *
 *  @return YES 是有权限  NO是没有权限
 */
+(BOOL)cameraLimit;
/**
 *  判断麦克风权限
 *
 *  @return yes有权限 no没权限
 */
+(BOOL)microphoneLimit;

+(BOOL)isCookeValue;
@end
