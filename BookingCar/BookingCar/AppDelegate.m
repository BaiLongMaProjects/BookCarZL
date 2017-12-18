//
//  AppDelegate.m
//  BookingCar
//
//  Created by LiXiaoJing on 26/06/2017.
//  Copyright © 2017 LiXiaoJing. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainTabViewController.h"
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>
/** 调用系统震动和声音 */
#import <AudioToolbox/AudioToolbox.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApiInterface.h>
//新浪微博SDK头文件
//#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加”-ObjC”
//人人SDK头文件
//#import <RennSDK/RennSDK.h>
#import <MBProgressHUD.h>

#import "CoreNewFeatureVC.h"
//#import "ZIKCellularAuthorization.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,EMClientDelegate,EMChatManagerDelegate>{
    int appCount;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /** 加载动画 */
    //[self svPreferrenceConf];
    
    appCount = 0;
    /** 检测网络，允许蜂窝网络 */
    //[ZIKCellularAuthorization requestCellularAuthorization];
    // 启动图片延时: 1秒
    //[NSThread sleepForTimeInterval:2];
     [Bugly startWithAppId:BUGGLY_APP_ID];
    //环信
    [self CreatHyphenateHuanXin];
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                            didFinishLaunchingWithOptions:launchOptions
                                                   appkey:@"messagego#bookingcar"
                                             apnsCertName:@"BookingCar_dev"
                                              otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    //});

    
    //关闭设置为NO, 默认值为NO.
    //键盘设置
    [IQKeyboardManager sharedManager].enable = YES;
    //键盘一建回收
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    LoginModel * loginMo = [[LoginModel alloc]init];
    loginMo= [LoginDataModel sharedManager].loginInModel;
    /** 新版本检测 */
    if([CoreNewFeatureVC canShowNewFeature] == YES){
        [self newBanBenShow];
    }
    else{
        if (loginMo.token.length > 0) {
            //自动登录 下次不用再等，默认是关闭的
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = [[EMClient sharedClient] loginWithUsername:[kUserDefaults valueForKey:USER_PHOTO_ZL] password:[kUserDefaults valueForKey:USER_PASSWORD_ZL]];
                if (!error)
                {
                    [[EMClient sharedClient].options setIsAutoLogin:YES];
                }
            });
            MainTabViewController *tabController=[[MainTabViewController alloc]init];
            self.window.rootViewController=tabController;
        }
        else{
            [self setRootControllerLoginVC];
        }
    }


    //第三方登录
//    [self CreatShareSDKLogin];
    
    //友盟推送
    [UMessage startWithAppkey:@"598ab822677baa576d0000a2" launchOptions:launchOptions];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            NSLog(@"点击允许通知");
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            NSLog(@"点击不允许通知");
            //这里可以添加一些自己的逻辑
        }
    }];

    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
    
    /**
     注册APNS离线推送  iOS8 注册APNS
     */
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
//    /** 3D touch 开发 */
//    [self creatShortcutItem];
//    UIApplicationShortcutItem *shortcutItem = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
//    //如果是从快捷选项标签启动app，则根据不同标识执行不同操作，然后返回NO，防止调用- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
//    if (shortcutItem) {
//        //判断设置的快捷选项标签唯一标识，根据不同标识执行不同操作
//        if([shortcutItem.type isEqualToString:@"com.yang.one"]){
//            NSLog(@"新启动APP-- 第一个按钮");
//        } else if ([shortcutItem.type isEqualToString:@"com.yang.search"]) {
//            //进入搜索界面
//            NSLog(@"新启动APP-- 搜索");
//        } else if ([shortcutItem.type isEqualToString:@"com.yang.add"]) {
//            //进入分享界面
//            NSLog(@"新启动APP-- 添加联系人");
//        }else if ([shortcutItem.type isEqualToString:@"com.yang.share"]) {
//            //进入分享页面
//            NSLog(@"新启动APP-- 分享");
//            //[self shareButtonAction];
//        }
//        
//        return NO;
//    }
    
    [self.window makeKeyAndVisible];
    return YES;
}
/** 3D Touch开发 */
//如果APP没被杀死，还存在后台，点开Touch会调用该代理方法
//- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
//    if (shortcutItem) {
//        //判断设置的快捷选项标签唯一标识，根据不同标识执行不同操作
//        if([shortcutItem.type isEqualToString:@"com.yang.one"]){
//            NSLog(@"APP没被杀死-- 第一个按钮");
//        } else if ([shortcutItem.type isEqualToString:@"com.yang.search"]) {
//            //进入搜索界面
//            NSLog(@"APP没被杀死-- 搜索");
//        } else if ([shortcutItem.type isEqualToString:@"com.yang.add"]) {
//            //进入分享界面
//            NSLog(@"APP没被杀死-- 添加联系人");
//        }else if ([shortcutItem.type isEqualToString:@"com.yang.share"]) {
//            //进入分享页面
//            NSLog(@"APP没被杀死-- 分享");
//            //[self shareButtonAction];
//        }
//    }
//
//    if (completionHandler) {
//        completionHandler(YES);
//    }
//}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"注册deviceToken失败error -- %@",error);
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
    [application registerForRemoteNotifications];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[EMClient sharedClient] bindDeviceToken:deviceToken];

    // <32e7cf5f 8af9a8d4 2a3aaa76 7f3e9f8e 1f7ea8ff 39f50a2a e383528d 7ee9a4ea>
    // <32e7cf5f 8af9a8d4 2a3aaa76 7f3e9f8e 1f7ea8ff 39f50a2a e383528d 7ee9a4ea>
  
    /*
    NSLog(@" 加入测试设备 === %@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    */
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    [UMessage registerDeviceToken:deviceToken];
   
    NSString * StrDevice=[NSString stringWithFormat:@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                                            stringByReplacingOccurrencesOfString: @">" withString: @""]
                                                           stringByReplacingOccurrencesOfString: @" " withString: @""]];

    [[NSUserDefaults standardUserDefaults] setObject:StrDevice forKey:@"deviceToken"];
    //这一步是使数据同步，但不是必须的
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//环信
-(void)CreatHyphenateHuanXin{
    
    [[EMClient sharedClient] setApnsNickname:@"白龙马"];
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"messagego#bookingcar"];
    options.apnsCertName = @"BookingCar_dev";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    //2. AppDelegate程序加载完成时,监听自动登录的状态
    [[EMClient sharedClient]addDelegate:self delegateQueue:nil];
    
    EMPushOptions *emoptions = [[EMClient sharedClient] pushOptions];
    //设置有消息过来时的显示方式:1.显示收到一条消息 2.显示具体消息内容.
    //自己可以测试下
    emoptions.displayStyle = EMPushDisplayStyleMessageSummary;
    [[EMClient sharedClient] updatePushOptionsToServer];
    
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
 
}
//自动登录时调用
-(void)didAutoLoginWithError:(EMError*)aError{
    
    NSLog(@"环信自动登录了");

}

//当前登录账号在其它设备登录时会接收到此回调
- (void)userAccountDidLoginFromOtherDevice{

    [[RYHUDManager sharedManager] showWithMessage:@"当前登录账号在其它设备登录" customView:nil hideDelay:2.f];

}

#pragma mark ===================实时接收消息回调==================
/*!
 @method
 @brief 接收到一条及以上非cmd消息
 */
//监听环信在线推送消息
- (void)messagesDidReceive:(NSArray *)aMessages{
    appCount++;
    UIApplication *app=[UIApplication sharedApplication];
    app.applicationIconBadgeNumber = appCount;
    
    for (EMMessage *message in aMessages) {
        EMMessageBody *msgBody = message.body;
        switch (msgBody.type) {
            case EMMessageBodyTypeText:
            {
                // 收到的文字消息
                EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                NSString *txt = textBody.text;
                NSLog(@"收到的文字是 txt -- %@",txt);
            }
                break;
            case EMMessageBodyTypeImage:
            {
                // 得到一个图片消息body
                EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
                NSLog(@"大图remote路径 -- %@"   ,body.remotePath);
                NSLog(@"大图local路径 -- %@"    ,body.localPath); // // 需要使用sdk提供的下载方法后才会存在
                NSLog(@"大图的secret -- %@"    ,body.secretKey);
                NSLog(@"大图的W -- %f ,大图的H -- %f",body.size.width,body.size.height);
                NSLog(@"大图的下载状态 -- %u",body.downloadStatus);
                
                
                // 缩略图sdk会自动下载
                NSLog(@"小图remote路径 -- %@"   ,body.thumbnailRemotePath);
                NSLog(@"小图local路径 -- %@"    ,body.thumbnailLocalPath);
                NSLog(@"小图的secret -- %@"    ,body.thumbnailSecretKey);
                NSLog(@"小图的W -- %f ,大图的H -- %f",body.thumbnailSize.width,body.thumbnailSize.height);
                NSLog(@"小图的下载状态 -- %u",body.thumbnailDownloadStatus);
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
                NSLog(@"纬度-- %f",body.latitude);
                NSLog(@"经度-- %f",body.longitude);
                NSLog(@"地址-- %@",body.address);
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                // 音频sdk会自动下载
                EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
                NSLog(@"音频remote路径 -- %@"      ,body.remotePath);
                NSLog(@"音频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在（音频会自动调用）
                NSLog(@"音频的secret -- %@"        ,body.secretKey);
                NSLog(@"音频文件大小 -- %lld"       ,body.fileLength);
                NSLog(@"音频文件的下载状态 -- %u"   ,body.downloadStatus);
                NSLog(@"音频的时间长度 -- %u"      ,body.duration);
            }
                break;
            case EMMessageBodyTypeVideo:
            {
                EMVideoMessageBody *body = (EMVideoMessageBody *)msgBody;
                
                NSLog(@"视频remote路径 -- %@"      ,body.remotePath);
                NSLog(@"视频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
                NSLog(@"视频的secret -- %@"        ,body.secretKey);
                NSLog(@"视频文件大小 -- %lld"       ,body.fileLength);
                NSLog(@"视频文件的下载状态 -- %u"   ,body.downloadStatus);
                NSLog(@"视频的时间长度 -- %u"      ,body.duration);
                NSLog(@"视频的W -- %f ,视频的H -- %f", body.thumbnailSize.width, body.thumbnailSize.height);
                
                // 缩略图sdk会自动下载
                NSLog(@"缩略图的remote路径 -- %@"     ,body.thumbnailRemotePath);
                NSLog(@"缩略图的local路径 -- %@"      ,body.thumbnailLocalPath);
                NSLog(@"缩略图的secret -- %@"        ,body.thumbnailSecretKey);
                NSLog(@"缩略图的下载状态 -- %u"      ,body.thumbnailDownloadStatus);
            }
                break;
            case EMMessageBodyTypeFile:
            {
                EMFileMessageBody *body = (EMFileMessageBody *)msgBody;
                NSLog(@"文件remote路径 -- %@"      ,body.remotePath);
                NSLog(@"文件local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
                NSLog(@"文件的secret -- %@"        ,body.secretKey);
                NSLog(@"文件文件大小 -- %lld"       ,body.fileLength);
                NSLog(@"文件文件的下载状态 -- %u"   ,body.downloadStatus);
            }
                break;
                
            default:
                break;
        }
    }
    
    
    //aMessages是一个对象,包含了发过来的所有信息,怎么提取想要的信息我会在后面贴出来.
    NSLog(@"接收消息回调：%ld",aMessages.count);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  // 震动
    AudioServicesPlaySystemSound(1007);
    
    /** 接收消息 发送用户通知*/
    //[self xw_postNotificationWithName:USER_RECEIVE_MESSAGE_NOTIFICATION userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_RECEIVE_MESSAGE_NOTIFICATION object:nil];
}

#pragma mark ===================实时接收消息回调结束==================

-(void)CreatShareSDKLogin{
//    /**初始化ShareSDK应用
//     @param activePlatforms
//     使用的分享平台集合
//     @param importHandler (onImport)
//     导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作
//     @param configurationHandler (onConfiguration)
//     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
//     */
//    [ShareSDK registerActivePlatforms:@[
//                                  
//                                        @(SSDKPlatformTypeSinaWeibo),
//                                        @(SSDKPlatformTypeMail),
//                                        @(SSDKPlatformTypeSMS),
//                                        @(SSDKPlatformTypeCopy),
//                                        @(SSDKPlatformTypeWechat),
//                                        @(SSDKPlatformTypeQQ),
//                                        @(SSDKPlatformTypeRenren),
//                                        @(SSDKPlatformTypeFacebook),
//                                        @(SSDKPlatformTypeTwitter),
//                                        @(SSDKPlatformTypeGooglePlus),
//                                        
//                                        ]
//                             onImport:^(SSDKPlatformType platformType)
//     {
//         switch (platformType)
//         {
//             case SSDKPlatformTypeWechat:
//                 [ShareSDKConnector connectWeChat:[WXApi class]];
//                 break;
////             case SSDKPlatformTypeQQ:
////                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
////                 break;
////             case SSDKPlatformTypeSinaWeibo:
////                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
////                 break;
//             
//             default:
//                 break;
//         }
//     }
//                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
//     {
//         switch (platformType)
//         {
//             case SSDKPlatformTypeSinaWeibo:
//                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
//                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                                         redirectUri:@"http://www.sharesdk.cn"
//                                            authType:SSDKAuthTypeBoth];
//                 break;
//             case SSDKPlatformTypeWechat:
//                 [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
//                                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
//                 break;
//             case SSDKPlatformTypeQQ:
//                 [appInfo SSDKSetupQQByAppId:@"100371282"
//                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
//                                    authType:SSDKAuthTypeBoth];
//                 break;
//             case SSDKPlatformTypeRenren:
//                 [appInfo        SSDKSetupRenRenByAppId:@"226427"
//                                                 appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
//                                              secretKey:@"f29df781abdd4f49beca5a2194676ca4"
//                                               authType:SSDKAuthTypeBoth];
//                 break;
//             case SSDKPlatformTypeFacebook:
//                 [appInfo SSDKSetupFacebookByApiKey:@"107704292745179"
//                                          appSecret:@"38053202e1a5fe26c80c753071f0b573"
//                                        displayName:@"shareSDK"
//                                           authType:SSDKAuthTypeBoth];
//                 break;
//             case SSDKPlatformTypeTwitter:
//                 [appInfo SSDKSetupTwitterByConsumerKey:@"LRBM0H75rWrU9gNHvlEAA2aOy"
//                                         consumerSecret:@"gbeWsZvA9ELJSdoBzJ5oLKX0TU09UOwrzdGfo9Tg7DjyGuMe8G"
//                                            redirectUri:@"http://mob.com"];
//                 break;
//             case SSDKPlatformTypeGooglePlus:
//                 [appInfo SSDKSetupGooglePlusByClientID:@"232554794995.apps.googleusercontent.com"
//                                           clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
//                                            redirectUri:@"http://localhost"];
//                 break;
//             default:
//                 break;
//         }
//     }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
   
    [[EMClient sharedClient] applicationDidEnterBackground:application];

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    appCount = 0;
    [[EMClient sharedClient] applicationWillEnterForeground:application];
//     Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"iOS 10以下，调用 通知");
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_NOTIFICATION_ZL object:self userInfo:userInfo];
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:YES];
    [UMessage didReceiveRemoteNotification:userInfo];
}
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        NSLog(@"应用处于----前台-----时的远程推送接受");
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:USER_NOTIFICATION_ZL object:self userInfo:userInfo];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        NSLog(@"应用处于----后台----时的远程推送接受");
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [[NSNotificationCenter defaultCenter] postNotificationName:USER_NOTIFICATION_ZL object:self userInfo:userInfo];

        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

- (void)autoLoginDidCompleteWithError:(EMError *)error
{
    NSLog(@"发生自动登录的回调 === %@",error);
}


#pragma mark ===================调用DeviceToken方法 ZL==================

//remote 授权

- (void)registRemoteNotification{
    
#ifdef __IPHONE_8_0
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
        
    }
    
#else
    
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    
#endif
    
}



#pragma mark - remote Notification





//ios 7.0

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    /**
     
     *  系统会估量App消耗的电量，并根据传递的UIBackgroundFetchResult 参数记录新数据是否可用
     
     *  调用完成的处理代码时，应用的界面缩略图会自动更新
     
     */
    
    NSLog(@"did Receive Remote Notification userInfo %@",userInfo);
    
    switch (application.applicationState) {
            
        case UIApplicationStateActive:
            
            completionHandler(UIBackgroundFetchResultNewData);
            
            break;
            
        case UIApplicationStateInactive:
            
            completionHandler(UIBackgroundFetchResultNewData);
            
            break;
            
        case UIApplicationStateBackground:
            
            completionHandler(UIBackgroundFetchResultNewData);
            
            break;
            
        default:
            
            break;
            
    }
    
}


#pragma mark ===================ZL加载动画开始==================
#pragma mark --- SVProgressHUD 偏好设置
- (void)svPreferrenceConf{
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:CGFLOAT_MAX];
    [SVProgressHUD setInfoImage:[UIImage imageWithGIFNamed:@"loading.gif"]];
    UIImageView *svImgView = [[SVProgressHUD sharedView] valueForKey:@"imageView"];
    CGRect imgFrame = svImgView.frame;
    //设置图片的显示大小
    imgFrame.size = CGSizeMake(64, 64);
    svImgView.frame = imgFrame;
}
#pragma mark ===================ZL加载动画结束==================

@end
