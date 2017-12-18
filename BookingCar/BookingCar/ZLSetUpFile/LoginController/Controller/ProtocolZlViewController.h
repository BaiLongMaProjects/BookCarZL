//
//  ProtocolZlViewController.h
//  BookingCar
//
//  Created by apple on 2017/11/24.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import "BaseZLRootViewController.h"
#import <WebKit/WebKit.h>
@interface ProtocolZlViewController : BaseZLRootViewController<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, copy)  NSString *url;

@end
