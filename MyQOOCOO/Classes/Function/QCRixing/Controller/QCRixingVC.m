//
//  RixingViewController.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/22.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCRixingVC.h"
#import "QCAddRixingVC.h"
#import "QCRixingTableView.h"
#import "QCRixingTableView2.h"
#import "CustomTableView.h"
#import "QCSwitchCell.h"

@interface QCRixingVC ()<UIAlertViewDelegate>
{
    CustomTableView *_tableView;
    
}
@property (nonatomic , strong)NSMutableArray *contentArray;
@property (nonatomic , strong)UISwitch *qcSwitch;
@property (nonatomic , strong)UIScrollView *backScrollView;

@end

@implementation QCRixingVC
#pragma mark - 懒加载
-(NSMutableArray *)contentArray{
    if (!_contentArray) {
        _contentArray = [NSMutableArray arrayWithObjects:@"心情",@"学习",@"帮人",@"为人处事",@"工作",@"陪伴家人", nil];
    }
    return _contentArray;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"日省";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveRixing:)];
    //scrollView
    _backScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _backScrollView.contentSize = CGSizeMake(SCREEN_W, SCREEN_H);
    [self.view addSubview:_backScrollView];
    
    //title
    [self setupTitleView];
    
    //日省View
//    _tableView = [[QCRixingTableView2 alloc]initWithFrame:CGRectMake(0, 115, SCREEN_W, 0) style:UITableViewStylePlain];
    
    
    NSMutableDictionary *trDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableArray *leftKeys = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *rightKeys = [NSMutableArray arrayWithCapacity:0];
    int leftNumber = 1;
    for (int i = 0; i < 10; i++) {
        NSString *key = [NSString stringWithFormat:@"tr_%d", i];
        [trDict setValue:[NSNumber numberWithFloat:50.0] forKey:key];
        if (i < leftNumber) {
            [leftKeys addObject:key];
        } else {
            [rightKeys addObject:key];
        }
    }
    
    NSMutableArray *dArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 50; i ++) {
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithCapacity:0];
        for (NSString *key in trDict) {
            [data setValue:[NSString stringWithFormat:@"%@ %d", key, i] forKey:key];
        }
        [dArray addObject:data];
    }
    _tableView = [[CustomTableView alloc]initWithData:dArray trDictionary:trDict size:CGSizeMake(SCREEN_W, 400) scrollMethod:kScrollMethodWithRight leftDataKeys:leftKeys rightDataKeys:rightKeys];
    CGRect frame = _tableView.frame;
    frame.origin = CGPointMake(0, 115);
    _tableView.frame = frame;
    
    [_backScrollView addSubview:_tableView];
    
    //同步到点滴
    _qcSwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
    [_qcSwitch addTarget:self action:@selector(synchronizeToDiandi:) forControlEvents:UIControlEventValueChanged];
    UITableViewCell *synchronizeCell = [[QCSwitchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"synchronizeCell" title:@"同步到点滴" switchView:_qcSwitch];
    [_backScrollView addSubview:synchronizeCell];
    [synchronizeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom).offset(20);
        make.left.equalTo(_backScrollView.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_W,44));
    }];


}
-(void)saveRixing:(UIBarButtonItem *)bar
{
    
}
#pragma mark - 子控件
-(void)setupTitleView{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, WIDTH(self.view), WIDTH(self.view)/5)];
    [_backScrollView addSubview:backView];
    //满意
    UIButton *satisfyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    satisfyBtn.frame = CGRectMake(0, 0, WIDTH(backView)/3, HEIGHT(backView));
    UIImage *image = [[UIImage imageNamed:@"rixing_Laugh"]scaleToSize:CGSizeMake(WIDTH(satisfyBtn)/3, WIDTH(satisfyBtn)/3)];
    [satisfyBtn setImage:image forState:UIControlStateNormal];
    [satisfyBtn setTitle:@"满意" forState:UIControlStateNormal];
    [satisfyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [satisfyBtn setTitleEdgeInsets:UIEdgeInsetsMake(WIDTH(satisfyBtn)/2, -55, 0, 0)];
    [satisfyBtn setImageEdgeInsets:UIEdgeInsetsMake(-30, 30, 0, 0)];
    [backView addSubview:satisfyBtn];
    //一般
    UIButton *sosoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sosoBtn.frame = CGRectMake(MaxX(satisfyBtn), 0, WIDTH(backView)/3, HEIGHT(backView));
    UIImage *image2 = [[UIImage imageNamed:@"rixing_Normal"]scaleToSize:CGSizeMake(WIDTH(sosoBtn)/3, WIDTH(sosoBtn)/3)];
    [sosoBtn setImage:image2 forState:UIControlStateNormal];
    [sosoBtn setTitle:@"一般" forState:UIControlStateNormal];
    [sosoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sosoBtn setTitleEdgeInsets:UIEdgeInsetsMake(50, -55, 0, 0)];
    [sosoBtn setImageEdgeInsets:UIEdgeInsetsMake(-30, 30, 0, 0)];
    [backView addSubview:sosoBtn];
    //不满意
    UIButton *dissatisfyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dissatisfyBtn.frame = CGRectMake(MaxX(sosoBtn), 0, WIDTH(backView)/3, HEIGHT(backView));
    UIImage *image3 = [[UIImage imageNamed:@"rixing_Cry"]scaleToSize:CGSizeMake(WIDTH(dissatisfyBtn)/3, WIDTH(dissatisfyBtn)/3)];
    [dissatisfyBtn setImage:image3 forState:UIControlStateNormal];
    [dissatisfyBtn setTitle:@"不满意" forState:UIControlStateNormal];
    [dissatisfyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dissatisfyBtn setTitleEdgeInsets:UIEdgeInsetsMake(50, -40, 0, 0)];
    [dissatisfyBtn setImageEdgeInsets:UIEdgeInsetsMake(-30, 30, 0, 0)];
    [backView addSubview:dissatisfyBtn];
}
#pragma mark - 同步点滴
-(void)synchronizeToDiandi:(id)sender{
    if ([_qcSwitch isOn]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"是否同步到点滴" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alertView show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        _qcSwitch.on = NO;
    }else if (buttonIndex == 1){

    }
}


//#pragma mark - tableViewDelegate
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 3;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
////    if (tableView.tag == 101) {
//        if (section == 0) {
//            return 1;
//        }if (section ==1) {
//            //        return self.cellArray.count;
//            return 1;
//        }else{
//            return 1;
//        }
////    }else {
////        return _cellArray.count;
////    }
////    
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (indexPath.section == 0) {
//        return 75;
//    }else if(indexPath.section == 1){
//        return 400;
//    }else{
//        return 44;
//    }
//    
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 20;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.01;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *ID = @"cell";
//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
////    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
////    if (!cell) {
////        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
////    }
//    if (indexPath.section == 0) {
//        //满意
//        UIButton *satisfyBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W/3, 75)];
//        UIImage *image = [UIImage imageNamed:@"rixing_Laugh"];
//        [image scaleToSize:CGSizeMake(48, 48)];
//        [satisfyBtn setImage:image forState:UIControlStateNormal];
//        [satisfyBtn setTitle:@"满意" forState:UIControlStateNormal];
//        [satisfyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [satisfyBtn setTitleEdgeInsets:UIEdgeInsetsMake(50, -60, 0, 0)];
//        [satisfyBtn setImageEdgeInsets:UIEdgeInsetsMake(-30, 0, 0, 0)];
//        [cell addSubview:satisfyBtn];
//        //一般
//        UIButton *sosoBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W/3, 0, SCREEN_W/3, 75)];
//        UIImage *image2 = [UIImage imageNamed:@"rixing_Normal"];
//        [image2 scaleToSize:CGSizeMake(48, 48)];
//        [sosoBtn setImage:image2 forState:UIControlStateNormal];
//        [sosoBtn setTitle:@"一般" forState:UIControlStateNormal];
//        [sosoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [sosoBtn setTitleEdgeInsets:UIEdgeInsetsMake(50, -60, 0, 0)];
//        [sosoBtn setImageEdgeInsets:UIEdgeInsetsMake(-30, 0, 0, 0)];
//        [cell addSubview:sosoBtn];
//        //不满意
//        UIButton *dissatisfyBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W/3 * 2, 0, SCREEN_W/3, 75)];
//        UIImage *image3 = [UIImage imageNamed:@"rixing_Cry"];
//        [image3 scaleToSize:CGSizeMake(48, 48)];
//        [dissatisfyBtn setImage:image3 forState:UIControlStateNormal];
//        [dissatisfyBtn setTitle:@"不满意" forState:UIControlStateNormal];
//        [dissatisfyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [dissatisfyBtn setTitleEdgeInsets:UIEdgeInsetsMake(50, -60, 0, 0)];
//        [dissatisfyBtn setImageEdgeInsets:UIEdgeInsetsMake(-30, 0, 0, 0)];
//        [cell addSubview:dissatisfyBtn];
//        
//        
//    }if (indexPath.section == 1) {
//        
//        QCRixingTableView *subTableView = [[QCRixingTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 99) style:UITableViewStylePlain];
//        subTableView.delegate = self;
//        subTableView.dataSource = self;
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RixingTableViewCell"];
//        [cell.contentView addSubview:subTableView];
//        
//        
//    }else if(indexPath.section == 2){
//        _qcSwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
//        [_qcSwitch addTarget:self action:@selector(synchronizeToDiandi:) forControlEvents:UIControlEventValueChanged];
//        cell.accessoryView = _qcSwitch;
//        
//        cell.textLabel.text = @"同步到点滴";
//    }
//    
//    return cell;
//    
//    
//}

//
//#pragma mark - tableView的delegate方法
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    
//    
//}

@end
