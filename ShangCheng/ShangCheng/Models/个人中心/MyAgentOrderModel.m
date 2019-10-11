//
//  MyAgentOrderModel.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyAgentOrderModel.h"

@implementation MyAgentOrderModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"o_buyer_name"]) {
        self.u_truename = value;
    }
    if ([key isEqualToString:@"o_buyer_mobile"]) {
        self.mobile = value;
    }
    
    
    
    if ([key isEqualToString:@"item"]) {
        self.product_icon = [value[0] objectForKey:@"p_icon"];
        self.product_name = [value[0] objectForKey:@"p_name"];
        self.product_format = [value[0] objectForKey:@"productst"];
        self.product_factory = [value[0] objectForKey:@"o_supplier_name"];
    }
    
    
//    if ([key isEqualToString:@"o_s_name"]) {
//        self.product_icon = value;
//    }
    if ([key isEqualToString:@"o_s_name"]) {
        self.product_name = value;
    }
    if ([key isEqualToString:@"o_s_standard"]) {
        self.product_format = value;
    }
    
    
    
    
    if ([key isEqualToString:@"o_time_create"]) {
        self.p_time_create = value;
    }
    if ([key isEqualToString:@"o_num"]) {
        self.p_num = value;
    }
    if ([key isEqualToString:@"o_price_total"]) {
        self.p_o_price_total = value;
    }
    
    
}

@end

