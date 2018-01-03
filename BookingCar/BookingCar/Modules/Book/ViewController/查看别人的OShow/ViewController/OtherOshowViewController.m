//
//  OtherOshowViewController.m
//  BookingCar
//
//  Created by mac on 2017/9/13.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "OtherOshowViewController.h"
#import "MyLifeTableViewCell.h"//自定义Cell
#import "CheckDetailViewController.h"//详情
#import "MyLifeHeadView.h"//头视图
#import "CCHeadImagePicker.h"//调用系统的相册
#import "BigPhotoView.h"//图片放大
#import "LewPopupViewAnimationFade.h"
#import "OShowModel.h"
#import "MyLifeHeadModel.h"//头文件
@interface OtherOshowViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,BackUpDateDetailOShowVCDelegate>
{
    UIImage * Image;//储存头像的部分
    NSMutableArray * MyLifeArray;//我的生活数组
    NSInteger OShowPage;
}
@property (nonatomic, strong)UITableView * myLifeTab;
@property (nonatomic, strong)NearDetailModel * nearModel;

@property (nonatomic, strong)MyLifeTableViewCell * myLifeTabCell;
@property (nonatomic, strong)MyLifeHeadView * myLifeHeadView;
@end

@implementation OtherOshowViewController
-(instancetype)initWithDataModel:(NearDetailModel *)NearModel
{
    if (self=[super init]) {
        _nearModel=[[NearDetailModel alloc]init];
        _nearModel=NearModel;
    }
    return self;
}
-(UITableView * )myLifeTab{
    if (nil == _myLifeTab) {
        _myLifeTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
        _myLifeTab.delegate = self;
        _myLifeTab.dataSource = self;
        _myLifeTab.tableHeaderView = self.myLifeHeadView;
    }
    return _myLifeTab;
}
-(MyLifeHeadView *)myLifeHeadView{
    if (nil == _myLifeHeadView) {
        NSArray * nibs = [[NSBundle mainBundle]loadNibNamed:@"MyLifeHeadView" owner:self options:nil];
        _myLifeHeadView = [nibs lastObject];
        [_myLifeHeadView.ButBack addTarget:self action:@selector(ButBackClick:) forControlEvents:UIControlEventTouchUpInside];
        //点击了背景图
        _myLifeHeadView.ImgBigPhoto.userInteractionEnabled = YES;
        _myLifeHeadView.ImgBigPhoto.contentMode = UIViewContentModeScaleAspectFill;
        _myLifeHeadView.ImgBigPhoto.clipsToBounds = YES;
        //点击了头像
        _myLifeHeadView.ImgHeadPhoto.userInteractionEnabled = YES;
//        InforModel * infor = [[InforModel alloc]init];
//        infor = [LoginDataModel sharedManager].inforModel;
//        [_myLifeHeadView.ImgHeadPhoto sd_setImageWithURL:[NSURL URLWithString:infor.portrait_image] placeholderImage:[UIImage imageNamed:@"My_Header"]];
        //设置手势
        UITapGestureRecognizer * tapHeadPhoto = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headPhotoClick:)];
        tapHeadPhoto.numberOfTouchesRequired = 1; //手指数
        tapHeadPhoto.numberOfTapsRequired = 1; //tap次数
        tapHeadPhoto.delegate= self;
        _myLifeHeadView.ImgHeadPhoto.contentMode = UIViewContentModeScaleToFill;
        [_myLifeHeadView.ImgHeadPhoto addGestureRecognizer:tapHeadPhoto];
    }
    return _myLifeHeadView;
}
-(MyLifeTableViewCell *)myLifeTabCell{
    if (nil == _myLifeTabCell) {
        NSArray * nibs = [[NSBundle mainBundle]loadNibNamed:@"MyLifeTableViewCell" owner:self options:nil];
        _myLifeTabCell = [nibs lastObject];
        [self.myLifeTabCell.LabMessage setFrame:CGRectMake(58, 16, 200, 15)];
    }
    return _myLifeTabCell;
}
#pragma mark -- 数据请求
-(void)requsetMyLifeView{
    [self showLoading];
    LoginModel * login = [[LoginModel alloc]init];
    login= [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:login.token forKey:@"token"];
    [params setValue:self.nearModel.idTemp forKey:@"user_id"];

    [HttpTool getWithPath:kOShowOtherList params:params success:^(id responseObj) {
        
        if ([[NSString stringWithFormat:@"%@",responseObj[@"statusCode"]]isEqualToString:@"1"]) {
            [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:2.f];
        }
        if ([[NSString stringWithFormat:@"%@",responseObj[@"statusCode"]]isEqualToString:@"0"]) {
            
            NSDictionary * user_info = responseObj[@"user_info"];
            MyLifeHeadModel * lifeHead = [[MyLifeHeadModel alloc]initWithRYDict:user_info];
            [self.myLifeHeadView getInfo:lifeHead];
            
            self.title = [NSString stringWithFormat:@"%@的Show",lifeHead.nick_name];
    
            NSArray * data = responseObj[@"data"];
            NSLog(@"%@",data);
            for (NSDictionary * dic in data) {
                OShowModel * oshow = [[OShowModel alloc]initWithRYDict:dic];
                [MyLifeArray addObject:oshow];
            }
        }
        
        [self.myLifeTab reloadData];
        [self dismissLoading];
        
    } failure:^(NSError *error) {
        
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
        [self dismissLoading];
    }];
    
}
-(void)headPhotoClick:(UITapGestureRecognizer *)tap{
    //网络图片的加载方法
    //本地图片的加载方法
    BigPhotoView *view = [BigPhotoView defaultPopupView];
    
    view.parentVC = self;
    view.ImgPhotoHead.image = self.myLifeHeadView.ImgHeadPhoto.image;
    
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
        NSLog(@"动画结束");
    }];
}
-(void)CreatMJRefresh{
    self.myLifeTab.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            OShowPage = 0;
            MyLifeArray = [[NSMutableArray alloc]init];
            [self requsetMyLifeView];
            // 结束刷新
            [self.myLifeTab.mj_header endRefreshing];
            if (OShowPage*10 < MyLifeArray.count) {
                [self.myLifeTab.mj_footer resetNoMoreData];
            }
        });
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.myLifeTab.mj_header.automaticallyChangeAlpha = YES;
    
    //    // 上拉刷新
    //    self.myLifeTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    //        //        if (OShowPage * 10<_OShowListArray.count) {
    //        if (OShowPage >= 0) {
    //            //
    //            //            // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                [self requsetMyLifeView];
    //                //                // 结束刷新
    //                [self.myLifeTab.mj_footer endRefreshing];
    //            }
    //                           );
    //        }
    //        else{
    //
    //            [self requsetMyLifeView];
    //
    //            // 结束刷新
    //            [self.myLifeTab.mj_footer endRefreshingWithNoMoreData];
    //        }
    //    }];
}
-(void)ButBackClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    /** 解决返回黑块问题 隐藏时加上动画*/
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    MyLifeArray = [[NSMutableArray alloc]init];


    self.view.backgroundColor = kGlobalBg;
    //加载我的OShow数据
    [self requsetMyLifeView];
    //刷新数据
    [self CreatMJRefresh];
    
    [self.view addSubview:self.myLifeTab];
    //ios 11新特性
    if (@available(iOS 11.0, *)) {
        
        self.myLifeTab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    // Do any additional setup after loading the view.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MyLifeArray.count;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"myLifeCell";
    self.myLifeTabCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!self.myLifeTabCell) {
        self.myLifeTabCell = [[[NSBundle mainBundle]loadNibNamed:@"MyLifeTableViewCell" owner:self options:nil]lastObject];
    }
    OShowModel * oshow = [[OShowModel alloc]init];
    oshow = MyLifeArray[indexPath.row];
    self.myLifeTabCell.currentIndexPath = indexPath;
    [self.myLifeTabCell getInfo:oshow];
    
    /** 点击CollectionViewcCell 跳转到图片查看器 */
    self.myLifeTabCell.clickBlock = ^(NSIndexPath *currentIndexPath) {
        [weak_self(self) pushToPhotoBrownerWithIndexPath:currentIndexPath];
    };
    
    return self.myLifeTabCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushToPhotoBrownerWithIndexPath:indexPath];
}

/** 跳转到图片查看控制器 */
- (void)pushToPhotoBrownerWithIndexPath:(NSIndexPath *)indexPath{
//    OShowModel * oshowModel = MyLifeArray[indexPath.row];
//    if (oshowModel.attache.count > 0) {
//        NSMutableArray * imageArray = [NSMutableArray new];
//        for (NSDictionary * dics in oshowModel.attache) {
//            AttacheOShowPhoto * photoModel = [[AttacheOShowPhoto alloc]initWithRYDict:dics];
//            [imageArray addObject:photoModel];
//        }
//        AttacheOShowPhoto * firstModel = imageArray[0];
//        [self oShowDetailTableViewCellwithCurrentImage:firstModel.attache withImageArray:imageArray withIndexPath:indexPath withCurrenImageIndex:0];
//    }
    MyLifeTableViewCell * cell = [self.myLifeTab cellForRowAtIndexPath:indexPath];
    
    OShowModel * oshowModel = MyLifeArray[indexPath.row];
    if (oshowModel.attache.count > 0) {
        NSMutableArray * imageArray = [NSMutableArray new];
        for (NSDictionary * dics in oshowModel.attache) {
            AttacheOShowPhoto * photoModel = [[AttacheOShowPhoto alloc]initWithRYDict:dics];
            UIImageView * imageView = [[UIImageView alloc]init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            //        AttacheOShowPhoto * photoModel = self.collectionImageArray[i];
            //[imageView sd_setImageWithURL:[NSURL URLWithString:photoModel.attache] placeholderImage:[UIImage imageNamed:Default_ImageView]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:photoModel.attache] placeholderImage:[UIImage imageNamed:Default_ImageView] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            [imageArray addObject:imageView];
        }
        UIImageView * firstImage = imageArray[0];
        ZJImageViewBrowser *browser = [[ZJImageViewBrowser alloc] initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT) imageViewArray:imageArray imageViewContainView:cell.attachePhotoCollectionCell.contentView];
        browser.selectedImageView = firstImage;
        [browser show];
    }
}

-(void)UpDateRequsetDetailOShowVCData
{
    MyLifeArray = [[NSMutableArray alloc]init];
    [self requsetMyLifeView];
}

#pragma mark ===================图片浏览器 MWPhotoBrowser Start ==================
- (void)oShowDetailTableViewCellwithCurrentImage:(NSString *) currentImageURL withImageArray:(NSMutableArray *)imageArray withIndexPath:(NSIndexPath *)indexPath withCurrenImageIndex:(NSInteger )currentIndex{
    // Browser
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    OShowModel * oshowModel = MyLifeArray[indexPath.row];
    [self.currentPhotoArray removeAllObjects];
    for (int i=0; i<imageArray.count; i++) {
        AttacheOShowPhoto * photoModel = imageArray[i];
        MWPhoto * photoZL = [MWPhoto photoWithURL:[NSURL URLWithString:photoModel.attache]];
        photoZL.caption = oshowModel.message;
        [self.currentPhotoArray addObject:photoZL];
    }
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    [browser.tabBarController.tabBar setHidden:YES];
    browser.displayActionButton = displayActionButton;//分享按钮,默认是
    browser.displayNavArrows = displayNavArrows;//左右分页切换,默认否
    browser.displaySelectionButtons = displaySelectionButtons;//是否显示选择按钮在图片上,默认否
    browser.alwaysShowControls = displaySelectionButtons;//控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = NO;//是否全屏,默认是
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;//是否全屏
#endif
    browser.enableGrid = enableGrid;//是否允许用网格查看所有图片,默认是
    browser.startOnGrid = startOnGrid;//是否第一张,默认否
    browser.enableSwipeToDismiss = NO;
    [browser showNextPhotoAnimated:NO];
    [browser showPreviousPhotoAnimated:NO];
    [browser setCurrentPhotoIndex:currentIndex];//当前图片位置
    //browser.photoTitles = @[@"000",@"111",@"222",@"333"];//标题
    
    //[self presentViewController:browser animated:YES completion:nil];
    [self.navigationController pushViewController:browser animated:NO];
    
    
}
#pragma mark - MWPhotoBrowserDelegate
- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser{
    
    NSLog(@"调用了photoBrowserDidFinishModalPresentation方法");
}
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.currentPhotoArray.count;
}

- (id )photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.currentPhotoArray.count)
        return [self.currentPhotoArray objectAtIndex:index];
    return nil;
}

- (NSMutableArray *)currentPhotoArray{
    if (!_currentPhotoArray) {
        _currentPhotoArray = [NSMutableArray new];
    }
    return _currentPhotoArray;
}

#pragma mark ===================图片浏览器 MWPhotoBrowser END ==================


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
