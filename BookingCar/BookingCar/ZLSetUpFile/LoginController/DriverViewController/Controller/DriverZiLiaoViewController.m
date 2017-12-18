//
//  DriverZiLiaoViewController.m
//  BookingCar
//
//  Created by apple on 2017/11/28.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import "DriverZiLiaoViewController.h"

@interface DriverZiLiaoViewController (){

}

@end

@implementation DriverZiLiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"司机注册";
    [self loadScrollView];
    [self loadUploadImageView];
    [self loadOKButton];
    self.scrollView.bounces = YES;
    self.currentViewModel = [DriverZiLiaoViewModel shareInstance];
}

- (void)viewWillAppear:(BOOL)animated{
    //self.tabBarController.tabBar
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}


- (void)loadScrollView{
    /** ScrollView */
    self.scrollView = [UIScrollView new];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    /** 内容ContentView */
    self.containView = [UIView new];
    self.containView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.containView];
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.greaterThanOrEqualTo(@0.0f);
    }];
    
    
    UILabel * label01 = [UILabel new];
    label01.text = @"完善个人资料,以便于我们了解您的情况。";
    label01.textColor = [UIColor lightGrayColor];
    label01.font = [UIFont systemFontOfSize:14.0];
    [self.containView addSubview:label01];
    [label01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.containView).mas_offset(20);
        make.top.mas_equalTo(self.containView).mas_offset(10);
        make.height.mas_equalTo(20);
    }];
    
    /** TextField设置 */
    UIImageView * image01 = [UIImageView new];
    image01.userInteractionEnabled = YES;
    image01.layer.cornerRadius = 5.0f;
    image01.layer.borderWidth = 1.0;
    image01.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [image01.layer setMasksToBounds:YES];
    //image01.image = [UIImage imageNamed:@"kuang"];
    //image01.contentMode = UIViewContentModeScaleAspectFill;
    //image01.backgroundColor = [UIColor redColor];
    [self.containView addSubview:image01];
    [image01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.top.mas_equalTo(label01.mas_bottom).mas_offset(25);
        make.height.mas_equalTo(40);
    }];
    UIImageView * image02 = [UIImageView new];
    image02.userInteractionEnabled = YES;
//    image02.image = [UIImage imageNamed:@"kuang"];
    image02.layer.cornerRadius = 5.0f;
    image02.layer.borderWidth = 1.0;
    image02.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [image02.layer setMasksToBounds:YES];
    [self.containView addSubview:image02];
    [image02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.top.mas_equalTo(image01.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(40);
    }];
    UIImageView * image03 = [UIImageView new];
    image03.userInteractionEnabled = YES;
//    image03.image = [UIImage imageNamed:@"kuang"];
    image03.layer.cornerRadius = 5.0f;
    image03.layer.borderWidth = 1.0;
    image03.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [image03.layer setMasksToBounds:YES];
    [self.containView addSubview:image03];
    [image03 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.top.mas_equalTo(image02.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(40);
    }];
    UIImageView * image04 = [UIImageView new];
    image04.userInteractionEnabled = YES;
    //    image03.image = [UIImage imageNamed:@"kuang"];
    image04.layer.cornerRadius = 5.0f;
    image04.layer.borderWidth = 1.0;
    image04.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [image04.layer setMasksToBounds:YES];
    [self.containView addSubview:image04];
    [image04 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.top.mas_equalTo(image03.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(40);
    }];
    
    [self.containView addSubview:self.jiaShiZhengField];
    [self.jiaShiZhengField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.top.mas_equalTo(label01.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(40);
    }];
    [self.containView addSubview:self.baoXianHaoField];
    [self.baoXianHaoField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.top.mas_equalTo(self.jiaShiZhengField.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(40);
    }];
    [self.containView addSubview:self.chePaiHaoField];
    [self.chePaiHaoField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.top.mas_equalTo(self.baoXianHaoField.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(40);
    }];
    [self.containView addSubview:self.chePinPaiField];
    [self.chePinPaiField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.top.mas_equalTo(self.chePaiHaoField.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(40);
    }];
}
- (void)loadUploadImageView{
    UILabel * label02 = [UILabel new];
    label02.text = @"驾驶证正面照";
    label02.textColor = [UIColor blackColor];
    label02.font = [UIFont systemFontOfSize:17.0];
    [self.containView addSubview:label02];
    [label02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.containView).mas_offset(20);
        make.top.mas_equalTo(self.chePinPaiField.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(20);
    }];
    UILabel * label03 = [UILabel new];
    label03.text = @"请使用手机横向拍摄以保证照片正常显示";
    label03.textColor = [UIColor colorWithhex16stringToColor:@"179cff"];
    label03.font = [UIFont systemFontOfSize:14.0];
    [self.containView addSubview:label03];
    [label03 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.containView).mas_offset(20);
        make.top.mas_equalTo(label02.mas_bottom).mas_offset(5);
    }];
    
    [self.containView addSubview:self.jiaShiZhengImage];
    [self.jiaShiZhengImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.top.mas_equalTo(label03.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(144.0/299.0*(SIZE_WIDTH-40.0));
    }];
    
    UILabel * label04 = [UILabel new];
    label04.text = @"保险单照片";
    label04.textColor = [UIColor blackColor];
    label04.font = [UIFont systemFontOfSize:17.0];
    [self.containView addSubview:label04];
    [label04 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.containView).mas_offset(20);
        make.top.mas_equalTo(self.jiaShiZhengImage.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(20);
    }];
    UILabel * label05 = [UILabel new];
    label05.text = @"请使用手机横向拍摄以保证照片正常显示";
    label05.textColor = [UIColor colorWithhex16stringToColor:@"179cff"];
    label05.font = [UIFont systemFontOfSize:14.0];
    [self.containView addSubview:label05];
    [label05 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.containView).mas_offset(20);
        make.top.mas_equalTo(label04.mas_bottom).mas_offset(5);
    }];
    
    [self.containView addSubview:self.baoXianDanImage];
    [self.baoXianDanImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.top.mas_equalTo(label05.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(144.0/299.0*(SIZE_WIDTH-40.0));
    }];
    
    
    UILabel * label06 = [UILabel new];
    label06.text = @"车辆正反面照片";
    label06.textColor = [UIColor blackColor];
    label06.font = [UIFont systemFontOfSize:17.0];
    [self.containView addSubview:label06];
    [label06 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.containView).mas_offset(20);
        make.top.mas_equalTo(self.baoXianDanImage.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(20);
    }];
    UILabel * label07 = [UILabel new];
    label07.text = @"请使用手机横向拍摄以保证照片正常显示";
    label07.textColor = [UIColor colorWithhex16stringToColor:@"179cff"];
    label07.font = [UIFont systemFontOfSize:14.0];
    [self.containView addSubview:label07];
    [label07 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.containView).mas_offset(20);
        make.top.mas_equalTo(label06.mas_bottom).mas_offset(5);
    }];
    
    [self.containView addSubview:self.cheLiangZhengImage];
    [self.cheLiangZhengImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.top.mas_equalTo(label07.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(144.0/299.0*(SIZE_WIDTH-40.0));
    }];
    [self.containView addSubview:self.cheLiangBeiImage];
    [self.cheLiangBeiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.top.mas_equalTo(self.cheLiangZhengImage.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(144.0/299.0*(SIZE_WIDTH-40.0));
    }];
}

- (void)loadOKButton{
    UILabel * label06 = [UILabel new];
    label06.text = @"请确认以上信息正确无误";
    label06.textColor = [UIColor blackColor];
    label06.font = [UIFont systemFontOfSize:14.0];
    [self.containView addSubview:label06];
    [label06 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.cheLiangBeiImage.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(20);
    }];
    
    UIView * view1 = [UIView new];
    view1.backgroundColor = [UIColor grayColor];
    [self.containView addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(label06.mas_left).mas_offset(-10);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(80);
        make.centerY.mas_equalTo(label06);
    }];
    
    UIView * view2 = [UIView new];
    view2.backgroundColor = [UIColor grayColor];
    [self.containView addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label06.mas_right).mas_offset(10);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(80);
        make.centerY.mas_equalTo(label06);
    }];
    
    self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.okButton.backgroundColor = [UIColor colorWithhex16stringToColor:Main_blueColor_ZL];
    [self.okButton setTitle:@"确定" forState:UIControlStateNormal];
    self.okButton.layer.cornerRadius =5.0;
    [self.okButton.layer setMasksToBounds:YES];
    [self.okButton addTarget:self action:@selector(okButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.okButton.enabled = NO;
    [self.containView addSubview:self.okButton];
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(30);
        make.right.mas_equalTo(self.view).mas_offset(-30);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(label06.mas_bottom).mas_offset(20);
    }];
    
    self.lastLabel = [UILabel new];
    self.lastLabel.text = @"请确认以上信息正确无误";
    self.lastLabel.textColor = [UIColor lightGrayColor];
    self.lastLabel.font = [UIFont systemFontOfSize:14.0];
    [self.containView addSubview:self.lastLabel];
    [self.lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.okButton.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(self.containView.mas_bottom).mas_offset(-20);
    }];
}
- (void)okButtonAction:(UIButton *)sender{
    NSLog(@"点击了确定按钮");
    sender.enabled = NO;
    [self.currentViewModel startNetworkZiLiaoWithSuccessBlock:^(BOOL success) {
        if (success == YES) {
             [[RYHUDManager sharedManager] showWithMessage:@"资料提交成功，等待审核" customView:nil hideDelay:2.f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [(AppDelegate *)[UIApplication sharedApplication].delegate setRootControllerMainTabVC];
            });
        }
        sender.enabled = YES;
    } withFailBlock:^(BOOL failure) {
        sender.enabled = YES;
    }];
}

#pragma mark ===================三个TextField设置 开始==================
/** 驾驶证号Field */
- (JVFloatLabeledTextField *)jiaShiZhengField{
    if (!_jiaShiZhengField) {
        UIView * leftView = [UIView new];
        leftView.backgroundColor = [UIColor clearColor];
        [leftView setFrame:CGRectMake(0, 0, 10, 40)];
        _jiaShiZhengField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectZero];
        _jiaShiZhengField.leftView = leftView;
        _jiaShiZhengField.leftViewMode = UITextFieldViewModeAlways;
        //[_jiaShiZhengField setBackground:[UIImage imageNamed:@"kuang"]];
//        _jiaShiZhengField.layer.borderWidth = 1.0;
//        _jiaShiZhengField.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        [_jiaShiZhengField.layer setMasksToBounds:YES];
        //_userNameField.font = FONT_THEME;
        // 浮动式标签的正常字体颜色
        //_userNameField.floatingLabelTextColor = COLOR_THEME;
        // 输入框成为第一响应者时,浮动标签的文字颜色.
        _jiaShiZhengField.floatingLabelActiveTextColor = [UIColor lightGrayColor];
        //浮动文字Y距离
        _jiaShiZhengField.floatingLabelYPadding = -10.0f;
        // 指明当输入文字时,是否下调基准线(baseline).设置为YES(非默认值),意味着占位内容会和输入内容对齐.
        _jiaShiZhengField.keepBaseline = YES;
        //placeHolder字体颜色
        _jiaShiZhengField.placeholderColor = [UIColor lightGrayColor];
        //正常字体颜色
        _jiaShiZhengField.textColor = [UIColor blackColor];
        // 设置占位符文字和浮动式标签的文字.
        [_jiaShiZhengField setPlaceholder:@"驾驶证号:"
                         floatingTitle:@"驾驶证号"];
        _jiaShiZhengField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _jiaShiZhengField.delegate = self;
        //_jiaShiZhengField.keyboardType = UIKeyboardTypeNumberPad;
        [_jiaShiZhengField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _jiaShiZhengField;
}
/** 保险单号Field */
- (JVFloatLabeledTextField *)baoXianHaoField{
    if (!_baoXianHaoField) {
        UIView * leftView = [UIView new];
        leftView.backgroundColor = [UIColor clearColor];
        [leftView setFrame:CGRectMake(0, 0, 10, 40)];
        _baoXianHaoField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectZero];
        _baoXianHaoField.leftView = leftView;
        _baoXianHaoField.leftViewMode = UITextFieldViewModeAlways;
        //[_baoXianHaoField setBackground:[UIImage imageNamed:@"kuang"]];
        //_userNameField.font = FONT_THEME;
        // 浮动式标签的正常字体颜色
        //_userNameField.floatingLabelTextColor = COLOR_THEME;
        // 输入框成为第一响应者时,浮动标签的文字颜色.
        _baoXianHaoField.floatingLabelActiveTextColor = [UIColor lightGrayColor];
        //浮动文字Y距离
        _baoXianHaoField.floatingLabelYPadding = -10.0f;
        // 指明当输入文字时,是否下调基准线(baseline).设置为YES(非默认值),意味着占位内容会和输入内容对齐.
        _baoXianHaoField.keepBaseline = YES;
        //placeHolder字体颜色
        _baoXianHaoField.placeholderColor = [UIColor lightGrayColor];
        //正常字体颜色
        _baoXianHaoField.textColor = [UIColor blackColor];
        // 设置占位符文字和浮动式标签的文字.
        [_baoXianHaoField setPlaceholder:@"保险单号:"
                            floatingTitle:@"保险单号"];
        _baoXianHaoField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _baoXianHaoField.delegate = self;
        //_jiaShiZhengField.keyboardType = UIKeyboardTypeNumberPad;
        [_baoXianHaoField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _baoXianHaoField;
}
/** 车辆号Field */
- (JVFloatLabeledTextField *)chePaiHaoField{
    if (!_chePaiHaoField) {
        UIView * leftView = [UIView new];
        leftView.backgroundColor = [UIColor clearColor];
        [leftView setFrame:CGRectMake(0, 0, 10, 40)];
        _chePaiHaoField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectZero];
        _chePaiHaoField.leftView = leftView;
        _chePaiHaoField.leftViewMode = UITextFieldViewModeAlways;
        
        //[_chePaiHaoField setBackground:[UIImage imageNamed:@"kuang"]];
        //_userNameField.font = FONT_THEME;
        // 浮动式标签的正常字体颜色
        //_userNameField.floatingLabelTextColor = COLOR_THEME;
        // 输入框成为第一响应者时,浮动标签的文字颜色.
        _chePaiHaoField.floatingLabelActiveTextColor = [UIColor lightGrayColor];
        //浮动文字Y距离
        _chePaiHaoField.floatingLabelYPadding = -10.0f;
        // 指明当输入文字时,是否下调基准线(baseline).设置为YES(非默认值),意味着占位内容会和输入内容对齐.
        _chePaiHaoField.keepBaseline = YES;
        //placeHolder字体颜色
        _chePaiHaoField.placeholderColor = [UIColor lightGrayColor];
        //正常字体颜色
        _chePaiHaoField.textColor = [UIColor blackColor];
        // 设置占位符文字和浮动式标签的文字.
        [_chePaiHaoField setPlaceholder:@"车牌号:"
                            floatingTitle:@"车牌号"];
        _chePaiHaoField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _chePaiHaoField.delegate = self;
        //_jiaShiZhengField.keyboardType = UIKeyboardTypeNumberPad;
        [_chePaiHaoField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _chePaiHaoField;
}
/** 车辆品牌 */
- (JVFloatLabeledTextField *)chePinPaiField{
    if (!_chePinPaiField) {
        UIView * leftView = [UIView new];
        leftView.backgroundColor = [UIColor clearColor];
        [leftView setFrame:CGRectMake(0, 0, 10, 40)];
        _chePinPaiField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectZero];
        _chePinPaiField.leftView = leftView;
        _chePinPaiField.leftViewMode = UITextFieldViewModeAlways;
        
        //[_chePaiHaoField setBackground:[UIImage imageNamed:@"kuang"]];
        //_userNameField.font = FONT_THEME;
        // 浮动式标签的正常字体颜色
        //_userNameField.floatingLabelTextColor = COLOR_THEME;
        // 输入框成为第一响应者时,浮动标签的文字颜色.
        _chePinPaiField.floatingLabelActiveTextColor = [UIColor lightGrayColor];
        //浮动文字Y距离
        _chePinPaiField.floatingLabelYPadding = -10.0f;
        // 指明当输入文字时,是否下调基准线(baseline).设置为YES(非默认值),意味着占位内容会和输入内容对齐.
        _chePinPaiField.keepBaseline = YES;
        //placeHolder字体颜色
        _chePinPaiField.placeholderColor = [UIColor lightGrayColor];
        //正常字体颜色
        _chePinPaiField.textColor = [UIColor blackColor];
        // 设置占位符文字和浮动式标签的文字.
        [_chePinPaiField setPlaceholder:@"车辆品牌型号:"
                          floatingTitle:@"车辆型号"];
        _chePinPaiField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _chePinPaiField.delegate = self;
        //_jiaShiZhengField.keyboardType = UIKeyboardTypeNumberPad;
        [_chePinPaiField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _chePinPaiField;
}


- (void)textFieldDidChange:(JVFloatLabeledTextField *)sender{
    NSLog(@"TextField变化:%@",sender.text);
    if (sender == self.jiaShiZhengField) {
        self.currentViewModel.jiaShiZhengString = sender.text;
    }
    if (sender == self.baoXianHaoField) {
        self.currentViewModel.baoXianDanString = sender.text;
    }
    if (sender == self.chePaiHaoField) {
        self.currentViewModel.chePaiString = sender.text;
    }
    if (sender == self.chePinPaiField) {
        self.currentViewModel.cheModelString = sender.text;
    }
    if (sender == self.chePinPaiField) {
        self.currentViewModel.cheModelString = sender.text;
    }
    [self isCanTiJiao];
}
#pragma mark ===================三个TextField设置 结束==================
#pragma mark ===================四个ImageView设置 开始==================
- (ZhengJianImageView *)jiaShiZhengImage{
    if (!_jiaShiZhengImage) {
        _jiaShiZhengImage = [[ZhengJianImageView alloc]initWithFrame:CGRectZero];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        [_jiaShiZhengImage addGestureRecognizer:tap];
    }
    return _jiaShiZhengImage;
}
- (void)tapImageView:(UITapGestureRecognizer *)tap{
    NSLog(@"点击了驾驶证ImageView");
    __weak typeof(self) weakSelf = self;
    [ZLPhotoScaleManager showHeadImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (image) {
            [self.jiaShiZhengImage setImage:image];
            //[SVProgressHUD show];
            //[self requsetdriverPic1];
            [weakSelf.currentViewModel startUploadImageWithType:0 withImage:image withSuccessBlock:^(BOOL success, NSString *imageUrl) {
                if (success == YES) {
                    [self isCanTiJiao];
                }
                NSLog(@"驾驶证正面照：%@",self.currentViewModel.jiaShiZhengImageUrl);
            } withFailBlock:^(BOOL failure) {
                
            }];
        }
    }];
    
}
- (ZhengJianImageView *)baoXianDanImage{
    if (!_baoXianDanImage) {
        _baoXianDanImage = [[ZhengJianImageView alloc]initWithFrame:CGRectZero];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView02:)];
        [_baoXianDanImage addGestureRecognizer:tap];
    }
    return _baoXianDanImage;
}
- (void)tapImageView02:(UITapGestureRecognizer *)tap{
    NSLog(@"点击了ImageView");
     __weak typeof(self) weakSelf = self;
    [ZLPhotoScaleManager showHeadImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (image) {
            [self.baoXianDanImage setImage:image];
//            [SVProgressHUD show];
            //[self requsetdriverPic2];
            [weakSelf.currentViewModel startUploadImageWithType:1 withImage:image withSuccessBlock:^(BOOL success, NSString *imageUrl) {
                if (success == YES) {
                    [self isCanTiJiao];
                }
                NSLog(@"保险单正面照：%@",self.currentViewModel.baoXianDanImageUrl);
            } withFailBlock:^(BOOL failure) {
                
            }];
        }
    }];
    
}
- (ZhengJianImageView *)cheLiangZhengImage{
    if (!_cheLiangZhengImage) {
        _cheLiangZhengImage = [[ZhengJianImageView alloc]initWithFrame:CGRectZero];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView03:)];
        [_cheLiangZhengImage addGestureRecognizer:tap];
    }
    return _cheLiangZhengImage;
}
- (void)tapImageView03:(UITapGestureRecognizer *)tap{
    NSLog(@"点击了车辆正面ImageView");
    __weak typeof(self) weakSelf = self;
    [ZLPhotoScaleManager showHeadImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (image) {
            [self.cheLiangZhengImage setImage:image];
            //            [SVProgressHUD show];
            //[self requsetdriverPic2];
            [weakSelf.currentViewModel startUploadImageWithType:2 withImage:image withSuccessBlock:^(BOOL success, NSString *imageUrl) {
                if (success == YES) {
                    [self isCanTiJiao];
                }
                NSLog(@"车辆正面照：%@",self.currentViewModel.cheLiangZhengImageUrl);
            } withFailBlock:^(BOOL failure) {
                
            }];
        }
    }];
}
- (ZhengJianImageView *)cheLiangBeiImage{
    if (!_cheLiangBeiImage) {
        _cheLiangBeiImage = [[ZhengJianImageView alloc]initWithFrame:CGRectZero];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView04:)];
        [_cheLiangBeiImage addGestureRecognizer:tap];
    }
    return _cheLiangBeiImage;
}
- (void)tapImageView04:(UITapGestureRecognizer *)tap{
    NSLog(@"点击了车辆反面ImageView");
    __weak typeof(self) weakSelf = self;
    [ZLPhotoScaleManager showHeadImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (image) {
            [self.cheLiangBeiImage setImage:image];
            //            [SVProgressHUD show];
            //[self requsetdriverPic2];
            [weakSelf.currentViewModel startUploadImageWithType:3 withImage:image withSuccessBlock:^(BOOL success, NSString *imageUrl) {
                if (success == YES) {
                    [self isCanTiJiao];
                }
                NSLog(@"车辆反面照：%@",self.currentViewModel.cheLiangBeiImageUrl);
            } withFailBlock:^(BOOL failure) {
                if (failure == YES) {
                    /** 网络连接成功,但是上传失败 */
                }
                else{
                    /** 网络连接失败 */
                }
            }];
        }
    }];
}

#pragma mark ===================四个ImageView设置 结束==================
/** 判断是否可以提交审核 */
- (BOOL)isCanTiJiao{
    BOOL result = NO;
    if (self.currentViewModel.jiaShiZhengString.length > 0 && self.currentViewModel.baoXianDanString.length > 0  && self.currentViewModel.chePaiString.length > 0   &&  self.currentViewModel.jiaShiZhengImageUrl.length > 0 && self.currentViewModel.baoXianDanImageUrl.length > 0 && self.currentViewModel.cheLiangZhengImageUrl.length > 0 && self.currentViewModel.cheLiangBeiImageUrl.length > 0 && self.currentViewModel.cheModelString.length > 0 && self.currentViewModel.cheModelString.length > 0 ) {
        self.okButton.enabled = YES;
        result = YES;
    }
    else{
        result = NO;
        self.okButton.enabled = NO;
    }
    
    return result;
}

#pragma mark ===================提交资料==================


#pragma mark ===================提交资料  结束==================

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
