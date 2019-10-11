//
//  MyAgentCashModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/2/17.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAgentCashModel : NSObject
@property(nonatomic,strong)NSString *w_id;//id

@property(nonatomic,strong)NSString *week;
@property(nonatomic,strong)NSString *w_time_create;//添加时间
@property(nonatomic,strong)NSString *w_time_operation;//操作时间
@property(nonatomic,strong)NSString *w_time_apply;//申请时间
@property (nonatomic,strong)NSDateComponents *time_dateComponents;


@property(nonatomic,strong)NSString *w_status;//状态码 申请审核操作等
@property(nonatomic,strong)NSString *status;//状态（对应上面的）

@property(nonatomic,strong)NSString *w_amount_original;//原账号金额
@property(nonatomic,strong)NSString *w_amount;//账号余额
@property(nonatomic,strong)NSString *w_accout;//金额,（原账号金额-账号余额）

//----------------------
@property(nonatomic,strong)NSString *w_note_apply;//申请备注
@property(nonatomic,strong)NSString *w_withdraw_note;//支付备注如银行微信号等
@property(nonatomic,strong)NSString *w_note_operation;//操作备注
@property(nonatomic,strong)NSString *w_withdraw_name;//开户姓名
@property(nonatomic,strong)NSString *u_truename;//用户名
@property(nonatomic,strong)NSString *w_u_id_operation;//操作人id
@property(nonatomic,strong)NSString *w_withdraw_type;//支付方式码 0支付宝 1微信
@property(nonatomic,strong)NSString *withdraw_type;//支付方式
@property(nonatomic,strong)NSString *w_u_id_apply;//申请人id
@property(nonatomic,strong)NSString *w_note;//备注
@property(nonatomic,strong)NSString *w_note_check;//审核备注

//@property(nonatomic,strong)NSString *w_status_operation;//申请状态

- (void)setValue:(id)value forUndefinedKey:(NSString *)key ;
@end
