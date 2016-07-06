//
//  NSString+Validation.h
//  app
//
//  Created by Apple on 15/10/6.
//  Copyright © 2015年 linaicai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validation)
/**是否手机号*/
-(BOOL) isMobile;
/**是否邮箱*/
-(BOOL) isEmail;
/**是否密码*/
-(BOOL) isPassword;
/**判断是否为浮点*/
- (BOOL)isPureFloat;
/**判断是否为整形*/
- (BOOL)isPureInt;
/**是否是否昵称*/
-(BOOL) isNickName;
/**是否网址*/
-(BOOL) isWebURL;
/**是否中文字符*/
-(BOOL) isChineseCharacter;
@end
