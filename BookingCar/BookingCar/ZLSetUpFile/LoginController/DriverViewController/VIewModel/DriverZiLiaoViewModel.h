//
//  DriverZiLiaoViewModel.h
//  BookingCar
//
//  Created by apple on 2017/11/29.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriverZiLiaoViewModel : NSObject

/** 单例 */
+ (DriverZiLiaoViewModel *)shareInstance;

@property (nonatomic, copy) NSString *jiaShiZhengString;
@property (nonatomic, copy) NSString *baoXianDanString;
@property (nonatomic, copy) NSString *chePaiString;
@property (nonatomic, copy) NSString *cheModelString;
@property (nonatomic, copy) NSString *jiaShiZhengImageUrl;
@property (nonatomic, copy) NSString *baoXianDanImageUrl;
@property (nonatomic, copy) NSString *cheLiangZhengImageUrl;
@property (nonatomic, copy) NSString *cheLiangBeiImageUrl;
/** 上传到七牛云 */
- (void)startUploadImageWithType:(NSInteger )type withImage:(UIImage *)image withSuccessBlock:(void (^)(BOOL success,NSString * imageUrl)) successBlock withFailBlock:(void (^)(BOOL failure)) failureBlock;
/** 提交资料到服务器 */
- (void)startNetworkZiLiaoWithSuccessBlock:(void (^)(BOOL success)) successBlock withFailBlock:(void (^)(BOOL failure)) failureBlock;

@end
