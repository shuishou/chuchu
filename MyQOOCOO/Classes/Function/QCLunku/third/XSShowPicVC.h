//
//  XSShowPicVC.h
//  XSTeachEDU
//
//  Created by xsteach on 14/12/29.
//  Copyright (c) 2014年 xsteach.com. All rights reserved.
//

#import "QCBaseVC.h"
#import "XSPicBrowseView.h"

@interface XSShowPicVC : QCBaseVC<XSPicBrowseViewDelegate>
- (id)initWithSourceData:(NSMutableArray *)imgSource withIndex:(NSInteger)index;
-(void)show;
@end
