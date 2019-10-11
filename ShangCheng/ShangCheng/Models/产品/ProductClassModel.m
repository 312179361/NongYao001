//
//  ProductClassModel.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/29.
//  Copyright © 2016年 TongLi. All rights reserved.
//  产品分类

#import "ProductClassModel.h"

@implementation ProductClassModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"d_code"]) {
        self.productClassID = value;
    }
    
    if ([key isEqualToString:@"d_value"]) {
        self.productClassName = value;
    }
    
}



@end
