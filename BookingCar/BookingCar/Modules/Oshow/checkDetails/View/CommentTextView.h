//
//  CommentTextView.h
//  BookingCar
//
//  Created by mac on 2017/8/1.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTextView : UIView<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *OShowTextView;
@property (weak, nonatomic) IBOutlet UIView *KeyBordView;

@end
