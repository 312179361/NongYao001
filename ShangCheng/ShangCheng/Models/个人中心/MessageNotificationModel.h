//
//  MessageNotificationModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/4/1.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageNotificationModel : NSObject
@property(nonatomic,strong)NSString *i_title;
@property(nonatomic,strong)NSString *i_id;
@property(nonatomic,strong)NSString *i_introduce;
@property(nonatomic,strong)NSString *i_status;
@property(nonatomic,strong)NSString *i_user_id_update;
@property(nonatomic,strong)NSString *i_level;
@property(nonatomic,strong)NSString *i_type;
@property(nonatomic,strong)NSString *i_user_id_create;
@property(nonatomic,strong)NSString *i_profile;
@property(nonatomic,strong)NSString *i_keyword;
@property(nonatomic,strong)NSString *i_time_create;
@property(nonatomic,strong)NSString *i_classify;
@property(nonatomic,strong)NSString *i_source;
@property(nonatomic,strong)NSString *i_hits;
@property(nonatomic,strong)NSString *i_author;
@property(nonatomic,strong)NSString *i_time_update;
@property(nonatomic,strong)NSString *i_code;
@property(nonatomic,strong)NSString *i_source_url;
@property(nonatomic,strong)NSString *i_blob_content;
@property(nonatomic,strong)NSString *i_icon_path;
@property(nonatomic,strong)NSString *i_tag;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
