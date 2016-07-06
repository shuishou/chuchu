//
//  QCFaXieQuanTableView.m
//  MyQOOCOO
//
//  Created by lanou on 16/2/27.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCFaXieQuanTableView.h"
#import "QCDoodleCell.h"

@implementation QCFaXieQuanTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    
    self = [super initWithFrame:frame style:style];
    if (self) {
       
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = kGlobalBackGroundColor;

    }
    return self;
}


#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.doodleStatusFrames.count;
}

//cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QCDoodleCell *cell = [QCDoodleCell cellWithTableView:tableView];
    cell.qcStatusFrame = self.doodleStatusFrames[indexPath.row];
    
    //工具条的点击事件
    [cell.toolbar.commentBtn addTarget:self action:@selector(selfCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}



#pragma mark - tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QCDoodleStatusFrame *doodleStatusFrame = self.doodleStatusFrames[indexPath.row];
    return doodleStatusFrame.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"closeKeyBord" object:nil userInfo:nil];
     [[NSNotificationCenter defaultCenter]postNotificationName:@"pushToFaXieQuan" object:nil userInfo:@{@"model":self.doodleStatusFrames[indexPath.row]}];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}
-(void)selfCommentBtnClick:(UIButton *)sender{
    NSLog(@"点点点");
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self indexPathForCell:cell];

    [self deselectRowAtIndexPath:indexPath animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"closeKeyBord" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pushToFaXieQuan" object:nil userInfo:@{@"model":self.doodleStatusFrames[indexPath.row]}];
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    
//    
//    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"closeKeyBord" object:nil userInfo:nil];
//}

@end
