//
//  QCPaihuoViewController.h
//  MyQOOCOO
//
//  Created by lanou on 15/12/11.
//  Copyright © 2015年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"

@interface QCPaihuoViewController : QCBaseVC<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{


}

@property(nonatomic,strong)NSMutableArray* dataArray;
@property (strong, nonatomic) NSMutableArray * isfriendArr;
@property(nonatomic,assign)NSInteger type;


@end
