//
//  MyAgentOrderModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/2/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAgentOrderModel : NSObject
@property (nonatomic,strong)NSString *u_truename;
@property (nonatomic,strong)NSString *mobile;
@property (nonatomic,strong)NSString *capitalname;
@property (nonatomic,strong)NSString *cityname;
@property (nonatomic,strong)NSString *countyname;
@property (nonatomic,strong)NSString *o_buyer_address;
@property (nonatomic,strong)NSString *p_money_agent;//收益


//产品
@property (nonatomic,strong)NSString *product_icon;
@property (nonatomic,strong)NSString *product_name;
@property (nonatomic,strong)NSString *product_format;
@property (nonatomic,strong)NSString *product_factory;



@property (nonatomic,strong)NSString *p_time_create;
@property (nonatomic,strong)NSString *p_num;
@property (nonatomic,strong)NSString *p_o_price_total;




- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
