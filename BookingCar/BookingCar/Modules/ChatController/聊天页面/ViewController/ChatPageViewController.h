//
//  ChatPageViewController.h
//  BookingCar
//
//  Created by mac on 2017/9/18.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <EaseUI/EaseUI.h>
#import <UIKit/UIKit.h>
#import "ChatModel.h"
#define KNOTIFICATIONNAME_DELETEALLMESSAGE @"RemoveAllMessages"
#import <EaseMessageViewController.h>

@interface ChatPageViewController : EaseMessageViewController

@property (nonatomic,copy)NSString * OtherName;//对方名字
@property (nonatomic,copy)NSString * OtherHeadPhoto;//对方头像
@property (nonatomic,copy)NSString * OtherID;//对方的ID
@property (nonatomic,copy)NSString * MeName;//我的名字
@property (nonatomic,copy)NSString * MeHeadPhoto;//我的头像
@property (nonatomic,copy)NSString * MeID;//我的ID

@end
