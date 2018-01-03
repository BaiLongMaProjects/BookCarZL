//
//  MeController.m
//  BookingCar
//
//  Created by LiXiaoJing on 29/06/2017.
//  Copyright © 2017 LiXiaoJing. All rights reserved.
//

#import "MeController.h"
#import "CreatMeView.h"
#import "PersonCenterViewController.h"//个人中心
#import "MyLifeViewController.h"//我的动态
#import "RoleViewController.h"//切换角色
#import "NSDate+RYAdditions.h"
#import "LoginViewController.h"
#import "MyOrderListViewController.h"//我的行程
#import "WithMeViewController.h"//关于我们
#import "MyOfferViewController.h"//投诉建议

#define ALL_HEIGHT 240 + 60.0 * 5 + 20.0

@interface MeController ()<UIAlertViewDelegate>
{
    NSString * RoleName;
    
}
@property (nonatomic, strong)UIScrollView * MyScr;
@property (nonatomic, strong)CreatMeView * creatMeView;
@end

@implementation MeController


//加载个人信息
-(void)requsetdetail{
    [self showLoading];
    LoginModel * login = [[LoginModel alloc]init];
    login= [LoginDataModel sharedManager].loginInModel;
    InforModel * IninforMo = [[InforModel alloc]init];
    IninforMo = [LoginDataModel sharedManager].inforModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:login.token forKey:@"token"];
    NSLog(@"我的页面用户信息：");
    [HttpTool getWithPath:kDetailUrl params:params success:^(id responseObj) {
        NSString * status = [NSString stringWithFormat:@"%@",responseObj[@"status"]];
        if ([status isEqualToString:@"1"]) {
            NSLog(@"%@",responseObj);
            InforModel * inforMo = [[InforModel alloc]initWithRYDict:responseObj[@"data"][@"user"]];
            IninforMo.idTemp = inforMo.idTemp;
            IninforMo.create_time = inforMo.create_time;
            IninforMo.portrait_image = inforMo.portrait_image;
            IninforMo.nick_name = inforMo.nick_name;
            IninforMo.article_count = inforMo.article_count;
            IninforMo.mobile = inforMo.mobile;
            IninforMo.access_token = inforMo.access_token;
            IninforMo.company1 = inforMo.company1;
            IninforMo.company2 = inforMo.company2;
            IninforMo.email = inforMo.email;
            IninforMo.points = inforMo.points;
            IninforMo.job = inforMo.job;
            IninforMo.gender = inforMo.gender;
            IninforMo.role = inforMo.role;
            IninforMo.portrait_image = inforMo.portrait_image;
            
            [[LoginDataModel sharedManager]saveLoginMemberData:IninforMo];
            
            [_creatMeView.headerButton sd_setBackgroundImageWithURL:[NSURL URLWithString:inforMo.portrait_image] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"My_header"]];
            if ([RoleName isEqualToString:@"0"]) {
                self.creatMeView.LabRole.text = @"乘客";
            }else
            {
                self.creatMeView.LabRole.text = @"司机";
            }
            
            _creatMeView.LabNiceName.text = inforMo.nick_name;

        }
        if ([status isEqualToString:@"0"]) {
            [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:2.f];
        }
        [self dismissLoading];
    } failure:^(NSError *error) {
        [self dismissLoading];
    }];
}
-(UIScrollView*)MyScr
{
    if (nil == _MyScr) {
        _MyScr = [[UIScrollView alloc]init];
        _MyScr.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-49);
        _MyScr.backgroundColor = [UIColor colorWithhex16stringToColor:@"EFEFF4"];
        _MyScr.contentSize = CGSizeMake(KScreenWidth, ALL_HEIGHT);
    }
    return _MyScr;
}

-(CreatMeView *)creatMeView
{
    if (nil == _creatMeView) {
        _creatMeView = [[[NSBundle mainBundle]loadNibNamed:@"CreatMeView" owner:self options:nil]lastObject];
        [_creatMeView setFrame:CGRectMake(0, 0, KScreenWidth, ALL_HEIGHT)];
        /** 个人信息 */
        [_creatMeView.headerButton addTarget:self action:@selector(PerCenterClick:) forControlEvents:UIControlEventTouchUpInside];
        /** 我的动态 */
        [_creatMeView.dongTaiControl addTarget:self action:@selector(ButMyLifeClick) forControlEvents:UIControlEventTouchUpInside];
        /** 我的行程 */
        [_creatMeView.xingChengControl addTarget:self action:@selector(myXingCheng) forControlEvents:UIControlEventTouchUpInside];
        /** 切换角色 */
        [_creatMeView.ButSwichRole addTarget:self action:@selector(ButSwichRoleClick:) forControlEvents:UIControlEventTouchUpInside];
        /** 切换账号 */
        [_creatMeView.clearButton addTarget:self action:@selector(ButSwichLoginClick:) forControlEvents:UIControlEventTouchUpInside];
        /** 发布行程 */
        [_creatMeView.faBuControl addTarget:self action:@selector(ButIssueTripClick) forControlEvents:UIControlEventTouchUpInside];
        //关于我们
        [_creatMeView.ButWithMe addTarget:self action:@selector(ButWithMeClick:) forControlEvents:UIControlEventTouchUpInside];
        //投诉建议
        [_creatMeView.ButSwichLogin addTarget:self action:@selector(ButOfferClick:) forControlEvents:UIControlEventTouchUpInside];
        //清除缓存
        [_creatMeView.ButOffer addTarget:self action:@selector(clearSDWebImageCache) forControlEvents:UIControlEventTouchUpInside];
    }
    return _creatMeView;
}
/** 清除缓存 */
- (void)clearSDWebImageCache{
    //NSLog(@"快速document的路径：%@",kDocumentPath);
//    [ZLFileClearManager clearSDWebImageCacheResault:^(BOOL success, float fileSize) {
//        NSString * sizeString = [NSString stringWithFormat:@"清除了%.1fMB",fileSize];
//        //NSString * path = [ZLFileClearManager getDocumentPath];
//        //NSLog(@"document的路径为：%@",path);
//        [[RYHUDManager sharedManager] showWithMessage:sizeString customView:nil hideDelay:2.f];
//    }];
    [ZLFileClearManager clearALLFileCacheResault:^(BOOL success, float fileSize) {
        NSString * sizeString = [NSString stringWithFormat:@"清除了%.1fMB",fileSize];
        //NSString * path = [ZLFileClearManager getDocumentPath];
        //NSLog(@"document的路径为：%@",path);
        [[RYHUDManager sharedManager] showWithMessage:sizeString customView:nil hideDelay:1.f];
    }];
    
}

//个人中心
-(void)PerCenterClick:(UIButton *)sender
{
    
    PersonCenterViewController * percenter = [[PersonCenterViewController alloc]init];
    [self.navigationController pushViewController:percenter animated:YES];
     
}

//我的动态
-(void)ButMyLifeClick{
    MyLifeViewController * myLife = [[MyLifeViewController alloc]init];
    [self.navigationController pushViewController:myLife animated:YES];
}

//切换角色
-(void)ButSwichRoleClick:(UIButton *)sender
{
    RoleViewController * role = [[RoleViewController alloc]init
                                 ];
    [self.navigationController pushViewController:role animated:YES];
}

//发布行程
-(void)ButIssueTripClick
{
    self.tabBarController.selectedIndex = 0;
}
//我的行程
- (void)myXingCheng{
    self.tabBarController.selectedIndex = 1;
}
//关于我们
-(void)ButWithMeClick:(UIButton *)sender
{
    WithMeViewController * withMe = [[WithMeViewController alloc]init];
    [self.navigationController pushViewController:withMe animated:YES];
}

//投诉建议
-(void)ButOfferClick:(UIButton *)sender
{
    MyOfferViewController * Myoffer = [[MyOfferViewController alloc]init];
    [self.navigationController pushViewController:Myoffer animated:YES];
}

-(void)ButSwichLoginClick:(UIButton *)sender
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定要切换账号吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertview show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",(long)buttonIndex);
    if (buttonIndex == 1) {

        EMError *error = [[EMClient sharedClient] logout:YES];
        if (!error) {
            NSLog(@"退出成功");
        }
        LoginModel *inModel = [[LoginModel alloc]init];
        inModel.token = nil;
        [[LoginDataModel sharedManager] saveLoginInData:inModel];
        InforModel * info = [[InforModel alloc]init];
        [[LoginDataModel sharedManager] saveLoginMemberData:info];
       [(AppDelegate *)[UIApplication sharedApplication].delegate setRootControllerLoginVC];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"touMing"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //读取个人信息
    [self requsetdetail];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //UIStatusBarStyleDefault
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;//白色
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";

    [self.view addSubview:self.MyScr];
//    [self.MyScr mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.left.bottom.mas_equalTo(self.view);
//    }];
    //取出数据 但是数据格式尽量要对应 大部分是可以使用ObjectForKey的
    RoleName=[[NSUserDefaults standardUserDefaults] objectForKey:ROLE_TYPE_ZL];
    [self.MyScr addSubview:self.creatMeView];

    [self CreatNowTime];
    //ios 11新特性  解决 电池导航栏 空白问题
    if (@available(iOS 11.0, *)) {
        
        self.MyScr.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
-(void)CreatNowTime
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY年 MM月dd日"];
    NSString *DateTime = [formatter stringFromDate:date];

    //self.creatMeView.LabCreatTime.text = [NSString stringWithFormat:@"%@ %@",DateTime,[NSDate weekdataForDate:date]];
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
