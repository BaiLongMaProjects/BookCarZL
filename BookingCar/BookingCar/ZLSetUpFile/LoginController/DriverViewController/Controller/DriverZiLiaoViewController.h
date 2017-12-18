//
//  DriverZiLiaoViewController.h
//  BookingCar
//
//  Created by apple on 2017/11/28.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import "BaseZLRootViewController.h"
#import "ZhengJianImageView.h"
#import "DriverZiLiaoViewModel.h"
@interface DriverZiLiaoViewController : BaseZLRootViewController<UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containView;
/** 驾驶证 */
@property(nonatomic, strong) JVFloatLabeledTextField *jiaShiZhengField;
/** 保险单号 */
@property(nonatomic, strong) JVFloatLabeledTextField *baoXianHaoField;
/** 车牌号 */
@property(nonatomic, strong) JVFloatLabeledTextField *chePaiHaoField;
/** 车辆品牌 */
@property (nonatomic, strong) JVFloatLabeledTextField *chePinPaiField;
/** 驾驶证正面照 */
@property (nonatomic, strong) ZhengJianImageView *jiaShiZhengImage;
/** 保险单照片 */
@property (nonatomic, strong) ZhengJianImageView *baoXianDanImage;
/** 车辆正面照 */
@property (nonatomic, strong) ZhengJianImageView *cheLiangZhengImage;
/** 车辆背面照 */
@property (nonatomic, strong) ZhengJianImageView *cheLiangBeiImage;
/** 提交审核 */
@property (nonatomic, strong) UIButton *okButton;
/** 最后Label */
@property (nonatomic, strong) UILabel *lastLabel;
/** 当前Model */
@property (nonatomic, strong) DriverZiLiaoViewModel *currentViewModel;

@end
