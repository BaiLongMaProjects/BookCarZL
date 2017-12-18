//
//  UIImage+image.h
//  weibo
//
//  Created by apple on 13-8-28.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)

// 返回一张已经经过拉伸处理的图片
+ (UIImage *)stretchImageWithName:(NSString *)name;

@end
