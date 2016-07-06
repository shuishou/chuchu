//
//  QCProfileViewController.h
//  MyQOOCOO
//
//  Created by lanou on 15/12/25.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import "QCFriendInfoModel.h"
#import "QCPersonMarkModel.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"


@interface QCProfileViewController : QCBaseVC<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    BOOL isOpen;
    UITableView*bottomTb;
    NSMutableArray*mySectionArr;
    NSMutableArray*openedInSectionArr;
    UIImageView*sectionimagev;
    
    CGRect TBframe;
    
    
    UIImageView*imagevs;
    UIImageView*imagevs2;

    
    
    QCFriendInfoModel*qcFriend;
    QCPersonMarkModel*personMark;
    
    
    float tbH;

    NSString *showOthers;
    
    
    UITextField*boxtf;

}
@property(nonatomic,assign)long uid;
@property(nonatomic,strong)NSMutableArray *personMarkArr;
@property(nonatomic,strong)NSMutableArray*userMarkArr;
@property(nonatomic,assign)BOOL isFriend;
@property(nonatomic,strong)NSDictionary *userDic;


@property(nonatomic,assign)NSInteger groupId;



@property(nonatomic,assign)BOOL isRootVC;

@end
