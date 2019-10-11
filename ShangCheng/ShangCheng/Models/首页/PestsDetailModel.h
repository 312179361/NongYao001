//
//  PestsDetailModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/4/27.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PestsDetailModel : NSObject
@property (nonatomic,strong)NSString *i_id;
@property (nonatomic,strong)NSString *i_title;
@property (nonatomic,strong)NSString *i_author;
@property (nonatomic,strong)NSString *i_time_create;
@property (nonatomic,strong)NSString *i_icon_path;
@property (nonatomic,strong)NSString *content;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;


@end
