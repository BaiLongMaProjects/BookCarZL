//
//  UIButton+bg.m
//  weibo
//
//  Created by apple on 13-8-29.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "UIButton+Bg.h"
#import "NSString+File.h"
#import "UIImage+Image.h"

@implementation UIButton (Bg)
- (CGSize)setAllStateBg:(NSString *)icon
{
    UIImage *disable = [UIImage imageNamed:[icon filenameAppend:@"_disable"]];
    UIImage *normal = [UIImage imageNamed:icon];
    UIImage *highlighted = [UIImage imageNamed:[icon filenameAppend:@"_highlighted"]];
    
    [self setBackgroundImage:disable forState:UIControlStateDisabled];
    [self setBackgroundImage:normal forState:UIControlStateNormal];
    [self setBackgroundImage:highlighted forState:UIControlStateHighlighted];
    return normal.size;
}

- (CGSize)setAllStateBgWithStretchImage:(NSString *)icon
{
    UIImage *disable = [UIImage stretchImageWithName:[icon filenameAppend:@"_disable"]];
    UIImage *normal = [UIImage stretchImageWithName:icon];
    UIImage *highlighted = [UIImage stretchImageWithName:[icon filenameAppend:@"_highlighted"]];
    
    [self setBackgroundImage:disable forState:UIControlStateDisabled];
    [self setBackgroundImage:normal forState:UIControlStateNormal];
    [self setBackgroundImage:highlighted forState:UIControlStateHighlighted];
    return normal.size;
}

- (CGSize)setAllStateImage:(NSString *)icon
{
    UIImage *disable = [UIImage imageNamed:[icon filenameAppend:@"_disable"]];
    UIImage *normal = [UIImage imageNamed:icon];
    UIImage *highlighted = [UIImage imageNamed:[icon filenameAppend:@"_highlighted"]];
    UIImage *selected = [UIImage imageNamed:[icon filenameAppend:@"_selected"]];
    
    [self setImage:disable forState:UIControlStateDisabled];
    [self setImage:normal forState:UIControlStateNormal];
    [self setImage:highlighted forState:UIControlStateHighlighted];
    [self setImage:selected forState:UIControlStateSelected];
    return normal.size;
}

@end
