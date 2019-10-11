//
//  MyAgentShopCarModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/12/7.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAgentShopCarModel : NSObject

@property(nonatomic,strong)NSString *u_truename;
@property(nonatomic,strong)NSString *u_mobile;

@property(nonatomic,strong)NSString *s_image_fir;
@property(nonatomic,strong)NSString *productname;
@property(nonatomic,strong)NSString *f_name;
//@property(nonatomic,strong)NSString *c_title;
@property(nonatomic,strong)NSString *s_standard;

@property(nonatomic,strong)NSString *c_time_create;
@property(nonatomic,strong)NSString *c_number;//个数
@property(nonatomic,strong)NSString *s_price;//单价
@property(nonatomic,strong)NSString *amount;//总价

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
