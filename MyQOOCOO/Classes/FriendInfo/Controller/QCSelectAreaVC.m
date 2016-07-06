//
//  QCSelectAreaVC.m
//  MyQOOCOO
//
//  Created by lanou on 16/1/9.
//  Copyright © 2016年 CN.QOOCOO. All rights reserved.
//

#import "QCSelectAreaVC.h"

@interface QCSelectAreaVC ()

@end

@implementation QCSelectAreaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"选择地区";
    
    
    UIButton*rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.frame=CGRectMake(0, 0, 60, 40);
    rightBtn.font=[UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0xed6664) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(touchRights) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
  
    //省
    provincesArray=[[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ProvincesAndCities" ofType:@"plist"]];
    
    
    tableArr=provincesArray;
    
    iscity=NO;
    
    UILabel* location=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.width-15, 50)];
    location.text=@"定位到的位置";
    location.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:location];
    
    UIView*wView=[[UIView alloc]initWithFrame:CGRectMake(0, 50, self.view.width, 50)];
    wView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:wView];
    
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getaddress)];
    tap.numberOfTapsRequired =1;
    [wView addGestureRecognizer:tap];

    
    
    UIImageView*imagev=[[UIImageView alloc]initWithFrame:CGRectMake(15, 60, 20, 25)];
    imagev.image=[UIImage imageNamed:@"address"];
    [self.view addSubview:imagev];
    
    myAddress=[[UILabel alloc]initWithFrame:CGRectMake(45, 50,self.view.frame.size.width-60, 50)];
    myAddress.text=@"点击定位";
    [self.view addSubview:myAddress];
    
    UILabel*allLb=[[UILabel alloc]initWithFrame:CGRectMake(15, 100, self.view.width-15, 50)];
    allLb.text=@"全部";
    allLb.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:allLb ];
    
    
   UITableView* tableV=[[UITableView alloc]initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height-214) style:UITableViewStylePlain];
    tableV.backgroundColor=[UIColor whiteColor];
    tableV.delegate=self;
    tableV.dataSource=self;
    tableV.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    //    [tableV setSeparatorInset:UIEdgeInsetsZero];
    tableV.backgroundColor=[UIColor clearColor];
    tableV.allowsSelection= YES;
    tableV.scrollEnabled =YES;
    //    tableV.separatorColor=[UIColor clearColor];
    [self.view addSubview:tableV];

    
    // Do any additional setup after loading the view.
}



#pragma -mark tableview的代理方法

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
    
    UILabel*lb=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, cell.bounds.size.width-12, 50)];
    if (iscity==NO) {
        
    
    lb.text=[tableArr[indexPath.row] valueForKey:@"State"];
    }else{
    lb.text=[tableArr[indexPath.row] valueForKey:@"city"];
    
    
    }
//    lb.textAlignment=NSTextAlignmentCenter;
    lb.font=[UIFont systemFontOfSize:16];
    [cell addSubview:lb];
    
    UIImageView*imagev=[[UIImageView alloc]initWithFrame:CGRectMake(cell.bounds.size.width+20, 15, 20,20)];
    imagev.image=[UIImage imageNamed:@"LJjianyou@2x"];
    [cell addSubview:imagev];
    
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",(long)indexPath.row);
    if (iscity==YES) {
        self.AddresStr =[NSString stringWithFormat:@"%@%@",self.AddresStr,[tableArr[indexPath.row] valueForKey:@"city"]];
        self.city=[tableArr[indexPath.row] valueForKey:@"city"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectArea" object:nil userInfo:@{@"str":self.AddresStr,@"province":self.province,@"city":self.city}];
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        self.AddresStr=[tableArr[indexPath.row] valueForKey:@"State"];
        self.province=[tableArr[indexPath.row] valueForKey:@"State"];
        iscity=YES;
        //城市
        citiesArray=[[provincesArray objectAtIndex:indexPath.row] objectForKey:@"Cities"];
        tableArr=citiesArray;
        [tableView reloadData];
    
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    return 50;
    
    
    
}


#pragma mark - 地图定位后返回地址 LocationViewDelegate
-(void)sendLocationLatitude:(double)latitude longitude:(double)longitude andAddress:(NSString *)address{
        CZLog(@"%lf,%lf,%@",latitude,longitude,address);
//    self.latitude = latitude;
//    self.longitude = longitude;
    myAddress.text = address;
    self.AddresStr=address;
    CLLocation * location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [[CLGeocoder new] reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        
        
        if (!error) {
            CLPlacemark * placeMark = [placemarks firstObject];
            
            self.province=placeMark.administrativeArea;
            self.city=placeMark.locality;
            
            
            NSLog(@"%@",placeMark.addressDictionary);
        }
        
    }];


}

-(void)getaddress
{

    //    //地图定位
        LocationViewController* locationVC = [[LocationViewController alloc]init];
        locationVC.delegate = self;
        [self.navigationController pushViewController:locationVC animated:YES];

}



-(void)touchRights
{


   [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectArea" object:nil userInfo:@{@"str":self.AddresStr,@"province":self.province,@"city":self.city}];
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
