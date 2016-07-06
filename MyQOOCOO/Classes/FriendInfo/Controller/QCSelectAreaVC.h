//
//  QCSelectAreaVC.h
//  MyQOOCOO
//
//  Created by lanou on 16/1/9.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"
#import "LocationViewController.h"

@interface QCSelectAreaVC : QCBaseVC<UITableViewDataSource,UITableViewDelegate,LocationViewDelegate>
{
    NSMutableArray*provincesArray;//装省
    NSMutableArray*citiesArray;//装市
    
    NSMutableArray*tableArr;//tablev当前数据
    
    
    
    UILabel*myAddress;
    
    
    
    BOOL iscity;
}

@property(nonatomic,strong)NSString*AddresStr;

@property(nonatomic,strong)NSString*province;

@property(nonatomic,strong)NSString*city;





@end
