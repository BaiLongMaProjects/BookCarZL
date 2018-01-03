//
//  ZLLoginViewController.m
//  BookingCar
//
//  Created by apple on 2017/11/22.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import "ZLLoginViewController.h"
@interface ZLLoginViewController (){
    
    UIScrollView * _backScrollView;
}

@end
@implementation ZLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /** 加载视图 */
    [self setupViews];
    //ios 11新特性  解决 电池导航栏 空白问题 UITableView UIScrollView
    if (@available(iOS 11.0, *)) {
        
        _backScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    /** 国际代码 默认为1 美国*/
    self.countryString = @"1";
    /** 清空用户关键数据 token 和 角色类型 */
    [kUserDefaults removeObjectForKey:USER_TOKEN_ZL];
    [kUserDefaults removeObjectForKey:USER_ROLE_FINISHED_TYPE];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
/** 创建视图 */
- (void)setupViews{
    /*
    _backScrollView = [[UIScrollView alloc]init];
    [self.view addSubview:_backScrollView];
    [_backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.mas_equalTo(self.view);
    }];
    */
    UIImageView * backImage = [UIImageView new];
    [backImage setImage:[UIImage imageNamed:@"BGImgView"]];
    backImage.userInteractionEnabled = YES;
    [self.view addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.mas_equalTo(self.view);
    }];
    UIImageView * logoImage = [UIImageView new];
    [logoImage setImage:[UIImage imageNamed:@"iconLogo"]];
    [self.view addSubview:logoImage];
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view).mas_offset(20);
        make.top.mas_equalTo(self.view).mas_offset(80);
        make.width.mas_equalTo(132.0f);
        make.height.mas_equalTo(109.0f);
    }];
    UILabel * label = [UILabel new];
    label.font = [UIFont systemFontOfSize:21.0];
    label.textColor = [UIColor colorWithhex16stringToColor:@"f3fffa"];
    label.text = @"白龙马让出行更简单";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(logoImage.mas_bottom).mas_offset(0.0f);
        //make.width.mas_equalTo(150.0f);
        //make.height.mas_equalTo(20.0f);
    }];
    UIImageView * logoImage2 = [UIImageView new];
    [logoImage2 setImage:[UIImage imageNamed:@"backToLoginButton"]];
//    [self.view addSubview:logoImage2];
//    [logoImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.view);
//        make.top.mas_equalTo(logoImage.mas_bottom).mas_offset(10.0f);
//        make.width.mas_equalTo(150.0f);
//        make.height.mas_equalTo(20.0f);
//    }];

    /** TextField设置 */
    [self setupTextFieldWith:label];
    /** 第三方登录 */
    
    /** 用户协议 */
    [self setupUserProtocolLabel];
}
/** 创建 TextField */
- (void)setupTextFieldWith:(UILabel *)topView{
    /** 背景View */
    UIView * zhongView = [UIView new];
    zhongView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:zhongView];
    [zhongView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).mas_offset(30.0f);
        make.right.left.mas_equalTo(self.view);
        make.height.mas_equalTo(270.0f);
    }];
    
    /** 用户名 输入框 */
    UIView * topView1 = [UIView new];
    topView1.backgroundColor = [UIColor clearColor];
    [zhongView addSubview:topView1];
    [topView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(zhongView);
        make.height.mas_equalTo(40.0f);
    }];
    
    UIImageView * phoneImage = [UIImageView new];
    [phoneImage setImage:[UIImage imageNamed:@"shoujihao"]];
    [topView1 addSubview:phoneImage];
    [phoneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(topView1);
        make.left.mas_equalTo(topView1).mas_offset(20.0f);
        make.width.height.mas_equalTo(@20.0);
    }];
    
    self.countryButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.countryButton setTitle:@"+1" forState:UIControlStateNormal];
    self.countryButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [self.countryButton setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
    [self.countryButton addTarget:self action:@selector(countryButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView1 addSubview:self.countryButton];
    [self.countryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(topView1);
        make.left.mas_equalTo(phoneImage.mas_right).mas_offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
    }];
    
    [topView1 addSubview:self.userNameField];
    [self.userNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.countryButton
                              .mas_right).mas_offset(10);
        make.centerY.mas_equalTo(topView1);
        make.height.mas_equalTo(@20);
        make.right.mas_equalTo(topView1).mas_offset(-10);
    }];
    
    UIView * spLineView = [UIView new];
    spLineView.backgroundColor = [UIColor colorWithhex16stringToColor:Main_GrayColor_ZL];
    [topView1 addSubview:spLineView];
    [spLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(topView1).mas_offset(20);
        make.right.mas_equalTo(topView1).mas_offset(-20);
        make.height.mas_equalTo(@1);
        make.bottom.mas_equalTo(topView1);
    }];
    
    /** 密码输入框 */
    UIView * topView2 = [UIView new];
    topView2.backgroundColor = [UIColor clearColor];
    [zhongView addSubview:topView2];
    [topView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView1.mas_bottom).mas_offset(20.0f);
        make.left.right.mas_equalTo(zhongView);
        make.height.mas_equalTo(40.0f);
    }];
    UIImageView * phoneImage2 = [UIImageView new];
    [phoneImage2 setImage:[UIImage imageNamed:@"yanzheng"]];
    [topView2 addSubview:phoneImage2];
    [phoneImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(topView2);
        make.left.mas_equalTo(topView2).mas_offset(20.0f);
        make.width.height.mas_equalTo(@20.0);
    }];
    
    /** 是否显示密码 */
    self.isCanSeePassword = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.isCanSeePassword setBackgroundImage:[UIImage imageNamed:@"wodedongtai"] forState:UIControlStateNormal];
    [self.isCanSeePassword addTarget:self action:@selector(seePasswordButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    /*
    [topView2 addSubview:self.isCanSeePassword];
    [self.isCanSeePassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(topView2).mas_offset(-20);
        make.centerY.mas_equalTo(topView2);
        make.width.height.mas_equalTo(20);
    }];
    */
    /** 获取验证码按钮 */
    self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.codeButton.titleLabel.font  = [UIFont systemFontOfSize:13.0];
    [self.codeButton addTarget:self action:@selector(huoquYanZhengMaButton:) forControlEvents:UIControlEventTouchUpInside];
    [topView2 addSubview:self.codeButton];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(topView2).mas_offset(-20);
        make.centerY.mas_equalTo(topView2);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(80);
    }];
    
    [topView2 addSubview:self.passwordField];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneImage2.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(topView2);
        make.height.mas_equalTo(@20);
        make.right.mas_equalTo(self.codeButton.mas_left).mas_offset(-5);
    }];
    
    
    UIView * spLineView2 = [UIView new];
    spLineView2.backgroundColor = [UIColor colorWithhex16stringToColor:Main_GrayColor_ZL];
    [topView2 addSubview:spLineView2];
    [spLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(topView2).mas_offset(-20);
        make.left.mas_equalTo(topView2).mas_offset(20);
        make.height.mas_equalTo(@1);
        make.bottom.mas_equalTo(topView2);
    }];
    
    /** 忘记密码按钮 删除*/
    self.forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    self.forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.forgetPasswordButton addTarget:self action:@selector(forgetPasswordButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.forgetPasswordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    /*
    [zhongView addSubview:self.forgetPasswordButton];
    [self.forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView2.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(zhongView).mas_offset(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
     */
    
    /** 登录按钮 */
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.enabled = NO;
    [zhongView addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView2.mas_bottom).mas_offset(50.0f);
        make.left.mas_equalTo(zhongView).mas_offset(20);
        make.right.mas_equalTo(zhongView).mas_offset(-20);
        make.height.mas_equalTo(40);
    }];
    /** 注册按钮 删除*/
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registerButton setTitle:@"注册新账号" forState:UIControlStateNormal];
    self.registerButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.registerButton addTarget:self action:@selector(registerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    /*
    [zhongView addSubview:self.registerButton];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginButton.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(zhongView);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(30);
    }];
     */
    
    
}

- (void)setupUserProtocolLabel{
    self.protocolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.protocolButton setBackgroundImage:[UIImage imageNamed:@"bugou"] forState:UIControlStateNormal];
    [self.protocolButton setBackgroundImage:[UIImage imageNamed:@"gou"] forState:UIControlStateSelected];
    self.protocolButton.selected = YES;
    [self.protocolButton addTarget:self action:@selector(protocolButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.protocolButton];
    [self.protocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view).mas_offset(-30);
        make.bottom.mas_equalTo(self.view).mas_offset(-20);
        make.width.height.mas_equalTo(20);
    }];
    
    NSMutableAttributedString * one = [[NSMutableAttributedString alloc] initWithString:@"用户协议"];
    one.font = [UIFont systemFontOfSize:11.0];
    one.underlineStyle = NSUnderlineStyleSingle;
    //NSMakeRange(0, self.length)
    __weak typeof(self) weakSelf = self;
    [one setTextHighlightRange:one.rangeOfAll
                         color:[UIColor whiteColor] backgroundColor:[UIColor colorWithWhite:0.0 alpha:0.22] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                             ProtocolZlViewController * VC = [[ProtocolZlViewController alloc]init];
                             [weakSelf.navigationController pushViewController:VC animated:YES];
    }];
    NSMutableAttributedString * two = [[NSMutableAttributedString alloc] initWithString:@"同意 "];
    two.font = [UIFont systemFontOfSize:11.0];
    [two appendAttributedString:one];
    
    YYLabel * labelyy = [YYLabel new];
    labelyy.attributedText = two;
    //labelyy.centerX = [[UIScreen mainScreen] bounds].size.width/2.0-30;
    //labelyy.width = 70;
    labelyy.height = 15.0;
    //labelyy.bottom = [[UIScreen mainScreen] bounds].size.height-200;
    labelyy.textAlignment = NSTextAlignmentLeft;
    labelyy.numberOfLines = 0;
    labelyy.backgroundColor = [UIColor clearColor];
    labelyy.textColor = [UIColor whiteColor];
    [self.view addSubview:labelyy];
    [labelyy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.protocolButton.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(self.protocolButton).mas_offset(3);
    }];
    //            labelyy.highlightTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
    //                NSLog(@"再次点击");
    //            };
    
}

- (JVFloatLabeledTextField *)userNameField{
    if (!_userNameField) {
        _userNameField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectZero];
        //_userNameField.font = FONT_THEME;
        // 浮动式标签的正常字体颜色
        //_userNameField.floatingLabelTextColor = COLOR_THEME;
        // 输入框成为第一响应者时,浮动标签的文字颜色.
        _userNameField.floatingLabelActiveTextColor = [UIColor grayColor];
        //浮动文字Y距离
        _userNameField.floatingLabelYPadding = -15.0f;
        // 指明当输入文字时,是否下调基准线(baseline).设置为YES(非默认值),意味着占位内容会和输入内容对齐.
        _userNameField.keepBaseline = YES;
        //placeHolder字体颜色
        _userNameField.placeholderColor = [UIColor whiteColor];
        //正常字体颜色
        _userNameField.textColor = [UIColor whiteColor];
        // 设置占位符文字和浮动式标签的文字.
        [_userNameField setPlaceholder:@"请输入手机号码"
                             floatingTitle:@"手机号"];
        _userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userNameField.delegate = self;
        _userNameField.keyboardType = UIKeyboardTypeNumberPad;
        [_userNameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _userNameField;
}
- (JVFloatLabeledTextField *)passwordField{
    if (!_passwordField) {
        _passwordField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectZero];
        //_userNameField.font = FONT_THEME;
        // 浮动式标签的正常字体颜色
        //_userNameField.floatingLabelTextColor = COLOR_THEME;
        // 输入框成为第一响应者时,浮动标签的文字颜色.
        _passwordField.floatingLabelActiveTextColor = [UIColor grayColor];
        //浮动文字Y距离
        _passwordField.floatingLabelYPadding = -15.0f;
        // 指明当输入文字时,是否下调基准线(baseline).设置为YES(非默认值),意味着占位内容会和输入内容对齐.
        _passwordField.keepBaseline = YES;
        //placeHolder字体颜色
        _passwordField.placeholderColor = [UIColor whiteColor];
        //正常字体颜色
        _passwordField.textColor = [UIColor whiteColor];
        // 设置占位符文字和浮动式标签的文字.
        [_passwordField setPlaceholder:@"请输入验证码"
                         floatingTitle:@"验证码"];
        _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordField.delegate = self;
        //密文显示
        //_passwordField.secureTextEntry = YES;
        //_passwordField.tag = 1;
        /** 实时监控TextField的变化 */
        _passwordField.keyboardType = UIKeyboardTypeNumberPad;
        [_passwordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordField;
}
#pragma mark ===================TextField代理方法 START==================
- (void)textFieldDidChange:(UITextField *)textField{
    /** 密码输入框 */
    if (textField == self.passwordField) {
        //NSLog(@"密码输入框输入变化：%@",textField.text);
    }
    if (self.protocolButton.isSelected == YES) {
        if (self.passwordField.text.length > 0 && self.userNameField.text.length > 0) {
            self.loginButton.enabled = YES;
        }
        else{
            
            self.loginButton.enabled = NO;
        }
    }
    else{
        self.loginButton.enabled = NO;
    }
}

#pragma mark ===================TextField代理方法 END==================

/** 获取验证码 */
- (void)huoquYanZhengMaButton:(UIButton *)sender{
    if (self.userNameField.text.length > 0) {
        //倒计时默认状体
        [self.codeButton setTitle:@"重发(60s)" forState:UIControlStateNormal];
        //倒计时时间
        __block int timeout=59;
        //倒计时全局队列
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //设置一个事件处理器
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        //设置时间处理器时间
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                
                //取消事件处理器
                dispatch_source_cancel(_timer);
                //回到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    self.codeButton.userInteractionEnabled = YES;
                    //设置倒计时标题
                    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                    
                });
            }else{
                //去时间余
                int seconds = timeout % 60;
                //拿到时间文字
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                //回到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [UIView beginAnimations:nil context:nil];
                    //设置动画时间为1秒
                    [UIView setAnimationDuration:1];
                    //时间倒计时为0的时候显示重发?秒
                    [self.codeButton setTitle:[NSString stringWithFormat:@"重发(%@秒)",strTime] forState:UIControlStateNormal];
                    
                    [UIView commitAnimations];
                    self.codeButton.userInteractionEnabled = NO;
                    
                });
                timeout--;
            }
        });
        
        dispatch_resume(_timer);
        NSLog(@"获取验证码按钮点击");
        /** 请求发送验证码 */
        //self.userName = self.userNameField.text;
        [[ZLLoginViewModel shareInstance] startCodeAFWorkingWith:self.userNameField.text withCountryNum:self.countryString];
    }
}


/** 显示隐藏密码 */
- (void)seePasswordButtonAction:(UIButton *)sender{
    
     // 前提:在xib中设置按钮的默认与选中状态的背景图
     // 切换按钮的状态
     sender.selected = !sender.selected;
     
     if (sender.selected) { // 按下去了就是明文
     
     NSString *tempPwdStr = self.passwordField.text;
     self.passwordField.text = @""; // 这句代码可以防止切换的时候光标偏移
     self.passwordField.secureTextEntry = NO;
     self.passwordField.text = tempPwdStr;
     
     } else { // 暗文
     
     NSString *tempPwdStr = self.passwordField.text;
     self.passwordField.text = @"";
     self.passwordField.secureTextEntry = YES;
     self.passwordField.text = tempPwdStr;
     }
    
}
/** 忘记密码 */
- (void)forgetPasswordButtonAction:(UIButton *)sender{
    ForgetpasswordViewController * forget = [[ForgetpasswordViewController alloc]init];
    [self.navigationController pushViewController:forget animated:YES];
}

/** 登录按钮 */
- (void)loginButtonAction:(UIButton *)sender{
    [self.view endEditing:YES];
    // 因为设置了自动登录模式：[[EMClient sharedClient].options setIsAutoLogin:YES];
    // 所以，登录之前要先注销之前的用户，否则重复登录会抛异常
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        NSLog(@"环信退出成功");
    }
    /** 登录页面中，创建用户详细信息类，而非登录信息类，并保存。Predecessor遗留问题，准备重构 */
    InforModel * IninforMo = [[InforModel alloc]init];
    IninforMo = [LoginDataModel sharedManager].inforModel;
    [[LoginDataModel sharedManager]saveLoginMemberData:IninforMo];
    
    sender.enabled = NO;
    if (self.passwordField.text.length > 0 && self.userNameField.text.length > 0) {
        [self showLoading];
        [[ZLLoginViewModel shareInstance] startLoginAFNetworkingWith:self.userNameField.text withCode:self.passwordField.text  withCountryNum:self.countryString withSuccessBlock:^(BOOL success,int active,int mark,int checkType) {
             [self dismissLoading];
            if (success == YES) {
                if (mark == 0) {
                    //老用户
                    if (active == 0) {
                        //乘客
                         [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:ROLE_TYPE_ZL];
                        /** 登陆成功 已经激活 */
                        [(AppDelegate *)[UIApplication sharedApplication].delegate setRootControllerMainTabVC];
                        
                    }else if (active == 1){
                        //司机
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:ROLE_TYPE_ZL];
                        if (checkType == 0) {
                            /** 未提交资料认证 */
                            DriverZiLiaoViewController * ziLiaoVC = [[DriverZiLiaoViewController alloc]init];
                            [self.navigationController pushViewController:ziLiaoVC animated:YES];
                        }else if (checkType == 1){
                            
                            /** 登陆成功 已经激活 */
                            [(AppDelegate *)[UIApplication sharedApplication].delegate setRootControllerMainTabVC];
                            /** 审核中 */
//                            ShenHeZLViewController *VC = [[ShenHeZLViewController alloc]init];
//                            VC.type = 0;
//                            [self.navigationController pushViewController:VC animated:YES];
                        }else if (checkType == 2){
                            /** 审核未通过 */
                            ShenHeZLViewController *VC = [[ShenHeZLViewController alloc]init];
                            VC.type = 1;
                            [self.navigationController pushViewController:VC animated:YES];
                        }else if (checkType == 10){
                            /** 登陆成功 已经激活 */
                            [(AppDelegate *)[UIApplication sharedApplication].delegate setRootControllerMainTabVC];
                        }
                        
                    }else if (active == 2){
                        //未选择角色
                        /** 未激活，既是未设置角色 */
                        RoleViewController * roleVC= [[RoleViewController alloc]init];
                        [self.navigationController pushViewController:roleVC animated:YES];
                    }
                }
                else{
                    //新用户
                    /** 未激活，既是未设置角色 */
                    RoleViewController * roleVC= [[RoleViewController alloc]init];
                    [self.navigationController pushViewController:roleVC animated:YES];
                }
            }else{
               
            }
            sender.enabled = YES;
           
        } withFailBlock:^(BOOL fail, NSString *message) {
            [self dismissLoading];
            if (fail == YES) {
                /** 登录失败，但是网络连接成功 */
                ZLALERT_TEXTINFO(message);
                //[self showErrorText:message];
                
            }
            else{
                /** 网络连接失败 */
                ZLALERT_TEXTINFO(FAIL_NETWORKING_CONNECT);
                //[self showErrorText:FAIL_NETWORKING_CONNECT];
                
            }
            sender.enabled = YES;
            
        }];
    }
    else{

    }
}

/** 注册按钮 */
- (void)registerButtonAction:(UIButton *)sender{
    
}
/** 选择国际代码 */
- (void)countryButtonAction:(UIButton *)sender{
    NSLog(@"进入选择国际代码界面");
    XWCountryCodeController *CountryCodeVC = [[XWCountryCodeController alloc] init];
    CountryCodeVC.deleagete = self;
    //block
    [CountryCodeVC toReturnCountryCode:^(NSString *countryCodeStr) {
        
        NSString * str = countryCodeStr;
        
        NSArray *array = [str componentsSeparatedByString:@"+"];
        
        NSLog(@"%@---%@",array[1],countryCodeStr);
        NSString * daiMaStr = [NSString stringWithFormat:@"+%@",array[1]];
        [self.countryButton setTitle:daiMaStr forState:UIControlStateNormal];
        self.countryString = daiMaStr;
    }];
    [self presentViewController:CountryCodeVC animated:YES completion:nil];
}

/** 协议按钮 */
- (void)protocolButtonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.isSelected == YES) {
        if (self.passwordField.text.length > 0 && self.userNameField.text.length > 0) {
            self.loginButton.enabled = YES;
        }
        else{
            
            self.loginButton.enabled = NO;
        }
    }
    else{
        self.loginButton.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
