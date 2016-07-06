//
//  QCAKeyToReplyVC.m
//  MyQOOCOO
//
//  Created by Wind on 15/12/30.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCAKeyToReplyVC.h"
#import "QCHFAddReplyVC.h"
#import "ChatSendHelper.h"

@interface QCAKeyToReplyVC ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    UITableView * tableViews;
    UIView * deleteView;
    UIView * titleView;
}
/**快捷回复数据*/
@property (strong, nonatomic) NSMutableArray * replyDataArray;
@end

@implementation QCAKeyToReplyVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initGetReplyData];
    if (!tableViews) {
        [self initTableView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _replyDataArray = [NSMutableArray array];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addReplys:)];
    
    
}

- (void)initTableView
{
    tableViews = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view)) style:UITableViewStylePlain];
    tableViews.delegate = self;
    tableViews.dataSource = self;
    tableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:tableViews];
}

#pragma -mark 获取快捷回复
- (void)initGetReplyData
{
    [_replyDataArray removeAllObjects];
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:GETREPLY parameter:nil success:^(id response) {
        CZLog(@"%@", response);
        NSArray * arr = response;
        
        if (arr.count > 0) {
            [_replyDataArray addObjectsFromArray:arr];
            [tableViews reloadData];
            [MBProgressHUD hideHUD];
        }
        else
        {
            [tableViews reloadData];
            [MBProgressHUD hideHUD];
            return ;
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [MBProgressHUD hideHUD];
    }];
}

- (void)addReplys:(UIBarButtonItem *)bar
{
    QCHFAddReplyVC * vc = [[QCHFAddReplyVC alloc] init];
    vc.title = @"添加快速回复";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _replyDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"QCAKeyToReplyVCId";
    
    UIImageView * images;
    UITableViewCell * cell = [tableViews dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, WIDTH(self.view)/9-0.5, WIDTH(self.view), 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"999999"];
        [cell.contentView addSubview:line];
        
        images = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self.view)-(WIDTH(self.view)/9)*2/3 - 15, (WIDTH(self.view)/9)/2 - ((WIDTH(self.view)/9)*2/3)/2, (WIDTH(self.view)/9)*2/3, (WIDTH(self.view)/9)*2/3)];
        [cell.contentView addSubview:images];
        
        cell.textLabel.font = [UIFont systemFontOfSize:(WIDTH(self.view)/9)*2/5];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    
//    UIColor *color = [UIColor blueColor];//通过RGB来定义自己的颜色
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"2ab6f4"];
    
    if (_replyDataArray.count > 0) {
        NSDictionary * dic = _replyDataArray[indexPath.row];
        cell.textLabel.text = dic[@"content"];
        
        NSString * imUrl = dic[@"url"];
        if (imUrl.length > 0) {
           
            [images sd_setImageWithURL:[NSURL URLWithString:imUrl]];
            
        }
        
    }
    
    cell.contentView.tag = indexPath.row;
    
#pragma -mark 长按删除
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleteReply:)];
    [longPressGesture setDelegate:self];
    //允许15秒中运动
    longPressGesture.allowableMovement=NO;
    //所需触摸1次
    longPressGesture.numberOfTouchesRequired=1;
    longPressGesture.minimumPressDuration=0.5;//默认0.5秒
    [cell.contentView addGestureRecognizer:longPressGesture];
    
    return cell;
}

- (void)deleteReply:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        //长按事件开始"
        //do something
        
    }
    else if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        //长按事件结束
        //do something
        
        [self initDeleteReply:gestureRecognizer.view.tag];
    }
}

- (void)initDeleteReply:(NSInteger)indexs
{
    deleteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view))];
    deleteView.backgroundColor = kColorRGBA(52,52,52,0.3);
    deleteView.userInteractionEnabled = YES;
    [self.navigationController.view addSubview:deleteView];
    
    titleView = [[UIView alloc] initWithFrame:CGRectMake(30, (HEIGHT(deleteView)-HEIGHT(deleteView)/3)/2, WIDTH(deleteView)-60, HEIGHT(deleteView)/3)];
    titleView.backgroundColor = [UIColor whiteColor];
    [deleteView addSubview:titleView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH(titleView), HEIGHT(titleView)/5)];
    label.text = @"删除";
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
        
        [deleteView removeFromSuperview];
        
    }];
    [titleView addSubview:cancelBu];
    
    UIButton * doneBu = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBu.frame = CGRectMake(MaxX(cancelBu), Y(cancelBu), WIDTH(cancelBu), HEIGHT(cancelBu));
    [doneBu.titleLabel setFont:[UIFont systemFontOfSize:HEIGHT(doneBu)*2/5]];
    [doneBu setTitle:@"确定" forState:UIControlStateNormal];
    [doneBu setTitleColor:[UIColor colorWithHexString:@"#2ab6f4"] forState:UIControlStateNormal];
    [doneBu actionButton:^(UIButton *sender) {
        
        NSDictionary * dic = _replyDataArray[indexs];
        
        [self initDeleteReplyData:dic[@"id"]];
        
    }];
    [titleView addSubview:doneBu];
    
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT(titleView)-HEIGHT(cancelBu)-0.5, WIDTH(titleView), 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"E0E0E0"];
    [titleView addSubview:line];
    
    
    //#pragma -mark 轻点消失
    //    UITapGestureRecognizer * dismissTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissTap:)];
    //    [deleteView addGestureRecognizer:dismissTap];
}

- (void)initDeleteReplyData:(NSString *)Id
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"replyId"] = Id;
    
    [NetworkManager requestWithURL:DELETEREPLY parameter:dic success:^(id response) {
        
        [deleteView removeFromSuperview];
        [self initGetReplyData];
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WIDTH(self.view)/9;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (_replyDataArray.count > 0) {
        NSDictionary * dic = _replyDataArray[indexPath.row];
//        cell.textLabel.text = dic[@"content"];
        
        NSMutableDictionary * dicRe = [NSMutableDictionary dictionary];
        NSString * imUrl = dic[@"url"];
        if (imUrl.length > 0) {
            UIImageView * images = [UIImageView new];
            [images sd_setImageWithURL:[NSURL URLWithString:imUrl] placeholderImage:[UIImage imageNamed:@"ios-template-1024"]];
            
            dicRe[@"image"] = images.image;
        }
        
        NSString * str = dic[@"content"];
        dicRe[@"content"] = str;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendReplyImageAndMessage" object:dicRe];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
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
