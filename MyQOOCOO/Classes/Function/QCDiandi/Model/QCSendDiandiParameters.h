//
//  QCSendDiandi.h
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/14.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCSendDiandiParameters : NSObject
/**
*  标题
*/
@property (nonatomic , copy) NSString *title;
/**
 *  图片url
 */
@property (nonatomic , copy) NSString *coverUrl;
/**
 *  经度
 */
@property ( nonatomic , assign) double locLat;
/**
 *  纬度
 */
@property ( nonatomic , assign) double locLng;
/**
 *  GEO
 */
@property (nonatomic , copy) NSString *locGeo;
/**
 *  地址
 */
@property (nonatomic , copy) NSString *address;//	N	String	地址
@property ( nonatomic , assign) int permission;//	Y	Int	权限1-所有人   2-仅自己   3-选择性可见
@property ( nonatomic , assign) int contentType;//	N	int	内容类型
@property (nonatomic , copy) NSString *vedioUrl;//	N	string	音频url
@property (nonatomic , copy) NSString *content;//	Y	string	内容
@property (nonatomic , copy) NSString *defineUids;//	N	String	被限制的uid集合，以“，”分隔
@property ( nonatomic , assign) int type;//	Y	Int	类型，1，普通，2来自日省
@property ( nonatomic , assign) int ranges;//	Y	int	1、外圈，2、内圈，3、日记
@end
