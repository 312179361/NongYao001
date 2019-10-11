//
//  ReceiveAddressModel.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/29.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ReceiveAddressModel.h"

@implementation ReceiveAddressModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"r_id"]) {
        self.receiverID = value;
    }
    if ([key isEqualToString:@"r_truename"]) {
        self.receiverName = value;
    }
    if ([key isEqualToString:@"r_address"]) {
        self.receiveAddress = value;
    }
    
    if ([key isEqualToString:@"r_mobile"]) {
        self.receiveMobile = value;
    }
    if ([key isEqualToString:@"r_area_id"]) {
        self.areaID = value;
    }
    
    
    if ([key isEqualToString:@"r_default_address"]) {
        if ([value integerValue] == 1) {
            self.defaultAddress = YES;
        }else {
            self.defaultAddress = NO;
        }
    }
    
//    name 姓名
//    address 地址
//    tel 电话
//    mobile 手机号
//    areaid 地区id
//    defaultaddress 默认地址0(非默认)1(默认)

}


-(id)mutableCopyWithZone:(NSZone*)zone {
    
    ReceiveAddressModel *receiveAddressModel = [[[self class] allocWithZone:zone] init];
   
    receiveAddressModel.receiverID = [_receiverID copy];
    receiveAddressModel.receiverName = [_receiverName copy];
    receiveAddressModel.receiveMobile = [_receiveMobile copy];

    receiveAddressModel.areaID = [_areaID copy];
    receiveAddressModel.capitalname = [_capitalname copy];
    receiveAddressModel.cityname = [_cityname copy];
    receiveAddressModel.countyname = [_countyname copy];
    receiveAddressModel.receiveAddress = [_receiveAddress copy];
    receiveAddressModel.defaultAddress = _defaultAddress;
    receiveAddressModel.isSelect = _isSelect;
    
    
    return receiveAddressModel;
    
}

@end
