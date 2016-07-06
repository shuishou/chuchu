//
//  ShareHelper.m
//  Sport
//
//  Created by fenguo  on 15/2/6.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#import "ShareHelper.h"

@implementation ShareHelper

+(void)shareWithImagePath:(NSString *)imagePath ShareContent:(NSString*)content ShareTitle:(NSString*)shareTitle ShareUrl:(NSString*)url ShreType:(SSPublishContentMediaType)type
{
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:content
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:shareTitle
                                                  url:url
                                          description:content
                                            mediaType:type
                                     ];
    
    
    //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
    //定制QQ空间信息
    [publishContent addQQSpaceUnitWithTitle:shareTitle
                                        url:url
                                       site:shareTitle
                                    fromUrl:url
                                    comment:shareTitle
                                    summary:content
                                      image:[ShareSDK imageWithPath:imagePath]
                                       type:[NSNumber numberWithInteger:type]
                                    playUrl:nil
                                       nswb:nil];

    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:[NSNumber numberWithInteger:type]
                                         content:content
                                           title:shareTitle
                                             url:url
                                      thumbImage:[ShareSDK imageWithPath:imagePath]
                                           image:[ShareSDK imageWithPath:imagePath]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:type]
                                          content:content
                                            title:shareTitle
                                              url:url
                                       thumbImage:[ShareSDK imageWithPath:imagePath]
                                            image:[ShareSDK imageWithPath:imagePath]
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //定制微信收藏信息
    [publishContent addWeixinFavUnitWithType:[NSNumber numberWithInteger:type]
                                     content:content
                                       title:shareTitle
                                         url:url
                                  thumbImage:[ShareSDK imageWithPath:imagePath]
                                       image:[ShareSDK imageWithPath:imagePath]
                                musicFileUrl:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:nil];
    
    //定制QQ分享信息
    [publishContent addQQUnitWithType:[NSNumber numberWithInteger:type]
                              content:content
                                title:shareTitle
                                  url:url
                                image:nil];
    
    //定制短信信息
    [publishContent addSMSUnitWithContent:content];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:[ShareSDK customShareListWithType:
                                    SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                                    SHARE_TYPE_NUMBER(ShareTypeQQ),
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    SHARE_TYPE_NUMBER(ShareTypeSMS),
                                    nil]
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    
                                    CZLog(@"分享成功");
                                    
                                }
                                
                                else if (state == SSResponseStateFail)
                                {
                                    
                                    CZLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                    
                                }
                            }];
}

+(void)showSystemShareList{
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"app_icon.png" ofType:nil];
    
    NSString * shareContent = @"耍起:专门用于场馆预定的APP";
    NSString *shareTitle = @"来自耍起的下载邀请";
    NSString *shareUrl = @"http://www.baidu.com/";
    [ShareHelper shareWithImagePath:imagePath ShareContent:shareContent ShareTitle:shareTitle ShareUrl:shareUrl ShreType:SSPublishContentMediaTypeNews];
    
}

@end
