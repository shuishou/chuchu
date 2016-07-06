//
//  QCSeniorCollectionView.h
//  MyQOOCOO
//
//  Created by lanou on 16/1/4.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCSeniorModel.h"

@interface QCSeniorCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource>


@property(nonatomic,strong)NSMutableArray*dataArr;

@property(nonatomic,assign)BOOL isDelete;

@end
