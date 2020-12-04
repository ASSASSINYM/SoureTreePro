//
//  LoginEnterTaxInfoViewController.h
//  MobileCenter
//
//  Created by liuwang on 2018/6/28.
//  Copyright © 2018年 CSII. All rights reserved.
//


typedef NS_ENUM(NSInteger,MapPointType) {
    NetPointType = 0,
    ATMType = 1
};


@interface MapPointViewController : BusinessBaseViewController

@property(nonatomic,assign)MapPointType type;

-(void)setMapPointType:(MapPointType)type;

@end
