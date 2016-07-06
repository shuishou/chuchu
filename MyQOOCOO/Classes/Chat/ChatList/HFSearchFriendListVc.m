//
//  HFSearchFriendListVc.m
//  MyQOOCOO
//
//  Created by Wind on 15/11/30.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "HFSearchFriendListVc.h"

#import "QCHFTheUserCell.h"
#import "QCFriendAccout.h"
#import "MJExtension.h"
#import "NSObject+MJKeyValue.h"

#import "QCUserViewController2.h"
@interface HFSearchFriendListVc ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    UITextField * field;
    UITableView * TabelView;
    UIView * tybeView;
    UIButton * tybeBu;
    UIButton * currentButton;
    BOOL isFriends;
}

/**搜索关键字*/
@property (strong, nonatomic) NSString * HFKeyWords;
/**搜索条件*/
@property (assign, nonatomic) NSInteger HFIndex;
@end

@implementation HFSearchFriendListVc

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isAn = @0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    // white.png图片自己下载个纯白色的色块，或者自己ps做一个
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"navBackGround"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    
    if (![self.isAn boolValue]) {
        self.HFIndex = -1;
        self.isfriendArr = [NSMutableArray array];
        self.dataArray = [NSMutableArray array];
        [self searchTextfiled];
        [self searchConditionsView];
    }
    else{
        
    }
    
    [self initTableView];
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    taps.delegate = self;
    taps.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:taps];
}

- (void)viewTapped:(UITapGestureRecognizer *)tap
{
    [field resignFirstResponder];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

- (void)searchTextfiled
{
    UIView * searchV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 44)];
    
    field = [[UITextField alloc] initWithFrame:CGRectMake(0, 8, WIDTH(searchV)*4/5, 28)];
    field.placeholder = @"搜索";
    [field setValue:[UIColor colorWithHexString:@"666666"] forKeyPath:@"_placeholderLabel.textColor"];
    field.font = [UIFont systemFontOfSize:15];
    field.textColor = [UIColor colorWithHexString:@"333333"];
    field.backgroundColor = [UIColor whiteColor];
    field.layer.masksToBounds = YES;
    field.layer.cornerRadius = 5;
    field.delegate = self;
    [field addTarget:self action:@selector(searchDataED:) forControlEvents:UIControlEventEditingDidEnd];
    field.returnKeyType = UIReturnKeyGoogle;
    [searchV addSubview:field];
    
    UIButton * searchBu = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBu setFrame:CGRectMake(MaxX(field) + 8, 8, WIDTH(searchV)-WIDTH(field) - 16, 28)];
    [searchBu.layer setCornerRadius:14];
    [searchBu.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [searchBu setTitleColor:kLoginbackgoundColor forState:UIControlStateNormal];
    [searchBu setTitle:@"取消" forState:UIControlStateNormal];
    [searchBu actionButton:^(UIButton *sender){
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [searchV addSubview:searchBu];
    
    self.navigationItem.titleView = searchV;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)searchDataED:(UITextField *)fields
{
    self.HFKeyWords = field.text;
    [self searchDownData];
}

- (void)searchConditionsView
{
    
    tybeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 40)];
    tybeView.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    
    NSArray * tybeArr = @[@"处号", @"手机号", @"昵称", @"全部标签"];
    for (int i = 1; i < 5; i++) {
        
        tybeBu = [UIButton buttonWithType:UIButtonTypeCustom];
        tybeBu.frame = CGRectMake(WIDTH(self.view)/6*((i-1)%6), 10, WIDTH(self.view)/6, 20);
        tybeBu.titleLabel.font = [UIFont systemFontOfSize:13];
        tybeBu.titleLabel.textAlignment = NSTextAlignmentCenter;
        [tybeBu setTitle:tybeArr[i-1] forState:UIControlStateNormal];
        [tybeBu addTarget:self action:@selector(tybeSearch:) forControlEvents:UIControlEventTouchUpInside];
        tybeBu.tag = i - 1;
        [tybeBu setTitleColor:[UIColor colorWithHexString:@"#2ab6f4"] forState:UIControlStateSelected];
        [tybeBu setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [tybeView addSubview:tybeBu];
    }
    
    [self.view addSubview:tybeView];
}


- (void)tybeSearch:(UIButton *)bu
{
#pragma 改变当前 button 颜色,其他保持原状
    currentButton.selected = NO;
    currentButton = bu;
    currentButton.selected  = YES;
    
    self.HFIndex = bu.tag;
    [self searchDownData];
}

- (void)initTableView
{
    TabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, MaxY(tybeView), WIDTH(self.view), HEIGHT(self.view) - HEIGHT(tybeView) - 64) style:UITableViewStylePlain];
    NSLog(@"%f,%f,%f,%f",X(TabelView),Y(TabelView),WIDTH(TabelView),HEIGHT(TabelView));
    TabelView.delegate = self;
    TabelView.dataSource = self;
    TabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:TabelView];
}

- (void)searchDownData
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    if (self.HFIndex >= 0) {
        switch (self.HFIndex) {
            case 0:
                dic[@"type"] = @"1";
                break;
            case 1:
                dic[@"type"] = @"2";
                break;
            case 2:
                dic[@"type"] = @"3";
                break;
            case 3:
                nil;
                break;
            default:
                break;
        }

    }
    dic[@"keyWord"] = self.HFKeyWords;
    
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:FRIEND_SEARCH parameter:dic success:^(id response) {
        
        [_dataArray removeAllObjects];
        [_isfriendArr removeAllObjects];
        NSArray * arr = response;
        if (arr.count > 0) {
            for (NSDictionary * dic in arr) {
                
                NSNumber * isF = [dic objectForKey:@"isFriends"];
                
                QCFriendAccout * model = [[QCFriendAccout alloc] init];
                model = [QCFriendAccout objectWithKeyValues:dic];
                model.isFriend = isF;
                [_dataArray addObject:model];
                [_isfriendArr addObject:isF];
            }
        }
        else
        {
            [OMGToast showText:@"没有搜索到相关的内容!"];
            [TabelView reloadData];
            [MBProgressHUD hideHUD];
            return ;
        }
        
        [TabelView reloadData];
        [MBProgressHUD hideHUD];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [MBProgressHUD hideHUD];
        [TabelView reloadData];
    }];
};

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count > 0) {
        return _dataArray.count;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QCHFTheUserCell * cell = [QCHFTheUserCell QCHFTheUserCell:TabelView];
    cell.chatLine.hidden = YES;
    if (_dataArray.count > 0) {
        QCFriendAccout * models = _dataArray[indexPath.row];
        [cell.avatarUrlImage sd_setImageWithURL:[NSURL URLWithString:models.avatarUrl] placeholderImage:[UIImage imageNamed:@"ios-template-120(1)"]];
        if (models.sex==0) {
            cell.theSexIge.image=[UIImage imageNamed:@"found_icon_man"];
            
        }else if(models.sex==1){
            cell.theSexIge.image=[UIImage imageNamed:@"LJ_con_woman"];
            
            
        }
        if (models.age==nil) {
            cell.age.text=@"0岁";
        }else{
            cell.age.text=[NSString stringWithFormat:@"%@岁",models.age];
        }

        cell.nicknameLabel.text = models.nickname;
        if ([_isfriendArr[indexPath.row] boolValue]) {
            cell.isFriendBu.selected = YES;
        }
        else
        {
            cell.isFriendBu.selected = NO;
        }
        cell.isFriendBu.tag = indexPath.row;
        
        if (models.marks.length > 0) {
            NSArray * markArr = [models.marks componentsSeparatedByString:@","];
            
            if (markArr.count > 2) {
                cell.marksLabel1.text = markArr[markArr.count-1];
                cell.marksLabel2.text = markArr[markArr.count-2];
                cell.marksLabel3.text = markArr[markArr.count-3];
            }
            else if (markArr.count > 1)
            {
                cell.marksLabel1.text = markArr[markArr.count-1];
                cell.marksLabel2.text = markArr[markArr.count-2];
            }
            else
            {
                cell.marksLabel1.text = markArr[0];
            }
            
            if (cell.marksLabel1.text.length < 1) {
                cell.markView1.hidden = YES;
            }
            if (cell.marksLabel2.text.length < 1) {
                cell.markView2.hidden = YES;
            }
            if (cell.marksLabel3.text.length < 1) {
                cell.markView3.hidden = YES;
            }
        }
        else
        {
            cell.markView1.hidden = YES;
            cell.markView2.hidden = YES;
            cell.markView3.hidden = YES;
        }
        
        [cell.isFriendBu actionButton:^(UIButton *sender){
#pragma -mark 根据判断数组,获取对应的 BOOL 值
            isFriends = [_isfriendArr[cell.isFriendBu.tag] boolValue];
            
            if (isFriends)
            {
                [self isfriendRemoveAction:models button:cell.isFriendBu];
            }
            else
            {
                [self isfriendAddAction:models button:cell.isFriendBu];
            }
            
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QCUserViewController2*user=[[QCUserViewController2 alloc]init];
    QCFriendAccout*um=self.dataArray[indexPath.row] ;
    user.uid =[um.uid longLongValue];
    user.isFriend=[_isfriendArr[indexPath.row] boolValue];
    [self.navigationController pushViewController:user animated:YES];
}

#pragma -mark 关注
- (void)isfriendAddAction:(QCFriendAccout *)model button:(UIButton *)bu
{
    NSMutableDictionary * dics = [NSMutableDictionary dictionary];
    dics[@"destUids"] = model.uid;
    
    bu.selected = YES;
    isFriends = YES;
#pragma -mark 一旦 BOOL 值有改变,通过 button的 tag标记数组里对应的下标进行替换数组的元素
    [_isfriendArr replaceObjectAtIndex:bu.tag withObject:[NSNumber numberWithBool:isFriends]];
    
    [NetworkManager requestWithURL:FRIEND_ADD parameter:dics success:^(id response) {
//        [self searchDownData];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        NSLog(@"错误信息%@",error);
    }];
}

#pragma -mark 取消关注
- (void)isfriendRemoveAction:(QCFriendAccout *)model button:(UIButton *)bu
{
    NSMutableDictionary * dics = [NSMutableDictionary dictionary];
    dics[@"destUids"] = model.uid;
    
    bu.selected = NO;
    isFriends = NO;
    [_isfriendArr replaceObjectAtIndex:bu.tag withObject:[NSNumber numberWithBool:isFriends]];
    [NetworkManager requestWithURL:FRIEND_REMOVEFOCUS parameter:dics success:^(id response) {
//        [self searchDownData];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        NSLog(@"错误信息%@",error);
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
