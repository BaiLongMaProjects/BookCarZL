//
//  ItemModal.h
//  GlobalSetting
//
//  Created by ZRAR on 14-8-19.
//  Copyright (c) 2014年 zrar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ItemModel : NSObject

@property (nonatomic, copy) UIImage *iconImage;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) void (^operation)() ; // 点击cell后要执行的操作

+ (id)itemWithIcon:(NSString *)icon title:(NSString *)title;
+ (id)itemWithTitle:(NSString *)title;

@end
