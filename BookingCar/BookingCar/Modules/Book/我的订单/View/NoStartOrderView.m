//
//  NoStartOrderView.m
//  BookingCar
//
//  Created by mac on 2017/8/19.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "NoStartOrderView.h"
#import "NoStartOrderTableViewCell.h"
@implementation NoStartOrderView
{
    NSArray * NoStartArray;
}
-(id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
    }

    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
//    self.NoStartTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-44-64) style:UITableViewStylePlain];
//    self.NoStartTabView.delegate = self;
//    self.NoStartTabView.dataSource = self;
//    [self addSubview:self.NoStartTabView];
//    NoStartArray = [NSArray arrayWithObjects:@"等待车主接单",@"车主已接单请求同意",@"准备出发",@"车主希望取消订单" ,nil];
//    
//    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"JsonOrderList" ofType:@"geojson"];
//    NSString *parseJason = [[NSString alloc] initWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"%@",parseJason);
    
}
//#pragma mark- delegate
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return self.noStartTabCell.frame.size.height;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 4;
//}
//
//-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString * identCell = @"NoStartCell";
//    self.noStartTabCell = [tableView dequeueReusableCellWithIdentifier:identCell];
//    if (!self.noStartTabCell) {
//        self.noStartTabCell = [[[NSBundle mainBundle]loadNibNamed:@"NoStartOrderTableViewCell" owner:self options:nil]lastObject];
//        self.noStartTabCell.selectionStyle=UITableViewCellSelectionStyleNone;
//    }
//    self.noStartTabCell.LabStatus.text = NoStartArray[indexPath.row];
//    [self.noStartTabCell getInforIndexRow:indexPath];
//    
//    return self.noStartTabCell;
//}
//
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self.delegate TabViewAndTab:tableView didSelectIndex:indexPath NSMutableArray:self.DataArray];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
