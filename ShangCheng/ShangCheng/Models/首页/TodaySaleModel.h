//
//  TodaySaleModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/1.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodaySaleModel : NSObject
@property (nonatomic,strong)NSString *a_id;
@property (nonatomic,strong)NSString *a_title;
@property (nonatomic,strong)NSString *a_image1;
@property (nonatomic,strong)NSString *a_image2;
@property (nonatomic,strong)NSString *type;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
