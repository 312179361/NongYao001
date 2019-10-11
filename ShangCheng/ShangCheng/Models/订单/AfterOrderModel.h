//
//  AfterOrderModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/6/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AfterOrderModel : NSObject

@property (nonatomic,strong)NSString *f_name;
@property (nonatomic,strong)NSString *o_p_id;
@property (nonatomic,strong)NSString *productst;
@property (nonatomic,strong)NSString *o_valid;
@property (nonatomic,strong)NSString *o_id;
@property (nonatomic,strong)NSString *o_code;
@property (nonatomic,strong)NSString *o_time_create;
@property (nonatomic,strong)NSString *p_pid;
@property (nonatomic,strong)NSString *o_price;
@property (nonatomic,strong)NSString *o_endstate;
@property (nonatomic,strong)NSString *o_price_total;
@property (nonatomic,strong)NSString *isreply;
@property (nonatomic,strong)NSString *p_buyer_user_id;
@property (nonatomic,strong)NSString *o_specification_id;
@property (nonatomic,strong)NSString *activitytitle;
@property (nonatomic,strong)NSString *o_activity_id;
@property (nonatomic,strong)NSString *p_name;
@property (nonatomic,strong)NSString *o_product_id;
@property (nonatomic,strong)NSString *o_status;
@property (nonatomic,strong)NSString *o_num;
@property (nonatomic,strong)NSString *statusvalue;
@property (nonatomic,strong)NSString *p_icon;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
