
//
//

#import <UIKit/UIKit.h>


@interface CityListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *cities;

@property (nonatomic, strong) NSMutableArray *keys; //城市首字母
@property (nonatomic, strong) NSMutableArray *arrayCitys;   //城市数据
@property (nonatomic, strong) NSMutableArray *arrayHotCity;
@property (nonatomic , strong)NSString *selectedCityName;

@property(nonatomic,strong)UITableView *tableView;



//定义一个回调的block;
-(instancetype)initWithChoose:(void(^)(NSString * cityName))chooseBlock;
@end
