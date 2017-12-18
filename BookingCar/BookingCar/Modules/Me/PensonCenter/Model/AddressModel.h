//
//  AddressModel.h
//  work
//
//  Created by LDX on 16/6/12.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import "RYBaseModel.h"

@interface AddressModel : RYBaseModel
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSArray *city;

@end
