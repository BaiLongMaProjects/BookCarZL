//
//  Header.h
//  BookingCar
//
//  Created by LiXiaoJing on 29/06/2017.
//  Copyright © 2017 LiXiaoJing. All rights reserved.
//

#ifndef Header_h
#define Header_h

#pragma mark--- LDX========================================
#import <SVProgressHUD/SVProgressHUD.h>//加载样式
#import <SMS_SDK/SMSSDK.h>//短信接口
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKConnector/ShareSDKConnector.h>
//#import "WXApi.h"//微信SDK头文件

#import "RYUtils.h"//封装
#import <AFNetworking/AFNetworking.h>//数据请求
#import "AFHTTPRequestOperationManager.h"
#import "HttpTool.h"//封装的网络数据请求
#import <XYQRegexPattern/XYQRegexPatternHelper.h>//正则表达式
#import "LoginModel.h"//登录
#import "LoginDataModel.h"
#import "UIImageView+WebCache.h"//加载网络图片

#import <TSMessages/TSMessage.h>//提示
#import <MJRefresh/MJRefresh.h>//下拉刷新
#import <MJRefresh/UIScrollView+MJRefresh.h>
#import "LewPopupViewController.h"//放大的框
#import <FMDB.h>//数据存储
#import "IQKeyboardManager.h"//ios 键盘
#import "CCHeadImagePicker.h"//调用系统的相册
#import "UIBarButtonItem+Icon.h"

#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MainNavigationController.h"

#ifdef __OBJC__
#import "ZLBookCarComonHeader.h"
#import "CommonDefineHeader.h"

#endif

#define BaseLDXColor [UIColor colorWithRed:245.0f/255.0 green:245.0f/255.0 blue:245.0f/255.0 alpha:1.0f]
// 测试外网
//#define kBaseURL @"​http://api.mansi.xiamaixiaomai.com/"

/** 测试环境URL */
//#define kBaseurl  @"https://api.wangchengjian.cn/"
/** 正式环境 */
#define kBaseurl  @"https://api.mansi.xiaomaixiaomai.com/"

#define DOWNLOAD_APP_URL @"https://itunes.apple.com/cn/app/%E7%99%BD%E9%BE%99%E9%A9%AC%E5%87%BA%E8%A1%8C/id1273504597?mt=8"

#pragma mark -- 图片接口
#define kPhotoAddress @"https://image.mansi.xiaomaixiaomai.com/" 
//登录注册
#define kLoginUrl @"/api/sign/login"//登录
#define kRegisterUrl @"/api/sign/register"//注册
#define kResetPasswordUrl @"/api/sign/reset-password"//手机号修改密码
#define kChangePasswordUrl @"/api/sign/change-password"//手机号修改密码
#define kSetRoleUrl @"/api/sign/set-role"//设置角色
#define kdriverMyVerify @"/api/driver/my-verify"//验证身份
#define kdriverVerifySubmit @"/api/driver/verify-submit"//身份认证表单

#define kUploaddriverPic1 @"/api/demo/upload?prefix=driver_pic1"//上传驾驶证正面单号
#define kUploaddriverPic2 @"/api/demo/upload?prefix=driver_pic2"//上传保险单号
#define kUploadCarPic1 @"/api/demo/upload?prefix=car_pic1"//上传车辆正面照片
#define kUploadCarPic2 @"/api/demo/upload?prefix=car_pic2"//上传车辆背面照片

#define kSignPortocol @"/api/sign/protocol"//登录
#define kNewBanBenInfo @"/api/sign/get-version"



//首页
#define kOrderNewUrl @"/api/order/new"//发布行程
#define kOrderMyList @"/api/order/my-list"//我的行程
#define kOrderMyList2 @"/api/order/my-list2"//我的行程列表
#define kOrderCancel @"/api/order/cancel"//取消行程
#define kWaitingList @"/api/order/waiting-list3"//附近的订单列表
#define kWaitingList2 @"/api/order/wait-near-driver"//附近的车列表

#define kSignNearDriver @"/api/sign/near-drivers4"//附近的司机
#define kSignNearUser @"/api/sign/near-users4"//附近的乘客
#define kOrderQuote @"/api/order/quote"//司机报价等待乘客同意
#define kOrderUserStatus @"/api/order/user-order-status"//用户订单状态
#define kOrderDriverStatus @"/api/order/driver-order-status"//司机订单状态
#define kOrderQuotes @"api/order/quotes"//获取我的订单报价列表
#define kOrderAgree @"/api/order/agree"//乘客同意报价
#define kUploadBackgroud @"/api/demo/upload?prefix=backgroud"//上传背景图
#define kOrderInfo @"/api/order/order-info"//订单详情

#define kSelectDriver @"api/order/select-driver"//用户选择司机
#define kSignThumb @"/api/sign/thumb"//用户点赞

//个人中心
#define kPersonUpload @"/api/sign/upload"//上传头像
#define kUploadPrefixHeadphoto @"api/demo/upload?prefix=avatar"//骑牛上传头像
#define kUpdatePerson @"/api/sign/update"//上传个人信息
#define kOrderQuote @"/api/order/quote"//司机报价等待乘客同意
#define kSingFeedback @"/api/sign/feedback"//投诉建议接口


//聊天
#define kDialogNew @"/api/dialog/new"//添加聊天人
#define kDialogList @"/api/dialog/list"//聊天列表
#define kDialogAdd @"/api/dialog/add"//聊天对话


//OShow
#define kDetailUrl @"/api/sign/detail"//详情
#define kOShowListUrl @"/api/oshow/list"//OShow列表
#define kOShowList2Url @"/api/oshow/list2"//OShow列表2
#define kOShowReport @"/api/oshow/report"//举报
#define kOShowShield @"/api/oshow/shield"//屏蔽


#define kOShowAddUrl @"api/oshow/add"//OShow上传朋友圈列表
#define kUploadUrl @"api/demo/upload"//OShow上传图片
//#define kUploadUrl @"/api/demo/upload?prefix=img"//OShow上传图片

#define kMyOShowList @"/api/oshow/my-list"//我的OShow列表
#define kOShowOtherList @"/api/oshow/other-list"//我的OShow列表

#define kFavoriteLove @"/api/oshow/favorite"//点赞
#define kOShowComment @"/api/oshow/comment"//评论


/** ZL新增加接口 */
#define kZLLogin_URL @"/api/sign/login2"
/** 短信登录*/
#define kZLSMS_Login_URL @"/api/sign/sms-sign"


//Downloader
#define DOCUMENTS_FOLDER    [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"]
#define kNetWorkErrorString @"网络错误"
#define kAllDataLoaded      @"已加载完所有数据"

//App Constant Values
#define kLoginUserDataFile                  @"LoginUserDataFile"
#define kLoginInDataFile @"LoginInDataFile"


#pragma mark--- LDX<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
//Constant Values
#define  SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height
#define  SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define D_width SCREENWIDTH/375
#define D_height SCREENHEIGHT/667


#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KScaleOfLenth(x) (([UIScreen mainScreen].bounds.size.width/375.0f)*(x))
//定义高度
#define kUIScreenSize [UIScreen mainScreen].bounds.size
#define kUIScreenWidth kUIScreenSize.width
#define kUIScreenHeight kUIScreenSize.height



#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r,g,b,a)                  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
//背景色
#define kGlobalBg RGB(245, 245, 245)
#define kSwichChangeNotificationKey @"SwichChangeNotification"
#define kGlobalTintColor RGBColor(28, 26, 35)
#define BaseLDXColor       [UIColor colorWithRed:245.0f/255.0 green:245.0f/255.0 blue:245.0f/255.0 alpha:1.0f]
#define ButLDXColor        [UIColor colorWithRed:59.0f/255.0 green:119.0f/255.0 blue:188.0f/255.0 alpha:1.0f]



#define BelowFrame(frame,offset) frame.origin.y+frame.size.height+offset
#define KCenterOfFrame(frame) CGPointMake(frame.origin.x+frame.size.width/2.0f, frame.origin.y+frame.size.height/2.0f)
#define KNewFrameOfScale(scaleWidth,scaleHeight,oldFrame) CGRectMake(KCenterOfFrame(oldFrame).x-oldFrame.size.width*scaleWidth/2.0f, KCenterOfFrame(oldFrame).y-oldFrame.size.width*scaleHeight/2.0f, oldFrame.size.width*scaleWidth, oldFrame.size.height*scaleHeight);

//判断是否为IOS7.0
#define iOS70 ([[[UIDevice currentDevice] systemVersion]floatValue] <= 7.0)
#endif /* Header_h */



//40acfd

