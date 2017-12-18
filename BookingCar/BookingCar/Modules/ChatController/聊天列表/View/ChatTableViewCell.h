//
//  ChatTableViewCell.h
//  BookingCar
//
//  Created by mac on 2017/7/20.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"
@interface ChatTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImgMyHead;//头像

@property (weak, nonatomic) IBOutlet UILabel *LabName;//姓名

@property (weak, nonatomic) IBOutlet UILabel *LabLastMessage;//聊天内容

@property (weak, nonatomic) IBOutlet UILabel *LabCreatTime;//时间

@property (weak, nonatomic) IBOutlet UIView *VeChatList;//外框

-(void)getInfo:(ChatModel*)Model;

@end
