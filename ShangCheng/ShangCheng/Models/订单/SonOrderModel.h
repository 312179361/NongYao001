//
//  SonOrderModel.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/14.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SonOrderModel : NSObject

@property (nonatomic,strong)NSString *o_id;//主键
@property (nonatomic,strong)NSString *o_status;//状态
@property (nonatomic,strong)NSString *o_num;//个数
@property (nonatomic,strong)NSString *o_code;//编码
@property (nonatomic,strong)NSString *productst;//规格
@property (nonatomic,strong)NSString *o_product_id;//产品id
@property (nonatomic,strong)NSString *p_name;//名字
@property (nonatomic,strong)NSString *o_activity_id;//活动id
@property (nonatomic,strong)NSString *activitytitle;//活动标题
@property (nonatomic,strong)NSString *p_icon;//图片
@property (nonatomic,strong)NSString *f_name;//厂家
@property (nonatomic,strong)NSString *o_price;//单价
@property (nonatomic,strong)NSString *p_pid;//商品编码
@property (nonatomic,strong)NSString *statusvalue;//状态值
@property (nonatomic,strong)NSString *o_price_total;//总价
@property (nonatomic,strong)NSString *o_p_id;//父订单id
@property (nonatomic,strong)NSString *o_specification_id;//规格id
@property (nonatomic,strong)NSString *isreply;//是否评价

- (void)setValue:(id)value forUndefinedKey:(NSString *)key ;

@end
