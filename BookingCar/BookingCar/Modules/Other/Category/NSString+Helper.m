//
//  NSString+Helper.m
//  ARErp
//
//  Created by ZRAR on 14/11/6.
//  Copyright (c) 2014年 ZRAR. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

#pragma mark 汉字转为汉语拼音
- (NSString *)pinyinString
{
    if ([self isEqualToString:@""]) {
        return self;
    }
    NSMutableString *source = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    
    if ([[(NSString *)self substringToIndex:1] compare:@"长"] ==NSOrderedSame){
        [source replaceCharactersInRange:NSMakeRange(0, 5)withString:@"chang"];
    }
    
    if ([[(NSString *)self substringToIndex:1] compare:@"沈"] ==NSOrderedSame){
        [source replaceCharactersInRange:NSMakeRange(0, 4)withString:@"shen"];
    }
    
    if ([[(NSString *)self substringToIndex:1] compare:@"厦"] ==NSOrderedSame){
        [source replaceCharactersInRange:NSMakeRange(0, 3)withString:@"xia"];
    }
    
    if ([[(NSString *)self substringToIndex:1] compare:@"地"] ==NSOrderedSame){
        [source replaceCharactersInRange:NSMakeRange(0, 3)withString:@"di"];
    }
    
    if ([[(NSString *)self substringToIndex:1] compare:@"重"] ==NSOrderedSame){
        [source replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chong"];
    }
    return [source stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark 清空字符串中的空白字符
- (NSString *)trimString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark 是否空字符串
- (BOOL)isEmptyString
{
    return (self.length == 0);
}

@end
