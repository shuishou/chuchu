//
//  QCFunctionBtn.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/29.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCFunctionBtn : UIButton

+(QCFunctionBtn *)setupFunctionBtn:(NSString *)normalImageName highLightedImageName:(NSString *)highLightedImageName title:(NSString *)title index:(NSInteger)index;
@end
