//
//  QCDianDiTableView.m
//  MyQOOCOO
//
//  Created by lanou on 16/2/27.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCDianDiTableView.h"
#import "QCDiandiDetailVC.h"
#import "OkamiPhotoView.h"

@implementation QCDianDiTableView
- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kGlobalBackGroundColor;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource = self;
        self.delegate = self;
        self.rowHeight = UITableViewAutomaticDimension;
        self.estimatedRowHeight = 2;
        self.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    }
    return self;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QCDiandiListCell *cell = [QCDiandiListCell cellWithTableView:tableView];
    
    CGRect rect = cell.frame;
    QCDiandiListModel*model=self.modelArr[indexPath.row];
    NSArray * tempArr = [model.coverUrl componentsSeparatedByString:@","];
    NSMutableArray * Arr =[tempArr mutableCopy];
    CGSize photosSize=[OkamiPhotoView photoViewSizeWithPictureCount:Arr.count];
    
    
    NSString*str=Arr[0];
    if (![str isEqualToString:@""]) {
        
        
        rect.size.height=photosSize.height+227;
    }else{
        rect.size.height=227;
    }
    
    
    
    cell.frame = rect;
    
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.diandiListModel =self.modelArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pushToDianDi" object:nil userInfo:@{@"model":self.modelArr[indexPath.row]}];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"closeKeyBord" object:nil userInfo:nil];
    
    
//    QCDiandiDetailVC *VC = [[QCDiandiDetailVC alloc] init];
//    VC.dianDi = self.modelArr[indexPath.row];
//    [self.navigationController pushViewController:VC animated:YES];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"cell height %f",cell.frame.size.height);
    
    return cell.frame.size.height;
    
    
    
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    
//    
//    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"closeKeyBord" object:nil userInfo:nil];
//}



@end
