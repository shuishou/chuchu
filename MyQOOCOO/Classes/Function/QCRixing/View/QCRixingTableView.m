//
//  QCRixingTableView.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/31.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#define kCount 20
#define kWidth 100
#define kHeight 40
#import "QCRixingTableView.h"

#import "HeadView.h"
#import "TimeView.h"
#import "MyCell.h"
#import "MeetModel.h"

@interface QCRixingTableView()<UITableViewDataSource,UITableViewDelegate,MyCellDelegate>
@property (nonatomic,strong) UIView *myHeadView;
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) TimeView *timeView;
@property (nonatomic,strong) NSMutableArray *meets;
@property (nonatomic,strong) NSMutableArray *currentTime;
@end

@implementation QCRixingTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.separatorColor = kSeparatorColor;//设置分割线的颜色
        self.backgroundColor = [UIColor clearColor];
    }
    UIView *tableViewHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kCount*kWidth, kHeight)];
    self.myHeadView=tableViewHeadView;
    
    for(int i=0;i<kCount;i++){
        
        HeadView *headView=[[HeadView alloc]initWithFrame:CGRectMake(i*kWidth, 0, kWidth, kHeight)];
        headView.num=[NSString stringWithFormat:@"%03d",i];
        headView.detail=@"查看会议室安排";
        headView.backgroundColor=[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        [tableViewHeadView addSubview:headView];
    }
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.myHeadView.frame.size.width, 460) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.bounces=NO;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.myTableView=tableView;
    tableView.backgroundColor=[UIColor whiteColor];
    
    UIScrollView *myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(kWidth*0.7, 0, self.frame.size.width-kWidth*0.7, 480)];
    [myScrollView addSubview:tableView];
    myScrollView.bounces=NO;
    myScrollView.contentSize=CGSizeMake(self.myHeadView.frame.size.width,0);
    [self addSubview:myScrollView];
    
    self.timeView=[[TimeView alloc]initWithFrame:CGRectMake(0, 100, kWidth*0.7, kCount*(kHeight+kHeightMargin))];
    [self addSubview:self.timeView];
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kCount-1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    
    MyCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        
        cell=[[MyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
        cell.backgroundColor=[UIColor grayColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    [self.currentTime removeAllObjects];
    for(MeetModel *model in self.meets){
        
        NSArray *timeArray=[ model.meetTime componentsSeparatedByString:@":"];
        int min=[timeArray[0] intValue]*60+[timeArray[1] intValue];
        int currentTime=indexPath.row*30+510;
        if(min>currentTime&&min<currentTime+30){
            [self.currentTime addObject:model];
        }
    }
    cell.index=(int)indexPath.row;
    cell.currentTime=self.currentTime;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return self.myHeadView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return kHeight;
}
-(void)myHeadView:(HeadView *)headView point:(CGPoint)point
{
    CGPoint myPoint= [self.myTableView convertPoint:point fromView:headView];
    
    [self convertRoomFromPoint:myPoint];
}
-(void)convertRoomFromPoint:(CGPoint)ponit
{
    NSString *roomNum=[NSString stringWithFormat:@"%03d",(int)(ponit.x)/kWidth];
    int currentTime=(ponit.y-kHeight-kHeightMargin)*30.0/(kHeight+kHeightMargin)+510;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"clicked room" message:[NSString stringWithFormat:@"time :%@ room :%@",[NSString stringWithFormat:@"%d:%02d",currentTime/60,currentTime%60],roomNum] delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    [alert show];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY= self.myTableView.contentOffset.y;
    CGPoint timeOffsetY=self.timeView.timeTableView.contentOffset;
    timeOffsetY.y=offsetY;
    self.timeView.timeTableView.contentOffset=timeOffsetY;
    if(offsetY==0){
        self.timeView.timeTableView.contentOffset=CGPointZero;
    }
}






//#pragma mark - UITableView Delegate
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [self.data count];
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *identify = @"RixingCell";
//    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
//    if (nil == cell) {
//        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:identify];
//    }
//    return cell;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.1;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.1;
//}
@end
