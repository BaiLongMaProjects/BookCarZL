//
//  InformationPickView.h
//  RootDirectory
//
//  Created by LDX on 16/6/8.
//  Copyright © 2016年 LDX All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol InformationPickViewDelegate <NSObject>
@required
-(void)informationPickViewCancelButtonClick;
-(void)informationPickViewTrueButtonClickOfTheCityString:(NSString *)name WithProvinceModelString:(NSString *)province WithCityModelString:(NSString *)city;
-(void)informationPickViewTrueButtonClickOfTheSexString:(NSString *)name;

@end

@interface InformationPickView : UIView
@property (weak, nonatomic) IBOutlet UIView *bjView;
@property (weak, nonatomic) IBOutlet UIView *pickView;

@property (weak, nonatomic) IBOutlet UIButton *bjButton;
@property (weak, nonatomic) IBOutlet UIPickerView *informationView;
@property (weak, nonatomic) IBOutlet UIButton *trueButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property(weak,nonatomic)id<InformationPickViewDelegate>delegate;
- (IBAction)cancelInformationButtonClick:(id)sender;
- (IBAction)trueInformationButtonClick:(id)sender;
- (IBAction)informationBjButtonClick:(id)sender;
-(void)InformationPickViewForDataOfAddressArray:(NSMutableArray *)array;
-(void)InformationPickViewForDataOfSexArray:(NSMutableArray *)array;

@end
