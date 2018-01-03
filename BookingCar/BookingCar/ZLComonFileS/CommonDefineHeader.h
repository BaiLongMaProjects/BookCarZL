//
//  CommonDefineHeader.h
//  BookingCar
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#ifndef CommonDefineHeader_h
#define CommonDefineHeader_h



#define DefaultHeaderImage @"My_Header"
#define DefaultBackImage @"defaultzl"
#define Default_ImageView @"defaultPZL"

#define DEVICE_TOKEN_ZL @"deviceToken"
#define USER_NOTIFICATION_ZL @"userInfoNotification"
#define USER_ROLE_CHANGE_NOTIFICATION @"user_role_change_notification"
#define USER_RECEIVE_MESSAGE_NOTIFICATION @"user_receive_message_notification"

/** 用户经纬度 */
#define USER_LOCATION_LAT @"user_location_lat"
#define USER_LOCATION_LON @"user_location_lon"



#define Main_USERNAME_COLOR_ZL  @"566993"
#define Main_GrayColor_ZL  @"F3F3F5"
#define Main_TextMessage_Color_ZL  @"010101"
#define Main_TextComent_Color_ZL  @"010101"
#define Main_ZAN_URSERCOLOR_ZL  @"586C95"

#define Main_LightGray_CCCCCC @"cccccc"
#define Main_TextColor_Black  @"333333"
#define Main_TextColor_Gray   @"666666"
#define Main_blueColor_ZL     @"179cff"
#define Main_OrangeColor_ZL   @"fd9d07"
#define Main_Background_Gray_Color @"E6E6E6"


/** 用户相关 */
#define USER_NICK_NAME @"user_nick_name"
#define ROLE_TYPE_ZL  @"role"
#define USER_PHOTO_ZL @"user_photo_zl"
#define USER_PASSWORD_ZL  @"user_password_zl"
#define USER_TOKEN_ZL @"user_token_zl"
/** 环信默认密码 */
#define USER_HUANXIN_PASSWORD @"111111"
#define USER_ROLE_FINISHED_TYPE @"user_role_finished_type"


#define BUGGLY_APP_ID   @"0c6831fb30"
#define BUGGLY_APP_KEY @"946c56d2-deb4-4932-a8b0-b93b3ebc2ae1"
#define GAODE_APP_KEY @"8a63cee1b8c483aa312d11267cc7fd46"


/** 网络请求相关宏定义 */
#define FAIL_NETWORKING_CONNECT @"白龙马迷路了"
#define SUCCESS_NETWORKING_CONNECT @"success_networking_connect"

/** 环信APPKEY，APNSCERNAME */
#define HUANXIN_APPKEY @"1151171228115450#bookingcar"
#define HUANXIN_APNSCERNAME @"CeShiPush"
//#define HUANXIN_APNSCERNAME @"BookZhengShi"

/** 弹出提示信息 */
#define ZLALERT_TEXTINFO(text)  [[RYHUDManager sharedManager] showWithMessage:text customView:nil hideDelay:2.f]

#endif /* CommonDefineHeader_h */
