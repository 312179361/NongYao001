//
//  PestsListModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/6.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PestsListModel : NSObject
@property (nonatomic,strong)NSString *i_id;
@property (nonatomic,strong)NSString *i_time_create;
@property (nonatomic,strong)NSString *i_code;
@property (nonatomic,strong)NSString *i_title;
@property (nonatomic,strong)NSString *i_level;
@property (nonatomic,strong)NSString *i_introduce;
@property (nonatomic,strong)NSString *i_status;
@property (nonatomic,strong)NSString *i_icon_path;
@property (nonatomic,strong)NSString *i_source_url;
@property (nonatomic,strong)NSString *i_classify;
@property (nonatomic,strong)NSString *i_author;
@property (nonatomic,strong)NSString *rn;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
