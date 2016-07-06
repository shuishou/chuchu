//
//  QCSendLunkuVC.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/10/19.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"

#define kReloadLKdataNotification @"ReloadLKdataNotification"

@interface QCSendLunkuVC : QCBaseVC<UITextFieldDelegate,UITextViewDelegate>


/**是否自由人**/
@property(nonatomic,assign)BOOL isFree;
/**自由人类型**/
@property(nonatomic,assign)int funcType;

@end
