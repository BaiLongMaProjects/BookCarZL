//
//  ZLSecondAFNetworking.h
//  SecondProject
//
//  Created by wkj on 2017/3/7.
//  Copyright © 2017年 wkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
@class UploadParam;
/**
 *  网络请求类型
 */
typedef NS_ENUM(NSUInteger,HttpRequestTypeZL) {
    /**
     *  get请求
     */
    HttpRequestTypeGetzl = 0,
    /**
     *  post请求
     */
    HttpRequestTypePostzl
};
@interface ZLSecondAFNetworking : NSObject
+ (instancetype)sharedInstance;

/**
 *  发送get请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;

/**
 *  发送post请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

/**
 *  发送网络请求
 *
 *  @param URLString   请求的网址字符串
 *  @param parameters  请求的参数
 *  @param type        请求的类型
 *  @param resultBlock 请求的结果
 */
- (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                        type:(HttpRequestTypeZL)type
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

/**
 *  上传图片
 *
 *  @param URLString   上传图片的网址字符串
 *  @param parameters  上传图片的参数
 *  @param uploadParam 上传图片的信息
 *  @param success     上传成功的回调
 *  @param failure     上传失败的回调
 */
- (void)uploadWithURLString:(NSString *)URLString
                 parameters:(id)parameters
                uploadParam:(NSArray <UploadParam *> *)uploadParams
                    success:(void (^)())success
                    failure:(void (^)(NSError *error))failure;

/**
 *  下载数据
 *
 *  @param URLString   下载数据的网址
 *  @param parameters  下载数据的参数
 *  @param success     下载成功的回调
 *  @param failure     下载失败的回调
 */
- (void)downLoadWithURLString:(NSString *)URLString
                   parameters:(id)parameters
                     progerss:(void (^)())progress
                      success:(void (^)())success
                      failure:(void (^)(NSError *error))failure;

/**
 *==========ZL注释start===========
 *1.获取当前时间
 *
 *2.设置时区
 *3.设置时间格式
 *4.返回字符串
 ===========ZL注释end==========*/
+ (NSString *)getNowTime;

/**
 *==========ZL注释start===========
 *1.md5加密
 *
 *2.<#注释描述#>
 *3.<#注释描述#>
 *4.<#注释描述#>
 ===========ZL注释end==========*/
+ (NSString *)getMD5fromString:(NSString *)string;

@end
