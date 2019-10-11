//
//  BannerModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/29.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerModel : NSObject

@property(nonatomic,strong)NSString *l_id;
@property(nonatomic,strong)NSString *l_title;
@property(nonatomic,strong)NSString *l_image_path;
@property(nonatomic,strong)NSString *l_link_path;
@property(nonatomic,strong)NSString *l_remark;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
