//
//  ActivityProductModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/11/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityProductModel : NSObject

@property (nonatomic,strong)NSString *d_p_id;   //  产品ID
@property (nonatomic,strong)NSString *d_s_id;   //  规格ID
@property (nonatomic,strong)NSString *s_code;  // 产品编号
@property (nonatomic,strong)NSString *p_icon;
@property (nonatomic,strong)NSString *p_title; //产品名
@property (nonatomic,strong)NSString *s_standard; //规格
@property (nonatomic,strong)NSString *p_factory_name; //产品公司

@property (nonatomic,strong)NSString *s_price;     //   活动价
@property (nonatomic,strong)NSString *s_price_backup;  // 原价


@property (nonatomic,strong)NSString *s_activity_id;
//s_activity_id 活动ID (如果不等于0 活动开始（两个都显示）如果等于0  s_price_backup 原价   s_price 未开始)
@property (nonatomic,strong)NSString *s_activity_show_id;

@property (nonatomic,strong)NSString *p_registration;//PD证
@property (nonatomic,strong)NSString *s_min_quantity; //最小起订数
@property (nonatomic,strong)NSString *p_sales_volume;//销量

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
