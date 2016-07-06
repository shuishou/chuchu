//
//  NSCreateCode.h
//  Hucii_POS
//
//  Created by MinSen on 16/2/1.
//  Copyright © 2016年 Hucii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSCreateCode : NSObject

// 生成二维码
+ (UIImage *)createCode:(NSString *)codeStr size:(CGFloat)size;

@end
