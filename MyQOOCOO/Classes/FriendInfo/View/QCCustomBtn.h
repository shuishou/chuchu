//
//  QCCustomBtn.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/11/4.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QCCustomBtn;

@interface QCCustomBtn : UIButton
+(QCCustomBtn *)setupFunctionBtn:(NSString *)normalImageName highLightedImageName:(NSString *)highLightedImageName title:(NSString *)title index:(NSInteger)index btnH:(CGFloat)btnH;
@end
