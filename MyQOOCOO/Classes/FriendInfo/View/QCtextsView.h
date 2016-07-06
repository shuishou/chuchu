//
//  QCtextsView.h
//  MyQOOCOO
//
//  Created by lanou on 16/3/16.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCGetUserMarkModel.h"
#import "QCtextV.h"


@interface QCtextsView : UIView
{
        BOOL isDelete;
}

@property(nonatomic,strong)NSMutableArray *codeArr;

@property(nonatomic,strong)NSIndexPath *indexpath;

@property int flag;

//传入文字数，返回textView的尺寸
+(CGSize)textViewSizeWithArrCount:(NSInteger)count;
@end
