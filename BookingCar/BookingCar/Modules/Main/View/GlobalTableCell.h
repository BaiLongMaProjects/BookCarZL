//
//  GlobalTableCell.h
//  HZ12345
//
//  Created by ZRAR on 15/1/6.
//  Copyright (c) 2015年 ZRAR. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTitleFont [UIFont systemFontOfSize:15]

@interface GlobalTableCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

+ (instancetype)settingCellWithTableView:(UITableView *)tableView andCellStyle: (UITableViewCellStyle)style;


@end
