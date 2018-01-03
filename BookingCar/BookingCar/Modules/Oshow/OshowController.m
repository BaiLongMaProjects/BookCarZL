//
//  OshowController.m
//  BookingCar
//
//  Created by LiXiaoJing on 29/06/2017.
//  Copyright © 2017 LDX. All rights reserved.
//

#import "OshowController.h"
#import "OShowTableViewCell.h"//自定义Cell
#import "AttachePhotoCollectionViewCell.h"//自定义照片Cell
#import "OShowModel.h"//OShow数据
#import "AttacheOShowPhoto.h"//OShow照片
#import "UIBarButtonItem+Icon.h"
#import "IssueOShowViewController.h"//发布朋友圈
#import "CheckDetailViewController.h"//展示某个朋友圈
#import "OShowBigPhotoScrView.h"//图片放大
#import "JJPhotoManeger.h"

static const CGFloat MJDuration = 2.0;

@interface OshowController ()<UITableViewDelegate,UITableViewDataSource,OShowPhotoImageDelegate,UIGestureRecognizerDelegate,BackUpDateDetailOShowVCDelegate,JJPhotoDelegate>
{
    //    NSArray * data;//包含的数据
    NSInteger OShowPage;
    OShowModel *OShowmodel;
}
@property (nonatomic, strong)UITableView * OShowTab;//OShow朋友圈列表
@property (nonatomic, strong)NSMutableArray * OShowListArray;
@property (nonatomic, strong)OShowTableViewCell * OShowTabCell;//自定义Cell
@end

@implementation OshowController

//下拉刷新
-(void)requsetUpdateOShowList{
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    if (OShowPage == 0) {
        self.OShowListArray = [[NSMutableArray alloc]init];
    }
    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:login.token forKey:@"token"];
    [params setValue:@"5" forKey:@"per_page"];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)OShowPage] forKey:@"page"];
    [HttpTool getWithPath:kOShowList2Url params:params success:^(id responseObj) {
        NSLog(@"PengYou---->:%@",responseObj[@"data"]);
        NSString * message = [NSString stringWithFormat:@"%@",responseObj[@"message"]];
        NSString * statusCode = [NSString stringWithFormat:@"%@",responseObj[@"statusCode"]];
        if ([message  isEqualToString:@"sucess"]) {
            NSArray * data = responseObj[@"data"];
            
            for (NSDictionary * showDic in data) {
                OShowModel * showMo = [[OShowModel alloc]initWithRYDict:showDic];
                [self.OShowListArray addObject:showMo];
            }
        }
        [self.OShowTab reloadData];
        [SVProgressHUD dismiss];
        // 结束刷新
        [self.OShowTab.mj_header endRefreshing];
        [self.OShowTab.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
        [SVProgressHUD dismiss];
        // 结束刷新
        [self.OShowTab.mj_header endRefreshing];
        [self.OShowTab.mj_footer endRefreshing];
    }];
    
}

-(UITableView *)OShowTab
{
    if (nil == _OShowTab) {
        _OShowTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _OShowTab.delegate = self;
        _OShowTab.dataSource = self;
        //  支持自适应 cell
        //        _OShowTab.estimatedRowHeight = 219;
        _OShowTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _OShowTab.rowHeight = UITableViewAutomaticDimension;
        _OShowTab.backgroundColor = [UIColor whiteColor];
    }
    return _OShowTab;
}

-(OShowTableViewCell *)OShowTabCell
{
    if (nil == _OShowTabCell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"OShowTableViewCell" owner:self options:nil];
        _OShowTabCell = [nibs lastObject];
        
        _OShowTabCell.delegate = self;
    }
    return _OShowTabCell;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    OShowPage = 0;
    [self requsetUpdateOShowList];
    [self.tabBarController.tabBar setHidden:NO];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"OShow";
    
    self.OShowListArray = [[NSMutableArray alloc]init];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //添加OShow页面
    [self.view addSubview:self.OShowTab];
    [self.OShowTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.mas_equalTo(self.view);
    }];
    //右侧点击发朋友圈
    [self CreatRightBarButtonItem];
    //加载朋友圈
    //    [self requsetUpdateOShowList];
    //下拉刷新
    [self CreatMJRefresh];
}
-(void)CreatMJRefresh{
    
    self.OShowTab.mj_footer.automaticallyHidden = YES;
    
    __weak typeof(self) weakSelf = self;
    
    //默认block方法：设置下拉刷新
    self.OShowTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        OShowPage = 0;
        [weakSelf requsetUpdateOShowList];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.OShowTab.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.OShowTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        OShowPage ++;
        [weakSelf requsetUpdateOShowList];
    }];
}



#pragma mark- delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.OShowTabCell.LabMessage setFont:[UIFont systemFontOfSize:14*D_height]];
    CGSize titleSize = [self.OShowTabCell.LabMessage.text boundingRectWithSize:CGSizeMake(self.OShowTabCell.LabMessage.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    if (self.OShowTabCell.ViewImage.hidden == YES) {
        return self.OShowTabCell.LabMessage.frame.size.height+150;
    }
    if (OShowmodel.attache.count == 1) {
        [self.OShowTabCell.AttachePhotoCollectionView setFrame:CGRectMake(0, 0, 275*D_width, 170*D_height)];
        return titleSize.height*D_height + (self.OShowTabCell.AttachePhotoCollectionView.frame.size.height+160)*D_height;
    }
    if (OShowmodel.attache.count == 2) {
        [self.OShowTabCell.AttachePhotoCollectionView setFrame:CGRectMake(0, 0, 275*D_width, 200*D_height)];
        return titleSize.height + self.OShowTabCell.AttachePhotoCollectionView.frame.size.height+120;
    }
    if (OShowmodel.attache.count == 3) {
        [self.OShowTabCell.AttachePhotoCollectionView setFrame:CGRectMake(0, 0, 275*D_width, 90*D_height)];
        return titleSize.height + self.OShowTabCell.AttachePhotoCollectionView.frame.size.height+120;
    }
    if (OShowmodel.attache.count <= 6 && OShowmodel.attache.count > 3) {
        [self.OShowTabCell.AttachePhotoCollectionView setFrame:CGRectMake(0, 0, 275*D_width, 200)];
        return titleSize.height + self.OShowTabCell.AttachePhotoCollectionView.frame.size.height+120;
    }
    if (OShowmodel.attache.count == 9) {
        [self.OShowTabCell.AttachePhotoCollectionView setFrame:CGRectMake(0, 0, 275*D_width, 260*D_height)];
        return titleSize.height*D_height + (self.OShowTabCell.AttachePhotoCollectionView.frame.size.height+130);
    }
    [self.OShowTabCell.AttachePhotoCollectionView setFrame:CGRectMake(0, 0, 275*D_width, 260*D_height)];
    return titleSize.height*D_height + (self.OShowTabCell.AttachePhotoCollectionView.frame.size.height+130);
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.OShowListArray.count;
}
//点击Cell触发
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击时去灰的方法
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    NSLog(@"点击了 == %@",perCenterArr[indexPath.row]);
    //    if (indexPath.row == 0) {
    NSLog(@"点击了 ");
    OShowModel * oshowModel = [[OShowModel alloc]init];
    oshowModel = self.OShowListArray[indexPath.row];
    CheckDetailViewController * checkDetailVC = [[CheckDetailViewController alloc]initWithDataModel:oshowModel];
    checkDetailVC.backUpDatedelegate = self;
    checkDetailVC.page = OShowPage;
    checkDetailVC.OShowPath = indexPath;
    if ([oshowModel.status isEqualToString:@"999"]) {
        checkDetailVC.LoveBooL = YES;
    }
    else
    {
        checkDetailVC.LoveBooL = NO;
    }
    [self.navigationController pushViewController:checkDetailVC animated:YES];
    
    //    }
    
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * identifier = @"OShowTabCell";
    self.OShowTabCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!self.OShowTabCell) {
        self.OShowTabCell = [[[NSBundle mainBundle]loadNibNamed:@"OShowTableViewCell" owner:self options:nil]lastObject];
        [self.OShowTabCell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    if (self.OShowListArray.count>0) {
        OShowmodel = self.OShowListArray[indexPath.row];
        [self.OShowTabCell getInfo:OShowmodel andIndexPath:indexPath];
    }
    //点击没反应方法
    self.OShowTabCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return self.OShowTabCell;
}

//添加头部左边栏
-(void)CreatRightBarButtonItem{
    UIBarButtonItem * bar = [[UIBarButtonItem alloc]initWithIcon:@"OShow_add" target:self action:@selector(OShowaddClick:)];
    self.navigationItem.rightBarButtonItem = bar;
}
-(void)OShowaddClick:(UIButton *)sender
{
    IssueOShowViewController * issueOShow = [[IssueOShowViewController alloc]init];
    [self.navigationController pushViewController:issueOShow animated:YES];
    //    FaBuZLViewController * VC = [[FaBuZLViewController alloc]init];
    //    [self.navigationController pushViewController:VC animated:YES];
    //    issueOShow.backUpDatedelegate = self;
}
////刷新数据
//-(void)UpDateRequsetOShowData
//{
//    [self requsetUpdateOShowList];
//}

-(void)OShowPhotoImageClick:(NSString *)ImageUrl
{
    OShowBigPhotoScrView * ScrPhoto = [OShowBigPhotoScrView defaultPopupView];
    ScrPhoto.parentVC = self;
    [ScrPhoto.ImageOShowBigPhoto sd_setImageWithURL:[NSURL URLWithString:ImageUrl] placeholderImage:[UIImage imageNamed:@"My_Header"]];
    [self lew_presentPopupView:ScrPhoto animation:[LewPopupViewAnimationSpring new] dismissed:^{
        NSLog(@"动画结束");
    }];
}

-(void)UpDateRequsetDetailOShowVCData
{
    [self requsetUpdateOShowList];
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
