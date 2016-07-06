//
//  QCTaoLunZuTVC.m
//  MyQOOCOO
//
//  Created by Wind on 15/12/5.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCTaoLunZuTVC.h"

#import "QCGroupModel.h"
#import "QCFriendListCell.h"
#import "QCChatViewController.h"
#import "UserProfileManager.h"
@interface QCTaoLunZuTVC ()
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * positionFor4ModeImage;
@property (nonatomic,strong) NSMutableArray * positionFor9ModeImage;
@property (strong, nonatomic) NSMutableArray * HFImageArr;
@end

@implementation QCTaoLunZuTVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataArray = [NSMutableArray array];
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _positionFor4ModeImage = [[NSMutableArray alloc]init];
    _positionFor9ModeImage = [[NSMutableArray alloc]init];
    _HFImageArr = [NSMutableArray array];
    //初始化图片在UIView中图片的坐标
    [self initImageposition];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
//    [MBProgressHUD showMessage:nil background:NO];
    [NetworkManager requestWithURL:GROUP_GETLIST parameter:@{@"type":@(2)} success:^(id response) {
        NSArray * arr = response;
        if (arr.count < 1) {
//            [MBProgressHUD hideHUD];
            [self.tableView reloadData];
            return ;
        }
        else
        {
            _dataArray = [QCGroupModel mj_objectArrayWithKeyValuesArray:arr];
        }
//        [MBProgressHUD hideHUD];
        [self.tableView reloadData];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        
//        [MBProgressHUD hideHUD];
        CZLog(@"%@", error);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArray.count > 0) {
        return _dataArray.count;
    }
    else
    {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellId = @"QunZu";
    
    QCFriendListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[QCFriendListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    QCGroupModel * model = _dataArray[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@(%@人)", model.name,model.memberCount];
    [_HFImageArr removeAllObjects];
    for (NSDictionary * dic in model.members) {
        
        UIImageView * imga = [UIImageView new];
        
        [imga sd_setImageWithURL:[NSURL URLWithString:dic[@"avatarUrl"]] placeholderImage:[UIImage imageNamed:@"ios-template-120"]];
        if (_HFImageArr.count < 4) {
            [_HFImageArr addObject:imga.image];
        }
        
    }
    [cell.avaterImage setImage:[self makeGroupAvatar:_HFImageArr]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QCGroupModel * model = _dataArray[indexPath.row];
    QCChatViewController *chatView = [[QCChatViewController alloc]initWithChatter:model.hid isGroup:YES];
    chatView.title = [[UserProfileManager sharedInstance] getNickNameWithUsername:model.name];
    
    [self.navigationController pushViewController:chatView animated:YES];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
