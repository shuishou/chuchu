//
//  QCHFMoreVC.m
//  MyQOOCOO
//
//  Created by Wind on 15/12/27.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCHFMoreVC.h"

@interface QCHFMoreVC ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView * tableViews;
}
@property (strong, nonatomic) NSMutableArray * arrays;
@property (strong, nonatomic) NSMutableArray * arrays1;
@property (strong, nonatomic) NSUserDefaults * userDefaults;
@end

@implementation QCHFMoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
    
    _arrays = [NSMutableArray array];
    _arrays1 = [NSMutableArray array];
    NSArray * arr = @[@"点滴", @"论库", @"发泄圈", @"日省", @"我要派活", @"我要接活"];
    
    NSMutableArray * yiArr = [NSMutableArray array];
    yiArr = [_userDefaults objectForKey:@"已启用功能"];
    NSMutableArray * weiArr = [NSMutableArray array];
    weiArr = [_userDefaults objectForKey:@"未启用功能"];
    
    if ( yiArr.count > 0 ) {
        
        [_arrays addObjectsFromArray:yiArr];
    }
    else
    {
        if (weiArr.count > 0) {
            
        }else{
            [_arrays addObjectsFromArray:arr];
        }
        
    }
    
    
    
    if (weiArr.count > 0) {
        [_arrays1 addObjectsFromArray:weiArr];
    }
    
    [self initTableView];
}

- (void)initTableView
{
    tableViews = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view)) style:UITableViewStylePlain];
    tableViews.delegate = self;
    tableViews.dataSource = self;
    tableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViews.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    
    [self.view addSubview:tableViews];
}

#pragma -mark tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _arrays.count;
    }
    else
    {
        return _arrays1.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"QCHFMoreId";
    
    UITableViewCell * cell = [tableViews dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.textLabel.font = [UIFont systemFontOfSize:HEIGHT(cell.contentView)/3];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
        
        UIImageView * image =[[UIImageView alloc] initWithFrame:CGRectMake(0, WIDTH(self.view)/8-1, self.view.frame.size.width, 1)];
        image.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
        [cell.contentView addSubview:image];

    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = _arrays[indexPath.row];
        return cell;
    }
    else
    {
        cell.textLabel.text = _arrays1[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WIDTH(self.view)/8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WIDTH(self.view)/8;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view)/8)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, WIDTH(headerView), HEIGHT(headerView))];
    [label setFont:[UIFont systemFontOfSize:HEIGHT(label) *2/5]];
    label.textColor = [UIColor colorWithHexString:@"666666"];
    [headerView addSubview:label];
    
    if (section == 0) {
        label.text = @"已启用功能";
    }
    else
    {
        label.text = @"未启用功能";
    }
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
     
        [self initMoreview:indexPath.row sections:indexPath.section];
    }
    else
    {
        [self initMoreview:indexPath.row sections:indexPath.section];
    }
}

- (void)initMoreview:(NSInteger)indexs sections:(NSInteger)sections
{
    UIView * moreFunctionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view))];
    moreFunctionView.backgroundColor = kColorRGBA(52,52,52,0.3);
    moreFunctionView.userInteractionEnabled = YES;
    [self.navigationController.view addSubview:moreFunctionView];
    
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(30, (HEIGHT(moreFunctionView)-HEIGHT(moreFunctionView)/3)/2, WIDTH(moreFunctionView)-60, HEIGHT(moreFunctionView)/3)];
    titleView.backgroundColor = [UIColor whiteColor];
    [moreFunctionView addSubview:titleView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT(titleView)/2-(HEIGHT(titleView)/5)/2-10, WIDTH(titleView), HEIGHT(titleView)/5)];
    if (sections == 0) {
        label.text = [NSString stringWithFormat:@"停用%@", _arrays[indexs]];
    }
    else
    {
        label.text = [NSString stringWithFormat:@"启用%@", _arrays1[indexs]];
    }
    
    label.textColor = [UIColor colorWithHexString:@"333333"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:HEIGHT(label)*2/5];
    [titleView addSubview:label];
    
    UIButton * cancelBu = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBu.frame = CGRectMake(0, HEIGHT(titleView)-HEIGHT(titleView)/5, WIDTH(titleView)/2, HEIGHT(titleView)/5);
    [cancelBu setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBu.titleLabel setFont:[UIFont systemFontOfSize:HEIGHT(cancelBu)*2/5]];
    [cancelBu setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [cancelBu actionButton:^(UIButton *sender) {
        
        [moreFunctionView removeFromSuperview];
        
    }];
    [titleView addSubview:cancelBu];
    
    UIButton * doneBu = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBu.frame = CGRectMake(MaxX(cancelBu), Y(cancelBu), WIDTH(cancelBu), HEIGHT(cancelBu));
    [doneBu.titleLabel setFont:[UIFont systemFontOfSize:HEIGHT(doneBu)*2/5]];
    [doneBu setTitle:@"确定" forState:UIControlStateNormal];
    [doneBu setTitleColor:[UIColor colorWithHexString:@"#2ab6f4"] forState:UIControlStateNormal];
    [doneBu actionButton:^(UIButton *sender) {
        
        if (sections == 0) {
            [_arrays1 addObject:_arrays[indexs]];
            [_arrays removeObjectAtIndex:indexs];
            [tableViews reloadData];
            [moreFunctionView removeFromSuperview];
        }
        else
        {
            [_arrays addObject:_arrays1[indexs]];
            [_arrays1 removeObjectAtIndex:indexs];
            [tableViews reloadData];
            [moreFunctionView removeFromSuperview];
        }
        CZLog(@"%@", NSHomeDirectory());
        [_userDefaults setObject:_arrays forKey:@"已启用功能"];
        [_userDefaults setObject:_arrays1 forKey:@"未启用功能"];
    }];
    [titleView addSubview:doneBu];
    
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT(titleView)-HEIGHT(cancelBu)-0.5, WIDTH(titleView), 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"E0E0E0"];
    [titleView addSubview:line];
    
    
    //#pragma -mark 轻点消失
    //    UITapGestureRecognizer * dismissTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissTap:)];
    //    [dayLogView addGestureRecognizer:dismissTap];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
