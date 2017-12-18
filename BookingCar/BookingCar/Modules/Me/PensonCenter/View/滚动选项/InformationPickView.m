//
//  InformationPickView.m
//  RootDirectory
//
//  Created by LDX on 16/6/8.
//  Copyright © 2016年 LDX All rights reserved..
//

#import "InformationPickView.h"
#import "CityModel.h"
#import "AddressModel.h"
@interface InformationPickView ()
@property(nonatomic,strong)NSMutableArray *sexArray;
@property(nonatomic,strong)NSMutableArray *provinceArray;
@property(nonatomic,strong)NSMutableArray *cityArray;
@property(nonatomic,copy)NSString *name;//性别或者年龄

@property(nonatomic,copy)NSString *province;//所属地区省
@property(nonatomic,copy)NSString *city;//所属地区市


@property(nonatomic,assign)BOOL address;
@end
@implementation InformationPickView
#pragma mark - IBAction Methods
- (IBAction)cancelInformationButtonClick:(id)sender {
    NSLog(@"取消");
    if (self.delegate &&[self.delegate respondsToSelector:@selector(informationPickViewCancelButtonClick)]) {
        [self.delegate informationPickViewCancelButtonClick];
    }
}

- (IBAction)trueInformationButtonClick:(id)sender {
    NSLog(@"确认");
    if (self.address) {
        //城市的代理
        if (self.delegate &&[self.delegate respondsToSelector:@selector(informationPickViewTrueButtonClickOfTheCityString:WithProvinceModelString:WithCityModelString:)]) {
            [self.delegate informationPickViewTrueButtonClickOfTheCityString:self.name WithProvinceModelString:self.province WithCityModelString:self.city];
        }
    }else{
        //性别的代理
        if (self.delegate &&[self.delegate respondsToSelector:@selector(informationPickViewTrueButtonClickOfTheSexString:)]) {
            [self.delegate informationPickViewTrueButtonClickOfTheSexString:self.name];
        }
    }
}

- (IBAction)informationBjButtonClick:(id)sender {
    NSLog(@"取消");
    if (self.delegate &&[self.delegate respondsToSelector:@selector(informationPickViewCancelButtonClick)]) {
        [self.delegate informationPickViewCancelButtonClick];
    }
}
#pragma mark - Public Methods
-(void)InformationPickViewForDataOfAddressArray:(NSMutableArray *)array
{
    if (!self.address) {
        self.provinceArray = [NSMutableArray array];
        self.cityArray = [NSMutableArray array];
        self.provinceArray = array;
        
        AddressModel *placeModel = self.provinceArray[0];
        NSArray *addressArray = placeModel.city;
        if (addressArray.count >0) {
            for(NSDictionary *cityDic in addressArray){
                CityModel *model = [[CityModel alloc]initWithRYDict:cityDic];
                [self.cityArray addObject:model];
            }
            CityModel *cityModel = self.cityArray[0];
            self.name = [NSString stringWithFormat:@"%@  %@",placeModel.name,cityModel.name];
            
            self.province = placeModel.code;
            self.city = cityModel.code;
             NSLog(@"省===     %@，市===     %@",self.province,self.city);
        }
        self.address = YES;
        [self.informationView reloadAllComponents];
        [self.informationView selectRow:0 inComponent:0 animated:YES];
    }
}

-(void)InformationPickViewForDataOfSexArray:(NSMutableArray *)array
{
        self.sexArray = [[NSMutableArray alloc]init];
        self.sexArray = array;
        self.address = NO;
        self.name = [NSString stringWithFormat:@"%@",self.sexArray[0]];
        [self.informationView reloadAllComponents];
        [self.informationView selectRow:0 inComponent:0 animated:YES];
}

#pragma mark - UIView Methods
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self configSubViews];
    
}

-(void)configSubViews
{
    self.informationView.showsSelectionIndicator = NO;
}
#pragma mark - UIPickViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.address) {
        return 2;
    }else
        return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.address) {
        if (component == 0) {
            return self.provinceArray.count;
        }else{
            
            return self.cityArray.count ;
        }
    }else{
        return self.sexArray.count;
    }
}

#pragma mark - UIPickViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.address) {
        if (component == 0) {
            AddressModel *model = self.provinceArray[row];
            return model.name;
        }else{
            if (self.cityArray.count >0) {
                CityModel *model = self.cityArray[row];
                return model.name;
            }else{
                return @"";
            }
        }
    }else{
        return self.sexArray[row];
    }
}
//设置列里边组件的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (self.address) {
        return KScreenWidth/2;
    }else{
        return KScreenWidth;
    }
}
//pickView修改字体大小..
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
//选择器选择的方法  row：被选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //选择第一列执行的方法
    if (self.address) {
        //城市
        if (component == 0) {
            AddressModel *addressModel = self.provinceArray[row];
            NSArray *addressArray = addressModel.city;
            [self.cityArray removeAllObjects];


            if (addressArray.count >0) {
                for(NSDictionary *cityDic in addressArray){
                    CityModel *model = [[CityModel alloc]initWithRYDict:cityDic];
                    [self.cityArray addObject:model];
                }
                CityModel *model = self.cityArray[0];
                NSLog(@"-----%ld",self.cityArray.count);

                  self.name = [NSString stringWithFormat:@"%@  %@",addressModel.name,model.name];
                
                self.province = addressModel.code;
                self.city = model.code;
                 NSLog(@"省==     %@，市==     %@",self.province,self.city);
                
            }else{
                 self.name = [NSString stringWithFormat:@"%@  %@",addressModel.name,@""];
                
                self.province = addressModel.code;
                self.city = nil;
                
                 NSLog(@"省=     %@，市=     %@",self.province,self.city);
            }
            [self.informationView reloadComponent:1];
            if(self.cityArray.count>0)
                [pickerView selectRow:0 inComponent:1 animated:YES];
            

        }else{
            NSInteger rowOne = [self.informationView selectedRowInComponent:0];
            NSInteger rowTwo = [self.informationView  selectedRowInComponent:1];
            AddressModel *model = self.provinceArray[rowOne];
            CityModel *cityModel = self.cityArray[rowTwo];
            self.name = [NSString stringWithFormat:@"%@  %@",model.name,cityModel.name];
            
            self.province = model.code;
            self.city = cityModel.code;
            
            NSLog(@"省     %@，市     %@",self.province,self.city);
        }
    }else{
        //性别
        self.name = [NSString stringWithFormat:@"%@",self.sexArray[row]];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
