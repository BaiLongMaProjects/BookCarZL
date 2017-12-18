//
//  NSString+file.m
//  weibo
//
//  Created by apple on 13-8-28.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "NSString+File.h"

@implementation NSString (File)
- (NSString *)filenameAppend:(NSString *)append
{
    // 1.获取没有拓展名的文件名
    NSString *filename = [self stringByDeletingPathExtension];
    
    // 2.拼接append
    filename = [filename stringByAppendingString:append];
    
    // 3.拼接拓展名
    NSString *extension = [self pathExtension];
    
    // 4.生成新的文件名
    return [filename stringByAppendingPathExtension:extension];
}
@end
