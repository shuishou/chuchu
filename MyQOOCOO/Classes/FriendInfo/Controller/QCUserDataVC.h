//
//  QCUserDataVC.h
//  MyQOOCOO
//
//  Created by lanou on 16/1/7.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"
#import "QCFriendInfoModel.h"

@interface QCUserDataVC : QCBaseVC<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,UITextFieldDelegate>
{
    UICollectionView* cv;
    NSInteger sex;
    UIButton*bt2;
    UIButton*bt3;
    UITextField*boxtf;
}

/**传过来的交友标签**/
@property(nonatomic,strong)NSMutableArray*markfriend;
/**新添加的交友标签**/
@property(nonatomic,strong)NSMutableArray*newmarkFriend;
/**总的交友标签**/
@property(nonatomic,strong)NSMutableArray*showMarkFriend;
/**删除过的旧的交友标签状态数组**/
@property(nonatomic,strong)NSMutableArray*deleteMarkfriend;

@property(nonatomic,strong)QCFriendInfoModel*myData;
//@property(nonatomic,strong)NSMutableArray*userMarkArr;

@property(nonatomic,strong)NSString*province;
@property(nonatomic,strong)NSString*city;

@property (strong, nonatomic) NSNumber * isFirstLogin;
@property(strong,nonatomic)NSMutableArray*userMarkArr;//获取组id

@property(nonatomic,assign)NSInteger groupId;

@property(nonatomic,assign)NSInteger traveled;//记录访问次数

@property(nonatomic,assign)NSInteger istraveled;//访问成功次数

@end
