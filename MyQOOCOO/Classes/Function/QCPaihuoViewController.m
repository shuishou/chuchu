//
//  QCPaihuoViewController.m
//  MyQOOCOO
//
//  Created by lanou on 15/12/11.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCPaihuoViewController.h"
#import "QCHFTheUserCell.h"
#import "QCFriendAccout.h"
#import "QCHFUserModel.h"
#import "QCUserViewController2.h"

@interface QCPaihuoViewController ()

@property(nonatomic,strong)UILabel *topLabel;

@end

@implementation QCPaihuoViewController
{
    BOOL isFriends;
    UITableView * TabelView;
    UITextField*tf;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    if (self.type == 4) {
         self.topLabel.text = @"以下的人可能帮你干活";
    }else{
         self.topLabel.text = @"以下的人可能给你活干";
    }
        [self getDatas];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isfriendArr = [NSMutableArray array];
    self.navigationItem.title = @"我要派活";
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    UIView*topv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    topv.backgroundColor=RGBA_COLOR(237, 237, 237, 1);
    [self.view addSubview:topv];
    
    tf=[[UITextField alloc]initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-70, 40)];
    tf.placeholder = @"  搜索";
    tf.layer.cornerRadius=5;
    tf.delegate=self;
    tf.returnKeyType =UIReturnKeySearch;
    tf.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:tf];

    //    返回按钮
    UIButton*backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitleColor:RGBA_COLOR(233, 77, 79, 1) forState:UIControlStateNormal];
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
   // backBtn.backgroundColor=[UIColor redColor];
    backBtn.font=[UIFont systemFontOfSize:14];
    backBtn.frame=CGRectMake(self.view.frame.size.width-60, 30, 60, 40);
    [backBtn addTarget:self action:@selector(backBtnCliack) forControlEvents:UIControlEventTouchUpInside];
    [topv addSubview:backBtn];

    
    TabelView=[[UITableView alloc]initWithFrame:CGRectMake(0,110,self.view.frame.size.width,self.view.frame.size.height-110) style:UITableViewStylePlain];
    TabelView.delegate=self;
    TabelView.dataSource=self;
    //tableView.separatorInset = UIEdgeInsetsZero;
    //tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    //       self.scrollEnabled = NO;
    TabelView.allowsSelection=YES;//不让cell被选中
    
    TabelView.backgroundColor=[UIColor colorWithHexString:@"#f2f2f2"];
    
}

-(UILabel *)topLabel{
    if (_topLabel == nil) {
         _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 280, 30)];
         _topLabel.textAlignment = NSTextAlignmentLeft;
         _topLabel.font = [UIFont fontWithName:@"Arial" size:16];
         _topLabel.textColor = [UIColor blackColor];
        [self.view addSubview:_topLabel];
        return _topLabel;
    }
    return _topLabel;
}

-(void)backBtnCliack
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma -mark tableview代理

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
    
    if (_dataArray.count > 0) {
        QCFriendAccout * models = _dataArray[indexPath.row];
        [cell.avatarUrlImage sd_setImageWithURL:[NSURL URLWithString:models.avatarUrl] placeholderImage:[UIImage imageNamed:@"icon"]];
        if (models.sex ==0) {
            cell.theSexIge.image=[UIImage imageNamed:@"found_icon_man"];
            
        }else if(models.sex ==1){
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",(long)indexPath.row);
    QCUserViewController2*user=[[QCUserViewController2 alloc]init];
    QCHFUserModel*um=self.dataArray[indexPath.row] ;
    user.uid =[um.uid longLongValue];
    user.isFriend=[_isfriendArr[indexPath.row] boolValue];
    [self.navigationController pushViewController:user animated:YES];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *emptyView = [[UIView alloc] init];
    emptyView.backgroundColor = [UIColor clearColor];
    return emptyView;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [tf resignFirstResponder];
}


#pragma -mark 关注
- (void)isfriendAddAction:(QCFriendAccout *)model button:(UIButton *)bu
{
    NSMutableDictionary * dics = [NSMutableDictionary dictionary];
    dics[@"destUids"] = model.uid;
    
#pragma -mark 一旦 BOOL 值有改变,通过 button的 tag标记数组里对应的下标进行替换数组的元素
    bu.selected = YES;
    isFriends = YES;
    
    [NetworkManager requestWithURL:FRIEND_ADD parameter:dics success:^(id response) {
        [_isfriendArr replaceObjectAtIndex:bu.tag withObject:[NSNumber numberWithBool:isFriends]];
        //        [self searchDownData];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        NSLog(@"错误信息%@",error);
        [OMGToast showText:@"关注失败"];
        bu.selected = NO;
        isFriends = NO;
    }];
}

#pragma -mark 取消关注
- (void)isfriendRemoveAction:(QCFriendAccout *)model button:(UIButton *)bu
{
    NSMutableDictionary * dics = [NSMutableDictionary dictionary];
    dics[@"destUids"] = model.uid;
    
    bu.selected = NO;
    isFriends = NO;
    
    [NetworkManager requestWithURL:FRIEND_REMOVEFOCUS parameter:dics success:^(id response) {
        NSLog(@"%@",response);
        [_isfriendArr replaceObjectAtIndex:bu.tag withObject:[NSNumber numberWithBool:isFriends]];
        //        [self searchDownData];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        NSLog(@"错误信息%@",error);
        [OMGToast showText:@"取消失败"];
        bu.selected = YES;
        isFriends = YES;
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}





#pragma -mark uitextField的代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"你点了return");
    //取消键盘的第一响应者(收回键盘)
    [textField resignFirstResponder];
    [self getDatas];

    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![tf isExclusiveTouch]) {
        [tf resignFirstResponder];
    }
}

-(void)getDatas
{
    NSLog(@"self.type===%ld",(long)self.type);
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"type"]=@(self.type);
    dic[@"marks"] = tf.text;
    
    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:AssignWork_URL parameter:dic success:^(id response) {
        NSArray * arr = [QCHFUserModel mj_objectArrayWithKeyValuesArray:response];
        if (arr.count > 0) {
            [_isfriendArr removeAllObjects];
            self.dataArray = [NSMutableArray arrayWithArray:arr];
            [TabelView removeFromSuperview];
            if (self.dataArray!=nil) {
                
                [self.view addSubview:TabelView];
            }else{
            
                [TabelView removeFromSuperview];
            
            }
            for (QCHFUserModel * models in self.dataArray) {
                [_isfriendArr addObject:models.isFriends];
            }
            
            [MBProgressHUD hideHUD];
            [TabelView reloadData];
            
        }
        else
        {
            [MBProgressHUD hideHUD];
            [TabelView reloadData];
            return ;
        }
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        CZLog(@"%@", error);
        [TabelView removeFromSuperview];

        [MBProgressHUD hideHUD];
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
