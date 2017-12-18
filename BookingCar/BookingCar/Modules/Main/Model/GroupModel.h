//
//  GroupModal.h
//  GlobalSetting
//
//  Created by ZRAR on 14-8-19.
//  Copyright (c) 2014年 zrar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupModel : NSObject

@property (nonatomic, copy) NSString *header; // 头部标题
@property (nonatomic, copy) NSString *footer; // 尾部标题
@property (nonatomic, strong) NSArray *items; // 中间的条目


@end
