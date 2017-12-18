//
//  CommonHeader.h
//  ZXMeng
//
//  Created by apple on 17-09-23.
//  Copyright (c) 2017年 KingkongWolf. All rights reserved.
//

#ifndef ZXMeng_CommonHeader_h
#define ZXMeng_CommonHeader_h

#define DEV_SCREEN(width, height)	(([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(width, height), [[UIScreen mainScreen] currentMode].size) : NO))
#define iPad			(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define iPhone			([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define iPhone_Normal	(DEV_SCREEN(320, 480))
#define iPhone_Retina	(DEV_SCREEN(640, 960))
#define iPhone5			(DEV_SCREEN(640, 1136))
#define iPhone6         (DEV_SCREEN(750, 1334))
#define iPhone6s        (DEV_SCREEN(1242, 2208))
#define iPad_Normal		(DEV_SCREEN(768, 1024))
#define iPad_Retina		(DEV_SCREEN(768*2, 1024*2))

#define	RetinaScree		(iPhone_Retina || iPhone5 || iPad_Retina)
#define NormalScree		(iPad_Normal||iPhone_Normal)

#define iPhone_X  (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375.0f, 812.0f)) || CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(812.0f, 375.0f))?:NO)


#define Color(color)					(((float)color)/255.0f)

#define ColorWithRGB(r,g,b)         ([UIColor colorWithRed:Color(r) green:Color(g) blue:Color(b) alpha:1.0f])
#define ColorWithRGBA(r,g,b,a)      ([UIColor colorWithRed:Color(r) green:Color(g) blue:Color(b) alpha:(a)])
#define RadomColor      [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1.0]

#define I2S(v)          ([NSString stringWithFormat:@"%d", v])
#define F2S(v)          ([NSString stringWithFormat:@"%f", v])
#define L2S(v)          ([NSString stringWithFormat:@"%ld", v])

#define debug(v)    NSLog(@"%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d",v,v,v,v,v,v,v,v,v,v,v,v)

#define SIZE_WIDTH [UIScreen mainScreen].bounds.size.width
#define SIZE_HEIGHT [UIScreen mainScreen].bounds.size.height


#define NAVTOP_Height 64
#define NAVBOT_Height 49

#define FontCustomNeue @"HelveticaNeue"
#define FontCustomNeue_Bold @"HelveticaNeue-Bold"
#define FontCustomNeue_Light @"HelveticaNeue-Light"
#define FontHelvetca @"Helvetica"
#define FontHelvetca_Bold @"Helvetica-Bold"

#define DisplayQuestion_Count 4

#define IOS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IOS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IOS_10_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

#define Login_NSNotification @"logined"

#define CHINA_FONT @"迷你简细圆"

#define EN_FONT @"HelveticaNeue"
#define EN_FONT_LIGHT @"HelveticaNeue-Light"
#define EN_FONT_LIGHTER @"HelveticaNeue-UltraLight"
#define EN_FONT_XIETI @"BodoniSvtyTwoITCTT-BookIta"



//ae835d
#define Main_BackgroundColor @"f9bf34"
//bab6b7  e6e6e6   f0eff5
#define Main_grayBackgroundColor @"f6f6f6"
//浅灰
#define Main_lightGrayBackgroundColor @"999999"




#define REQUEST_ERROR_ZL @"服务连接失败"

#define BundleZLShortVersionStr [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define IOS_VERSION		([[[UIDevice currentDevice] systemVersion] floatValue])
#define IOS(ver)		(IOS_VERSION >= ver)

#define Message_badge_num   @"message_badge_num"

#define SelectSecondVC_NOTIFICATION     @"SelectSecondVC_NOTIFICATION"


#define PlaceholderImage_Name           @"icon_default"
#define Index3Button_LEFT_NOTICIFICATION    @"Index3Button_LEFT_NOTICIFICATION"
#define Index3Button_RIGHT_NOTICIFICATION   @"Index3Button_RIGHT_NOTICIFICATION"

#define TIAOZHUAN_NOTICFICATION   @"tiaozhuan_noticfication"

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]



#define ApplicationDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define ReachabilityChangedNotification @"ReachabilityChangedNotification"

//字符串是否为空
#define zlStringIsEmpty(str)  ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define zlArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define zlDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define zlObjectIsEmpty(_object) (_object == nil || [_object isKindOfClass:[NSNull class]] || ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) || ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//获取屏幕宽度与高度
#define kScreenWidth ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreenmainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreenmainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.height)
#define kScreenSize ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? CGSizeMake([UIScreenmainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreenmainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale) : [UIScreen mainScreen].bounds.size)

//一些缩写
#define kApplication        [UIApplication sharedApplication]
#define kKeyWindow          [UIApplication sharedApplication].keyWindow
#define kAppDelegate        [UIApplication sharedApplication].delegate
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

//APP版本号
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//系统版本号
#define kSystemVersion [[UIDevice currentDevice] systemVersion]
//获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
//判断是否为iPhone
#define kISiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//判断是否为iPad
#define kISiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//获取沙盒Document路径
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒temp路径
#define kTempPath NSTemporaryDirectory()
//获取沙盒Cache路径
#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//真机
#endif

#if TARGET_IPHONE_SIMULATOR
//模拟器
#endif

////开发的时候打印，但是发布的时候不打印的NSLog
//#ifdef DEBUG
//#define NSLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
//#else
//#define NSLog(...)
//#endif
//#ifdef DEBUG //开发阶段
//#define NSLog(format,...) printf("%s",[[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
//#else //发布阶段
//#define NSLog(...)
//打印不全 解决
//#ifdef DEBUG
//
//#define NSLog(FORMAT, ...) fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
//
//#else
//
//#define NSLog(FORMAT, ...) nil
//
//#endif
/*Release模式下  禁止NSLog*/
#ifdef __OPTIMIZE__
# define NSLog(...) {}
#else
# define NSLog(...) NSLog(__VA_ARGS__)
#endif



//颜色
#define kRGBColor(r, g, b)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]
#define kRandomColor  KRGBColor(arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0)

#define kColorWithHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

//弱引用/强引用
#define kWeakSelf(type)   __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;

//由角度转换弧度
#define kDegreesToRadian(x)      (M_PI * (x) / 180.0)
//由弧度转换角度
#define kRadianToDegrees(radian) (radian * 180.0) / (M_PI)

//获取一段时间间隔
#define kStartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kEndTime   NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)

#define PLACEHOLDER_IMAGE [UIImage imageNamed:@"icon_default"]

#define TEL(phoneNumber) ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]]])



//#define kScreenWidth [[UIScreen mainScreen]bounds].size.width //屏幕宽度
//#define kScreenHeight [[UIScreen mainScreen]bounds].size.height //屏幕高度
#define kStatusBarHeight ([[UIApplication sharedApplication]statusBarFrame].size.height)//状态栏高度
#define kNavgationBarHeight (64.0f) //NavgationBar的高度

#define kDeviceVersion [[UIDevice currentDevice].systemVersion floatValue]
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

#define kNavbarHeight ((kDeviceVersion>=7.0)? 64 :44 )
#define kIOS7DELTA   ((kDeviceVersion>=7.0)? 20 :0 )
#define kTabBarHeight 49

//系统版本  大于等于8.0
#define IOS8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >=8.0 ? YES : NO)

//内联函数
UIKIT_STATIC_INLINE id weak_self(id sender){
    __weak typeof(sender) weakSelf = sender;
    return weakSelf;
}

// 注册通知
#define NOTIFY_ADD(_noParamsFunc, _notifyName)  [[NSNotificationCenter defaultCenter] \
addObserver:self \
selector:@selector(_noParamsFunc) \
name:_notifyName \
object:nil];

// 发送通知
#define NOTIFY_POST(_notifyName)   [[NSNotificationCenter defaultCenter] postNotificationName:_notifyName object:nil];

// 移除通知
#define NOTIFY_REMOVE(_notifyName) [[NSNotificationCenter defaultCenter] removeObserver:self name:_notifyName object:nil];


#endif
