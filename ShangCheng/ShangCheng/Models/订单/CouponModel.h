//
//  CouponModel.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/11.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponModel : NSObject
//主键
@property (nonatomic,strong)NSString *c_id;
//创建时间
@property (nonatomic,strong)NSString *c_time_create;
//优惠码
@property (nonatomic,strong)NSString *c_code;
//优惠类型1抵金额 2有效期
@property (nonatomic,strong)NSString *c_type;
@property (nonatomic,strong)NSString *typevalue;
//优惠额度（可抵金额）
@property (nonatomic,strong)NSString *c_amount;
//优惠券金额（创建时默认的）
@property (nonatomic,strong)NSString *c_balance;
//使用次数
@property (nonatomic,strong)NSString *c_usagecount;
//有效期
@property (nonatomic,strong)NSString *c_time_valid;
//是否重复使用
@property (nonatomic,strong)NSString *c_isreuse;
//用户id
@property (nonatomic,strong)NSString *c_user_id;
//用户名字
@property (nonatomic,strong)NSString *username;
//用户绑定时间
@property (nonatomic,strong)NSString *c_time_binding;


- (void)setValue:(id)value forUndefinedKey:(NSString *)key;



@end
