//
//  NearDriverViewController.m
//  BookingCar
//
//  Created by mac on 2017/8/18.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "NearDriverViewController.h"
#import "NearDiverTableViewCell.h"
#import "NearDetailModel.h"
@interface NearDriverViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * NearArray;
    NSInteger OrderPage;
}
@property (nonatomic, strong)OrderCarModel * orderModel;
@property (nonatomic, strong)UITableView * NearDriverTabView;
@property (nonatomic, strong)NearDiverTableViewCell * nearDiverTabCell;
@end

@implementation NearDriverViewController
-(instancetype)initWithDataModel:(OrderCarModel *)orderCarModel
{
    if (self = [super init]) {
        _orderModel = [[OrderCarModel alloc]init];
        _orderModel = orderCarModel;
    }
    return self;
}
#pragma mark - 读取接口
-(void)requsetNearDriverViewList
{
    if (OrderPage == 0) {
        NearArray = [[NSMutableArray alloc]init];
    }
    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;

    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:login.token forKey:@"token"];
    [params setObject:self.orderModel.idTemp forKey:@"order_id"];
//    [params setValue:[NSString stringWithFormat:@"%f",self.orderModel.CoordinateStart.latitude] forKey:@"lat"];
//    [params setValue:[NSString stringWithFormat:@"%f",self.orderModel.CoordinateStart.longitude] forKey:@"lng"];
    [params setValue:@"10" forKey:@"per_page"];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)OrderPage] forKey:@"page"];
    
    [HttpTool getWithPath:kWaitingList2 params:params success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        for (NSDictionary * dic in responseObj[@"data"]) {
            NearDetailModel * order = [[NearDetailModel alloc]initWithRYDict:dic];
            [NearArray addObject:order];
        }
        [self.NearDriverTabView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark - 懒加载
-(UITableView *)NearDriverTabView
{
    if (nil == _NearDriverTabView) {
        _NearDriverTabView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _NearDriverTabView.delegate = self;
        _NearDriverTabView.dataSource = self;
        _NearDriverTabView.backgroundColor = RGBA(245, 245, 245, 1);
        _NearDriverTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _NearDriverTabView;
}
-(NearDiverTableViewCell *)nearDiverTabCell
{
    if (nil == _nearDiverTabCell) {
        _nearDiverTabCell = [[[NSBundle mainBundle]loadNibNamed:@"NearDiverTableViewCell" owner:self options:nil]lastObject];
    }
    return _nearDiverTabCell;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附近司机";
    [self.view addSubview:self.NearDriverTabView];
    [self.NearDriverTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.mas_equalTo(self.view);
    }];
    //下拉刷新
    [self CreatMJRefresh];
    NearArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
    [self requsetNearDriverViewList];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SIZE_WIDTH * (282.0/375.0);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return NearArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identCell = @"nearCell";
    self.nearDiverTabCell = [tableView dequeueReusableCellWithIdentifier:identCell];
    if (!self.nearDiverTabCell) {
        self.nearDiverTabCell = [[[NSBundle mainBundle]loadNibNamed:@"NearDiverTableViewCell" owner:self options:nil]lastObject];
    }
    if (NearArray.count > 0) {
        NearDetailModel * order = NearArray[indexPath.row];
        [self.nearDiverTabCell getInfo:order];
    }
    self.nearDiverTabCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return self.nearDiverTabCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.nearDiverTabCell.ButtonLove addTarget:self action:@selector(ButtonLove:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)ButtonLove:(UIButton *)sender
{
    NSLog(@"点心");
}

#pragma mark -- 下拉刷新
-(void)CreatMJRefresh{
    self.NearDriverTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        OrderPage = 0;
        [self requsetNearDriverViewList];
        NearArray = [[NSMutableArray alloc]init];
        //结束刷新
        [self.NearDriverTabView.mj_header endRefreshing];
        if (OrderPage*10 < NearArray.count) {
            [self.NearDriverTabView.mj_footer resetNoMoreData];
        }
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.NearDriverTabView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.NearDriverTabView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        OrderPage ++;
        
        if (OrderPage >= 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self requsetNearDriverViewList];
                // 结束刷新
                [self.NearDriverTabView.mj_footer endRefreshing];
            }
                           );
        }
        else{
            [self requsetNearDriverViewList];
            // 结束刷新
            [self.NearDriverTabView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
    
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
