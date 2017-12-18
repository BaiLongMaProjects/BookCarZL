//
//  GlobalTableCell.m
//  HZ12345
//
//  Created by ZRAR on 15/1/6.
//  Copyright (c) 2015年 ZRAR. All rights reserved.
//

#import "GlobalTableCell.h"


@interface GlobalTableCell ()
{
    UIView *_divider;
}

@end

@implementation GlobalTableCell

+ (instancetype)settingCellWithTableView:(UITableView *)tableView andCellStyle: (UITableViewCellStyle)style
{
    // 0.用static修饰的局部变量，只会初始化一次
    static NSString *ID = @"GlobalTableCell";
    
    // 1.拿到一个标识先去缓存池中查找对应的Cell
    GlobalTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 2.如果缓存池中没有，才需要传入一个标识创建新的Cell
    if (cell == nil) {
        cell = [[GlobalTableCell alloc] initWithStyle:style reuseIdentifier:ID];
    }
    return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 1.设置背景
        [self setupBg];
        
        // 2. 设置子控件属性
        [self setupSubviews];
        
        // 3. 添加分割线
        [self setupDivider];
    }
    return self;
}

#pragma mark 添加分隔线
- (void)setupDivider
{
    UIView *divider = [[UIView alloc] init];
    
    divider.backgroundColor = RGB(200, 200, 200);
    [self.contentView addSubview:divider];
    _divider = divider;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    _divider.hidden = indexPath.row == 0;
}

- (void)setupBg
{
    UIView *bg = [[UIImageView alloc] init];
    bg.backgroundColor = [UIColor whiteColor];
    self.backgroundView = bg;
    
    UIView *selectedBg = [[UIImageView alloc] init];
    selectedBg.backgroundColor = RGBA(237, 233, 218, 0.2);
    self.selectedBackgroundView = selectedBg;
}


- (void)setupSubviews
{
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.numberOfLines = 0;
    self.textLabel.font = kTitleFont;
    
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.font = [UIFont systemFontOfSize:14];
    self.detailTextLabel.textColor = [UIColor darkGrayColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 0.设置分隔线的位置
    _divider.frame = CGRectMake(self.textLabel.frame.origin.x, 0, self.contentView.frame.size.width + 100, 0.5);
}

@end
