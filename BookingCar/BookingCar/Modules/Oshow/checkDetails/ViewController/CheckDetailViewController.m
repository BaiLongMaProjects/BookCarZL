//
//  CheckDetailViewController.m
//  BookingCar
//
//  Created by mac on 2017/7/8.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "CheckDetailViewController.h"
#import "checkDetailTableViewCell.h"//
#import "checkDedatilModel.h"//数据
#import "checkHeadView.h"//视图
#import "OShowBigPhotoScrView.h"
#import "CommentTextView.h"//textView
@interface CheckDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,OShowPhotoImageDelegate>
{
    NSArray * data;//包含的数据
    NSString * Strflag;
    UITextField * text;
    UIView * ViewKeybord;
    NSMutableArray * CommentArray;
    checkDedatilModel * checking;
    UIButton *informButton;
    NSString * StrInformflag;
    BOOL BOOLReport;
}

@property (nonatomic, strong)UIScrollView * checkDetailScr;
@property (nonatomic, strong)checkHeadView * checkHeadView;
@property (nonatomic, strong)checkDedatilModel * checkMo;
@property (nonatomic, strong)CommentTextView * commentTextView;
@property (nonatomic, strong)UITableView * checkDetailTab;
@property (nonatomic, strong)checkDetailTableViewCell * checkDetailTabViewCell;
@property (nonatomic, strong)OShowModel * oshowModel;

@end

@implementation CheckDetailViewController

//点赞
-(void)requsetFavoriteLove{

    LoginModel * login = [[LoginModel alloc]init];
    login= [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:login.token forKey:@"token"];
    [params setValue:Strflag forKey:@"flag"];
    [params setValue:self.oshowModel.idTemp forKey:@"id"];
    [HttpTool getWithPath:kFavoriteLove params:params success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:1.5f];
    } failure:^(NSError *error) {
      [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:1.5f];
    }];
}
//评论
-(void)requsetCommentUpLoad
{
    LoginModel * login = [[LoginModel alloc]init];
    login= [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:login.token forKey:@"token"];
    [params setValue:text.text forKey:@"message"];
    [params setValue:self.oshowModel.idTemp forKey:@"id"];
    [HttpTool getWithPath:kOShowComment params:params success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:1.5f];
        checking = [[checkDedatilModel alloc]initWithRYDict:responseObj];
        checking.comment = text.text;
        [CommentArray addObject:checking];
        self.checkHeadView.LabComments.text = [NSString stringWithFormat:@"%ld",CommentArray.count];
            [self.checkDetailTab reloadData];
    } failure:^(NSError *error) {
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
}
//举报
-(void)requsetInform
{
    LoginModel * login = [[LoginModel alloc]init];
    login= [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:login.token forKey:@"token"];
    [params setValue:StrInformflag forKey:@"flag"];
    [params setValue:self.oshowModel.idTemp forKey:@"oshow_id"];
    [HttpTool getWithPath:kOShowReport params:params success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]]isEqualToString:@"1"]) {
            [[RYHUDManager sharedManager] showWithMessage:@"操作成功！" customView:nil hideDelay:2.f];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
}
//屏蔽
-(void)requsetScreening
{
    LoginModel * login = [[LoginModel alloc]init];
    login= [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:login.token forKey:@"token"];
    [params setValue:StrInformflag forKey:@"flag"];
    [params setValue:@"9" forKey:@"mark"];
    [params setValue:self.oshowModel.idTemp forKey:@"blocked"];
    [HttpTool getWithPath:kOShowShield params:params success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]]isEqualToString:@"1"]) {
            [[RYHUDManager sharedManager] showWithMessage:@"操作成功！" customView:nil hideDelay:2.f];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
}


-(UIScrollView*)checkDetailScr
{
    if (nil == _checkDetailScr) {
        _checkDetailScr = [[UIScrollView alloc]init];
        _checkDetailScr.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        _checkDetailScr.backgroundColor = [UIColor grayColor];
        _checkDetailScr.contentSize = CGSizeMake(KScreenWidth, 667);
    }
    return _checkDetailScr;
}
-(UITableView *)checkDetailTab
{
    if (nil == _checkDetailTab) {
        _checkDetailTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
        _checkDetailTab.delegate = self;
        _checkDetailTab.dataSource = self;
        _checkDetailTab.backgroundColor = [UIColor whiteColor];
        _checkDetailTab.rowHeight = UITableViewAutomaticDimension;
        //  支持自适应 cell
        _checkDetailTab.estimatedRowHeight = 219;
        _checkDetailTab.tableHeaderView = self.checkHeadView;
        //去线
        self.checkDetailTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _checkDetailTab;
}
-(checkDetailTableViewCell *)checkDetailTabViewCell
{
    if (nil == _checkDetailTabViewCell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"checkDetailTableViewCell" owner:self options:nil];
        _checkDetailTabViewCell = [nibs lastObject];
    }
    return _checkDetailTabViewCell;
}
-(checkHeadView *)checkHeadView
{
    if (nil == _checkHeadView) {
        NSArray * nibs = [[NSBundle mainBundle]loadNibNamed:@"checkHeadView" owner:self options:nil];
        _checkHeadView = [nibs lastObject];
        _checkHeadView.delegate = self;
        [_checkHeadView getInfo:self.oshowModel];
        [self.checkHeadView.LabMessage setFont:[UIFont systemFontOfSize:14*D_height]];
        CGSize titleSize = [self.checkHeadView.LabMessage.text boundingRectWithSize:CGSizeMake(self.checkHeadView.LabMessage.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        if (self.checkHeadView.ViewImage.hidden == YES || _oshowModel.attache.count == 0) {
            [self.checkHeadView setFrame:CGRectMake(0, 0, self.checkHeadView.frame.size.width, titleSize.height + 150)];
        }
        if (_oshowModel.attache.count == 2) {
            [self.checkHeadView.AttachePhotoCollectionView setFrame:CGRectMake(0, 0, 275*D_width, 200*D_height)];
           [self.checkHeadView setFrame:CGRectMake(0, 0, self.checkHeadView.frame.size.width*D_width, titleSize.height+self.checkHeadView.AttachePhotoCollectionView.frame.size.height+120)];
        }
        if (_oshowModel.attache.count == 3) {
            [self.checkHeadView.AttachePhotoCollectionView setFrame:CGRectMake(0, 0, 275*D_width, 90*D_height)];
            [self.checkHeadView setFrame:CGRectMake(0, 0, self.checkHeadView.frame.size.width*D_width, titleSize.height+self.checkHeadView.AttachePhotoCollectionView.frame.size.height+120)];
        }
        if ( _oshowModel.attache.count <= 6 && _oshowModel.attache.count > 3) {
            self.checkHeadView.ViewImage.backgroundColor = [UIColor clearColor];
            [self.checkHeadView.AttachePhotoCollectionView setFrame:CGRectMake(0, 0, 275*D_width, 200*D_height)];
            [self.checkHeadView setFrame:CGRectMake(0, 0, self.checkHeadView.frame.size.width*D_width, titleSize.height+self.checkHeadView.AttachePhotoCollectionView.frame.size.height+120)];
        }
        if (_oshowModel.attache.count <= 9 && 7 <=_oshowModel.attache.count) {
            [self.checkHeadView.AttachePhotoCollectionView setFrame:CGRectMake(0, 0, 275*D_width, 280*D_height)];
            [self.checkHeadView setFrame:CGRectMake(0, 0, self.checkHeadView.frame.size.width*D_width, titleSize.height*D_height+self.checkHeadView.AttachePhotoCollectionView.frame.size.height+130)];
        }
        if (self.LoveBooL == YES) {
          self.checkHeadView.ImageLove.image = [UIImage imageNamed:@"OShow_Love"];
        }else
        {
        self.checkHeadView.ImageLove.image = [UIImage imageNamed:@"unlike"];
        }
        [_checkHeadView.ButLove addTarget:self action:@selector(ButLoveClick:) forControlEvents:UIControlEventTouchUpInside];
        _checkHeadView.ButLove.selected = YES;
        [_checkHeadView.ButComments addTarget:self action:@selector(ButCommentsClick:) forControlEvents:UIControlEventTouchUpInside];
        _checkHeadView.ButComments.selected = YES;
    }
    return _checkHeadView;
}
-(CommentTextView * )commentTextView
{
    if (nil == _commentTextView) {
        NSArray * nibs = [[NSBundle mainBundle]loadNibNamed:@"CommentTextView" owner:self options:nil];
        _commentTextView = [nibs lastObject];
    }
    return _commentTextView;
}

-(void)ButLoveClick:(UIButton *)sender
{
    if (self.LoveBooL == NO) {
        NSLog(@"确认点赞");
        Strflag = @"1";
        self.checkHeadView.ImageLove.image = [UIImage imageNamed:@"OShow_Love"];
        self.checkHeadView.LabLove.text = [NSString stringWithFormat:@"%d",[self.checkHeadView.LabLove.text intValue]+1];
        [self requsetFavoriteLove];
        self.LoveBooL = YES;
        
    }else
    {
        NSLog(@"取消了点赞");
        Strflag = @"0";
        self.checkHeadView.ImageLove.image = [UIImage imageNamed:@"unlike"];
        self.checkHeadView.LabLove.text = [NSString stringWithFormat:@"%d",[self.checkHeadView.LabLove.text intValue]-1];
        [self requsetFavoriteLove];
        self.LoveBooL = NO;
    }
}
//点击了评论
-(void)ButCommentsClick:(UIButton *)sender
{
    NSLog(@"点击了评论");
    if (sender.selected == YES) {
        ViewKeybord.hidden = NO;
        text.hidden = NO;
        [self keyboardview];
        sender.selected = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

-(instancetype)initWithDataModel:(OShowModel *)oshowModel
{
    if (self=[super init]) {
        _oshowModel=[[OShowModel alloc]init];
        _oshowModel=oshowModel;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //关闭设置为NO, 默认值为NO.
    //键盘设置
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //键盘一建回收
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.tabBarController.tabBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"OShow详情";
    [self.view addSubview:self.checkDetailTab];
    //评论的数组
    CommentArray = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in self.oshowModel.comments) {
        checking = [[checkDedatilModel alloc]initWithRYDict:dic];
        [CommentArray addObject:checking];
    }
    
    if ([self.oshowModel.report isEqualToString:@"999"]) {
        BOOLReport = NO;
    }else{
        BOOLReport = YES;
    }
    
    
    
    [self CreatRight];
    // Do any additional setup after loading the view from its nib.
}
-(void)CreatLeft{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setImage:[UIImage imageNamed:@"public_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

-(void)CreatRight{
    informButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    informButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [informButton.layer setCornerRadius:5];
    [informButton.layer setMasksToBounds:YES];
    [informButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (BOOLReport == NO) {
        [informButton setTitle:@"已屏蔽" forState:UIControlStateNormal];
    }else{
        [informButton setTitle:@"屏蔽" forState:UIControlStateNormal];
    }
    [informButton.layer setBorderWidth:1];
    [informButton addTarget:self action:@selector(informAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *informItem = [[UIBarButtonItem alloc] initWithCustomView:informButton];
    [self.navigationItem setRightBarButtonItem:informItem];
}
-(void)informAction
{
    if (BOOLReport == NO) {
        [StrInformflag isEqualToString:@"0"];
        [informButton setTitle:@"屏蔽" forState:UIControlStateNormal];
        BOOLReport = YES;
        [self requsetInform];
    }else{
        [StrInformflag isEqualToString:@"1"];
        [informButton setTitle:@"已屏蔽" forState:UIControlStateNormal];
        BOOLReport = NO;
        [self requsetInform];
    }
    
    
}
-(void)backAction
{
    [self.backUpDatedelegate UpDateRequsetDetailOShowVCData];
    [self.navigationController popViewControllerAnimated:YES];
}

//触摸方法
-(void)GestureView
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [ViewKeybord removeFromSuperview];
    [text removeFromSuperview];
    [text resignFirstResponder];
    self.checkHeadView.ButComments.selected = YES;
}


-(void)keyboardWillShow:(NSNotification *)notification
{
    //这样就拿到了键盘的位置大小信息frame，然后根据frame进行高度处理之类的信息
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    NSLog(@"---------%f",frame.size.height);
}
#pragma mark - 键盘上的view
-(void)keyboardview
{
    UIView *inputview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    inputview.backgroundColor = [UIColor blueColor];

    text = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 35*D_height)];
    [text setBackgroundColor:kGlobalBg];
    text.delegate = self;
    text.returnKeyType = UIReturnKeyDone;
    text.font = [UIFont systemFontOfSize:15*D_width];
    [text becomeFirstResponder];
    
    ViewKeybord = [[UIView alloc]initWithFrame:CGRectMake(0, 375*D_height, KScreenWidth, 300*D_height)];
    ViewKeybord.backgroundColor = [UIColor whiteColor];
    [ViewKeybord addSubview:text];
    [self.view addSubview:ViewKeybord];
}

#pragma mark- delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.checkDetailTabViewCell.LabMessage.frame.size.height+44*D_height;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CommentArray.count;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"checkDeatilCell";
    self.checkDetailTabViewCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!self.checkDetailTabViewCell) {
        self.checkDetailTabViewCell = [[[NSBundle mainBundle]loadNibNamed:@"checkDetailTableViewCell" owner:self options:nil]lastObject];
    }
    checkDedatilModel * check = CommentArray[indexPath.row];
    [self.checkDetailTabViewCell getInfo:check];
    
    return self.checkDetailTabViewCell;
}
//点击Cell触发
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    // 点击时去灰的方法
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    NSLog(@"点击了 == %@",perCenterArr[indexPath.row]);
    //    if (indexPath.row == 0) {
    NSLog(@"点击了 ");
    //    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    ViewKeybord.hidden = YES;
    [self requsetCommentUpLoad];
    [textField resignFirstResponder];
    NSLog(@"%@",textField.text);
    NSLog(@"%@",text.text);
    self.checkHeadView.ButComments.selected = YES;
    self.checkHeadView.LabComments.text = [NSString stringWithFormat:@"%ld",CommentArray.count];
    
   // [self CreatLeft];

    return YES;
}

-(void)OShowPhotoImageClick:(NSString *)ImageUrl
{
    NSLog(@"imageUrl ==== %@",ImageUrl);
    OShowBigPhotoScrView * ScrPhoto = [OShowBigPhotoScrView defaultPopupView];
    ScrPhoto.parentVC = self;
    [ScrPhoto.ImageOShowBigPhoto sd_setImageWithURL:[NSURL URLWithString:ImageUrl] placeholderImage:[UIImage imageNamed:@"My_Header"]];
    [self lew_presentPopupView:ScrPhoto animation:[LewPopupViewAnimationFade new] dismissed:^{
        NSLog(@"动画结束");
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
