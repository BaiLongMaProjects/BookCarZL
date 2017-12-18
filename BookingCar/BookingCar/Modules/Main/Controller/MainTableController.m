//
//  MainTableController.m
//  YYweibo
//
//  Created by ZRAR on 14/10/9.
//  Copyright (c) 2014年 ZRAR. All rights reserved.
//

#import "MainTableController.h"
#import "CustomCell.h"

@interface MainTableController ()

@end

@implementation MainTableController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)loadView
{
    [super loadView];
    _allGroups = [NSMutableArray array];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = kGlobalBg;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 20;
    
    self.tableView.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _allGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GroupModel *group = _allGroups[section];
    return group.items.count;
}

#pragma mark 每当有一个cell进入视野范围内就会调用，返回当前这行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建一个CustomCell
    if (!self.cellStyle) {
        self.cellStyle = UITableViewCellStyleValue1;
    }
    CustomCell *cell = [CustomCell settingCellWithTableView:tableView andCellStyle:self.cellStyle];
    
    // 2.取出这行对应的模型
    GroupModel *group = _allGroups[indexPath.section];
    cell.cellItem = group.items[indexPath.row];
    cell.indexPath = indexPath;
    
    return cell;
}

#pragma mark 点击了cell后的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 0.取出这行对应的模型
    GroupModel *group = _allGroups[indexPath.section];
    ItemModel *item = group.items[indexPath.row];
    
    // 1.取出这行对应模型中的block代码
    if (item.operation) {
        // 执行block
        item.operation();
        return;
    }
    
    // 2.检测有没有要跳转的控制器
    if ([item isKindOfClass:[ArrowItem class]]) {
        ArrowItem *arrowItem = (ArrowItem *)item;
        if (arrowItem.showVCClass) {
            UIViewController *vc = [[arrowItem.showVCClass alloc] init];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark 返回每一组的header标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    GroupModel *group = _allGroups[section];
    
    return group.header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    GroupModel *group = _allGroups[section];
    
    return group.footer;
}

@end
