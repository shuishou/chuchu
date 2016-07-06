//
//  QCSearchModel.h
//  MyQOOCOO
//
//  Created by lanou on 16/2/19.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCSearchModel : NSObject
/**标题**/
@property(nonatomic,strong)NSString*title;
/**内容**/
@property(nonatomic,strong)NSString*content;
/**图片**/
@property(nonatomic,strong)NSString*image;
/**类型**/
@property(nonatomic,strong)NSString*type;
/**跳转的id**/
@property(nonatomic,strong)NSString*targetId;

@end
