//
//  IssueOShowViewController.m
//  BookingCar
//
//  Created by mac on 2017/7/6.
//  Copyright © 2017年 LDX. All rights reserved.
//
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备高度
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备宽度
#import "IssueOShowViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UIBarButtonItem+Icon.h"
#import "MShowGroupAllSet.h"
#import "JSONKit.h"
@interface IssueOShowViewController ()<LQPhotoPickerViewDelegate,CLLocationManagerDelegate,MShowGroupAllSetDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) FMDatabase * db;
@end
@implementation IssueOShowViewController
{
    //备注文本View高度
    float noteTextHeight;
    float pickerViewHeight;
    float allViewHeight;
    NSString * StrPhotoUp;
    
    NSMutableArray * PhotoArray;
    NSInteger  ButtonTag;
    
    BOOL _isTiJiao;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBar.hidden = NO;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布动态";
    self.AddPhoto = [NSMutableArray array];

    
    //收起键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    
    /**
     *  依次设置
     */
    self.LQPhotoPicker_superView = _scrollView;
    
    self.LQPhotoPicker_imgMaxCount = 9;
    
    [self LQPhotoPicker_initPickerView];
    
    self.LQPhotoPicker_delegate = self;
    
    [self initViews];
    
    
    //开始定位
    [self startLocation];
    // Do any additional setup after loading the view from its nib.
}
- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        //        CLog(@"--------开始定位");
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        //控制定位精度,越高耗电量越
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        // 总是授权
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.distanceFilter = 10.0f;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}
//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {

    NSLog(@"%f,%f",manager.location.coordinate.latitude,manager.location.coordinate.longitude);
    self.PointLatLngLocation = manager.location;
    
}
- (void)viewTapped{
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"caseLogNeedRef" object:nil];
}

- (void)initViews{
    
    _noteTextBackgroudView = [[UIView alloc]init];
    _noteTextBackgroudView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    _noteTextView = [[UITextView alloc]init];
    _noteTextView.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    _noteTextView.delegate = self;
    _noteTextView.font = [UIFont boldSystemFontOfSize:14];
    
    _textNumberLabel = [[UILabel alloc]init];
    _textNumberLabel.textAlignment = NSTextAlignmentRight;
    _textNumberLabel.font = [UIFont boldSystemFontOfSize:12];
    _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    _textNumberLabel.backgroundColor = [UIColor whiteColor];
    _textNumberLabel.text = @"0/140";
    
    _explainLabel = [[UILabel alloc]init];
    _explainLabel.text = @"添加图片不超过9张，文字备注不超过140字";
    _explainLabel.textColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1.0];
    _explainLabel.textAlignment = NSTextAlignmentCenter;
    _explainLabel.font = [UIFont boldSystemFontOfSize:12];
    
    _submitBtn = [[UIButton alloc]init];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [_scrollView addSubview:_noteTextBackgroudView];
    [_scrollView addSubview:_noteTextView];
    [_scrollView addSubview:_textNumberLabel];
    [_scrollView addSubview:_explainLabel];
    [_scrollView addSubview:_submitBtn];
    
    [self updateViewsFrame];
}
- (void)updateViewsFrame{
    
    if (!allViewHeight) {
        allViewHeight = 0;
    }
    if (!noteTextHeight) {
        noteTextHeight = 100;
    }
    
    _noteTextBackgroudView.frame = CGRectMake(0, 0, SCREENWIDTH, noteTextHeight);
    
    //文本编辑框
    _noteTextView.frame = CGRectMake(15, 0, SCREENWIDTH - 30, noteTextHeight);
    
    
    //文字个数提示Label
    _textNumberLabel.frame = CGRectMake(0, _noteTextView.frame.origin.y + _noteTextView.frame.size.height-15, SCREENWIDTH-10, 15);
    
    
    //photoPicker
    [self LQPhotoPicker_updatePickerViewFrameY:_textNumberLabel.frame.origin.y + _textNumberLabel.frame.size.height];
    
    
    //说明文字
    _explainLabel.frame = CGRectMake(0, [self LQPhotoPicker_getPickerViewFrame].origin.y+[self LQPhotoPicker_getPickerViewFrame].size.height+10, SCREENWIDTH, 20);
    
    //提交按钮
    _submitBtn.frame = CGRectMake(0, 0, 60, 30);
    [_submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_submitBtn];
    [self.navigationItem setRightBarButtonItem:backItem];
    
    allViewHeight = noteTextHeight + [self LQPhotoPicker_getPickerViewFrame].size.height + 30 + 100;
    
    _scrollView.contentSize = self.scrollView.contentSize = CGSizeMake(0,allViewHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/140    ",(unsigned long)_noteTextView.text.length];
    if (_noteTextView.text.length > 140) {
        _textNumberLabel.textColor = [UIColor redColor];
    }
    else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    
    [self textChanged];
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }

    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/140    ",(unsigned long)_noteTextView.text.length];
    if (_noteTextView.text.length > 140) {
        _textNumberLabel.textColor = [UIColor redColor];
        textView.text = [textView.text substringToIndex:140];
        [[RYHUDManager sharedManager] showWithMessage:@"请不要超过140字" customView:nil hideDelay:2.f];
    }
    else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    [self textChanged];
}

-(void)textChanged{
    
    CGRect orgRect = self.noteTextView.frame;//获取原始UITextView的frame
    
    CGSize size = [self.noteTextView sizeThatFits:CGSizeMake(self.noteTextView.frame.size.width, MAXFLOAT)];
    
    orgRect.size.height=size.height+10;//获取自适应文本内容高度
    
    if (orgRect.size.height > 100) {
        noteTextHeight = orgRect.size.height;
    }
    [self updateViewsFrame];
}

- (void)submitBtnClicked:(UIButton *)sender
{
    NSLog(@"self.AddPhoto.count个数为：%ld",self.AddPhoto.count);
    if (self.AddPhoto.count == 0&&[self checkInput]== NO) {
            NSLog(@"提交时图片不能为空，文字可以为空");
            [[RYHUDManager sharedManager] showWithMessage:@"请添加您想要发送的内容" customView:nil hideDelay:2.f];
        }else
        {
            if (_isTiJiao == NO) {
                _isTiJiao = YES;
                NSLog(@"提交朋友圈内容");
                StrPhotoUp = [NSString stringWithFormat:@"%@",self.AddPhoto];
                NSLog(@"str ==== %@",StrPhotoUp);
                //上传数据
                [self requsetUpdateOShowAdd];
            }

        }
    

    
}

#pragma maek - 检查输入
- (BOOL)checkInput{
    if (_noteTextView.text.length == 0) {
        return NO;
    }
    return YES;
}


#pragma mark - 上传数据到服务器前将图片转data（上传服务器用form表单：未写）

-(void)requsetUpdateOShowAdd
{
    
    LoginModel * login = [[LoginModel alloc]init];
    login= [LoginDataModel sharedManager].loginInModel;
    
    NSString * str = [StrPhotoUp stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString * str1 = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString * str2 = [str1 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSString * str3 = [str2 stringByReplacingOccurrencesOfString:@"(" withString:@""];
    
    NSString * str4 = [str3 stringByReplacingOccurrencesOfString:@")" withString:@""];

    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:login.token forKey:@"token"];
    [params setValue:_noteTextView.text forKey:@"message"];
    [params setObject:[NSString stringWithFormat:@"%f",self.PointLatLngLocation.coordinate.latitude] forKey:@"lat"];
    [params setObject:[NSString stringWithFormat:@"%f",self.PointLatLngLocation.coordinate.longitude] forKey:@"lng"];
    [params setValue:str4 forKey:@"attache"];
    [HttpTool postWithPath:kOShowAddUrl params:params success:^(id responseObj) {
        NSLog(@"发布凹凸圈：%@",responseObj);
        
        [[RYHUDManager sharedManager] showWithMessage:[NSString stringWithFormat:@"%@",responseObj[@"message"]] customView:nil hideDelay:2.f];
        NSString * status = [NSString stringWithFormat:@"%@",responseObj[@"status"]];
        if ([status isEqualToString:@"1"]) {
//            [self.backUpDatedelegate UpDateRequsetOShowData];
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        }
        _isTiJiao = NO;
    } failure:^(NSError *error) {
        _isTiJiao = NO;
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
        [SVProgressHUD dismiss];

    }];
}

- (void)submitToServer{

    NSMutableArray *bigImageArray = [self LQPhotoPicker_getBigImageArray];
    //大图数据
    NSMutableArray *bigImageDataArray = [self LQPhotoPicker_getBigImageDataArray];
    //小图数组
    NSMutableArray *smallImageArray = [self LQPhotoPicker_getSmallImageArray];
    
    //小图数据
    NSMutableArray *smallImageDataArray = [self LQPhotoPicker_getSmallDataImageArray];
    
    if (smallImageArray.count > 0) {
        
        [SVProgressHUD showWithStatus:@"正在提交......"];
        [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
       

        NSMutableDictionary * params = [[NSMutableDictionary alloc]init];

            [HttpTool postWithPath:kUploadUrl indexName:@"img" imagePathList:bigImageArray params:params success:^(id responseObj) {
                NSLog(@"上传成功");
                NSLog(@"上传成功===== %@",responseObj);
                [self.AddPhoto addObject:responseObj[@"result"][@"url"]];
                [PhotoArray addObject:responseObj];
                NSLog(@"------ %ld",PhotoArray.count);
                if (PhotoArray.count == smallImageArray.count) {
                    [SVProgressHUD dismiss];
                }
            } failure:^(NSError *error) {
                [SVProgressHUD dismiss];
                NSLog(@"上传失败  == %@",error);
                [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
            }];
    }
}

- (void)LQPhotoPicker_pickerViewFrameChanged{
    [self updateViewsFrame];
}

-(void)ButtonTag:(NSInteger)ButTag
{
    [self.AddPhoto removeObjectAtIndex:ButTag];
}


-(void)SaveResqustUpPhotoClick:(NSMutableArray*)AddPhoto
{
    for (NSString * str in AddPhoto) {
        [self.AddPhoto addObject:str];
    }
    NSLog(@"----%@",self.AddPhoto);

    
//    [self submitToServer];
//    PhotoArray = [[NSMutableArray alloc]init];
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
