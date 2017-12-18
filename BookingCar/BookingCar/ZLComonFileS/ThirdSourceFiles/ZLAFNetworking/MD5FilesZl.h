//
//  MD5FilesZl.h
//  UEHTML
//
//  Created by apple on 2017/10/17.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD5FilesZl : NSObject
// MD5加密
/*
 *由于MD5加密是不可逆的,多用来进行验证
 */
// 32位小写
+(NSString *)MD5ForLower32Bate:(NSString *)str;
// 32位大写
+(NSString *)MD5ForUpper32Bate:(NSString *)str;

@end
