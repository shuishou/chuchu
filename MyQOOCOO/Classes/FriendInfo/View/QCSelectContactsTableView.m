//
//  QCSelectContactsTableView.m
//  MyQOOCOO
//
//  Created by lanou on 16/1/29.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCSelectContactsTableView.h"
#import "ChineseToPinyin.h"

@implementation QCSelectContactsTableView
- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.delegate =self;
        self.dataSource = self ;
        self.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        [self setSeparatorInset:UIEdgeInsetsZero];
        self.backgroundColor=[UIColor clearColor];
        self.allowsSelection= YES;
        
        self.scrollEnabled =NO;
        self.separatorColor=[UIColor clearColor];
    }
    return self;
    
    
}
-(void)setDataArr:(NSMutableArray *)dataArr
{

       _dataArr=dataArr;

    [self reloadData];
}


#pragma -mark tableview的代理方法

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 16;
    
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section{
    
    return self.dataArr.count;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    static NSString*indentifier=@"cell";
    NSString *indentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    
    UILabel*pinyin=[[UILabel alloc]initWithFrame:CGRectMake(10, -16, cell.frame.size.width-10, cell.frame.size.height)];
    pinyin.backgroundColor=[UIColor clearColor];
    pinyin.font=[UIFont systemFontOfSize:10];
//    pinyin.textAlignment=NSTextAlignmentCenter;
    pinyin.text=self.dataArr[indexPath.row];
    [cell addSubview:pinyin];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",(long)indexPath.row);
    [self showLetter:self.dataArr[indexPath.row]];
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"pinyin" object:nil userInfo:@{@"pinyin":self.dataArr[indexPath.row]}];
    
}

- (void)showLetter:(NSString *)title
{
    [MBProgressHUD showLetter:title color:kLoginbackgoundColor];
}

@end
