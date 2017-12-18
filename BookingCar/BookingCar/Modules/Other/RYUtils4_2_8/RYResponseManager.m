//
//  RYResponseManager.m
//  PandaStock
//
//  Created by YuanRyan on 1/26/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "RYResponseManager.h"

@implementation RYResponseManager

#pragma mark - Singleton methods

+ (instancetype)sharedManger
{
    static RYResponseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RYResponseManager alloc] init];
    });
    return manager;
}

#pragma mark - Public methods
+ (BOOL)isValidResponseWithDict:(NSDictionary *)responseDict
{
    if(nil == responseDict)
        return NO;
    id codeObj = [responseDict objectForKey:kRYResponseMessageKey];
    if(nil == codeObj)
        return NO;
//    NSString *responseStr = [codeObj lowercaseString];
    if([codeObj isEqualToString:kRYResponseSucceedValue])
        return YES;
    return NO;
}

+ (NSString *)responseMessageWithDict:(NSDictionary *)responseDict
{
    return [responseDict objectForKey:kRYResponseMessageKey];
}

+ (id)responseBodyWithDict:(NSDictionary *)responseDict
{
    return [responseDict objectForKey:kRYResponseBodyKey];
}

@end
