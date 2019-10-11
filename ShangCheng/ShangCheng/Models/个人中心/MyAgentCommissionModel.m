//
//  MyAgentCommissionModel.m
//  ShangCheng
//
//  Created by TongLi on 2017/12/7.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyAgentCommissionModel.h"

@implementation MyAgentCommissionModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"d_id"] || [key isEqualToString:@"s_id"]) {
        self.orderId = value;
    }
    if ([key isEqualToString:@"d_amount"] || [key isEqualToString:@"s_money"]) {
        self.inComeStr = value;
    }
    if ([key isEqualToString:@"buyeruser"] || [key isEqualToString:@"s_buyer_name"]) {
        self.commissionName = value;
    }
    if ([key isEqualToString:@"s_buyer_mobile"]) {
        self.commissionPhone = value;
    }
    
    if ([key isEqualToString:@"p_name"] || [key isEqualToString:@"s_s_name"]) {
        self.productName = value;
    }
    if ([key isEqualToString:@"p_o_price_total"]) {
        self.productTotalPrice = value;
    }
    if ([key isEqualToString:@"d_time_create"] || [key isEqualToString:@"s_time_create"]) {
        self.commissionTime = value;
    }

  
}

@end

