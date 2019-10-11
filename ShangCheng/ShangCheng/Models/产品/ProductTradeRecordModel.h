//
//  ProductTradeRecordModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/16.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductTradeRecordModel : NSObject

@property (nonatomic,strong)NSString * o_buyer_user_id;

@property (nonatomic,strong)NSString *o_specification_id;
@property (nonatomic,strong)NSString *o_status;
@property (nonatomic,strong)NSString *o_p_id;
@property (nonatomic,strong)NSString *o_valid;
@property (nonatomic,strong)NSString *o_num;
//@property (nonatomic,strong)NSString *p_time_pay;
@property (nonatomic,strong)NSString *truename;
@property (nonatomic,strong)NSString *u_icon;
@property (nonatomic,strong)NSString *mobile;
@property (nonatomic,strong)NSString *o_time_create;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
