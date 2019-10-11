//
//  ProductClassModel.h
//  ShangCheng
//
//  Created by TongLi on 2016/11/29.
//  Copyright © 2016年 TongLi. All rights reserved.
//  产品分类

#import <Foundation/Foundation.h>

@interface ProductClassModel : NSObject
//分类id
@property (nonatomic,strong)NSString *productClassID;
//分类名称
@property (nonatomic,strong)NSString *productClassName;

//这个分类下的产品数组
@property (nonatomic,strong)NSMutableArray *productArr;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
