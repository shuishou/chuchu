//
//  QCSearchFriendViewController.m
//  MyQOOCOO
//
//  Created by wzp on 15/9/29.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCSearchFriendVC.h"

#import "QCFriendAccout.h"
#import "QCHFTheUserCell.h"

#import "QCUserViewController2.h"
@interface QCSearchFriendVC ()<UITextFieldDelegate>
{
    UITextField * field;
    UITableView * TabelView;
}
/**关键字*/
@property (strong, nonatomic) NSString * HFKeyWords;
/**数据*/
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) NSMutableArray * isfriendArr;
@end

@implementation QCSearchFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    self.isfriendArr = [NSMutableArray array];
//    self.tableView.frame = CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view));
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    // Do any additional setup after loading the view.
////    self.tableView.userInteractionEnabled = YES;
////    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
////    [self.tableView addGestureRecognizer:taps];

    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    // white.png图片自己下载个纯白色的色块，或者自己ps做一个
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"navBackGround"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    
    [self searchTextfiled];
    [self initTableView];
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

- (void)initTableView
{
    TabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view)) style:UITableViewStylePlain];
    NSLog(@"%f,%f,%f,%f",X(TabelView),Y(TabelView),WIDTH(TabelView),HEIGHT(TabelView));
    TabelView.delegate = self;
    TabelView.dataSource = self;
    TabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:TabelView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)searchDataED:(UITextField *)fields
{
    self.HFKeyWords = field.text;
    [self DownLoadData];
}

- (void)DownLoadData
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
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
                model = [QCFriendAccout mj_objectWithKeyValues:dic];
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

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArray.count > 0) {
        return _dataArray.count;
    }
    else
    {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QCHFTheUserCell * cell = [QCHFTheUserCell QCHFTheUserCell:TabelView];
    cell.isFriendBu.hidden = YES;
    cell.chatLine.hidden = YES;
    if (_dataArray.count > 0) {
        QCFriendAccout * model = _dataArray[indexPath.row];
        if (model.sex ==0) {
            cell.theSexIge.image=[UIImage imageNamed:@"found_icon_man"];
            
        }else if(model.sex ==1){
            cell.theSexIge.image=[UIImage imageNamed:@"LJ_con_woman"];
            
            
        }
        if (model.age==nil) {
            cell.age.text=@"0岁";
        }else{
            cell.age.text=[NSString stringWithFormat:@"%@岁",model.age];
        }

        cell.nicknameLabel.text = model.nickname;
        [cell.avatarUrlImage sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:[UIImage imageNamed:@"ios-template-120(1)"]];
        if (model.marks.length > 0) {
            NSArray * markArr = [model.marks componentsSeparatedByString:@","];
            
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

    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QCUserViewController2*user=[[QCUserViewController2 alloc]init];
    QCFriendAccout*um=self.dataArray[indexPath.row] ;
    user.uid =[um.uid longLongValue];
    user.isFriend=[_isfriendArr[indexPath.row] boolValue];
    [self.navigationController pushViewController:user animated:YES];
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
