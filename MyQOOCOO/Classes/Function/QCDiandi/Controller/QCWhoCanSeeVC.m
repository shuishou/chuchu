//
//  QCWhoCanSee1.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/10.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCWhoCanSeeVC.h"
#import "QCFriendListVC.h"

@interface QCWhoCanSeeVC ()<UITableViewDelegate,UITableViewDataSource>
{
    void(^_chooseBlock)(NSString *permissionType);
    NSString * _currentChoose;
    QCFriendListVC * fVC;
}
@property (nonatomic,assign) NSIndexPath *currentIndex;

@property (nonatomic,assign) NSInteger index;

@end

@implementation QCWhoCanSeeVC

-(instancetype)initWithCurrent:(NSString *)currentChoose choose:(void (^)(NSString *))chooseBlock{
    self = [super init];
    if (self) {
        _chooseBlock = chooseBlock;
        _currentChoose = currentChoose;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.index= 1;
    self.navigationItem.title = @"谁可以看";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addBarBtnTitle:@"确定" target:self action:@selector(sure:)];
//    self.tableView.data = [[NSMutableArray alloc]initWithArray:@[@[@"所有人",@"仅自己"],@[@"不给谁看",@"互相关注",@"关注我的",@"群组",@"趣友分组"]]];
    
    self.tableView.data = [[NSMutableArray alloc]initWithArray:@[@[@"所有人",@"仅自己"],@[@"不给谁看",@"互相关注",@"关注我的"]]];
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    if (_currentChoose.length == 0) {
        _currentIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    }else{
        for (int i = 0; i<self.tableView.data.count; i++) {
            for (int j = 0; j<[self.tableView.data[i] count]; j++) {
                NSString * choose = [self.tableView.data[i] objectAtIndex:j];
                if ([choose isEqualToString:_currentChoose]) {
                    _currentIndex = [NSIndexPath indexPathForRow:j inSection:i];
                }
            }
        }
    }
    
      
}

// 确定按钮
-(void)sure:(id)sender{
    
    if ([self.delegate respondsToSelector:@selector(whoCanSeeWhitTypeIndex:)]) {
        [self.delegate whoCanSeeWhitTypeIndex:self.index];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableViewDataSourceAndDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [self.tableView.data objectAtIndex:section];
    return array.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0||indexPath.row<1) {
        //选中
        _currentIndex = indexPath;
        
        if (indexPath.section==0) {
            self.index = indexPath.row +1;
        }else{
            self.index = 3;
        }
//        CZLog(@"%ld",self.currentIndex.row);
    }else{
        //跳转
        [self pushToChoose:indexPath.row-1];
    }
    [tableView reloadData];

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = [[self.tableView.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.tintColor = kGlobalTitleColor;
    
    if (indexPath.section==1&&indexPath.row>0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        if (indexPath==_currentIndex) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

-(void)pushToChoose:(NSInteger)row{
    
    if (self.index ==3) {//选中不给谁看才能跳转
    switch (row) {
        case 0:{
            fVC = [[QCFriendListVC alloc]initWithFriendStatus:kFriendStatusEachOther listType:kFriendGroupTpyeNormal];
            fVC.isDD = YES;
            [self.navigationController pushViewController:fVC animated:YES];
            break;
        }
        case 1:{
            fVC = [[QCFriendListVC alloc]initWithFriendStatus:kFriendStatusAttentionMe listType:kFriendGroupTpyeNormal];
            fVC.isDD = YES;
            [self.navigationController pushViewController:fVC animated:YES];
            break;
        }
            
        case 2:{
            
            break;
        }
        case 3:{
            
            break;
        }
    }
        
  }
}


@end
