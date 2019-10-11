//
//  ProductCommentModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/16.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductCommentModel : NSObject
@property(nonatomic,strong)NSString *r_id;
@property(nonatomic,strong)NSString *r_time_create;//时间
@property(nonatomic,strong)NSString *r_time_reply;//回复时间
@property(nonatomic,strong)NSString *r_buyer_user_id;//买家id
@property(nonatomic,strong)NSString *r_seller_user_id;//卖家id
@property(nonatomic,strong)NSString *r_reply_user_id;//回复者id
@property(nonatomic,strong)NSString *r_product_id;//
@property(nonatomic,strong)NSString *r_specification_id;
@property(nonatomic,strong)NSString *r_order_id;//
@property(nonatomic,strong)NSString *r_star_level;//星级
@property(nonatomic,strong)NSString *r_content;//内容
@property(nonatomic,strong)NSString *r_content_reply;//回复内容
@property(nonatomic,strong)NSString *r_type;//
@property(nonatomic,strong)NSString *r_status;//1是审核通过
@property(nonatomic,strong)NSString *r_anonymity;
@property(nonatomic,strong)NSString *r_note;//备注
@property(nonatomic,strong)NSString *mobile;//手机号
@property(nonatomic,strong)NSString *u_icon;//图片id
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
