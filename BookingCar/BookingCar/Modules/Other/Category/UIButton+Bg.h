//
//  UIButton+bg.h
//  weibo
//
//  Created by apple on 13-8-29.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Bg)
// 设置按钮所有状态下的背景（原始图片）
- (CGSize)setAllStateBg:(NSString *)icon;

//设置按钮所有状态下的背景（拉伸图片）
- (CGSize)setAllStateBgWithStretchImage:(NSString *)icon;

// 设置按钮所有状态下的图片（原始图片）
- (CGSize)setAllStateImage:(NSString *)icon;

@end
