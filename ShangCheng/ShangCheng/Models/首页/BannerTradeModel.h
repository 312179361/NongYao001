//
//  BannerTradeModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/11/16.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerTradeModel : NSObject
@property (nonatomic,strong)NSString *truename;
@property (nonatomic,strong)NSString *mobile; 
@property (nonatomic,strong)NSString *p_name; //购买的产品名
@property (nonatomic,strong)NSString *o_num; //购买数量
@property (nonatomic,strong)NSString *rn;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
