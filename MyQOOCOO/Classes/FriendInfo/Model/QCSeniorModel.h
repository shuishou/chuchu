//
//  QCSeniorModel.h
//  MyQOOCOO
//
//  Created by lanou on 16/1/5.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCSeniorModel : NSObject

/**类型**/
@property(nonatomic,assign)NSInteger type;

/**本地地址**/
@property(nonatomic,strong)NSURL*url;

/**本地路径**/
@property(nonatomic,strong)NSString*filePath;

/**图片**/
@property(nonatomic,strong)UIImage *image;

/**时长**/
@property(nonatomic,strong)NSString *str;

/**描述**/
@property(nonatomic,strong)NSString *describeStr;
/**视频缩略图**/
@property(nonatomic,strong)NSString *strUrl;


@end
