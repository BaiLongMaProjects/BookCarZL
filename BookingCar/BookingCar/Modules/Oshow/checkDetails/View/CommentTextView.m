//
//  CommentTextView.m
//  BookingCar
//
//  Created by mac on 2017/8/1.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "CommentTextView.h"

@implementation CommentTextView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.OShowTextView = [[UITextView alloc] initWithFrame:CGRectInset(self.KeyBordView.bounds, 5.0, 5.0)];
    self.OShowTextView.layer.borderColor   = [RGB(212.0, 212.0, 212.0) CGColor];
    self.OShowTextView.layer.borderWidth   = 1.0;
    self.OShowTextView.layer.cornerRadius  = 2.0;
    self.OShowTextView.layer.masksToBounds = YES;
    
    self.OShowTextView.inputAccessoryView  = self.KeyBordView;
    
    self.OShowTextView.backgroundColor     = [UIColor clearColor];
    self.OShowTextView.returnKeyType       = UIReturnKeySend;
    self.OShowTextView.delegate            = self;
    self.OShowTextView.font                = [UIFont systemFontOfSize:15.0];
////    [self addSubview:self.KeyBordView];//添加到window上或者其他视图也行，只要在视图以外就好了
 [self.OShowTextView becomeFirstResponder];//让textView成为第一响应者（第一次）这次键盘并未显示出来，（个人觉得这里主要是将commentsView设置为commentText的inputAccessoryView,然后再给一次焦点就能成功显示）
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
