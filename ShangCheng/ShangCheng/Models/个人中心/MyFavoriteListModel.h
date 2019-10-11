//
//  MyFavoriteListModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/2/5.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyFavoriteListModel : NSObject
//产品的基本信息
@property (nonatomic,strong)NSString *myFavoriteId;
@property (nonatomic,strong)NSString *productImageUrl;
@property (nonatomic,strong)NSString *favoriteProductCode;

@property (nonatomic,strong)NSString *favoriteProductTitleStr;
@property (nonatomic,strong)NSString *favoriteProductNameStr;
@property (nonatomic,strong)NSString *favoriteProductCompanyStr;
@property (nonatomic,strong)NSString *favoriteProductFormatID;
@property (nonatomic,strong)NSString *favoriteProductFormatStr;
@property (nonatomic,strong)NSString *favoriteProductPriceStr;
@property (nonatomic,strong)NSString *s_min_quantity;


- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
