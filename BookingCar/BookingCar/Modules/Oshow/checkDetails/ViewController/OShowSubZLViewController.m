//
//  OShowSubZLViewController.m
//  BookingCar
//
//  Created by apple on 2017/10/28.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "OShowSubZLViewController.h"

@interface OShowSubZLViewController (){
    NSInteger OShowPage;
    //OShowModel *OShowmodel;
}

@end

@implementation OShowSubZLViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //关闭设置为NO, 默认值为NO.
    //键盘设置
    [IQKeyboardManager sharedManager].enable = NO;
    //键盘一建回收
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.chatKeyBoard.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //关闭设置为NO, 默认值为NO.
    //键盘设置
    [IQKeyboardManager sharedManager].enable = YES;
    //键盘一建回收
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    self.chatKeyBoard.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CreatRightBarButtonItem];
    [self.view addSubview:self.backTableVIew];
    [self.backTableVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.mas_equalTo(self.view);
    }];
    
    [self.backTableVIew registerNib:[UINib nibWithNibName:@"OShowDetailTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OShowTableViewCellIDZL"];
    self.backTableVIew.showsVerticalScrollIndicator = NO;
    self.backTableVIew.separatorStyle = UITableViewCellSelectionStyleNone;
    [self creatMJRefresh];
    //请求数据
    [self startAFNetworking];
    
    //    //设置键盘
    //    self.chatKeyBoard =[ChatKeyBoard keyBoardWithParentViewBounds:CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT)];
    //    self.chatKeyBoard.delegate = self;
    //    self.chatKeyBoard.dataSource = self;
    //    self.chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
    //    self.chatKeyBoard.allowVoice = NO;
    //    self.chatKeyBoard.allowMore = NO;
    //    //UIWindow *window =  [UIApplication sharedApplication].delegate.window;
    //    [self.view addSubview:self.chatKeyBoard];
}
-(void)creatMJRefresh{
    __weak typeof(self) weakSelf = self;
    
    //默认block方法：设置下拉刷新
    self.backTableVIew.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        OShowPage = 0;
        [weakSelf startAFNetworking];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.backTableVIew.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.backTableVIew.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        OShowPage ++;
        [weakSelf startAFNetworking];
    }];
    self.backTableVIew.mj_footer.automaticallyHidden = YES;
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
}
#pragma mark ===================TableView  方法 开始==================
#pragma mark ===================FDT TableVIewCell 高度返回==================
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"OShowTableViewCellIDZL" cacheByIndexPath:indexPath configuration:^(OShowDetailTableViewCell *cell) {
        [cell bindDataModel:[self.oShowListArray objectAtIndex:indexPath.row] withIndexPath:indexPath];
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.oShowListArray.count;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * identifier = @"OShowTableViewCellIDZL";
    OShowDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //[cell prepareForReuse];
    cell.comentTableViewHeight = 0;
    cell.delegate = self;
    [cell bindDataModel:[self.oShowListArray objectAtIndex:indexPath.row] withIndexPath:indexPath];
    
    NSLog(@"oshow执行了cellForRowAtIndexPath=====---++++");
    return cell;
}
//点击Cell触发
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

#pragma mark ===================TableView  方法  结束==================
#pragma mark ===================网络请求开始==================
//下拉刷新  请求数据 朋友圈数据
-(void)startAFNetworkingAtGlobalDispatch{
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self startAFNetworking];
    });
    
}
- (void)startAFNetworking{
     [SVProgressHUD showWithStatus:@"玩命加载中"];

    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:login.token forKey:@"token"];
    [params setValue:@"10" forKey:@"per_page"];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)OShowPage] forKey:@"page"];
    NSLog(@"请求OShow的params:%@",params);
    [HttpTool getWithPath:kOShowList2Url params:params success:^(id responseObj) {
        //NSLog(@"oshow--->%@",responseObj);
        //NSString * message = [NSString stringWithFormat:@"%@",responseObj[@"message"]];
        //        NSString * statusCode = [NSString stringWithFormat:@"%@",responseObj[@"statusCode"]];
        if ([responseObj[@"status"] intValue] == 1) {
            if (OShowPage == 0) {
                [self.oShowListArray removeAllObjects];
            }
            NSArray * data = responseObj[@"data"];
            for (NSDictionary * showDic in data) {
                OShowModel * showMo = [[OShowModel alloc]initWithRYDict:showDic];
                NSMutableArray * photoMutableArray = [NSMutableArray new];
                for (NSDictionary * photoDic in showMo.attache.copy) {
                    AttacheOShowPhoto * photoModel = [[AttacheOShowPhoto alloc]initWithRYDict:photoDic];
                    [photoMutableArray addObject:photoModel];
                }
                showMo.attache = [photoMutableArray copy];
                
                NSMutableArray * comentMutableArray = [NSMutableArray new];
                for (NSDictionary * comentDic in showMo.comments.copy) {
                    CommentsModel * comentModel = [[CommentsModel alloc]initWithRYDict:comentDic];
                    [comentMutableArray addObject:comentModel];
                }
                showMo.comments = [comentMutableArray copy];
                
                [self.oShowListArray addObject:showMo];
            }
        }
        NSLog(@"oshow中self。oShowListArray的个数：%ld",self.oShowListArray.count);
        //dispatch_async(dispatch_get_main_queue(), ^{
            [self.backTableVIew reloadData];
            [SVProgressHUD dismiss];
            // 结束刷新
            [self.backTableVIew.mj_header endRefreshing];
            [self.backTableVIew.mj_footer endRefreshing];
        //});
        
    } failure:^(NSError *error) {
        NSLog(@"朋友圈请求错误：%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
            [SVProgressHUD dismiss];
            // 结束刷新
            [self.backTableVIew.mj_header endRefreshing];
            [self.backTableVIew.mj_footer endRefreshing];
        });
        
    }];
    
}
//评论接口
//评论
-(void)startNetworkingComentWith:(NSString *)message withOshowModel:(OShowModel *)curOShowModel
{
    LoginModel * login = [[LoginModel alloc]init];
    login= [LoginDataModel sharedManager].loginInModel;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:login.token forKey:@"token"];
    [params setValue:message forKey:@"message"];
    [params setValue:curOShowModel.idTemp forKey:@"id"];
    
    [HttpTool getWithPath:kOShowComment params:params success:^(id responseObj) {
        //NSLog(@"%@",responseObj);
        
        //[[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:1.5f];
        
        //NSLog(@"评论成功！");
        
        
    } failure:^(NSError *error) {
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
    
}
//点赞
-(void)startNetworkingLoveActionWith:(NSString *)loveStatus withCurOshowModel:(OShowModel *)curModel{
    
    LoginModel * login = [[LoginModel alloc]init];
    login= [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:login.token forKey:@"token"];
    [params setValue:loveStatus forKey:@"flag"];
    [params setValue:curModel.idTemp forKey:@"id"];
    [HttpTool getWithPath:kFavoriteLove params:params success:^(id responseObj) {
        NSLog(@"点赞结果%@",responseObj);
        //        [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:1.5f];
    } failure:^(NSError *error) {
        NSLog(@"点赞网络请求结果:%@",error);
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:1.5f];
    }];
}
#pragma mark ===================网络请求结束==================
#pragma mark ===================OShowDetailTableViewCellDelegate  方法开始==================
//点击举报按钮
- (void)juBaoButtonActionWithIndexPath:(NSIndexPath *)indexPath{
    [[RYHUDManager sharedManager] showWithMessage:@"举报成功" customView:nil hideDelay:2.0f];
}

//点击评论按钮
- (void)didClickCommentBtnWithIndexPath:(NSIndexPath *)indexPath
{
    
    self.commentIndexpath = indexPath;
    OShowModel *model = self.oShowListArray[indexPath.row];
    self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"评论：%@",model.point];
    [self.chatKeyBoard keyboardUpforComment];
    
}
//点赞按钮方法
- (void)didClickLoveBtnWithIndexPath:(NSIndexPath *)indexPath{
    OShowModel *model = self.oShowListArray[indexPath.row];
    //    NSMutableArray *likeArray = [NSMutableArray arrayWithArray:model.likeNameArray];
    int loveNum = [model.love intValue];
    if ([model.status_love isEqualToString:@"0"]) {
        model.status_love = @"1";
        loveNum = loveNum +1;
        model.love = [NSString stringWithFormat:@"%d",loveNum];
    }
    else{
        model.status_love = @"0";
        loveNum = loveNum -1;
        int num = loveNum>=0?loveNum:0;
        model.love = [NSString stringWithFormat:@"%d",num];
    }
    //model.isLiked = !model.isLiked;
    [self.backTableVIew reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self startNetworkingLoveActionWith:model.status_love withCurOshowModel:model];
    //});
    
}
//点击某一行回复
- (void)didClickRowWithFirstIndexPath:(NSIndexPath *)firIndexPath secondIndex:(NSIndexPath *)secIndexPath{
    NSString * meNickName = [kUserDefaults valueForKey:USER_NICK_NAME];
    OShowModel *model = self.oShowListArray[firIndexPath.row];
    CommentsModel *comModel = model.comments[secIndexPath.row];
    if([comModel.nick_name isEqualToString:meNickName])
    {
        //        UIAlertController * controller = [UIAlertController alertControllerWithTitle:nil  message:@"是否删除该条评论" preferredStyle:UIAlertControllerStyleAlert];
        //        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //            NSLog(@"取消");
        //        }];
        //        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ////            NSMutableArray *mutableArray = model.commentArray.mutableCopy;
        ////            [mutableArray removeObjectAtIndex:secIndexPath.row];
        ////            model.commentArray = mutableArray.copy;
        ////            [self.tableView reloadRowsAtIndexPaths:@[firIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        //
        //        }];
        //        [controller addAction:cancelAction];
        //        [controller addAction:okAction];
        //        [self presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        self.commentIndexpath = firIndexPath;
        self.replyIndexpath = secIndexPath;
        
        self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复：%@",comModel.nick_name];
        [self.chatKeyBoard keyboardUpforComment];
    }
    
}

/**
 *==========ZL注释start===========
 *1.图片点击代理方法实现
 *
 *2.ImageURL
 *3.imageURLArray
 *4.indexPath  currentIndex
 ===========ZL注释end==========*/
#pragma mark ===================图片浏览器 ZJImageViewBrowser Start ==================
-(void)didClickImageViewWithCurrentView:(UIImageView *)imageView imageViewArray:(NSMutableArray *)array imageSuperView:(UIView *)view indexPath:(NSIndexPath *)indexPath
{
    ZJImageViewBrowser *browser = [[ZJImageViewBrowser alloc] initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT) imageViewArray:array imageViewContainView:view];
    browser.selectedImageView = imageView;
    [browser show];
}
#pragma mark ===================图片浏览器 ZJImageViewBrowser end ==================
#pragma mark ===================图片浏览器 MWPhotoBrowser Start ==================
- (void)oShowDetailTableViewCell:(OShowDetailTableViewCell *)cell withCurrentImage:(NSString *) currentImageURL withImageArray:(NSMutableArray *)imageArray withIndexPath:(NSIndexPath *)indexPath withCurrenImageIndex:(NSInteger )currentIndex{
    // Browser
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    
    [self.currentPhotoArray removeAllObjects];
    for (int i=0; i<imageArray.count; i++) {
        AttacheOShowPhoto * photoModel = imageArray[i];
        MWPhoto * photoZL = [MWPhoto photoWithURL:[NSURL URLWithString:photoModel.attache]];
        photoZL.caption = @"我在这，你在哪儿";
        [self.currentPhotoArray addObject:photoZL];
    }
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
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
#pragma mark ===================图片浏览器 MWPhotoBrowser END ==================
#pragma mark ===================OShowDetailTableViewCellDelegate 结束==================

#pragma mark ===================懒加载 开始==================
- (NSMutableArray *)oShowListArray{
    if (!_oShowListArray) {
        _oShowListArray = [NSMutableArray new];
    }
    return _oShowListArray;
}
- (NSMutableArray *)currentPhotoArray{
    if (!_currentPhotoArray) {
        _currentPhotoArray = [NSMutableArray new];
    }
    return _currentPhotoArray;
}
-(ChatKeyBoard *)chatKeyBoard{
    if (_chatKeyBoard==nil) {
        _chatKeyBoard =[ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
        _chatKeyBoard.delegate = self;
        _chatKeyBoard.dataSource = self;
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        _chatKeyBoard.allowVoice = NO;
        _chatKeyBoard.allowMore = NO;
        _chatKeyBoard.allowFace = NO;
        _chatKeyBoard.allowSwitchBar = NO;
        _chatKeyBoard.placeHolder = @"评论";
        //        [self.view addSubview:_chatKeyBoard];
        //        [self.view bringSubviewToFront:_chatKeyBoard];
        UIWindow *window =  [UIApplication sharedApplication].delegate.window;
        [window addSubview:_chatKeyBoard];
    }
    return _chatKeyBoard;
}
#pragma mark ===================懒加载 结束==================
#pragma mark ===================关于键盘的方法  开始==================
#pragma mark -- ChatKeyBoardDelegate
//发送评论
- (void)chatKeyBoardSendText:(NSString *)text;
{
    
    NSString * meNickName = [kUserDefaults valueForKey:USER_NICK_NAME];
    OShowModel *model = self.oShowListArray[self.commentIndexpath.row];
    
    CommentsModel *newComModel = [[CommentsModel alloc] init];
    //NSLog(@"发送评论状态的info.nick_name:%@",meNickName);
    newComModel.nick_name = meNickName;
    if(self.replyIndexpath)
    {
        CommentsModel * comModel2 = model.comments[self.replyIndexpath.row];
        //CommentsModel *comModel = model.commentArray[self.replyIndexpath.row];
        newComModel.replyUserName = comModel2.nick_name;
        //NSLog(@"回复谁：%@",newComModel.replyUserName);
    }
    newComModel.comment = text;
    NSMutableArray *mutableArray = model.comments.mutableCopy;
    [mutableArray addObject:newComModel];
    model.comments = mutableArray.copy;
    
    [self.backTableVIew reloadRowsAtIndexPaths:@[self.commentIndexpath] withRowAnimation:UITableViewRowAnimationFade];
    self.chatKeyBoard.placeHolder = nil;
    [self.chatKeyBoard keyboardDownForComment];
    NSString * stringText = nil;
    if (self.replyIndexpath) {
        stringText = [NSString stringWithFormat:@" 回复 %@:  %@",newComModel.replyUserName,text];
    }
    else{
        stringText = text;
    }
    self.replyIndexpath = nil;
    [self startNetworkingComentWith:stringText withOshowModel:model];
}

#pragma mark -- ChatKeyBoardDataSource
- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems
{
    return nil;
}
- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    return @[item1];
}
- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}

- (void)keyboardWillChangeNotification:(NSNotification *)notification
{
    NSLog(@"键盘变化通知");
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"%.1f---%.1f-----%.1f----%.1f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    //    if(rect.origin.y<SIZE_HEIGHT)
    //    {
    //        self.totalKeybordHeight  = rect.size.height + 49;
    //
    //        UITableViewCell *cell = [self.backTableVIew cellForRowAtIndexPath:self.commentIndexpath];
    //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //        //坐标转换
    //        CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    //
    //        CGFloat dis = CGRectGetMaxY(rect) - (window.bounds.size.height - self.totalKeybordHeight);
    //        CGPoint offset = self.backTableVIew.contentOffset;
    //        offset.y += dis;
    //        if (offset.y < 0) {
    //            offset.y = 0;
    //        }
    //
    //        [self.backTableVIew setContentOffset:offset animated:YES];
    //    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.chatKeyBoard.placeHolder = nil;
    [self.chatKeyBoard keyboardDownForComment];
    
}

#pragma mark ===================关于键盘的方法  结束==================

- (UITableView *)backTableVIew{
    if (!_backTableVIew) {
        _backTableVIew = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _backTableVIew.delegate = self;
        _backTableVIew.dataSource = self;
        
    }
    return _backTableVIew;
}


-(void)dealloc
{
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
