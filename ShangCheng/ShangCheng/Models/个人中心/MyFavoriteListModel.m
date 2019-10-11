//
//  MyFavoriteListModel.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/5.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyFavoriteListModel.h"

@implementation MyFavoriteListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"f_id"]) {
        self.myFavoriteId = value;
    }
    if ([key isEqualToString:@"p_code"]) {
        self.favoriteProductCode = value;
    }
    if ([key isEqualToString:@"p_icon"]) {
        self.productImageUrl = value;
    }

    if ([key isEqualToString:@"f_title"]) {
        self.favoriteProductTitleStr = value;
    }
    if ([key isEqualToString:@"p_name"]) {
        self.favoriteProductNameStr = value;
    }
    
    if ([key isEqualToString:@"f_manufacturer"]) {
        self.favoriteProductCompanyStr = value;
    }
    if ([key isEqualToString:@"p_st"]) {
        self.favoriteProductFormatStr = value;
    }
    if ([key isEqualToString:@"f_s_id"]) {
        self.favoriteProductFormatID = value;
    }
    if ([key isEqualToString:@"unitprice"]) {
        self.favoriteProductPriceStr = value;
    }
    
    
}

@end
