//
//  ZLFisrViewModel.h
//  BookingCar
//
//  Created by apple on 2017/11/20.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLFisrViewModel : NSObject

/** 单例创建 */
+ (instancetype)shareInstance;
/** 检测是否有新版本 */
- (void)isHaveNewVersionsWithBlock:(void (^)(BOOL isHave,NSString * message)) success;

@end
