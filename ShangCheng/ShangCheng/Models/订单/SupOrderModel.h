//
//  SupOrderModel.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/6.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupOrderModel : NSObject
@property (nonatomic,strong)NSString *p_id;//订单id
@property (nonatomic,strong)NSString *p_code;//订单编号
@property (nonatomic,strong)NSString *p_status;//订单状态
@property (nonatomic,strong)NSString *statusvalue;//订单状态值
@property (nonatomic,strong)NSString *p_time_create;//订单创建时间
@property (nonatomic,strong)NSString *p_buyer_user_id;//买家id
@property (nonatomic,strong)NSString *p_truename;//真名
@property (nonatomic,strong)NSString *p_mobile;//手机号
@property (nonatomic,strong)NSString *p_telephone;//电话
@property (nonatomic,strong)NSString *capitalcode;//省的编号
@property (nonatomic,strong)NSString *capitalname;//省的名字
@property (nonatomic,strong)NSString *citycode;//市的编号
@property (nonatomic,strong)NSString *cityname;//市的名字
@property (nonatomic,strong)NSString *countycode;//县的编号
@property (nonatomic,strong)NSString *countyname;//县的名字
@property (nonatomic,strong)NSString *p_address;//详细信息
@property (nonatomic,strong)NSMutableArray *subOrderArr;//子订单产品
@property (nonatomic,strong)NSString *p_num;//产品数量
@property (nonatomic,strong)NSString *p_discount;//优惠金额
@property (nonatomic,strong)NSString *p_o_price_total;//总价
@property (nonatomic,strong)NSString *p_payment;//支付方式
@property (nonatomic,strong)NSString *p_account_num;//支付账号
@property (nonatomic,strong)NSString *p_time_pay;//支付时间

//是否被选择,主要用于订单列表中
@property (nonatomic,assign)BOOL isSelectOrder;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
