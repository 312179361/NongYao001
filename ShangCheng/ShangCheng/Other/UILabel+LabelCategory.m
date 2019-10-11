//
//  UILabel+LabelCategory.m
//  ShangCheng
//
//  Created by TongLi on 2017/5/25.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "UILabel+LabelCategory.h"

@implementation UILabel (LabelCategory)
- (void)setPriceLabelWithPriceStr:(NSString *)priceStr withFormatStr:(NSString *)formatStr {
    
    if (priceStr != nil && priceStr.length > 0) {
        if ([formatStr containsString:@"/件"]) {
            self.text = [NSString stringWithFormat:@"￥%@元/件",priceStr];
        }else {
            self.text = [NSString stringWithFormat:@"￥%@",priceStr];
        }
    }else {
        self.text = @"暂无报价";
    }
    
    
    
}

@end
