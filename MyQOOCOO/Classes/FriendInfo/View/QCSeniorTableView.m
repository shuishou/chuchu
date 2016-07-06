//
//  QCSeniorTableView.m
//  MyQOOCOO
//
//  Created by lanou on 16/1/4.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCSeniorTableView.h"
#import "QCSeniorCollectionView.h"

@implementation QCSeniorTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
       
        self.delegate =self;
        self.dataSource = self ;
        self.rowHeight = 75;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.scrollEnabled = YES;
        self.allowsSelection= NO;//不让cell被选中
        self.userInteractionEnabled=YES;
        self.bounces=NO;
        //self.contentInset = UIEdgeInsetsMake(12.5, 0, 0, 0);
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
    
    
}
//-(void)setDataArr:(NSMutableArray *)dataArr
//{
//    
//       _dataArr=dataArr;
//    
//}


#pragma -mark tableview的代理方法

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
    myLable.text=@"已选标签";
    myLable.font=[UIFont systemFontOfSize:13];
    myLable.backgroundColor=[UIColor clearColor];
    
    myLable.textColor=[UIColor blackColor];
    [header addSubview:myLable];
    
    
    
    return header;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString*indentifier=@"cell";
    NSString *indentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];

    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    
    
    
    
        CGRect rect = cell.frame;
        NSMutableArray*temparr2 =self.dataArr;
        float a=temparr2.count/3;
        if (a<1) {
           
                rect.size.height = 50;
                    }else {
                if (temparr2.count%3!=0&&temparr2.count>3) {
                   rect.size.height = 50*(int)a+50;
                }else{
            rect.size.height = 50*(int)a;
                }
        }
    
    
    
    
        cell.frame = rect;
    
    
    
    
        //创建一个布局类
        UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];
        //设置最小行间距
        layout.minimumLineSpacing=10;
        //这是最小列间距
        layout.minimumInteritemSpacing=10;
        //设置垂直滚动
        layout.scrollDirection=UICollectionViewScrollDirectionVertical;
        //设置外面上下左右的间距
        layout.sectionInset=UIEdgeInsetsMake(5, 5, 1, 1);
        //借助布局类创建一个UICollectionView
        QCSeniorCollectionView* cv=[[QCSeniorCollectionView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, rect.size.height) collectionViewLayout:layout];
    
        cv.dataArr=self.dataArr;
        [cell addSubview:cv];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",(long)indexPath.row);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
        NSLog(@"cell height %f",cell.frame.size.height);
    
        return cell.frame.size.height;
    //return 10;
    
    
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    //多少个分区
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section{
    
    return 1;
    
}

@end
