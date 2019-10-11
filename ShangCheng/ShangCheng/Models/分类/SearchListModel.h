//
//  SearchListModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchListModel : NSObject
@property (nonatomic,strong)NSString *rn;
@property (nonatomic,strong)NSString *p_time_create;
@property (nonatomic,strong)NSString *salesvol;
@property (nonatomic,strong)NSString *f_name;
@property (nonatomic,strong)NSString *p_s_id;
@property (nonatomic,strong)NSString *p_id;
@property (nonatomic,strong)NSString *p_name;
@property (nonatomic,strong)NSString *p_type3;
@property (nonatomic,strong)NSString *p_icon;
@property (nonatomic,strong)NSString *p_view_count;
@property (nonatomic,strong)NSString *p_pid;
@property (nonatomic,strong)NSString *p_standard;
@property (nonatomic,strong)NSString *p_price;
@property (nonatomic,strong)NSString *p_sort3;
@property (nonatomic,strong)NSString *p_activity_show_id;
//原价
@property (nonatomic,strong)NSString *p_price_backup;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
