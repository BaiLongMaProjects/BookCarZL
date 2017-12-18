//
//  UITextField+Placeholder.m
//  TJProperty
//
//  Created by Remmo on 15/6/24.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "UITextField+Placeholder.h"

@implementation UITextField (Placeholder)

- (void)setPlaceholder:(NSString *)placeholder tintColor:(UIColor *)tintColor
{
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:placeholder attributes:@{NSForegroundColorAttributeName: tintColor}];
    self.attributedPlaceholder = attributedString;
}

@end
