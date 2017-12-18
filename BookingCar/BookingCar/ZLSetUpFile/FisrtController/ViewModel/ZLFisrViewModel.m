//
//  ZLFisrViewModel.m
//  BookingCar
//
//  Created by apple on 2017/11/20.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import "ZLFisrViewModel.h"

@implementation ZLFisrViewModel

+ (ZLFisrViewModel *)shareInstance{
    static ZLFisrViewModel * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (void)isHaveNewVersionsWithBlock:(void (^)(BOOL, NSString *))success{
    /** 获取新版本请求 */
    [HttpTool getWithPath:kNewBanBenInfo params:nil success:^(id responseObj) {
        if ([responseObj[@"status"] intValue] == 1) {
            if (![kAppVersion isEqualToString:responseObj[@"version"]]) {
                success(YES,responseObj[@"describe"]);
            }
        }
        NSLog(@"获取新版本请求：%@",responseObj);
    } failure:^(NSError *error) {
        
    }];
    
}

@end
