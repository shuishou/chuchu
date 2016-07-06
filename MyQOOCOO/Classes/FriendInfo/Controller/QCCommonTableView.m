//
//  QCCommonTableView.m
//  MyQOOCOO
//
//  Created by lanou on 16/1/4.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCCommonTableView.h"
#import "QCCommonCollectionView.h"




@implementation QCCommonTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        titleArr = [[NSMutableArray alloc]initWithObjects:@"推荐标签",@"已选标签", nil];
        self.delegate = self;
        self.dataSource = self ;
        self.rowHeight = 75;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.scrollEnabled = NO;
        self.allowsSelection = NO;//不让cell被选中
        
        //self.contentInset = UIEdgeInsetsMake(12.5, 0, 0, 0);
        self.backgroundColor = RGBA_COLOR(237, 237, 237, 1);
    }
    return self;
}

#pragma mark - tableview的代理方法
//section头高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 37;
}

//section头内容
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 37)];
    header.backgroundColor=RGBA_COLOR(237, 237, 237, 1);
    
    UILabel*myLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.bounds.size.width/5, 37)];
    myLable.text=titleArr[section];
    myLable.font=[UIFont systemFontOfSize:13];
    myLable.backgroundColor=[UIColor clearColor];
    
    myLable.textColor=[UIColor blackColor];
    [header addSubview:myLable];

    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString*indentifier=@"cell";
    NSString *indentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    
    CGRect rect = cell.frame;
    NSMutableArray *temparr2 = self.textArr;
    if ( temparr2.count > 0 ) {
        float a=temparr2.count/4;
        if ( a < 1 ) {
            rect.size.height = 40;
        }else {
            if (temparr2.count%4!=0&&temparr2.count>4) {
                rect.size.height = 40*(int)a+40;
            }else{
                rect.size.height = 40*(int)a;
            }
        }
    }else{
        rect.size.height = 40;
    }
    
    cell.frame = rect;
    
    //创建一个布局类
    UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];
    //设置最小行间距
    layout.minimumLineSpacing=2;
    //这是最小列间距
    layout.minimumInteritemSpacing=2;
    //设置垂直滚动
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    //设置外面上下左右的间距
    layout.sectionInset=UIEdgeInsetsMake(1, 1, 1, 1);
    //借助布局类创建一个UICollectionView
    QCCommonCollectionView *cv=[[QCCommonCollectionView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, rect.size.height) collectionViewLayout:layout];
    if (indexPath.section == 0) {
        cv.textArr = self.textArr;
        cv.isSearch = YES;
    }else{
        cv.textArr = self.selectedArr;
//        cv.isDelete = YES;
    }
    
    [cell addSubview:cv];

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSLog(@"%ld",(long)indexPath.row);
    }else if (indexPath.section == 1){
        NSLog(@"%ld",(long)indexPath.row);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"cell height %f",cell.frame.size.height);
    return cell.frame.size.height;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    //多少个分区
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section{
    return 1;
}

#pragma marl - UIScrollView的代理方法
//重要的一个 一旦滚动就会执行
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

//其他代理方法
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"开始拖拽");
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"结束拖拽");
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"开始减速");
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"减速结束");
}

@end
