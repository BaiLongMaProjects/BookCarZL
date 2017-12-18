//
//  CustomCell.m
//  YYweibo
//
//  Created by ZRAR on 14/10/9.
//  Copyright (c) 2014年 ZRAR. All rights reserved.
//

#import "CustomCell.h"
#import "ItemModel.h"
#import "ArrowItem.h"
#import "SwitchItem.h"
#import "TextItem.h"
#import "ImageItem.h"
#import "UIView+Extension.h"
#define kTableBorderWidth 20

@interface CustomCell ()
{
    UIImageView *_arrow;
    UISwitch *_switch;
    UITextField *_textField;
    UIImageView *_imageIconView;
}

@end

@implementation CustomCell

+ (instancetype)settingCellWithTableView:(UITableView *)tableView andCellStyle:(UITableViewCellStyle)style
{
    static NSString *ID = @"CustomCell";
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
         cell  = [[CustomCell alloc] initWithStyle:style reuseIdentifier:ID];
    }
    return cell;
}


- (void)setCellItem:(ItemModel *)cellItem
{
    _cellItem = cellItem;
    
    // 设置数据
    if (cellItem.iconImage) {
        self.imageView.image = cellItem.iconImage;
    }else{
        self.imageView.image = [UIImage imageNamed:cellItem.icon];
    }
    self.textLabel.text = cellItem.title;
    self.detailTextLabel.text = cellItem.subtitle;
    
    if ([cellItem isKindOfClass:[ArrowItem class]]) {
        [self settingArrow];
    } else if ([cellItem isKindOfClass:[SwitchItem class]]) {
        [self settingSwitch];
    } else if ([cellItem isKindOfClass:[TextItem class]]) {
        [self settingTextField];
    }else if ([cellItem isKindOfClass:[ImageItem class]]) {
        [self settingIconView];
    } else {
        // 什么也没有，清空右边显示的view
        self.accessoryView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

#pragma mark 设置TextField
- (void)settingTextField
{
    TextItem *item = (TextItem*)_cellItem;
    _textField = item.textFeild;
    [self.contentView addSubview:_textField];
    
    // 禁止选中
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


#pragma mark 设置右边的开关
- (void)settingSwitch
{
    if (_switch == nil) {
        _switch = [[UISwitch alloc] init];
        [_switch addTarget:self action:@selector(switchChange) forControlEvents:UIControlEventValueChanged];
    }
    
    // 设置开关的状态
    SwitchItem *switchItem = (SwitchItem *)_cellItem;
    _switch.on = switchItem.off;
    
    // 右边显示开关
    self.accessoryView = _switch;
    // 禁止选中
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark 设置图片
- (void)settingIconView
{
    ImageItem *imageItem = (ImageItem *)_cellItem;
    _imageIconView = [[UIImageView alloc]initWithImage:imageItem.imageIcon];
    [self.contentView addSubview:_imageIconView];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

#pragma mark 开关状态改变
- (void)switchChange
{
    SwitchItem *switchItem = (SwitchItem *)_cellItem;
    switchItem.off = _switch.on;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kSwichChangeNotificationKey object:nil];
}

#pragma mark 设置右边的箭头
- (void)settingArrow
{
    // 右边显示箭头
//    self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow.png"]];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // 用默认的选中样式
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _textField.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame) + kTableBorderWidth, 0, kUIScreenWidth - CGRectGetMaxX(self.textLabel.frame) - 2 * kTableBorderWidth, self.contentView.height);
    _imageIconView.frame = CGRectMake(self.width - self.height * 0.9, self.height * 0.1, self.height * 0.8, self.height * 0.8);
    _imageIconView.layer.cornerRadius = self.height * 0.4;
    _imageIconView.layer.masksToBounds = YES;
}


@end
