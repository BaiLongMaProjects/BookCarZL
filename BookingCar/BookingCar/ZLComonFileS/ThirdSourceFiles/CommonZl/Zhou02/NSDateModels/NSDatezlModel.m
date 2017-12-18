//
//  NSDatezlModel.m
//  Matro
//
//  Created by lang on 16/6/21.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "NSDatezlModel.h"

@implementation NSDatezlModel
static NSDatezlModel * shareDateObj =nil;



+(NSDatezlModel *)shareDate{
    if (!shareDateObj) {
        shareDateObj=[[super allocWithZone:NULL]init];
    }
    return shareDateObj;
}


//
+(id)copyWithZone:(struct _NSZone *)zone{
    return [self shareDate];
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}



+ (instancetype)sharedInstance
{
    static NSDatezlModel *sharedFoodObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFoodObj =[[super allocWithZone:NULL]init];
    });
    
    return sharedFoodObj;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}
//以上是单例方法


//返回时间戳
- (NSTimeInterval )currentTimeDate{
    NSDate * nowDate = [NSDate date];
    NSTimeInterval timeIntervals = [nowDate timeIntervalSinceDate:self.firstDate];
    NSTimeInterval zong = timeIntervals+self.timeInterval;
    return zong;
   // NSLog(@"总的时间戳：%lf",zong);
}

#pragma mark - 获取当前的时间
+ (NSString *)currentDateString {
    return [self currentDateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

#pragma mark - 按指定格式获取当前的时间
+ (NSString *)currentDateStringWithFormat:(NSString *)formatterStr {
    // 获取系统当前时间
    NSDate *currentDate = [NSDate date];
    // 用于格式化NSDate对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置格式：yyyy-MM-dd HH:mm:ss
    formatter.dateFormat = formatterStr;
    // 将 NSDate 按 formatter格式 转成 NSString
    NSString *currentDateStr = [formatter stringFromDate:currentDate];
    // 输出currentDateStr
    return currentDateStr;
}
@end
