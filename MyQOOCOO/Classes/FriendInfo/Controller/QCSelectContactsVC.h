//
//  QCSelectContacts.h
//  MyQOOCOO
//
//  Created by lanou on 16/1/28.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCBaseVC.h"
#import "QCSelectContactsTableView.h"



@interface QCSelectContactsVC : QCBaseVC<UITableViewDelegate,UITableViewDataSource>
{
    
  NSArray * suoYinArr;
}

//通过文本方式发送：格式以“,”拼接：send_content_from_card_to_show+"," + avatar + "," + nickName + "," + uid  接收以“,”切割，满足4段且1段为“send_content_from_card_to_show”为名片
//@property(nonatomic,strong)

/**记录选中**/
//@property(nonatomic,strong)NSMutableArray*indexArr;
/**好友列表**/
@property(nonatomic,strong)NSMutableArray*friendArr;
/**右边字母栏**/
@property(nonatomic,strong)QCSelectContactsTableView*tableView;
/**分好首字母的数组**/
@property(nonatomic,strong)NSMutableArray*nickNameArr;






@end
