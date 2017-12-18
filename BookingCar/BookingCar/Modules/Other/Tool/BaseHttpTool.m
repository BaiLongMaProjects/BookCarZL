//
//  BaseHttpTool.m
//  TJProperty
//
//  Created by Remmo on 15/6/24.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "BaseHttpTool.h"
#import "AFNetworking.h"
#import "MBProgressHUD+RY.h"
@implementation BaseHttpTool

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript", nil];
    // 2.发送GET请求
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObj) {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         if (success) {
             success(responseObj);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         //[MBProgressHUD showError:@"网络不给力"];
         if (failure) {
             failure(error);
         }
     }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript", nil];
    // 2.发送POST请求
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (success) {
            success(responseObj);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //[MBProgressHUD showError:@"网络不给力"];
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)uploadImageWithPath:(NSString *)url name:(NSString *)name imagePathList:(NSArray *)imageList params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript", nil];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int index=0; index<imageList.count; index++) {
            UIImage * image=[imageList objectAtIndex:index];
            NSData * imageData=UIImageJPEGRepresentation(image, 0.5);
            NSString * fileName=[NSString stringWithFormat:@"img%d.jpg",index];
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpg/file"];
            
//            NSData * imageData = [imageList objectAtIndex:index];
////
//            //使用日期生成图片名称
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            
//            formatter.dateFormat = @"ss";
//            NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[formatter stringFromDate:[NSDate date]]];
//            
//            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpg/png/jpeg"];
            
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)uploadImageWithPath:(NSString *)url indexName:(NSString *)name imagePathList:(NSArray *)imageList params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript", nil];
    
    for (int index=0; index<imageList.count; index++) {

    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            UIImage * image=[imageList objectAtIndex:index];
            NSData * imageData=UIImageJPEGRepresentation(image, 0.5);
            //使用日期生成图片名称
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = [NSString stringWithFormat:@"yyyyMMddHHmmss%d",index];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[formatter stringFromDate:[NSDate date]]];
            [formData appendPartWithFileData:imageData name:@"img" fileName:fileName mimeType:@"image/jpg/file/png/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    }
}

@end
