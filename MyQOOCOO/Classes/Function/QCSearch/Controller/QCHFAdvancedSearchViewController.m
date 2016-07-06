//
//  QCHFAdvancedSearchViewController.m
//  MyQOOCOO
//
//  Created by Wind on 15/12/21.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCHFAdvancedSearchViewController.h"
#import "HFSearchFriendListVc.h"
#import "QCHFASViewController.h"

#import "User.h"
#import "QCPersonal_dataModel.h"
#import "QCASTVCell.h"

#import "QCHFUserModel.h"
@interface QCHFAdvancedSearchViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>
{
    UITableView * tableViews;
    UITableView * markTableV;
    NSString * HFUid;
    UIView * headerView;
    UIView * markView;
    UIView * searchMarkView;
    UIView * footViews;
    NSString * HFText;
    UIView * markGroupView;
    UIView * searchV;
    UITextField * textfileds;
    //大类选择切换
    BOOL isSearch;
    
    BOOL isDelete;
}
/**用户资料*/
@property (strong, nonatomic) LoginSession *sessions;
/**用户标签大类*/
@property (strong, nonatomic) NSMutableArray * marksDataArray;
/**用户标签*/
@property (strong, nonatomic) NSMutableArray * markArr;
@property (strong, nonatomic) NSMutableArray * addMarkArr;
/**所有大类*/
@property (strong, nonatomic) NSMutableArray * groupMarksArr;
@end

@implementation QCHFAdvancedSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _sessions = [[ApplicationContext sharedInstance] getLoginSession];
    _marksDataArray = [NSMutableArray array];
    _markArr = [NSMutableArray array];
    _addMarkArr = [NSMutableArray array];
    _groupMarksArr = [NSMutableArray array];
    NSString * str = @"全部";
    [_groupMarksArr addObject:str];
    isSearch = NO;
    isDelete = NO;
    
    [self initTableView];
    [self initGetMarkGroup];
    [self initFootdeView];
//    [self initMarksGroup];
//    markGroupView.hidden = YES;
    
//    UIBarButtonItem * AdvancedSearchBar =[[UIBarButtonItem alloc]initWithTitle:@"高级搜索" style:UIBarButtonItemStylePlain target:self action:@selector(AdvancedSearch:)];
//    self.navigationItem.rightBarButtonItem = AdvancedSearchBar;
    
    //监听键盘弹出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowNotificationds:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardRemoves:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)AdvancedSearch:(UIBarButtonItem *)bar
{
    QCHFASViewController * vc = [[QCHFASViewController alloc] init];
    vc.title = @"高级搜索";
    [self.navigationController pushViewController:vc animated:YES];
}

//键盘将要弹出的方法
-(void)keyBoardWillShowNotificationds:(NSNotification *)not
{
    
    //获取键盘高度
    NSDictionary *dic = not.userInfo;
    //获取坐标
    CGRect rc = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //键盘高度
    CGFloat f = rc.size.height;
    
    //调整输入框的位置
    [UIView animateWithDuration:0.1 animations:^{
        footViews.frame = CGRectMake(0, self.view.frame.size.height-f-HEIGHT(footViews), WIDTH(footViews), WIDTH(self.view)/8);
    }];
}

//键盘消失的方法
-(void)keyBoardRemoves:(NSNotification *)not
{
    //调整输入框的位置
    [UIView animateWithDuration:0.1 animations:^{
        footViews.frame = CGRectMake(0, HEIGHT(self.view)-WIDTH(self.view)/8, WIDTH(footViews), WIDTH(self.view)/8);
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //回收键盘
    [textField  resignFirstResponder];
    return YES;
}


- (void)initTableView
{
    tableViews = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view)-WIDTH(self.view)/8) style:UITableViewStylePlain];
    tableViews.delegate = self;
    tableViews.dataSource = self;
    tableViews.bounces = NO;
    tableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViews.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    
    [self.view addSubview:tableViews];
}

#pragma mark - 添加标签
- (void)initFootdeView
{
    footViews = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT(self.view)-WIDTH(self.view)/8, WIDTH(self.view), WIDTH(self.view)/8)];
    footViews.backgroundColor = [UIColor whiteColor];
    textfileds = [[UITextField alloc] initWithFrame:CGRectMake(6, 6, WIDTH(footViews)*3/4-12, HEIGHT(footViews)-12)];
    textfileds.font = [UIFont systemFontOfSize:HEIGHT(textfileds)/2];
    [textfileds setValue:[UIColor colorWithHexString:@"999999"] forKeyPath:@"_placeholderLabel.textColor"];
    textfileds.textColor = [UIColor colorWithHexString:@"333333"];
    textfileds.placeholder = @"请输入标签内容";
    textfileds.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    textfileds.layer.masksToBounds = YES;
    textfileds.layer.cornerRadius = 6;
    textfileds.delegate = self;
    [textfileds addTarget:self action:@selector(addMarks:) forControlEvents:UIControlEventEditingChanged];
    [footViews addSubview:textfileds];
    
    
    UIButton * bu = [UIButton buttonWithType:UIButtonTypeCustom];
    bu.frame = CGRectMake(MaxX(textfileds)+8, Y(textfileds), WIDTH(footViews)-WIDTH(textfileds)-25, HEIGHT(textfileds));
    bu.backgroundColor = kLoginbackgoundColor;
    [bu setTitle:@"添加标签" forState:UIControlStateNormal];
    bu.layer.masksToBounds = YES;
    bu.layer.cornerRadius = 6;
    bu.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(bu)/2];
    [bu actionButton:^(UIButton *sender) {
        if (HFText.length > 0) {
            
            [self initAddMarks];
        }else
        {
            [self.view endEditing:YES];
            [OMGToast showText:@"请输入标签内容"];
        }
    }];
    [footViews addSubview:bu];
    
    UIImageView * line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(footViews), 0.5)];
    line1.backgroundColor = [UIColor colorWithHexString:@"999999"];
    [footViews addSubview:line1];
    
    UIImageView * line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT(footViews)-0.5, WIDTH(footViews), 0.5)];
    line2.backgroundColor = [UIColor colorWithHexString:@"999999"];
    [footViews addSubview:line2];
    
    [self.view addSubview:footViews];
}

- (void)addMarks:(UITextField *)field
{
    HFText = field.text;
}

#pragma -mark 添加标签
- (void)initAddMarks
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"title"] = HFText;
    for (NSDictionary *dict in _addMarkArr) {
        if ([dict[@"title"] isEqualToString:dic[@"title"]]) {
            [OMGToast showText:@"已存在相同标签"];
            return ;
        }
    }
    [_addMarkArr addObject:dic];
    textfileds.text = nil;
    [tableViews reloadData];
    [self.view endEditing:YES];
}

#pragma -mark 获取标签大类
- (void)initGetMarkGroup
{
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"uid"] = [NSString stringWithFormat:@"%ld", _sessions.user.uid];
    
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:USERINFO_GETMARKGROUP parameter:dic success:^(id response) {
        NSArray * arr = response;
        
        if (arr.count > 0) {
            for (NSDictionary * dic in arr) {
                QCPersonal_dataModel * model = [[QCPersonal_dataModel alloc] init];
                model = [QCPersonal_dataModel mj_objectWithKeyValues:dic];\
                model.Id = dic[@"id"];
                [_marksDataArray addObject:model];
                [_groupMarksArr addObject:model.title];
            }
            [self initHeaderView];
            [MBProgressHUD hideHUD];
        }
        else
        {
            [MBProgressHUD hideHUD];
            return ;
        }
        
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}

#pragma -mark 标签大类
- (void)initHeaderView
{
    int HFHeghts1;
    
    if (_marksDataArray.count%4 == 0) {
        HFHeghts1 = (int)_marksDataArray.count/4;
    }
    else
    {
        HFHeghts1 = (int)_marksDataArray.count/4+1;
    }
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, WIDTH(self.view), (WIDTH(self.view)/13+7)*HFHeghts1+7)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 1; i < _marksDataArray.count+1; i++) {
        
        UILabel * markLabel = [[UILabel alloc] init];
        markLabel.frame = CGRectMake(WIDTH(headerView)/4*((i-1)%4)+6, (HEIGHT(headerView)-7)/HFHeghts1*((i-1)/4)+7, WIDTH(headerView)/4-12, WIDTH(headerView)/13);
        markLabel.font = [UIFont systemFontOfSize:HEIGHT(markLabel)/2];
        markLabel.textColor = RandomColor;
        markLabel.textAlignment = NSTextAlignmentCenter;
        markLabel.layer.borderWidth = 0.5;
        markLabel.layer.borderColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1].CGColor;
        markLabel.layer.masksToBounds = YES;
        markLabel.layer.cornerRadius = 5;
        
        QCPersonal_dataModel * model = _marksDataArray[i-1];
        markLabel.text = model.title;
        markLabel.userInteractionEnabled = YES;
        markLabel.tag = i-1;
        
        UITapGestureRecognizer * HFMarkTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MarkedTap:)];
        [markLabel addGestureRecognizer:HFMarkTap];
        
        [headerView addSubview:markLabel];
    }
    
    UIView * heView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(headerView)+8)];
    heView.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255  blue:241.0/255  alpha:1];
    [heView addSubview:headerView];
    
    tableViews.tableHeaderView = heView;
}

#pragma mark - 通过标签大类获取标签
- (void)MarkedTap:(UITapGestureRecognizer *)tap
{
    QCPersonal_dataModel * model = self.marksDataArray[tap.view.tag];
    _markArr = model.userMarks;
    
    int HFHeghts;
    if (_marksDataArray.count%4 == 0) {
        HFHeghts = (int)model.userMarks.count/4;
    }else{
        HFHeghts = (int)model.userMarks.count/4+1;
    }
    markView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, WIDTH(self.view)-16, ((WIDTH(self.view)/13+7)*HFHeghts+7))];
    markView.backgroundColor = [UIColor whiteColor];
    markView.layer.masksToBounds = YES;
    markView.layer.cornerRadius = 5;
    
    for (int i = 1; i < model.userMarks.count+1; i++) {
        
        UILabel * markLabel = [[UILabel alloc] init];
        markLabel.frame = CGRectMake(WIDTH(markView)/4*((i-1)%4)+6, (HEIGHT(markView)-7)/HFHeghts*((i-1)/4)+7, WIDTH(markView)/4-12, WIDTH(markView)/13);
        markLabel.font = [UIFont systemFontOfSize:HEIGHT(markLabel)/2];
        markLabel.textColor = RandomColor;
        markLabel.textAlignment = NSTextAlignmentCenter;
        markLabel.layer.borderWidth = 0.5;
        markLabel.layer.borderColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1].CGColor;
        markLabel.layer.masksToBounds = YES;
        markLabel.layer.cornerRadius = 5;
        
        NSDictionary * dic = model.userMarks[i-1];
        markLabel.text = dic[@"title"];
        markLabel.userInteractionEnabled = YES;
        markLabel.tag = i-1;
        
        UITapGestureRecognizer * HFMarksTaps =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MarkedTaps:)];
        [markLabel addGestureRecognizer:HFMarksTaps];
        
        [markView addSubview:markLabel];
    }
    
    [tableViews reloadData];
}

#pragma mark 根据标签搜索
- (void)MarkedTaps:(UITapGestureRecognizer *)tap
{
    NSDictionary * dic = _markArr[tap.view.tag];
    for (NSDictionary *dict in _addMarkArr) {
        if ([dict[@"title"] isEqualToString:dic[@"title"]]) {
            [OMGToast showText:@"已存在相同标签"];
            return ;
        }
    }
    [_addMarkArr addObject:dic];
    [tableViews reloadData];
}

- (void)initSearchMark1
{
    searchV = [[UIView alloc] initWithFrame:CGRectMake(0, 8, WIDTH(self.view), ((WIDTH(self.view)/13+7)+7)*2/3)];
    searchV.backgroundColor = [UIColor whiteColor];
    
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT(searchV)-1, WIDTH(self.view), 1)];
    line.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [searchV addSubview:line];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(8, HEIGHT(searchV)/2-HEIGHT(searchV)/4, 4*(HEIGHT(searchV)/2), HEIGHT(searchV)/2)];
    label.text = @"已选标签";
    label.font = [UIFont systemFontOfSize:HEIGHT(label)];
    label.textColor = [UIColor colorWithHexString:@"999999"];
    [searchV addSubview:label];
    
    UIButton * searchBu = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBu.frame = CGRectMake(MaxX(searchV)-HEIGHT(label)*5, Y(label), 5*HEIGHT(label), HEIGHT(label));
    [searchBu setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBu setTitleColor:[UIColor colorWithHexString:@"#2ab6f4"] forState:UIControlStateNormal];
    searchBu.titleLabel.font = [UIFont systemFontOfSize:HEIGHT(searchBu)];
    [searchBu actionButton:^(UIButton *sender) {
        
        if (_addMarkArr.count>0) {
            isSearch = YES;
            [self initMarksGroup];
        }
        else
        {
            [OMGToast showText:@"请选择标签"];
        }
        
    }];;
    [searchV addSubview:searchBu];
    
    [self initSearchMark2];
}

- (void)initSearchMark2
{
    int HFHeghts;
    
    if (_addMarkArr.count%4 == 0) {
        HFHeghts = (int)_addMarkArr.count/4;
    }
    else
    {
        HFHeghts = (int)_addMarkArr.count/4+1;
    }
    UIView * markVs = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(searchV), WIDTH(self.view), ((WIDTH(self.view)/13+7)*HFHeghts+7))];
    markVs.backgroundColor = [UIColor whiteColor];
    
    if (isDelete) {
        UITapGestureRecognizer * cancelDeleteTaps =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelDeleteMarksTaped:)];
        [self.view addGestureRecognizer:cancelDeleteTaps];
        
        for (int i = 1; i < _addMarkArr.count+1; i++) {
            
            UILabel * markLabel = [[UILabel alloc] init];
            markLabel.frame = CGRectMake(WIDTH(markVs)/4*((i-1)%4)+6, (HEIGHT(markVs)-7)/HFHeghts*((i-1)/4)+7, WIDTH(markVs)/4-12, WIDTH(markVs)/13);
            markLabel.font = [UIFont systemFontOfSize:HEIGHT(markLabel)/2];
            markLabel.textColor = RandomColor;
            markLabel.textAlignment = NSTextAlignmentCenter;
            markLabel.layer.borderWidth = 0.5;
            markLabel.layer.borderColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1].CGColor;
            markLabel.layer.masksToBounds = YES;
            markLabel.layer.cornerRadius = 5;
            
            NSDictionary * dic = _addMarkArr[i-1];
            markLabel.text = dic[@"title"];
            markLabel.userInteractionEnabled = YES;
            markLabel.tag = i-1;
#pragma -mark 轻点删除
            UITapGestureRecognizer * deleteMarksTaps =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteMarksTaps:)];
            [markLabel addGestureRecognizer:deleteMarksTaps];
            
            [markVs addSubview:markLabel];
            
            UIImageView * deImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(markLabel)-13, -2, 15, 15)];
            [deImage setImage:[UIImage imageNamed:@"but_deletelatel"]];
            [markLabel addSubview:deImage];
        }
    }
    else
    {
        for (int i = 1; i < _addMarkArr.count+1; i++) {
            
            UILabel * markLabel = [[UILabel alloc] init];
            markLabel.frame = CGRectMake(WIDTH(markVs)/4*((i-1)%4)+6, (HEIGHT(markVs)-7)/HFHeghts*((i-1)/4)+7, WIDTH(markVs)/4-12, WIDTH(markVs)/13);
            markLabel.font = [UIFont systemFontOfSize:HEIGHT(markLabel)/2];
            markLabel.textColor = RandomColor;
            markLabel.textAlignment = NSTextAlignmentCenter;
            markLabel.layer.borderWidth = 0.5;
            markLabel.layer.borderColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1].CGColor;
            markLabel.layer.masksToBounds = YES;
            markLabel.layer.cornerRadius = 5;
            
            NSDictionary * dic = _addMarkArr[i-1];
            markLabel.text = dic[@"title"];
            markLabel.userInteractionEnabled = YES;
            markLabel.tag = i-1;
            
#pragma -mark 长按删除
            UILongPressGestureRecognizer *longPressGestured = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressBtns:)];
            [longPressGestured setDelegate:self];
            //允许15秒中运动
            longPressGestured.allowableMovement=NO;
            //所需触摸1次
            longPressGestured.numberOfTouchesRequired=1;
            longPressGestured.minimumPressDuration=0.5;//默认0.5秒
            [markLabel addGestureRecognizer:longPressGestured];
            
            [markVs addSubview:markLabel];
        }
    }
    
    
    searchMarkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(searchV)+HEIGHT(markVs))];
    [searchMarkView addSubview:searchV];
    [searchMarkView addSubview:markVs];
}

#pragma -mark 长按触发删除
-(void)longPressBtns:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        //长按事件开始"
        //do something
        
    }
    else if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        //长按事件结束
        //do something
        isDelete = YES;
        [tableViews reloadData];
    }
}

#pragma -mark 删除添加的标签
- (void)deleteMarksTaps:(UITapGestureRecognizer *)tap
{
    [_addMarkArr removeObjectAtIndex:tap.view.tag];
    [tableViews reloadData];
}

#pragma -mark 点击空白处取消删除状态
- (void)cancelDeleteMarksTaped:(UITapGestureRecognizer *)taps
{
    isDelete = NO;
    [tableViews reloadData];
}

#pragma -mark 搜索时产生选择大类
- (void)initMarksGroup
{
    markGroupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view))];
    markGroupView.backgroundColor = kColorRGBA(52,52,52,0.3);
    markGroupView.userInteractionEnabled = YES;
    [self.navigationController.view addSubview:markGroupView];
    
    markTableV = [[UITableView alloc] initWithFrame:CGRectMake(30, (HEIGHT(markGroupView)-HEIGHT(markGroupView)/2)/2, WIDTH(markGroupView)-60, HEIGHT(markGroupView)/2-10) style:UITableViewStylePlain];
    markTableV.delegate = self;
    markTableV.dataSource = self;
    markTableV.bounces = NO;
    markTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    markTableV.backgroundColor = [UIColor whiteColor];
    [markGroupView addSubview:markTableV];
    
    
    UIView * heView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(markTableV), WIDTH(self.view)/9)];
    heView.backgroundColor = [UIColor whiteColor];
    UIImageView * cancelImaage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(heView)-HEIGHT(heView)/2-16, HEIGHT(heView)/2-(HEIGHT(heView)/2)/2, HEIGHT(heView)/2, HEIGHT(heView)/2)];
    cancelImaage.image = [UIImage imageNamed:@"deletes"];
    cancelImaage.userInteractionEnabled = YES;
    [heView addSubview:cancelImaage];
    
    UITapGestureRecognizer * cancelTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelTap:)];
    [heView addGestureRecognizer:cancelTap];
    UITapGestureRecognizer * cancelTaps =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelTap:)];
    [cancelImaage addGestureRecognizer:cancelTaps];
    
    markTableV.tableHeaderView = heView;

}

- (void)cancelTap:(UITapGestureRecognizer *)taps
{
    isSearch = NO;
    [markGroupView removeFromSuperview];
}

#pragma -mark tabledelete
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isSearch) {
        return 1;
    }
    else
    {
        return 2;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearch) {
        return _marksDataArray.count;
    }
    else
    {
       return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (isSearch) {
        QCASTVCell * cells = [QCASTVCell QCASTVCell:markTableV];

        cells.groupMarksLabel.text = _groupMarksArr[indexPath.row];
        
        return cells;
    }
    else
    {
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.contentView.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 0) {
            if (_markArr.count > 0) {
                [cell.contentView addSubview:markView];
                return cell;
            }
            else
            {
                return cell;
            }
        }
        else
        {
            [self initSearchMark1];
            [cell.contentView addSubview:searchMarkView];
            return cell;
        }

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSearch) {
        return WIDTH(self.view)/8;
    }
    else
    {
        if (indexPath.section == 0) {
            if (_markArr.count > 0) {
                return HEIGHT(markView)+8;
            }
            else
            {
                return 0;
            }
        }
        else
        {
            return HEIGHT(searchMarkView)+8;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSearch) {
        NSString * titleStr = _groupMarksArr[indexPath.row];
        int type;
        
        if ([titleStr isEqualToString:@"基本信息"]) {
            type = 1;
        }
        else if ([titleStr isEqualToString:@"交友标签"])
        {
            type = 2;
        }
        else if ([titleStr isEqualToString:@"粉丝标签"])
        {
            type = 3;
        }
        else if ([titleStr isEqualToString:@"派活"])
        {
            type = 4;
        }
        else if ([titleStr isEqualToString:@"接活"])
        {
            type = 5;
        }
        else
        {
            type = 0;
        }
        
        [self initSearchByMarks:[NSString stringWithFormat:@"%d", type]];
    }
}

#pragma -mark 搜索
- (void)initSearchByMarks:(NSString *)type
{
    NSMutableArray * arr = [NSMutableArray array];
    for (NSDictionary * dic in _addMarkArr) {
        [arr addObject:dic[@"title"]];
    }
    
    NSString * marks  = [arr componentsJoinedByString:@","];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"marks"] = marks;
    if (![type isEqualToString:@"0"]) {
        dic[@"type"] = type;
    }
    
    [NetworkManager requestWithURL:FRIEND_SEARCHBYMARK parameter:dic success:^(id response) {
        NSArray * arr = response;
        NSMutableArray * dataArrs = [NSMutableArray array];
        NSMutableArray * isfriendArr = [NSMutableArray array];
        if (arr.count > 0) {
            if (arr.count > 0) {
                for (NSDictionary * dic in arr) {
                    
                    NSNumber * isF = [dic objectForKey:@"isFriends"];
                    
                    QCHFUserModel * model = [[QCHFUserModel alloc] init];
                    model = [QCHFUserModel mj_objectWithKeyValues:dic];
                    model.isFriends = [NSString stringWithFormat:@"%@", isF];
                    [dataArrs addObject:model];
                    [isfriendArr addObject:isF];
                }
            }
            HFSearchFriendListVc * vc = [[HFSearchFriendListVc alloc] init];
            vc.isAn = @1;
            vc.dataArray = dataArrs;
            vc.isfriendArr = isfriendArr;
            vc.title = @"搜素结果";
            isSearch = NO;
            [markGroupView removeFromSuperview];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [OMGToast showText:@"没有找到相同标签的人"];
        }
        [self.view endEditing:YES];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [OMGToast showText:@"数据加载出错"];
    }];
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
