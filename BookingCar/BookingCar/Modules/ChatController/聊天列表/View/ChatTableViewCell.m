//
//  ChatTableViewCell.m
//  BookingCar
//
//  Created by mac on 2017/7/20.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.ImgMyHead.layer.cornerRadius = self.ImgMyHead.frame.size.height/2;
    self.ImgMyHead.layer.masksToBounds = YES;
    
    self.VeChatList.layer.cornerRadius = 4;
    self.VeChatList.layer.masksToBounds = YES;
    // Initialization code
}
-(void)getInfo:(ChatModel *)Model
{
    self.LabName.text = Model.nick_name;
    self.LabLastMessage.text = Model.content;
    [self.ImgMyHead sd_setImageWithURL:[NSURL URLWithString:Model.portrait_image]];
    if ([Model.content isEqualToString:@""]) {
        self.LabLastMessage.text = @"您还没有跟他（她）聊天呦！";
    }
    self.LabCreatTime.text = Model.create_time;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
