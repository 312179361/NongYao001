//
//  TodaySaleListModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/1.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodaySaleListModel : NSObject
@property (nonatomic,strong)NSString *d_id;
@property (nonatomic,strong)NSString *d_activity_id;
@property (nonatomic,strong)NSString *d_p_id;
@property (nonatomic,strong)NSString *p_name;
@property (nonatomic,strong)NSString *d_s_id;
@property (nonatomic,strong)NSString *s_standard;//规格
@property (nonatomic,strong)NSString *d_price;//活动价格
@property (nonatomic,strong)NSString *s_price_backup;//非活动价格
@property (nonatomic,strong)NSString *d_inventory;//库存数量
@property (nonatomic,strong)NSString *a_time_start;
@property (nonatomic,strong)NSString *a_time_end;
@property (nonatomic,strong)NSString *s_sales_volume;
@property (nonatomic,strong)NSString *p_icon;
@property (nonatomic,strong)NSString *s_code;
@property (nonatomic,strong)NSString *a_ico;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
