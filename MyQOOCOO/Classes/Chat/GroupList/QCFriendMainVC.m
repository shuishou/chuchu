//
//  QCGroupController.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/7/29.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCFriendMainVC.h"
#import "QCGroupChatCell.h"
#import "QCBaseTableView.h"
#import "QCLoginVC.h"

//导入分组
#import "QCStragerGroupVC.h"
#import "QCUndeterminedGroupVC.h"
#import "QCFriendListCell.h"
#import "QCSearchFriendVC.h"
#import "QCFriendListVC.h"
#import "QCGroupListVC.h"
#import "QCHFGroupCallVC.h"
#import <CoreText/CoreText.h>
#import "QCFriendModel.h"
@interface QCFriendMainVC (){
    
    UISearchController * _searchController;
    kFriendGroupTpye _type;
}

@property (nonatomic,strong) NSMutableArray * positionFor4ModeImage;
@property (nonatomic,strong) NSMutableArray * positionFor9ModeImage;

@property (strong, nonatomic) NSMutableArray * dataArray;
/**互相关注的头像*/
@property (strong, nonatomic) NSMutableArray * friendUsersArr;
/**我关注的头像*/
@property (strong, nonatomic) NSMutableArray * mFocusUsersArr;
/**关注我的头像*/
@property (strong, nonatomic) NSMutableArray * fFocusUsersArr;
/**群成员的头像*/
@property (strong, nonatomic) NSMutableArray * groupUsersArr;
/**待定的头像*/
@property (strong, nonatomic) NSMutableArray * crashUsersArr;
/**趣友分组的头像*/
@property (strong, nonatomic) NSMutableArray * fGroupUsersArr;
/**陌生人的头像*/
@property (strong, nonatomic) NSMutableArray * strangerUsersArr;

@property (strong, nonatomic) NSMutableArray * HFimageArray;
@property (strong, nonatomic) NSMutableArray * HFImageArray;

@end

@implementation QCFriendMainVC
@dynamic tableView;

-(instancetype)initWithType:(kFriendGroupTpye)type{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getFriendCount];
    [super viewWillAppear:animated];
    
    LoginSession *session = [[ApplicationContext sharedInstance] getLoginSession];
    if (![session isValidate]) {
        QCLoginVC *loginVC = [[QCLoginVC alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kGlobalBackGroundColor;
    if (_type == kFriendGroupTpyeSelected) {
        self.navigationItem.title = @"发起群聊";
    }
    
    _positionFor4ModeImage = [[NSMutableArray alloc]init];
    _positionFor9ModeImage = [[NSMutableArray alloc]init];
    
    //初始化图片在UIView中图片的坐标
    [self initImageposition];
    
    self.friendUsersArr = [NSMutableArray array];
    self.mFocusUsersArr = [NSMutableArray array];
    self.fFocusUsersArr = [NSMutableArray array];
    self.groupUsersArr = [NSMutableArray array];
    self.crashUsersArr = [NSMutableArray array];
    self.fGroupUsersArr = [NSMutableArray array];
    self.strangerUsersArr = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.HFimageArray = [NSMutableArray array];
    self.HFImageArray = [NSMutableArray array];
    
//    QCSearchFriendVC * resultVC = [[QCSearchFriendVC alloc]init];
//    _searchController = [[UISearchController alloc] initWithSearchResultsController:resultVC];
//    _searchController.searchResultsUpdater = resultVC;
//    _searchController.dimsBackgroundDuringPresentation = YES;
//    _searchController.searchBar.delegate = resultVC;
//    _searchController.searchBar.placeholder = @"搜索";
//    [_searchController.searchBar sizeToFit];
//    self.tableView.tableHeaderView = _searchController.searchBar;
//    self.definesPresentationContext = YES;
    
    //创建tableView
    self.tableView = [[QCBaseTableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.data = [[NSMutableArray alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = kSeparatorColor;
//    self.tableView.tableHeaderView = view;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self getFriendCount];
    self.view.backgroundColor = [UIColor clearColor];
    
}


- (void)searchViewTapped:(UITapGestureRecognizer *)taps
{
    QCSearchFriendVC * friendListVc = [[QCSearchFriendVC alloc] init];
    UINavigationController * friendNa = [[UINavigationController alloc] initWithRootViewController:friendListVc];
    
        friendListVc.hidesBottomBarWhenPushed = YES;
    
    [self presentViewController:friendNa animated:YES completion:nil];
}

-(void)getFriendCount{
    
//    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:FRIEND_GETFRIENDCOUNT parameter:nil success:^(id response) {
        
        [_friendUsersArr removeAllObjects];
        [_mFocusUsersArr removeAllObjects];
        [_fFocusUsersArr removeAllObjects];
        [_groupUsersArr removeAllObjects];
        [_crashUsersArr removeAllObjects];
        [_fGroupUsersArr removeAllObjects];
        [_strangerUsersArr removeAllObjects];
        [self.tableView.data removeAllObjects];
        if (!response) {
            return ;
        }
        
        NSDictionary * dataDic = response;
        
        //互相关注的头像
        for (NSDictionary * dic in dataDic[@"friendUsers"]) {
            NSDictionary * dic1 = dic[@"user"];
            if (dic1[@"avatar"]) {
                [_friendUsersArr addObject:dic1[@"avatar"]];
            }
        }
        //我关注的头像
        for (NSDictionary * dic in dataDic [@"mFocusUsers"]) {
            NSDictionary * dic1 = dic[@"user"];
            if (dic1[@"avatar"]) {
                [_mFocusUsersArr addObject:dic1[@"avatar"]];
            }        }
        //关注我的头像
        for (NSDictionary * dic  in dataDic[@"fFocusUsers"]) {
            NSDictionary * dic1 = dic[@"user"];
            if (dic1[@"avatar"]) {
                [_fFocusUsersArr addObject:dic1[@"avatar"]];
            }        }
        //群成员的头像
        for (NSDictionary * dic  in dataDic[@"groupUsers"]) {
            NSDictionary * dic1 = dic[@"user"];
            if (dic1[@"avatar"]) {
                [_groupUsersArr addObject:dic1[@"avatar"]];
            }        }
        //待定的头像
        for (NSDictionary * dic  in dataDic[@"crashUsers"]) {
            NSDictionary * dic1 = dic[@"user"];
            if (dic1[@"avatar"]) {
                [_crashUsersArr addObject:dic1[@"avatar"]];
            }        }
        //趣友分组的头像
        for (NSDictionary * dic  in dataDic[@"fGroupUsers"]) {
            NSDictionary * dic1 = dic[@"user"];
            if (dic1[@"avatar"]) {
                [_fGroupUsersArr addObject:dic1[@"avatar"]];
            }        }
        //陌生人的头像
        for (NSDictionary * dic  in dataDic[@"strangerUsers"]) {
            NSDictionary * dic1 = dic[@"user"];
            if (dic1[@"avatar"]) {
                [_strangerUsersArr addObject:dic1[@"avatar"]];
            }        }
        
        self.tableView.data = [@[@{@"name":@"好友",@"count":response[@"friendsCount"],@"avater":_friendUsersArr},
                                 @{@"name":@"偶像",@"count":response[@"mFocusCount"],@"avater":_mFocusUsersArr},
                                 @{@"name":@"粉丝",@"count":response[@"fFocusCount"],@"avater":_fFocusUsersArr},
                                 @{@"name":@"趣友分组",@"count":response[@"fGroupCount"],@"avater":_fGroupUsersArr},
                                 @{@"name":@"群组",@"count":response[@"groupCount"],@"avater":_groupUsersArr},
                                 
                                 @{@"name":@"待定",@"count":response[@"crashCount"],@"avater":_crashUsersArr},
                                 @{@"name":@"黑名单",@"count":response[@"strangerCount"],@"avater":_strangerUsersArr}]
                               mutableCopy];
        
//        self.tableView.data = [@[@{@"name":@"好友（互相关注的人）",@"count":response[@"friendsCount"],@"avater":_friendUsersArr},
//                                 @{@"name":@"偶像（我关注的人）",@"count":response[@"mFocusCount"],@"avater":_mFocusUsersArr},
//                                 @{@"name":@"粉丝（关注我的人）",@"count":response[@"fFocusCount"],@"avater":_fFocusUsersArr},
//                                 @{@"name":@"趣友分组（好友与偶像的分组）",@"count":response[@"fGroupCount"],@"avater":_fGroupUsersArr},
//                                 @{@"name":@"群组",@"count":response[@"groupCount"],@"avater":_groupUsersArr},
//                                 
//                                 @{@"name":@"待定（拉黑我的人）",@"count":response[@"crashCount"],@"avater":_crashUsersArr},
//                                 @{@"name":@"黑名单（我拉黑的人）",@"count":response[@"strangerCount"],@"avater":_strangerUsersArr}]
//                               mutableCopy];
        
//        if (_type==kFriendGroupTpyeSelected) {
//            
//            [self.tableView.data removeLastObject];
//        }
        [MBProgressHUD hideHUD];
        [self.tableView reloadData];
        
        
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        //
        [MBProgressHUD hideHUD];
        NSLog(@"%@", error);
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableView.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WIDTH(self.tableView)/5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return WIDTH(self.view)/10+16;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view)/10+16)];
    view.backgroundColor = kColorRGBA(237, 237, 237, 1);
    
    UILabel * searchLa = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.view.frame.size.width-16, WIDTH(self.view)/10)];
    searchLa.backgroundColor = [UIColor whiteColor];
    searchLa.textAlignment = NSTextAlignmentCenter;
    searchLa.textColor = [UIColor colorWithHexString:@"999999"];
    searchLa.text = @"搜索";
    searchLa.font = [UIFont systemFontOfSize:HEIGHT(searchLa)/2];
    searchLa.layer.masksToBounds = YES;
    searchLa.layer.cornerRadius = 5;
    searchLa.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchViewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [searchLa addGestureRecognizer:tap1];
    [view addSubview:searchLa];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"groupCell";
    QCFriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[QCFriendListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewStyleGrouped;
    NSMutableString * title = [[NSMutableString alloc]initWithString:[self.tableView.data[indexPath.row] objectForKey:@"name"]];
    if ([[self.tableView.data[indexPath.row] objectForKey:@"count"] integerValue] != 0) {
        [title appendString:[NSString stringWithFormat:@"(%ld)",[[self.tableView.data[indexPath.row] objectForKey:@"count"] integerValue]]];
    }
   
    
    NSUInteger length = [title length];
    
    
    

    NSArray*titarr=@[@" 互相关注的人 ",@" 我关注的人 ",@" 关注我的人 ",@" 好友与偶像的分组 ",@"",@" 拉黑我的人 ",@" 我拉黑的人 "];
    [title appendString:titarr[indexPath.row]];
    
    NSMutableAttributedString *attrString =
    [[NSMutableAttributedString alloc] initWithString:title];
    
    // 设置基本字体
     NSDictionary *attrsDic = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                                              };
    [attrString addAttributes:attrsDic range:NSMakeRange(0, length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(length, [titarr[indexPath.row] length])];
    
    cell.titleLabel.attributedText = attrString;
    NSString * str = [self.tableView.data[indexPath.row] objectForKey:@"name"];
    NSLog(@"self.tableView.data.indexPath.row===%@",self.tableView.data[indexPath.row]);
    if ([[self.tableView.data[indexPath.row] objectForKey:@"count"] integerValue] == 0) {
        [cell.avaterImage setImage:[UIImage imageNamed:@"default-avatar_1"]];
    }
    else if ([[self.tableView.data[indexPath.row] objectForKey:@"count"] integerValue] == 1)
    {
        if ([str isEqualToString:@"群组"]) {
            [cell.avaterImage setImage:[UIImage imageNamed:@"default-avatar_1"]];
        }
        else
        {
            NSArray * arr = [self.tableView.data[indexPath.row] objectForKey:@"avater"];
            if (arr.count > 0) {
                NSLog(@"arr[0]===%@",arr[0]);
                [cell.avaterImage sd_setImageWithURL:[NSURL URLWithString:arr[0]] placeholderImage:[UIImage imageNamed:@"default-avatar_1"]];
            }
            else
            {
                [cell.avaterImage setImage:[UIImage imageNamed:@"default-avatar_1"]];

            }
        }
    }
    else
    {
        [_HFimageArray removeAllObjects];
        
        if ([str isEqualToString:@"群组"])
        {
            for (int i = 0; i < [[self.tableView.data[indexPath.row] objectForKey:@"count"] integerValue]; i++) {
                [cell.avaterImage setImage:[UIImage imageNamed:@"default-avatar_1"]];
                
                if (_HFimageArray.count < 4) {
                    [_HFimageArray addObject:cell.avaterImage.image];
                }
            }
        }
        else
        {
            [_HFimageArray removeAllObjects];
            
            if ([[self.tableView.data[indexPath.row] objectForKey:@"avater"] count]> 0) {
                for (NSString * strs in [self.tableView.data[indexPath.row] objectForKey:@"avater"]) {
                    NSLog(@"%@", strs);
                    
                    UIImageView * ima = [UIImageView new];
                    
                    if ([strs containsString:@","]) {
                        NSMutableArray * array=[NSMutableArray arrayWithArray:[strs   componentsSeparatedByString:@","]];
                        NSString * strG = array[0];
                        
                        [ima sd_setImageWithURL:[NSURL URLWithString:strG] placeholderImage:[UIImage imageNamed:@"default-avatar_1"]];
                    }
                    else
                    {
                        [ima sd_setImageWithURL:[NSURL URLWithString:strs] placeholderImage:[UIImage imageNamed:@"default-avatar_1"]];
                    }
                    
                    
                    
                    if (_HFimageArray.count < 4) {
                        [_HFimageArray addObject:ima.image];
                    }
                }
            }
            else
            {
                for (int i = 0 ; i < [[self.tableView.data[indexPath.row] objectForKey:@"count"] integerValue]; i++) {
                    
                    UIImageView * ima = [UIImageView new];
                    
                    [ima setImage:[UIImage imageNamed:@"default-avatar_1"]];
                    
                    if (_HFimageArray.count < 4) {
                        [_HFimageArray addObject:ima.image];
                    }
                }
            }
            
            [cell.avaterImage setImage:[self makeGroupAvatar:_HFimageArray]];

        }
    }
    return cell;
}

- (UIImage *)makeGroupAvatar: (NSMutableArray *)imageArray {
    //数组为空，退出函数
    if ([imageArray count] == 0){
        return nil;
    }
    
    UIView *groupAvatarView = [[UIView alloc]initWithFrame:CGRectMake(0,0,193,193)];
    groupAvatarView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < [imageArray count]; i++){
        UIImageView *tempImageView;
        if ([imageArray count] < 5){
            tempImageView = [[UIImageView alloc]initWithFrame:[[_positionFor4ModeImage objectAtIndex:i]CGRectValue]];
        }
        else{
            tempImageView = [[UIImageView alloc]initWithFrame:[[_positionFor9ModeImage objectAtIndex:i]CGRectValue]];
        }
        [tempImageView setImage:[imageArray objectAtIndex:i]];
        [groupAvatarView addSubview:tempImageView];
    }
    
    //把UIView设置为image并修改图片大小55*55
    UIImage *reImage = [self scaleToSize:[self convertViewToImage:groupAvatarView]size:CGSizeMake(55, 55)];
    
    return reImage;
}


- (void)initImageposition{
    
    //初始化4图片模式和9图片模式
    for(int i = 0; i < 9; i++){
        CGRect tempMode4Rect;
        CGRect tempMode9Rect;
        float mode4PositionX = 0;
        float mode4PositionY = 0;
        float mode9PositionX = 0;
        float mode9PositionY = 0;
        
        switch (i) {
            case 0:
                mode4PositionX = 4;
                mode4PositionY = 4;
                mode9PositionX = 4;
                mode9PositionY = 4;
                break;
            case 1:
                mode4PositionX = 98.5;
                mode4PositionY = 4;
                mode9PositionX = 67;
                mode9PositionY = 4;
                break;
            case 2:
                mode4PositionX = 4;
                mode4PositionY = 98.5;
                mode9PositionX = 130;
                mode9PositionY = 4;
                break;
            case 3:
                mode4PositionX = 98.5;
                mode4PositionY = 98.5;
                mode9PositionX = 4;
                mode9PositionY = 67;
                break;
            case 4:
                mode9PositionX = 67;
                mode9PositionY = 67;
                break;
            case 5:
                mode9PositionX = 130;
                mode9PositionY = 67;
                break;
            case 6:
                mode9PositionX = 4;
                mode9PositionY = 130;
                break;
            case 7:
                mode9PositionX = 67;
                mode9PositionY = 130;
                break;
            case 8:
                mode9PositionX = 130;
                mode9PositionY = 130;
                break;
            default:
                break;
        }
        
        //添加4模式图片坐标到数组
        if (i < 4 ){
            tempMode4Rect = CGRectMake(mode4PositionX, mode4PositionY, 90.5, 90.5);
            [_positionFor4ModeImage addObject:[NSValue valueWithCGRect:tempMode4Rect]];
        }
        
        //添加4模式图片坐标到数组
        tempMode9Rect = CGRectMake(mode9PositionX, mode9PositionY, 59, 59);
        [_positionFor9ModeImage addObject:[NSValue valueWithCGRect:tempMode9Rect]];
    }
}

-(UIImage*)convertViewToImage:(UIView*)v{
    
    CGSize s = v.bounds.size;
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    UIGraphicsBeginImageContextWithOptions(s, YES, [UIScreen mainScreen].scale);
    
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

#pragma mark - tableView的delegate方法

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row<=2) {
        QCFriendListVC * friendList = [[QCFriendListVC alloc] initWithFriendStatus:indexPath.row+1 listType:_type];
        [self.navigationController pushViewController:friendList animated:YES];
    }else if (indexPath.row == 3){
        QCGroupListVC * groupList = [[QCGroupListVC alloc] init];
        groupList.title = @"趣友分组";
        [self.navigationController pushViewController:groupList animated:YES];
    }else if (indexPath.row == 4){
        QCHFGroupCallVC * groupcallVC = [[QCHFGroupCallVC alloc] init];
        groupcallVC.title = @"群组";
        [self.navigationController pushViewController:groupcallVC animated:YES];
    }else{
        QCFriendListVC * friendList = [[QCFriendListVC alloc] initWithFriendStatus:indexPath.row-1 listType:_type];
        [self.navigationController pushViewController:friendList animated:YES];
    }
    
    
}



//- (void)viewDidLoad {
//    [super viewDidLoad];
//    //需要传入一个数组，arr.count对应头像数量，最多显示9个
//    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];     [array addObject:@"1"];     [array addObject:@"2"];     [array addObject:@"3"];     [array addObject:@"5"];     [array addObject:@"9"];
//    //加方法调用群组头像功能
//    SudokuRoundView *view = [SudokuRoundView createSudokuRoundViewWithFrame:CGRectMake(20, 110, 70, 70) WithXIBSubImageViewArray:array WithMessageNotRead:0];
//    [self.view addSubview:view]; }
//    
//    /** 9宫格xib加方法  *  frame : 图片范围  *  array : 图像数据数组  *  message : 未读消息数字  */
//+ (SudokuRoundView *)createSudokuRoundViewWithFrame:(CGRect)frame WithXIBSubImageViewArray:(NSMutableArray *)array WithMessageNotRead:(int)messgae{
//    int maxNum = 0;
//    //判断最多9个头像
//    if (array.count > 9) {
//        maxNum = 9;
//    }
//    else
//    {
//        maxNum = array.count;
//    }
//    //加载对应的xib
//    SudokuRoundView *sudokuRoundView = [self initWithSudokuRoundView:maxNum -1];
//    if (array.count) {
//        [sudokuRoundView initWithTag:maxNum *100 WithFrame:frame WithArray:array WithMessageNotRead:messgae];
//    }
//    return sudokuRoundView;
//}
//        
//        //返回对应实例
//+ (SudokuRoundView *)initWithSudokuRoundView:(int)object {
//    return [[[NSBundle mainBundle]loadNibNamed:@"SudokuRoundView" owner:self options:nil]objectAtIndex:object];
//}
//        
//        //加载图片
//- (void)initWithTag:(int)tag WithFrame:(CGRect)frame WithArray:(NSMutableArray *)array WithMessageNotRead:(int)messgae{
//    //初始化数据
//    [self makeView:frame];
//    for (NSString *imageStr in array) {
//        static int i = 0;
//        UIImageView *imageView = (UIImageView *)[self viewWithTag:tag+i];
//        //SDWebImage的方法
//        [imageView setImageWithURL:nil placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageStr]]];
//        //badge图标
//        JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:self alignment:JSBadgeViewAlignmentTopRight];
//        badgeView.badgeText = [NSString stringWithFormat:@"%d", messgae];
//        i ++;
//        //超过9次放弃加载
//        if (i>=9) {
//            break;
//        }
//    }
//}


@end
