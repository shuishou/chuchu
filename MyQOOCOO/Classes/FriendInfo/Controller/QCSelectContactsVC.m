//
//  QCSelectContacts.m
//  MyQOOCOO
//
//  Created by lanou on 16/1/28.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCSelectContactsVC.h"
#import "QCSelectContactsTableViewCell.h"
#import "ChineseToPinyin.h"

#import "QCChatViewController.h"
#import "UserProfileManager.h"

@interface QCSelectContactsVC ()
{
    UITableView* tableV;
}
@end

@implementation QCSelectContactsVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"联系人选择";
    UIButton*leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.frame=CGRectMake(0, 0, 60, 40);
    leftBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [leftBtn setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(touchleftBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    //右侧按钮(自定义)
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    //    button.backgroundColor=[UIColor purpleColor];
    [button setTitle:@"确定" forState: UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0xed6664) forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 60, 30);
    button.titleLabel.font=[UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(touchrightBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortpinyin:) name:@"pinyin" object:nil];

    
    
    
//    self.indexArr=[[NSMutableArray alloc]init];
    self.friendArr=[[NSMutableArray alloc]init];
    [self getMyFriend ];
  tableV=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableV.backgroundColor=[UIColor whiteColor];
    tableV.delegate=self;
    tableV.dataSource=self;
    tableV.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [tableV setSeparatorInset:UIEdgeInsetsZero];
    tableV.backgroundColor=[UIColor whiteColor];
    tableV.allowsSelection= YES;
    
    tableV.scrollEnabled =YES;
    tableV.separatorColor=[UIColor clearColor];
    [self.view addSubview:tableV];

    
    
    
    suoYinArr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];

    self.tableView=[[QCSelectContactsTableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30,(self.view.frame.size.height-432+64)/2 , 30,432 )];
    self.tableView.dataArr=[suoYinArr mutableCopy];
    [self.view addSubview:self.tableView];
}


-(void)touchleftBtn
{
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)touchrightBtn
{

   
    NSLog(@"确定");
//    NSString *chatText = @"send_content_from_card_to_show, avatar , nickName , uid";
    for (int i=0; i<self.friendArr.count; i++) {
        QCFriendUser*user=self.friendArr[i];
        if ([user.isSele isEqualToString:@"1"]) {
            NSString*chatText =[NSString stringWithFormat:@"send_content_from_card_to_show,%@,%@,%@",user.avatar,user.nickname,user.uid];
            QCChatViewController *chatView = [[QCChatViewController alloc]initWithChatter:user.hid isGroup:NO];
            chatView.title = [[UserProfileManager sharedInstance] getNickNameWithUsername:user.nickname];
  
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                [chatView sendTextMessage:chatText];

            });

        }
    }
    [OMGToast showText:@"发送成功"];
    [self.navigationController popViewControllerAnimated:YES];
       
   
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section{
    
    return self.friendArr.count;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 70;
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    static NSString*indentifier=@"cell";
    NSString *indentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    
    QCSelectContactsTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell==nil) {
        cell=[[QCSelectContactsTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
      QCFriendUser *user=self.friendArr[indexPath.row];
//    if (self.indexArr.count>indexPath.row) {
    
        
        if ([user.isSele isEqualToString:@"0"]) {
            cell.pointImage.image=[UIImage imageNamed:@"no"];
        }else{
            
            cell.pointImage.image=[UIImage imageNamed:@"offs"];
            
        }
//    }
    
    [cell.userImage sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"ios-template-1024(1)"]];
    cell.userName.text=user.nickname;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",(long)indexPath.row);
     QCFriendUser *user=self.friendArr[indexPath.row];
    if ([user.isSele isEqualToString: @"0"]) {
//        self.indexArr[indexPath.row]=@"1";
//        QCFriendUser *user=self.friendArr[indexPath.row];
                            user.isSele=@"1";

    }else{
//    self.indexArr[indexPath.row]=@"0";
//        QCFriendUser *user=self.friendArr[indexPath.row];
                            user.isSele=@"0";

    }    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}



-(void)getMyFriend
{
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"type"]=@(1);
        [MBProgressHUD showMessage:nil background:NO];
//    [NetworkManager requestWithURL:FRIEND_GETFRIENDLIST parameter:dic success:^(id response) {
//        
//        [MBProgressHUD hideHUD];
//        [self.friendArr removeAllObjects];
////        [self.indexArr removeAllObjects];
//        NSMutableArray*tempArr=[QCFriendModel mj_objectArrayWithKeyValuesArray:response];
//        for (int i=0; i<tempArr.count; i++) {
//            QCFriendModel*model=tempArr[i];
//        
//        if (model.user) {
//        QCFriendUser *user=model.user;
//     
//            user.isSele=@"0";
//            [self.friendArr addObject:user];
////            [self.indexArr addObject:@"0"];
//            
//        }
//            }
//        
//        
//        [tableV reloadData];
//    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
//        [MBProgressHUD hideHUD];
//        [OMGToast showText:@"获取联系人失败"];
//        
//    }];
    [NetworkManager requestWithURL:FRIEND_GETFRIENDLIST parameter:dic success:^(id response) {
                [MBProgressHUD hideHUD];
                [self.friendArr removeAllObjects];
        //        [self.indexArr removeAllObjects];
                NSMutableArray*tempArr=[QCFriendModel mj_objectArrayWithKeyValuesArray:response];
                for (int i=0; i<tempArr.count; i++) {
                    QCFriendModel*model=tempArr[i];
        
                if (model.user) {
                QCFriendUser *user=model.user;
        
                    user.isSele=@"0";
                    [self.friendArr addObject:user];
        //            [self.indexArr addObject:@"0"];
                    
                }
                    }
                
                
                [tableV reloadData];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
                [MBProgressHUD hideHUD];
                [OMGToast showText:@"获取联系人失败"];
    }];


}
#pragma -mark 拼音排序
-(void)sortpinyin:(NSNotification*)n
{
    [self sortName:n.userInfo[@"pinyin"]];
}
-(void)sortName:(NSString*)pinyin
{
    
    
    NSMutableArray*yesArr=[[NSMutableArray alloc]init];//相同
    NSMutableArray*noArr=[[NSMutableArray alloc]init];//不相同
    self.nickNameArr=[[NSMutableArray alloc]init];
    
    
    //遍历
    for (int i=0; i<self.friendArr.count; i++) {
        
        QCFriendUser *user=self.friendArr[i];
        
        NSString * tempName=user.nickname;
        
        //首字母
        NSString * nameStr;
        //的用户的名字拼音
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:tempName];
        if (firstLetter.length > 0) {
            //拼音字符串转字符数组
            const char * mingziKey = [firstLetter cStringUsingEncoding:NSASCIIStringEncoding];
            //取首个字符,判断字符范围
            if (mingziKey[0] > 'A' && mingziKey[strlen(mingziKey)-1] < 'Z' ) {
                nameStr = [NSString stringWithFormat:@"%c",mingziKey[0]];
            }
            else
            {
                nameStr = @"#";
            }
        }
        //名字为空
        else
        {
            nameStr = @"#";
        }
        
       
        
        // 对应的拼音的首个字符与名字是否相同
        if ([nameStr isEqualToString:pinyin]) {
            [yesArr addObject:self.friendArr[i]];
            
        }else{
        
            [noArr addObject:self.friendArr[i]];
        }
    
 
    }
    
    for (int k=0; k<yesArr.count; k++) {
        [self.nickNameArr addObject:yesArr[k]];
    }
    for (int k2=0; k2<noArr.count; k2++) {
        [self.nickNameArr addObject:noArr[k2]];
    }
    

        self.friendArr=self.nickNameArr;
    [tableV reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
