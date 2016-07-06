//
//  QCCommonCollectionView.h
//  MyQOOCOO
//
//  Created by lanou on 16/1/4.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCCommonCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource>


@property(nonatomic,strong)NSMutableArray *textArr;

@property(nonatomic,assign)BOOL isDelete;

@property(nonatomic,assign)BOOL isSearch;



@end
