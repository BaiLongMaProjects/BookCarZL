//
//  ZLLoginViewController.h
//  BookingCar
//
//  Created by apple on 2017/11/22.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseZLRootViewController.h"
#import <JVFloatLabeledTextField.h>
#import "ForgetpasswordViewController.h"
#import "ZhengZePanDuan.h"
#import "ZLLoginViewModel.h"
#import "XWCountryCodeController.h"//选择国家
#import "ProtocolZlViewController.h"
#import "AppDelegate+AppCategoryZL.h"
#import "RoleViewController.h"
#import "ShenHeZLViewController.h"
#import "DriverZiLiaoViewController.h"

@interface ZLLoginViewController : BaseZLRootViewController<UITextFieldDelegate,XWCountryCodeControllerDelegate>
/** 用户名 */
@property (nonatomic, copy) NSString *userName;
/** 密码 */
@property (nonatomic, copy) NSString *passWord;
/** 验证码 */
@property (nonatomic, copy) NSString *code;
/** 是否同意用户协议 默认YES */
@property (nonatomic, assign) BOOL isAgreeProtocol;
/** 用户名 */
@property (nonatomic, strong) JVFloatLabeledTextField *userNameField;
/** 密码 */
@property (nonatomic, strong) JVFloatLabeledTextField *passwordField;
/** 密码可见 默认NO */
@property (nonatomic, strong) UIButton *isCanSeePassword;
/** 获取验证码 */
@property (nonatomic, strong) UIButton *codeButton;
/** 忘记密码 */
@property (nonatomic, strong) UIButton *forgetPasswordButton;
/** 登录按钮 */
@property (nonatomic, strong) UIButton *loginButton;
/** 注册按钮 */
@property (nonatomic, strong) UIButton *registerButton;
/** QQ登录 */
@property (nonatomic, strong) UIButton *qqButton;
/** 微信登录 */
@property (nonatomic, strong) UIButton *weixinButton;
/** 国家代码 */
@property (nonatomic, strong) UIButton *countryButton;
/** 当前国家代码 */
@property (nonatomic, copy) NSString *countryString;
/** 同意协议按钮 */
@property (nonatomic, strong) UIButton *protocolButton;
@end
