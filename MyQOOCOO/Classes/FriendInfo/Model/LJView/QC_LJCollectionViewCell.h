//
//  QC_LJCollectionViewCell.h
//  MyQOOCOO
//
//  Created by lanou on 15/12/29.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QC_LJCollectionViewCell : UICollectionViewCell


@property(nonatomic,strong)UIView*backv;//底部v
@property(nonatomic,strong)UILabel*titlelb;//标题
@property(nonatomic,strong)UIImageView*imagev;//底部图


@property(nonatomic,strong)UIImageView*voiceige;//音量或播放图标
@property(nonatomic,strong)UILabel*msLb;//时长

@property(nonatomic,assign)int type;


@property(nonatomic,strong)UIImageView*deleteIge;




@end
