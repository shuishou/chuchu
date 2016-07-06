//
//  QCSeniorCollectionView.m
//  MyQOOCOO
//
//  Created by lanou on 16/1/4.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCSeniorCollectionView.h"
#import "QCSeniorCollectionViewCell.h"

@implementation QCSeniorCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        _dataArr=[NSMutableArray array];
        
        //注册cell UICollectionView的cell必须注册
        [self registerClass:[QCSeniorCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        //注册header
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        self.scrollEnabled=NO;
        self.userInteractionEnabled=YES;
        
        //设置代理
        self.delegate =self;
        self.dataSource = self ;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
    
}
-(void)setDataArr:(NSMutableArray *)dataArr
{
    
        
    
//    QCSeniorModel*mod=[[QCSeniorModel alloc]init];
//    mod.type=4;
//    
//    [dataArr addObject:mod];
    _dataArr=dataArr ;
    


}

#pragma -mark CV代理

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArr count];
}

//item什么样子

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QCSeniorCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }

    
    QCSeniorModel*mod=self.dataArr[indexPath.row];
    cell.type=mod.type;

    if (cell.type!=4) {
        
    
    cell.picImagev.image=mod.image;
    }
    
    cell.msLb.text=mod.str;
    
    if (_isDelete==YES) {
        cell.deleteIge.hidden=NO;
    }else if(_isDelete==NO){
        cell.deleteIge.hidden=YES;
    }
        cell.tag=indexPath.row;
    if (indexPath.row!=self.dataArr.count -1) {
        
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [longPressGestureRecognizer addTarget:self action:@selector(longTouchItem:)];
    [longPressGestureRecognizer setMinimumPressDuration:2];
    [longPressGestureRecognizer setAllowableMovement:50.0];
    [cell addGestureRecognizer:longPressGestureRecognizer];
    }
    
    
    
    return cell;
}

//控制每个小方块的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.bounds.size.width/3-10, 40);
    
}

//点击的低级分区的第几个item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%ld",(long)indexPath.row);
    
    if (_isDelete!=YES) {
        
     if (indexPath.row==self.dataArr.count-1) {
  
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addTag" object:nil userInfo:nil];
     }
    }else{
        
        if (indexPath.row==self.dataArr.count-1) {
            
        
            
        }else{
            
         
        [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteTag" object:nil userInfo:@{@"index":@(indexPath.row)}];
            
        }
    
       
        
        
        
    }
     _isDelete=NO;
    
    
}

-(void)longTouchItem:(UILongPressGestureRecognizer*)longResture
{
    

    if (longResture.state==UIGestureRecognizerStateBegan) {
        _isDelete=YES;
        [self reloadData];
    }else if(longResture.state==UIGestureRecognizerStateEnded){
    
    
    }


}


@end
