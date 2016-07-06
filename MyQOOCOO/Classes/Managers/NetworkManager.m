
//  NetworkManager.m
//  FishingJoy
//
//  Created by expro on 14-1-9.
//  Copyright (c) 2014年 expro. All rights reserved.
//

#import "NetworkManager.h"
#import "GlobalConstant.h"
#import "ApplicationContext.h"
#import "OMGToast.h"

static NSString *const EPHttpApiBaseURL = @"http://192.168.1.134:9063/";//正式
//static NSString *const EPHttpApiBaseURL = @"http://203.195.168.151:9063/";//测试


@implementation NetworkManager

+ (instancetype)instanceManager
{
    
    static NetworkManager *_instanceManager = nil;
    static dispatch_once_t onceToken;
    
    
    dispatch_once(&onceToken, ^{
        _instanceManager = [[NetworkManager alloc] init];
        _instanceManager.httpClient = [BaseHttpClient sharedClient];
        _instanceManager.reachability = [Reachability reachabilityWithHostName:EPHttpApiBaseURL];
//        _instanceManager.reachability = [[AFNetworkReachabilityManager sharedManager]];
    });
    return _instanceManager;
}

/**
 *  请求网络接口,返回请求的响应接口,并作初期数据处理
 *
 *  @param webApi        网络请求的接口
 *  @param para          请求所带的参数
 *  @param successBlock  成功请求后得到的响应,此响应包括服务器业务逻辑异常结果,但只接收服务器业务逻辑状态码为200的结果
 *  @param errorBlock    服务器响应不正常,网络连接失败返回的响应结果
 */
+ (void)requestWithURL:(NSString*)URLString parameter:(NSDictionary *)parameter success:(HttpResponseSuccessBlock)successBlock error:(HttpResponseErrorBlock)errorBlock
{
    BaseHttpClient *httpClient = [[self instanceManager] httpClient];
    CZLog(@"正在请求URL:%@%@, 请求参数:\n%@", QCHttpApiBaseURL, URLString, parameter);
    
    [httpClient.requestSerializer setValue:[[ApplicationContext sharedInstance] getLoginSessionId] forHTTPHeaderField:@"user_session"];
    
    [httpClient POST:URLString parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        CZLog(@"URL:%@, 返回值:\n%@",operation.request.URL, responseObject);
        
        NSError *parserError = nil;
        NSDictionary *resultDictionry = nil;
        @try {
            resultDictionry = (NSDictionary *)responseObject;
        }
        @catch (NSException *exception) {
            [NSException raise:@"网络接口返回数据异常" format:@"Error domain %@\n,code=%ld\n,userinfo=%@",parserError.domain,(long)parserError.code,parserError.userInfo];
            //发出消息错误的通知
        }
        @finally {
            //业务产生的状态码
            NSNumber *logicCode = resultDictionry[@"status"];
            
            //成功获得数据
            if (logicCode.intValue == StateOk) {
                successBlock([resultDictionry objectForKey:@"data"]);
            } else {
                //业务逻辑错误
                NSString *message = [resultDictionry objectForKey:@"message"];
                NSError *error = [NSError errorWithDomain:@"服务器业务逻辑错误" code:logicCode.intValue userInfo:nil];
                
                //未登录或者登录过期
                if (logicCode.intValue == StateUserErrorUnLogin || logicCode.intValue == StateSessionInValid) {
                    //移除sessionId
                    [[ApplicationContext sharedInstance] removeLoginSession];
                    
                }
                
                NSString *str = [self getErrorMessage:logicCode];
                if (str.length > 0) {
                    [OMGToast showWithText:str bottomOffset:100 duration:4];
                }
                
                if (logicCode.intValue != StateDateError) {
                    
                    
                    errorBlock(nil,error,message);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        if (![self isExistNetwork]) {
            [OMGToast showText:@"网络异常喔"];
            errorBlock(task,error,@"网络有问题，请稍后再试");
        } else{
            CZLog(@"数据加载出错");
            [OMGToast showText:@"请求超时"];
            CZLog(@"%@",error)
            errorBlock(task,error,@"数据请求失败");
        }
    }];
    
//    [httpClient POST:URLString parameters:parameter success:^(NSURLSessionTask *operation, id responseObject) {
//        
//        CZLog(@"URL:%@, 返回值:\n%@",operation.request.URL, responseObject);
//        
//        NSError *parserError = nil;
//        NSDictionary *resultDictionry = nil;
//        @try {
//            resultDictionry = (NSDictionary *)responseObject;
//        }
//        @catch (NSException *exception) {
//            [NSException raise:@"网络接口返回数据异常" format:@"Error domain %@\n,code=%ld\n,userinfo=%@",parserError.domain,(long)parserError.code,parserError.userInfo];
//            //发出消息错误的通知
//        }
//        @finally {
//            //业务产生的状态码
//            NSNumber *logicCode = resultDictionry[@"status"];
//            
//            //成功获得数据
//            if (logicCode.intValue == StateOk) {
//                successBlock([resultDictionry objectForKey:@"data"]);
//            } else {
//                //业务逻辑错误
//                NSString *message = [resultDictionry objectForKey:@"message"];
//                NSError *error = [NSError errorWithDomain:@"服务器业务逻辑错误" code:logicCode.intValue userInfo:nil];
//                
//                //未登录或者登录过期
//                if (logicCode.intValue == StateUserErrorUnLogin || logicCode.intValue == StateSessionInValid) {
//                    //移除sessionId
//                    [[ApplicationContext sharedInstance] removeLoginSession];
//                    
//                }
//                
//                NSString *str = [self getErrorMessage:logicCode];
//                if (str.length > 0) {
//                    [OMGToast showWithText:str bottomOffset:100 duration:4];
//                }
//                
//                if (logicCode.intValue != StateDateError) {
//                    
//                
//                errorBlock(nil,error,message);
//                }
//            }
//        }
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        //请求失败
//        if (![self isExistNetwork]) {
//            [OMGToast showText:@"网络异常喔"];
//            errorBlock(operation,error,@"网络有问题，请稍后再试");
//        } else{
//            CZLog(@"数据加载出错");
//            [OMGToast showText:@"请求超时"];
//            
//            errorBlock(operation,error,@"数据请求失败");
//        }
//    }];
}

+ (BOOL)isExistNetwork
{
    BOOL isExistenceNetwork;
    //    Reachability *reachAblitity = [Reachability reachabilityForInternetConnection];
    Reachability *reachAblitity = [Reachability reachabilityWithHostName:@"http://www.apple.com"];
    switch ([reachAblitity currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork=FALSE;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork=TRUE;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork=TRUE;
            break;
    }
    
    return isExistenceNetwork;
}


- (id) init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork;
//    Reachability *reachAblitity = [Reachability reachabilityForInternetConnection];
    Reachability *reachAblitity = [Reachability reachabilityWithHostName:@"http://www.apple.com"];
    switch ([reachAblitity currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork=FALSE;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork=TRUE;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork=TRUE;
            break;
    }
    
    return isExistenceNetwork;
}

- (BOOL) IsEnableWIFI {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
//    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

- (BOOL) IsEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

/**
 *  请求网络接口,返回请求的响应接口,并作初期数据处理
 *
 *  @param webApi        网络请求的接口
 *  @param para          请求所带的参数
 *  @param completeBlock 成功请求后得到的响应,此响应包括服务器业务逻辑异常结果,只接收服务器业务逻辑状态码为200的结果
 *  @param errorBlock    服务器响应不正常,网络连接失败返回的响应结果
 */
//- (void)requestServerWithURL:(NSString*)URLString parameter:(NSDictionary *)parameter finish:(HttpResponseSucBlock)completeBlock error:(HttpResponseErrorBlock)errorBlock
//{
//    CZLog(@"URL:%@, 请求参数:\n%@", URLString, parameter);
//    //[self.httpClient.requestSerializer setValue:[MyTools getTheSeesionId] forHTTPHeaderField:@"user_session"];
//    [self.httpClient POST:URLString parameters:parameter success:^(NSURLSessionTask *operation, id responseObject) {
//        
//        CZLog(@"URL:%@\n, 返回值:%@",operation.request.URL, responseObject);
//        
//        NSError *parserError = nil;
//        NSDictionary *resultDictionry = nil;
//        @try {
//            resultDictionry = (NSDictionary *)responseObject;
//        }
//        @catch (NSException *exception) {
//            [NSException raise:@"网络接口返回数据异常" format:@"Error domain %@\n,code=%ld\n,userinfo=%@",parserError.domain,(long)parserError.code,parserError.userInfo];
//            //发出消息错误的通知
//        }
//        @finally {
//            //业务产生的状态码
//            NSNumber *logicCode = resultDictionry[@"status"];
//            
//            //成功获得数据
//            if (logicCode.intValue == StateOk) {
//                completeBlock(resultDictionry);
//            }
//            else{
//                //业务逻辑错误
//                NSString *message = [resultDictionry objectForKey:@"message"];
//                NSError *error = [NSError errorWithDomain:@"服务器业务逻辑错误" code:logicCode.intValue userInfo:nil];
//                
//                //未登录或者登录过期
//                if (logicCode.intValue == StateUserErrorUnLogin || logicCode.intValue == StateSessionInValid) {
//                    //移除sessionId
//                    
//                }
//               
//                errorBlock(nil,error,message);
//            }
//        }
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        //请求失败
//        if (![self isExistenceNetwork]) {
//            
//            errorBlock(operation,error,@"网络有问题，请稍后再试");
//        }
//        else{
//            errorBlock(operation,error,@"数据请求失败");
//        }
//        
//        
//    }];
//}

//获取所有的需要的参数
//- (void)getAllParamList
//{
//    [self requestServerWithURL:@"area!getFishConfig.action" parameter:nil finish:^(NSDictionary *resultDictionary) {
//        self.paramdic = resultDictionary;
//    } error:^(NSURLSessionTask *operation, NSError *error,NSString *description) {
//        if (error.code == 404) {
//            UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"网络不可用" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
//            [alert show];
//        }
//    }];
//}


/**
 *  5000100	找不到用户
 5000101	手机号已经被使用
 5000102	用户名密码错误
 5000103	会话信息失效
 5000104	用户未登录
 5000105	手机校验码无效
 50001056	用户已经被锁定
 *
 */
+ (NSString*)getErrorMessage:(NSNumber*)logicCode {
    NSString *message = nil;
    switch (logicCode.intValue) {
        case StateSessionInValid:
            message = @"用户登录已过期,会话信息失效";
            break;
        case StateUserErrorUnLogin://5000104
            message = @"用户未登录";
            break;
        case StateLoginErrorPWDWrong:
            message = @"用户名或密码错误";
            break;
        case 5000100:
            message = @"用户不存在";
            break;
        case 5000101:
            message = @"手机号已经被使用";
            break;
        case 5000105:
            message = @"手机检验码无效";
            break;
//        case 50001056:
//            message = @"用户已经被锁定";
//            break;
        case 5000106:
            message = @"该用户已被锁定";
            break;
        case 5000301:
            message = @"帖子不存在";
            break;
        case 5000302:
            message = @"评论不存在";
            break;
        case 5000020:
            CZLog(@"参数异常");
            message = @"十分抱歉,操作失败";
            break;
        case 5000001:
            CZLog(@"通用失败");
        case 5000000:
            message = @"十分抱歉，操作失败";
            break;
        case 5000704:
            message = @"点滴发表已超过三天，不能删除";
            break;
        case 5000802:
            message = @"这不是你的标签";
            break;
        case 5000801:
            message = @"存在相同标签";
            break;
            //新增
        case 5000805:
            message = @"您已经把他拉入黑名单，请先回复";
            break;
        case 5000806:
            message = @"对方已经把您拉黑";
            break;
        default:
            message = @"";
            break;
    }
    return message;
}

@end

@implementation BaseHttpClient

+ (instancetype)sharedClient
{
    static BaseHttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[BaseHttpClient alloc] initWithBaseURL:[NSURL URLWithString:QCHttpApiBaseURL]];
        [_sharedClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];
        [_sharedClient.requestSerializer setValue:@"ios" forHTTPHeaderField:@"client"];
        //[_sharedClient.requestSerializer setValue:APP_KEY forHTTPHeaderField:@"sign_appkey"];
    });
    
    return _sharedClient;
}

@end

