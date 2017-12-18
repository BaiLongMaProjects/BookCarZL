//
//  UIBarButtonItem+Icon.h
//  WangyiNews
//
//  Created by Miffy@Remmo on 14-8-11.
//  Copyright (c) 2014年 zrar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Icon)

- (id)initWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action;
+ (id)itemWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action;

- (id)initWithIcon:(NSString *)icon target:(id)target action:(SEL)action;
+ (id)itemWithIcon:(NSString *)icon target:(id)target action:(SEL)action;

@end
