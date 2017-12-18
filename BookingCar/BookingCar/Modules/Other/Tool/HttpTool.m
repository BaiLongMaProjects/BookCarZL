//
//  HttpTool.m
//  TJProperty
//
//  Created by Remmo on 15/6/24.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "HttpTool.h"
#import "BaseHttpTool.h"
#import "NSString+Hash.h"
@implementation HttpTool

/**
 * 用户敏感get请求
 */
+ (void)getWithUserIDPath:(NSString *)path params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    // 拼接sign参数
    NSDictionary *allParams = [self jointParamsWithDict:params withUserid:YES];
    
    NSString *netPath = [NSString stringWithFormat:@"%@%@",kBaseurl,path];
    [BaseHttpTool get:netPath params:allParams success:success failure:failure];
}

/**
 * 用户敏感POST请求
 */
+ (void)postWithUserIDPath:(NSString *)path params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    // 拼接sign参数
    NSDictionary *allParams = [self jointParamsWithDict:params withUserid:YES];
    
    //拼接请求地址
    NSString *netPath = [NSString stringWithFormat:@"%@%@",kBaseurl,path];
    [BaseHttpTool post:netPath params:allParams success:success failure:failure];
}

/**
 * 非用户敏感get请求
 */
+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    // 拼接sign参数
    NSDictionary *allParams = [self jointParamsWithDict:params withUserid:NO];
    
    // 拼接url
    NSString *netPath = [NSString stringWithFormat:@"%@%@",kBaseurl,path];
    [BaseHttpTool get:netPath params:allParams success:success failure:failure];
}

/**
 * 非用户敏感POST请求
 */
+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *allParams = [self jointParamsWithDict:params withUserid:NO];
    NSString *netPath = [NSString stringWithFormat:@"%@%@",kBaseurl,path];
    [BaseHttpTool post:netPath params:allParams success:success failure:failure];
}

/**
 *  用户敏感POST请求，加图片上传
 */
+ (void)postWithUserIDWithPath:(NSString *)path name:(NSString *)name imagePathList:(NSArray *)imageList params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *allParams = [self jointParamsWithDict:params withUserid:YES];
    NSString *netPath = [NSString stringWithFormat:@"%@%@",kBaseurl,path];
    [BaseHttpTool uploadImageWithPath:netPath name:(NSString *)name imagePathList:imageList params:allParams success:success failure:failure];
}

/**
 * 非用户敏感post请求，加图片上传
 */
+ (void)postWithPath:(NSString *)path name:(NSString *)name imagePathList:(NSArray *)imageList params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *allParams = [self jointParamsWithDict:params withUserid:NO];
    NSString *netPath = [NSString stringWithFormat:@"%@%@",kBaseurl,path];
    if (imageList == nil || imageList.count == 0) {
        [BaseHttpTool post:netPath params:params success:success failure:failure];
    }else{
        [BaseHttpTool uploadImageWithPath:netPath name:(NSString *)name imagePathList:imageList params:allParams success:success failure:failure];
    }
}

/**
 * post请求，多张图片上传
 */
+ (void)postWithPath:(NSString *)path indexName:(NSString *)name imagePathList:(NSArray *)imageList params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *allParams = [self jointParamsWithDict:params withUserid:NO];
    NSString *netPath = [NSString stringWithFormat:@"%@%@",kBaseurl,path];
    if (imageList == nil || imageList.count == 0) {
        [BaseHttpTool post:netPath params:params success:success failure:failure];
    }else{
        [BaseHttpTool uploadImageWithPath:netPath indexName:(NSString *)name imagePathList:imageList params:allParams success:success failure:failure];
    }
}

+ (NSDictionary *)jointParamsWithDict:(NSDictionary *)params withUserid:(BOOL)withUseID
{
    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    // 拼接传进来的参数
    if (params) {
        [allParams setDictionary:params];
    }
    
    NSDate *actionTime =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYYMMddHHmm"];
    NSString *formatterTime = [dateFormatter stringFromDate:actionTime];
    
    NSString *userString = withUseID?@"icheck": @"life";
    NSString *signSting = [NSString stringWithFormat:@"%@%@",formatterTime,userString];
    NSString *md5SignString = [signSting md5String];
    
    // 拼接sign参数
    [allParams setObject:md5SignString forKey:@"sign"];
    [allParams setObject:formatterTime forKey:@"timeline"];
    
    return allParams;
}


@end
