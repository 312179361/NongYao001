//
//  MyAgentPeopleModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/2/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAgentPeopleModel : NSObject
@property (nonatomic,strong)NSString *u_id;
@property (nonatomic,strong)NSString *u_r_id;
//@property (nonatomic,strong)NSString *u_login_id;
@property (nonatomic,strong)NSString *u_type;
@property (nonatomic,strong)NSString *u_typename;
@property (nonatomic,strong)NSString *u_truename;
@property (nonatomic,strong)NSString *u_email;
@property (nonatomic,strong)NSString *u_mobile;
@property (nonatomic,strong)NSString *u_time_create;
@property (nonatomic,strong)NSString *u_icon;
@property (nonatomic,strong)NSString *u_qq;
@property (nonatomic,strong)NSString *u_payword;
@property (nonatomic,strong)NSString *capitalcode;
@property (nonatomic,strong)NSString *capitalname;
@property (nonatomic,strong)NSString *citycode;
@property (nonatomic,strong)NSString *cityname;
@property (nonatomic,strong)NSString *countycode;
@property (nonatomic,strong)NSString *countyname;
@property (nonatomic,strong)NSString *u_status;
@property (nonatomic,strong)NSString *u_statusname;
@property (nonatomic,strong)NSString *u_amount;
@property (nonatomic,strong)NSString *u_amount_frozen;
@property (nonatomic,strong)NSString *u_amount_avail;
@property (nonatomic,strong)NSString *rversion;
@property (nonatomic,strong)NSString *rn;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
