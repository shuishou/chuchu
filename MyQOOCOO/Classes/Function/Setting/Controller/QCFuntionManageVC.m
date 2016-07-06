//
//  QCFuntionManageVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/9/2.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCFuntionManageVC.h"

@interface QCFuntionManageVC ()<UITableViewDataSource,UITableViewDelegate>
{
    QCBaseTableView *_tableView;
}
@property ( nonatomic , assign) int count;

@end

@implementation QCFuntionManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 0;
    self.navigationItem.title = @"功能管理";
    self.navigationItem.rightBarButtonItem = nil;
    _tableView = [[QCBaseTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.data = [[NSMutableArray alloc]initWithArray:@[@"功能管理"]];
    [self.view addSubview:_tableView];
}

#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
        return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [_tableView.data objectAtIndex:indexPath.row];
    UISwitch *qcSwtich = [[UISwitch alloc]init];
    qcSwtich.tag = _count;
    _count ++;
    
    [qcSwtich addTarget:self action:@selector(qcSwitchChange:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = qcSwtich;
    return cell;
}
#pragma mark - qcSwitch
-(void)qcSwitchChange:(UISwitch *)sender{
    //    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    UISwitch *qcSwitch = (UISwitch *)sender;
    if ([qcSwitch isOn]) {
        CZLog(@"%zd",sender.tag);
    }else {
        
    }
    
}

@end
