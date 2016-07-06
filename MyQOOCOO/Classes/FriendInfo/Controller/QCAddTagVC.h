//
//  QCAddTagVC.h
//  MyQOOCOO
//
//  Created by lanou on 16/1/8.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"

@interface QCAddTagVC : QCBaseVC<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

{
    NSMutableArray*shengao;
    NSMutableArray*nianling;
    NSMutableArray*xingzuo;
    NSMutableArray*aihao;
    NSMutableArray*techang;
    NSMutableArray*xingge;
    NSMutableArray*zhiye;
    NSMutableArray*wenhuachengdu;
    
    NSMutableArray*tableArr;
    /**要删除的字符串**/
    NSString*deleteStr;
    
    NSMutableArray*textfLength;
    UIView *picV;//动画标签背景
}

/**传过来的交友标签**/
@property(nonatomic,strong)NSMutableArray *userMarkArr;
/**新添加的交友标签**/
@property(nonatomic,strong)NSMutableArray *newmarkFriend;
/**总的交友标签**/
@property(nonatomic,strong)NSMutableArray *showMarkFriend;
/**记录旧数组状态**/
@property(nonatomic,strong)NSMutableArray *isdeleteArr;
/**男或女**/
@property(nonatomic,assign)NSInteger isMan;


@end
