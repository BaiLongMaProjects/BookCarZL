//
//  PageHomeHeadView.m
//  BookingCar
//
//  Created by mac on 2017/8/4.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "PageHomeHeadView.h"

@implementation PageHomeHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.TextfieldMoney.layer setBorderWidth:1];
    [self.ButStart.layer setBorderWidth:1];
    [self.ButFinish.layer setBorderWidth:1];
    [self.ButGoTime.layer setBorderWidth:1];
    [self.ViewCarHidden.layer setMasksToBounds:YES];
    [self.ViewCarHidden.layer setCornerRadius:5];
    [self.ButStart.layer setCornerRadius:5];
    [self.ButStart.layer setMasksToBounds:YES];
    [self.ButFinish.layer setCornerRadius:5];
    [self.ButFinish.layer setMasksToBounds:YES];
    [self.ButGoTime.layer setCornerRadius:5];
    [self.ButGoTime.layer setMasksToBounds:YES];
    [self.TextfieldMoney.layer setMasksToBounds:YES];
    [self.TextfieldMoney.layer setCornerRadius:5];
    [self.ButStartCar.layer setMasksToBounds:YES];
    [self.ButStartCar.layer setCornerRadius:5];
    
    [self.ButStart setImageEdgeInsets:UIEdgeInsetsMake(0, SIZE_WIDTH-30-48, 0, 0)];
    [self.ButFinish setImageEdgeInsets:UIEdgeInsetsMake(0, SIZE_WIDTH-30-48, 0, 0)];
    [self.ButGoTime setImageEdgeInsets:UIEdgeInsetsMake(0, SIZE_WIDTH-30-48, 0, 0)];
    NSLog(@"self.ButGoTime.frame.size.width->%f",SIZE_WIDTH-30-48);
    
    self.TextfieldMoney.delegate = self;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
     self.TextfieldMoney.leftView = view;
    UIImageView * rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"price"]];
    [rightView setFrame:CGRectMake(0, 0, 30, 18)];
    self.TextfieldMoney.rightView = rightView;
    
    self.TextfieldMoney.leftViewMode = UITextFieldViewModeAlways;
    self.TextfieldMoney.rightViewMode = UITextFieldViewModeAlways;
    
    [self.ButPeoCar addTarget:self action:@selector(ButPeoCarClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.ButSwag addTarget:self action:@selector(ButSwagClick:) forControlEvents:UIControlEventTouchUpInside];
    
    for (int i = 0; i < 7; i ++) {
        
        UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setFrame:CGRectMake(0, i * 20, 60, 20)];
        [but setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [but setBackgroundColor:[UIColor whiteColor]];
        [but.layer setBorderWidth:1];//设置边界的宽度
        but.tag = i;
        self.VePeoCar.hidden = YES;
        [but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.VePeoCar addSubview:but];
    }
   
    for (int i = 0; i < 7; i ++) {
        
        UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setFrame:CGRectMake(0, i * 20, 60, 20)];
        [but setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [but setBackgroundColor:[UIColor whiteColor]];
        [but.layer setBorderWidth:1];//设置边界的宽度
        but.tag = i;
        self.VePeoSwag.hidden = YES;
        [but addTarget:self action:@selector(butClick1:) forControlEvents:UIControlEventTouchUpInside];
        [self.VePeoSwag addSubview:but];
    }
    

    
    
    [self setNumberButon];
}
/**
 *==========ZL注释start===========
 *1.NumberButton
 *
 *2.人数
 *3.行李数
 *4.
 ===========ZL注释end==========*/
- (void)setNumberButon{
    __weak typeof(self) weakSelf = self;
    PPNumberButton *numButtons = [PPNumberButton numberButtonWithFrame:CGRectMake(0, 0, 90, 35)];
    // 开启抖动动画
    numButtons.shakeAnimation = YES;
    // 设置最小值
    numButtons.minValue = 1;
    // 设置最大值
    numButtons.maxValue = 9;
    // 设置输入框中的字体大小
    numButtons.inputFieldFont = 21;
    numButtons.buttonTitleFont = 19;
    numButtons.increaseTitle = @"＋";
    numButtons.decreaseTitle = @"－";
    numButtons.numberBlock = ^(NSString *num){
        //            NSLog(@"当前题目评分为：%@",num);
        weakSelf.personNumButton.currentNumber = num;
    };
    
    [self.personNumButton addSubview:numButtons];
    
    PPNumberButton *numButtons2 = [PPNumberButton numberButtonWithFrame:CGRectMake(0, 0, 90, 35)];
    // 开启抖动动画
    numButtons2.shakeAnimation = YES;
    // 设置最小值
    numButtons2.minValue = 0;
    // 设置最大值
    numButtons2.maxValue = 9;
    // 设置输入框中的字体大小
    numButtons2.inputFieldFont = 21;
    numButtons2.buttonTitleFont = 19;
    numButtons2.increaseTitle = @"＋";
    numButtons2.decreaseTitle = @"－";
    numButtons2.numberBlock = ^(NSString *num){
        //            NSLog(@"当前题目评分为：%@",num);
        self.xingLiButton.currentNumber = num;
    };
    
    [self.xingLiButton addSubview:numButtons2];
    self.personNumButton.currentNumber = @"1";
    self.xingLiButton.currentNumber = @"0";
    
}


-(void)butClick:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
    [self.ButPeoCar setTitle:[NSString stringWithFormat:@"%ld",(long)sender.tag] forState:UIControlStateNormal];
    CATransition * transition = [CATransition animation];
    
    transition.type = @"rippleEffect";
    
    [transition setSubtype:kCATransitionReveal];
    
    [transition setDuration:1.5];
    
    [self.VePeoCar.layer addAnimation:transition forKey:@"rippleEffect"];
    
    self.VePeoCar.hidden = YES;
}
-(void)butClick1:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
    [self.ButSwag setTitle:[NSString stringWithFormat:@"%ld",(long)sender.tag] forState:UIControlStateNormal];
    CATransition * transition = [CATransition animation];
    
    transition.type = @"rippleEffect";
    
    [transition setSubtype:kCATransitionReveal];
    
    [transition setDuration:1.5];
    
    [self.VePeoSwag.layer addAnimation:transition forKey:@"rippleEffect"];
    self.VePeoSwag.hidden = YES;
}


-(void)ButPeoCarClick:(UIButton *)sender
{
    NSLog(@"点击了人");
    self.VePeoCar.hidden = NO;

}
-(void)ButSwagClick:(UIButton *)sender
{
    NSLog(@"点击了行李");
    self.VePeoSwag.hidden = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.TextfieldMoney resignFirstResponder];
}
@end
