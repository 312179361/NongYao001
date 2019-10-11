//
//  MyAgentCommissionModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/12/7.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAgentCommissionModel : NSObject
@property(nonatomic,strong)NSString *orderId;
@property(nonatomic,strong)NSString *inComeStr;
@property(nonatomic,strong)NSString *commissionName;
@property(nonatomic,strong)NSString *commissionPhone;
@property(nonatomic,strong)NSString *capitalname;
@property(nonatomic,strong)NSString *cityname;
@property(nonatomic,strong)NSString *countyname;
@property(nonatomic,strong)NSString *productName;
@property(nonatomic,strong)NSString *productTotalPrice;
@property(nonatomic,strong)NSString *commissionTime;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
