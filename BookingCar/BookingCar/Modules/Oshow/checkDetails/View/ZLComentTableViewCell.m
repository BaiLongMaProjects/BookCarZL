//
//  ZLComentTableViewCell.m
//  BookingCar
//
//  Created by apple on 2017/10/28.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import "ZLComentTableViewCell.h"

@implementation ZLComentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.comentLabel.delegate = self;
    self.comentLabel.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:86/255.0 green:105/255.0 blue:147/255.0 alpha:1.0]};
    self.comentLabel.activeLinkTextAttributes = @{NSForegroundColorAttributeName : [UIColor blueColor]};
    // Initialization code
}

- (void)bindDataModel:(CommentsModel *)model withIndexPath:(NSIndexPath *)indexPath{
    /*
     self.nameLabel.text = model.userName;
     NSString *string =[NSString stringWithFormat:@"%@",model.content];
     if(model.replyUserName.length != 0)
     {
     self.nameLabel.text = model.userName;
     string =[NSString stringWithFormat:@"回复%@：%@",model.replyUserName ,model.content];
     }
     NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
     [text setAttributes:@{NSLinkAttributeName : model.userName} range:[string rangeOfString:model.userName]];
     if(model.replyUserName.length != 0)
     {
     [text setAttributes:@{NSLinkAttributeName : model.replyUserName} range:[string rangeOfString:model.replyUserName]];
     }
     self.contentLabel.attributedText = text;
     
     */
    NSLog(@"评论的nickname：%@---回复给：-----%@----评论内容：%@",model.nick_name,model.replyUserName,model.comment);
    NSString * comString = nil;
    if (model.replyUserName) {
        comString = [NSString stringWithFormat:@"%@: 回复 %@  %@",model.nick_name,model.replyUserName,model.comment];
    }
    else{
        comString = [NSString stringWithFormat:@"%@: %@",model.nick_name,model.comment];
    }
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:comString];
    [text setAttributes:@{NSLinkAttributeName : model.nick_name?:@"小马哥"} range:[comString rangeOfString:model.nick_name?:@"小马哥"]];
    self.comentLabel.attributedText = text;
    [self.superview layoutIfNeeded];
}

//MKLinkLabel代理方法
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel{
    NSLog(@"点击了MKLinkLabel代理方法");
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
