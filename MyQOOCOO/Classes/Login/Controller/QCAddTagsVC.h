//
//  QCAddTagsVC.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/12.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"

typedef void (^TagsBlock)(NSArray *tags);

@interface QCAddTagsVC : QCBaseVC
 /** 默认标签大类*/
@property (nonatomic , strong)NSMutableArray *tagsArray;

@property (nonatomic , copy)TagsBlock tagsBlock;

@end
