//
//  ItemModal.m
//  GlobalSetting
//
//  Created by ZRAR on 14-8-19.
//  Copyright (c) 2014年 zrar. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel

+ (id)itemWithIcon:(NSString *)icon title:(NSString *)title
{
    ItemModel *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    return item;
}

+ (id)itemWithTitle:(NSString *)title
{
     //用占位“tableViewCellholder.png”图片代替nil，直接用nil会有错误提示
    return [self itemWithIcon:@"tableViewCellholder.png" title:title];
}

@end
