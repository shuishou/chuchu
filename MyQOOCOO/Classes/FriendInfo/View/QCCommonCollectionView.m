//
//  QCCommonCollectionView.m
//  MyQOOCOO
//
//  Created by lanou on 16/1/4.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCCommonCollectionView.h"
#import "QCCommonCollectionViewCell.h"

@implementation QCCommonCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        //注册cell UICollectionView的cell必须注册
        [self registerClass:[QCCommonCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        //注册header
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        self.scrollEnabled=YES;
        
        //设置代理
        self.delegate =self;
        self.dataSource = self ;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
    
}


#pragma -mark CV代理

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"self.textArr count====%ld",[self.textArr count]);
    return [self.textArr count];
}

//item什么样子

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QCCommonCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }
    NSLog(@"self.textArr===%@",self.textArr);
    if (self.textArr.count > 0) {
        cell.type = 0;
        NSLog(@"title====%@",self.textArr[indexPath.row]);
        cell.lb.text = self.textArr[indexPath.row];
    }
    
    if ( _isDelete == YES ) {
        cell.deleteIge.hidden = NO;
    }else if( _isDelete == NO ){
        cell.deleteIge.hidden = YES;
    }

    
    if (!self.isSearch) {
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
    return CGSizeMake(self.bounds.size.width/4-2, 38);
}

//点击的低级分区的第几个item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"closeKeyBord" object:nil userInfo:nil];
    if (_isDelete == YES) {
        [self.textArr removeObjectAtIndex:indexPath.row];
        _isDelete = NO;
        [self reloadData];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteText" object:nil userInfo:@{@"index":@((long)indexPath.row)}];
    }
    
    if (self.isSearch) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeText" object:nil userInfo:@{@"index":@((long)indexPath.row)}];
    }
}

-(void)longTouchItem:(UILongPressGestureRecognizer*)longResture
{
    if (longResture.state==UIGestureRecognizerStateBegan) {
        _isDelete = YES;
        [self reloadData];
    }else if(longResture.state==UIGestureRecognizerStateEnded){
        
        
    }
}


//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//
//    
//   
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"closeKeyBord" object:nil userInfo:nil];
//}




@end
