//
//  MainTableController.h
//  YYweibo
//
//  Created by ZRAR on 14/10/9.
//  Copyright (c) 2014年 ZRAR. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GroupModel.h"
#import "ItemModel.h"
#import "ArrowItem.h"
#import "SwitchItem.h"
#import "TextItem.h"
#import "ImageItem.h"

@interface MainTableController : UITableViewController
{
    NSMutableArray *_allGroups; // 所有的组模型
}

@property (nonatomic, assign)UITableViewCellStyle cellStyle;

@end
