//
//  MyTradeRecordModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/2/9.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTradeRecordModel : NSObject
@property (nonatomic,strong)NSString *d_u_id;
@property (nonatomic,strong)NSString *accout;//变动金额
@property (nonatomic,strong)NSString *d_o_id;
@property (nonatomic,strong)NSString *rn;
@property (nonatomic,strong)NSString *d_amount;
@property (nonatomic,strong)NSString *d_note;
@property (nonatomic,strong)NSString *d_type;
@property (nonatomic,strong)NSString *week;
@property (nonatomic,strong)NSString *d_amount_original;
@property (nonatomic,strong)NSString *d_time_create;

@property (nonatomic,strong)NSDateComponents *time_dateComponents;

@property (nonatomic,strong)NSString *d_value;
@property (nonatomic,strong)NSString *d_accout;
@property (nonatomic,strong)NSString *d_user_id_create;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
