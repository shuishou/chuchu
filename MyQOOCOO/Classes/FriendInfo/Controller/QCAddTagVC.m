//
//  QCAddTagVC.m
//  MyQOOCOO
//
//  Created by lanou on 16/1/8.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCAddTagVC.h"

#import "QCGetUserMarkModel.h"


@interface QCAddTagVC ()
{
//    UIView*topV;
    UITableView*tableV;
    UIView*bV;
    UIView*boxV;
    UILabel*titleLB;
    UITextField*textf;
    

}

@end

@implementation QCAddTagVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加标签";
    self.isdeleteArr = [NSMutableArray array];
    for (int i = 0; i < self.userMarkArr.count; i++) {
        [self.isdeleteArr addObject:@"1"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowNotificationded:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardRemoveed:) name:UIKeyboardWillHideNotification object:nil];

    
    
    UIButton*leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.frame=CGRectMake(0, 0, 60, 40);
    leftBtn.font=[UIFont systemFontOfSize:14];
    [leftBtn setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(touchleftBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    UIButton*rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.frame=CGRectMake(0, 0, 60, 40);
    rightBtn.font=[UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0xed6664) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(touchRightBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [self initArr];
    
    [self showTopView];
    
    UIView*addV=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4*3,0,self.view.frame.size.width/4, 120)];
//    addV.backgroundColor=[UIColor greenColor];
    addV.tag=20;
    [self.view addSubview:addV];
    
    UIImageView*imagev=[[UIImageView alloc]initWithFrame:CGRectMake(addV.bounds.size.width-40, 50, 20, 20)];
    imagev.image=[UIImage imageNamed:@"LJ-add@2x"];
    [addV addSubview:imagev];

    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchview:)];
    tap.numberOfTapsRequired =1;
    [addV addGestureRecognizer:tap];
    
    
    UIImageView*manV=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-( self.view.frame.size.height/3/2.55))/2, self.view.height-(self.view.frame.size.height/3)-64, self.view.frame.size.height/3/2.55, self.view.frame.size.height/3)];
     
    if (self.isMan==1) {
        manV.image=[UIImage imageNamed:@"LJKGman"];

    }else if(self.isMan==2){
    manV.image=[UIImage imageNamed:@"LJKGwoman-"];
    }
    [self.view addSubview:manV];
    
    [self userMark ];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSLog(@"self.newmarkFriend===%@,self.showMarkFriend===%@,isdeleteArr==%@,userMarkArr=====%@",[self getDictFromArr:self.newmarkFriend],[self getDictFromArr:self.showMarkFriend],[self getDictFromArr:self.isdeleteArr],[self getDictFromArr:self.userMarkArr]);
    
}

-(NSMutableArray *)getDictFromArr:(NSMutableArray *)arr{
    NSMutableArray *resultArr = [NSMutableArray array];
    if (arr.count > 0) {
        for (QCGetUserMarkModel *model in arr) {
            NSMutableDictionary *dict = model.mj_keyValues;
            [resultArr addObject:dict];
        }
    }
    
    return resultArr;
}

-(void)showTopView
{
//    topV=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4*3, 0,self.view.frame.size.width/4, 120)];
////    topV.backgroundColor=[UIColor greenColor];
//    [self.view addSubview:topV];
    
    NSArray *arr1=[[NSArray alloc]initWithObjects:@"身高",@"年龄",@"星座", nil];
    NSArray *arr2=[[NSArray alloc]initWithObjects:@"爱好",@"特长",@"性格", nil];
    
    for (int i=0; i<3; i++) {
        UIView*tempv=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4*i, 10, self.view.frame.size.width/4, 30)];
        tempv.tag=i;
        tempv.backgroundColor=[UIColor clearColor];
        [self.view addSubview:tempv];
        
        
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchview:)];
        tap.numberOfTapsRequired =1;
        [tempv addGestureRecognizer:tap];

        
        UILabel*tempLb=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 55, 30)];
        tempLb.backgroundColor=[UIColor whiteColor];
        tempLb.textColor=RandomColor;
        tempLb.text = arr1[i];
        tempLb.textAlignment = NSTextAlignmentCenter;
        tempLb.layer.cornerRadius=5;
        tempLb.layer.masksToBounds=YES;
        tempLb.font=[UIFont systemFontOfSize:15];
        [tempv addSubview:tempLb];
        
        
        
        UIView*tempv2=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4*i, 45, self.view.frame.size.width/4, 30)];
        tempv2.tag=i+10;
        tempv2.backgroundColor=[UIColor clearColor];
        [self.view addSubview:tempv2];
        UITapGestureRecognizer*tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchview:)];
        tap2.numberOfTapsRequired =1;
        [tempv addGestureRecognizer:tap2];

        [tempv2 addGestureRecognizer:tap2];
        
        UILabel*tempLb2=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 55, 30)];
        tempLb2.backgroundColor=[UIColor whiteColor];
        tempLb2.textAlignment=NSTextAlignmentCenter;
        tempLb2.textColor=RandomColor;
        tempLb2.layer.cornerRadius=5;
        tempLb2.layer.masksToBounds=YES;
        tempLb2.text=arr2[i];
        tempLb2.font=[UIFont systemFontOfSize:15];
        [tempv2 addSubview:tempLb2];

        
        
    }

    
    UIView *tempv=[[UIView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width/4, 30)];
    tempv.tag=6;
    tempv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tempv];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchview:)];
    tap.numberOfTapsRequired =1;
    [tempv addGestureRecognizer:tap];

   
    
    UILabel *tempLb=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 55, 30)];
    tempLb.backgroundColor=[UIColor whiteColor];
    tempLb.textColor=RandomColor;
    tempLb.text = @"职业";
    tempLb.textAlignment=NSTextAlignmentCenter;
    tempLb.layer.cornerRadius=5;
    tempLb.layer.masksToBounds=YES;
    tempLb.font=[UIFont systemFontOfSize:15];
    [tempv addSubview:tempLb];

    UIView *tempv2=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4*1, 80, self.view.frame.size.width/4, 30)];
    tempv2.tag=7;
    tempv2.backgroundColor=[UIColor clearColor];
    [self.view addSubview:tempv2];
    
    UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchview:)];
    tap2.numberOfTapsRequired =1;
    [tempv2 addGestureRecognizer:tap2];

    
    UILabel *tempLb2=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, 30)];
    tempLb2.backgroundColor=[UIColor whiteColor];
    tempLb2.textAlignment=NSTextAlignmentCenter;
    tempLb2.textColor=RandomColor;
    tempLb2.layer.cornerRadius=5;
    tempLb2.layer.masksToBounds=YES;
    tempLb2.text=@"文化程度";
    tempLb2.font=[UIFont systemFontOfSize:15];
    [tempv2 addSubview:tempLb2];
}

-(void)initArr
{
    shengao=[[NSMutableArray alloc]initWithObjects:@"140cm",@"145cm",@"150cm",@"155cm",@"160cm",@"165cm",@"170cm",@"175cm",@"180cm",@"185cm",@"190cm",@"195cm",@"200cm", nil];
    
    nianling=[[NSMutableArray alloc]initWithObjects:@"00后",@"90后",@"80后",@"70后",@"60后", nil];
    
    xingzuo=[[NSMutableArray alloc]initWithObjects:@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座", nil];
    
    aihao=[[NSMutableArray alloc]initWithObjects:@"游泳",@"跑步",@"瑜伽",@"篮球",@"足球",@"乒乓球",@"网球",@"高尔夫",@"网游", nil];
    
    techang=[[NSMutableArray alloc]initWithObjects:@"绘画",@"视频剪辑",@"PS",@"平面设计",@"钢琴",@"小提琴", nil];
    
    xingge=[[NSMutableArray alloc]initWithObjects:@"内向",@"开朗",@"活泼",@"大大咧咧",@"外向",@"开朗",@"豪放",@"爽朗",@"温柔",@"谦虚",@"自信",@"坚强", nil];
    
    zhiye=[[NSMutableArray alloc]initWithObjects:@"销售",@"建筑设计",@"蓝领",@"金领",@"公务员",@"职业经理人",@"金融业",@"人力资源",@"律师",@"教师",@"房产经纪人",@"网络工程师",@"程序员",@"产品经理",@"项目经理",@"秘书",@"行政人员", nil];
    
    wenhuachengdu=[[NSMutableArray alloc]initWithObjects:@"小学",@"初中",@"高中",@"专科",@"本科",@"研究生",@"硕士",@"博士", nil];
    

    tableArr=[NSMutableArray array];
    self.showMarkFriend = [NSMutableArray array];
    self.newmarkFriend = [NSMutableArray array];
    [self.userMarkArr removeLastObject];
    self.showMarkFriend = [self.userMarkArr mutableCopy];
    
    
    
    textfLength=[NSMutableArray array];
    for (int i=0; i < self.showMarkFriend.count; i++) {
        
        QCGetUserMarkModel *mod = self.showMarkFriend[i];
        
        [textfLength addObject:[NSString stringWithFormat:@"%ld",mod.title.length]];
    }
}




-(void)touchview:(UITapGestureRecognizer*)tap
{

    switch (tap.view.tag) {
        case 0:
            NSLog(@"身高");
            tableArr = shengao;
            [self showBox ];
            titleLB.text=@"身高";
            
            break;
        case 1:
            NSLog(@"年龄");
            tableArr=nianling;
            [self showBox ];
            titleLB.text=@"年龄";
            
            break;
        case 2:
            NSLog(@"星座");
            tableArr=xingzuo;
            [self showBox ];
            titleLB.text=@"星座";
            
            break;
        case 10:
            NSLog(@"爱好");
            
            tableArr=aihao;
            [self showBox ];
            titleLB.text=@"爱好";
            
            break;
        case 11:
            NSLog(@"特长");
            tableArr=techang;
            [self showBox ];
            titleLB.text=@"特长";
            
            break;
        case 12:
            NSLog(@"性格");
            tableArr=xingge;
            [self showBox ];
            titleLB.text=@"性格";
            
            break;
        case 6:
            NSLog(@"职业");
            tableArr=zhiye;
            [self showBox ];
            titleLB.text=@"职业";
            
            break;
        case 7:
            NSLog(@"文化层度");
            tableArr=wenhuachengdu;
            
            [self showBox ];
            titleLB.text=@"文化程度";
            break;
        case 20:
            NSLog(@"添加");
            [self addBox];
            break;

            
        default:
            break;
    }


}


//弹窗
-(void)showBox
{
    bV=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.width,self.view.height)];
    bV.backgroundColor=[UIColor blackColor];
    bV.alpha=0.5;
    [self.view addSubview:bV];
    
    boxV=[[UIView alloc]initWithFrame:CGRectMake(40, bV.bounds.size.height/5, bV.bounds.size.width-80, bV.bounds.size.height/5*3)];
    boxV.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:boxV];
    
    
    titleLB=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, boxV.bounds.size.width-20, 60)];
    titleLB.font=[UIFont systemFontOfSize:18];
    [boxV addSubview:titleLB];
    
    
    
    UIButton*blackBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [blackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    blackBtn.frame=CGRectMake(boxV.bounds.size.width-40, 35/2, 25, 25);
    [blackBtn setImage:[UIImage imageNamed:@"Diandi_delete3"] forState: UIControlStateNormal];
    [blackBtn addTarget:self action:@selector(touchblackBtn) forControlEvents:UIControlEventTouchUpInside];
    [boxV addSubview:blackBtn];

    
    
    
    
    
    tableV=[[UITableView alloc]initWithFrame:CGRectMake(0, 60, boxV.bounds.size.width, boxV.bounds.size.height-60) style:UITableViewStylePlain];
    NSLog(@"%f",(float)boxV.bounds.size.width);
    tableV.backgroundColor=[UIColor whiteColor];
    tableV.delegate=self;
    tableV.dataSource=self;
    tableV.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
//    [tableV setSeparatorInset:UIEdgeInsetsZero];
    tableV.backgroundColor=[UIColor whiteColor];
    tableV.allowsSelection= YES;
    tableV.scrollEnabled =YES;
//    tableV.separatorColor=[UIColor clearColor];
    [boxV addSubview:tableV];
    

}


-(void)inputStr:(UITextField *)field{
    if (field.text.length > 10) {
        field.text = [field.text substringToIndex:10];
    }
}

-(void)addBox
{
    bV=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.width,self.view.height)];
    bV.backgroundColor=[UIColor blackColor];
    bV.alpha=0.5;
    [self.view addSubview:bV];
    
    boxV=[[UIView alloc]initWithFrame:CGRectMake(40, bV.bounds.size.height/3, bV.bounds.size.width-80, bV.bounds.size.height/3)];
    boxV.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:boxV];

    
    titleLB=[[UILabel alloc]initWithFrame:CGRectMake((boxV.bounds.size.width-(boxV.bounds.size.width-20))/2, 0, boxV.bounds.size.width-20, 60)];
    titleLB.textAlignment=NSTextAlignmentCenter;
    titleLB.text=@"自定义标签";
    titleLB.font=[UIFont systemFontOfSize:18];
    [boxV addSubview:titleLB];

    
    
    textf=[[UITextField alloc]initWithFrame:CGRectMake(30,  (boxV.bounds.size.height-40)/2, boxV.bounds.size.width-60, 40)];
    textf.placeholder = @"请输入标签内容";
    textf.delegate=self;
    textf.font=[UIFont systemFontOfSize:16];
    [textf addTarget:self action:@selector(inputStr:) forControlEvents:UIControlEventEditingChanged];
    [boxV addSubview:textf];
    
    
    UIButton*choiceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [choiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    choiceBtn.frame=CGRectMake(0,boxV.bounds.size.height-45, boxV.bounds.size.width/2, 45);
    [choiceBtn setTitle:@"取消" forState: UIControlStateNormal];
    [choiceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    choiceBtn.tag=1;
    choiceBtn.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
    choiceBtn.layer.borderWidth=0.5;
    [choiceBtn addTarget:self action:@selector(choiceBtnCliack:) forControlEvents:UIControlEventTouchUpInside];
    [boxV addSubview:choiceBtn];
    
    UIButton*choiceBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
    [choiceBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    choiceBtn2.frame=CGRectMake(boxV.bounds.size.width/2, boxV.bounds.size.height-45, boxV.bounds.size.width/2, 45);
    [choiceBtn2 setTitle:@"确定" forState: UIControlStateNormal];
    [choiceBtn2 setTitleColor:RGBA_COLOR(118, 168, 244, 1) forState:UIControlStateNormal];
    choiceBtn2.tag=2;
    choiceBtn2.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
    choiceBtn2.layer.borderWidth=0.5;
    [choiceBtn2 addTarget:self action:@selector(choiceBtnCliack:) forControlEvents:UIControlEventTouchUpInside];
    [boxV addSubview:choiceBtn2];
}

#pragma mark - tableview的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSString*indentifier=@"cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
   
    UILabel*lb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableV.bounds.size.width, 44)];
    lb.text=tableArr[indexPath.row];
    lb.textAlignment=NSTextAlignmentCenter;
    lb.font=[UIFont systemFontOfSize:16];
    [cell addSubview:lb];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",(long)indexPath.row);
    
    BOOL isExistence=NO;
    for (int i = 0; i < self.showMarkFriend.count; i++) {
        QCGetUserMarkModel *tempmod = self.showMarkFriend[i];
        if ([tableArr[indexPath.row] isEqualToString:tempmod.title]) {
            isExistence = YES;
        }
    }
    
    if (isExistence==NO) {
        QCGetUserMarkModel *mod=[[QCGetUserMarkModel alloc]init];
        mod.title = tableArr[indexPath.row];
        mod.type = 1;
        NSLog(@"mod====%@",mod.mj_keyValues);
        [self.newmarkFriend addObject:mod];
        NSLog(@"self.newmarkFriend====%@",[self getDictFromArr:self.newmarkFriend]);
        [self.showMarkFriend addObject:mod];
        NSLog(@"self.showMarkFriend====%@",[self getDictFromArr:self.showMarkFriend]);
        [textfLength addObject:[NSString stringWithFormat:@"%ld",(unsigned long)mod.title.length]];
        
        [self userMark];
    }else{
        [OMGToast showText:@"该标签已存在"];
    }
    [bV removeFromSuperview ];
    [boxV removeFromSuperview];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - 按钮
-(void)touchleftBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchRightBtn
{
    NSLog(@"完成");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddTag" object:nil userInfo:@{@"newArr":self.newmarkFriend,@"sumArr":self.showMarkFriend,@"isdelete":self.isdeleteArr}];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchblackBtn
{
    [bV removeFromSuperview];
    [boxV removeFromSuperview];
}

-(void)choiceBtnCliack:(UIButton*)btn
{
    if (btn.tag==1) {
        
    } else if(btn.tag==2){
        BOOL isExistence=NO;
        for (int i = 0; i < self.showMarkFriend.count; i++) {
            QCGetUserMarkModel *tempmod = self.showMarkFriend[i];
            if ([textf.text isEqualToString:tempmod.title]) {
                isExistence = YES;
            }
        }

        NSString *resultStr = [textf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (resultStr.length > 0) {
            if (isExistence == NO) {
                QCGetUserMarkModel *mod = [[QCGetUserMarkModel alloc]init];
                mod.title = textf.text;
                mod.type = 1;
                
                NSLog(@"mod====%@",mod.mj_keyValues);
                [self.newmarkFriend addObject:mod];
                [self.showMarkFriend insertObject:mod atIndex:0];
                [textfLength addObject:[NSString stringWithFormat:@"%ld",textf.text.length]];
                
                [self userMark];

            }else{
                [OMGToast showText:@"该标签已存在"];
            }
            
        }else{
            [OMGToast showText:@"自定义标签不能为空"];
        }
    }
    
    [bV removeFromSuperview];
    
    [boxV removeFromSuperview];
}


#pragma mark - 添加标签执行方法
-(void)userMark
{
    [picV removeFromSuperview];
    picV = [[UIView alloc]initWithFrame:CGRectMake(0,150, self.view.width, self.view.height-150)];
    [self .view addSubview:picV];
    
    for (int i=0; i < self.showMarkFriend.count; i++) {
        
        float w = 18 * ([textfLength[i] integerValue]);
        float h = 30;
        float x = [self getRandomNumber:0 to:picV.bounds.size.width-w];
        float y = [self getRandomNumber:0 to:picV.bounds.size.height-30];
        
        UILabel*tempLb=[[UILabel alloc]initWithFrame:CGRectMake(x+50, y+50, w, h)];
        tempLb.backgroundColor=[UIColor whiteColor];
        tempLb.textAlignment=NSTextAlignmentCenter;
        tempLb.textColor=RandomColor;
        tempLb.layer.cornerRadius=5;
        tempLb.tag=i;
        tempLb.layer.masksToBounds=YES;
        tempLb.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [tempLb addGestureRecognizer:tapGestureRecognizer];
        
        QCGetUserMarkModel *mod = self.showMarkFriend[i];
        tempLb.text = mod.title;
        tempLb.font=[UIFont systemFontOfSize:15];
        [picV addSubview:tempLb];
        
        [UIView animateWithDuration:0.5 animations:^{
            tempLb.alpha=0;
            tempLb.frame=CGRectMake(x, y, w, h);
        }];
        
        [UIView animateWithDuration:0.5 animations:^{
            tempLb.alpha=0.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                tempLb.alpha=1;
                NSLog(@"动画结束");
            }];
        }];
    }
}

-(float)getRandomNumber:(NSInteger)from to:(NSInteger)to
{
    return (float)(from + (arc4random() % (to - from + 1)));
}

#pragma mark - 键盘弹出
//键盘将要弹出的方法
-(void)keyBoardWillShowNotificationded:(NSNotification *)not
{
    //获取键盘高度
    NSDictionary *dic = not.userInfo;
    //获取坐标
    CGRect rc = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //键盘高度
    CGFloat f = rc.size.height;
    
    //调整输入框的位置
    [UIView animateWithDuration:0.1 animations:^{
        boxV.frame = CGRectMake(40, self.view.frame.size.height-f-(bV.bounds.size.height/3)-60,bV.bounds.size.width-80, bV.bounds.size.height/3);
    }];
}

//键盘消失的方法
-(void)keyBoardRemoveed:(NSNotification *)not
{
    //调整输入框的位置
    [UIView animateWithDuration:0.1 animations:^{
        boxV.frame = CGRectMake(40, bV.bounds.size.height/3, bV.bounds.size.width-80, bV.bounds.size.height/3);
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //回收键盘
    [textField  resignFirstResponder];
    return YES;
}

#pragma mark - 点击删除
-(void)tapGestureRecognized:(UITapGestureRecognizer*)tap
{
    QCGetUserMarkModel *mod = self.showMarkFriend[tap.view.tag];
    
    deleteStr = mod.title;
    
    NSLog(@"%@",deleteStr);
    
    [self deleteBox];
}

-(void)deleteBox
{
    bV=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.width,self.view.height)];
    bV.backgroundColor=[UIColor blackColor];
    bV.alpha=0.5;
    [self.view addSubview:bV];
    
    boxV=[[UIView alloc]initWithFrame:CGRectMake(40, bV.bounds.size.height/3, bV.bounds.size.width-80, bV.bounds.size.height/3)];
    boxV.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:boxV];

    UILabel*lb=[[UILabel alloc]initWithFrame:CGRectMake(40,( boxV.bounds.size.height-60)/2, boxV.bounds.size.width-80, 60)];
    lb.textAlignment=NSTextAlignmentCenter;
    lb.text=[NSString stringWithFormat:@"是否删除“%@”",deleteStr];
    lb.font=[UIFont systemFontOfSize:16];
    [boxV addSubview:lb];
    
    UIButton*choiceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [choiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    choiceBtn.frame=CGRectMake(0,boxV.frame.size.height-45, boxV.frame.size.width/2, 45);
    [choiceBtn setTitle:@"取消" forState: UIControlStateNormal];
    [choiceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    choiceBtn.tag=1;
    choiceBtn.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
    choiceBtn.layer.borderWidth=0.5;
    [choiceBtn addTarget:self action:@selector(deleteBtnCliack:) forControlEvents:UIControlEventTouchUpInside];
    [boxV addSubview:choiceBtn];
    
    UIButton*choiceBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
    [choiceBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    choiceBtn2.frame=CGRectMake(boxV.frame.size.width/2, boxV.frame.size.height-45, boxV.frame.size.width/2, 45);
    [choiceBtn2 setTitle:@"确定" forState: UIControlStateNormal];
    [choiceBtn2 setTitleColor:RGBA_COLOR(118, 168, 244, 1) forState:UIControlStateNormal];
    choiceBtn2.tag=2;
    choiceBtn2.layer.borderColor=[UIColor colorWithHexString:@"efefef"].CGColor;
    choiceBtn2.layer.borderWidth=0.5;
    
    [choiceBtn2 addTarget:self action:@selector(deleteBtnCliack:) forControlEvents:UIControlEventTouchUpInside];
    [boxV addSubview:choiceBtn2];

}


-(void)deleteBtnCliack:(UIButton*)bt
{
    if (bt.tag==1) {
        
    }else{
//    总数组
        for (int i=0; i<self.showMarkFriend.count; i++) {
            QCGetUserMarkModel*mod=self.showMarkFriend[i];
            if ([mod.title isEqualToString:deleteStr]) {
                [self.showMarkFriend removeObjectAtIndex:i];
            
            }
        }
        
//新添数组
        for (int i=0; i<self.newmarkFriend.count; i++) {
            QCGetUserMarkModel*mod=self.newmarkFriend[i];
            if ([mod.title isEqualToString:deleteStr]) {
                [self.newmarkFriend removeObjectAtIndex:i];
                
            }
            
        }
//旧数组
        for (int i=0; i<self.userMarkArr.count; i++) {
            QCGetUserMarkModel*mod=self.userMarkArr[i];
            if ([mod.title isEqualToString:deleteStr]) {
                self.isdeleteArr[i]=@"0";
                
            }
            
        }
    }
    
    [self userMark];


    [bV removeFromSuperview];
    [boxV removeFromSuperview];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
