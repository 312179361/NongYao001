//
//  MyAgentFavoriteModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/12/6.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAgentFavoriteModel : NSObject
@property (nonatomic,strong)NSString *u_truename;

@property (nonatomic,strong)NSString *p_icon;
@property (nonatomic,strong)NSString *f_title;
@property (nonatomic,strong)NSString *productname;
@property (nonatomic,strong)NSString *f_name;
@property (nonatomic,strong)NSString *s_standard;
@property (nonatomic,strong)NSString *f_time_create;


- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
