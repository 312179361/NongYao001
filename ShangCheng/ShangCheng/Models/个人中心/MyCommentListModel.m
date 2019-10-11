//
//  MyCommentListModel.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyCommentListModel.h"

@implementation MyCommentListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"p_icon"]) {
        self.productImageUrl = value;
    }
    if ([key isEqualToString:@"p_name"]) {
        self.productTitleStr = value;
    }
    if ([key isEqualToString:@"productst"]) {
        self.productFormatStr = value;
    }
//    if ([key isEqualToString:@"address"]) {
//        self.productCompanyStr = value;
//    }
    if ([key isEqualToString:@"r_content"]) {
        self.detailCommentStr = value;
    }
    if ([key isEqualToString:@"r_time_create"]) {
        self.commentTimeStr = value;
    }
    if ([key isEqualToString:@"r_star_level"]) {
        self.starCount = [value integerValue];
    }
    if ([key isEqualToString:@"o_price"]) {
        self.productPrice = value;
    }
  
}

@end
