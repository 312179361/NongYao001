//
//  ProductFormatModel.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/30.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ProductFormatModel.h"

@implementation ProductFormatModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"s_image_fir"] || [key isEqualToString:@"s_image_sec"] || [key isEqualToString:@"s_image_sec2"] || [key isEqualToString:@"s_image_sec3"] || [key isEqualToString:@"s_image_sec4"]) {
        [self.imageArr addObject:value];
    }
    if ([key isEqualToString:@"s_activity_show_id"]) {
        if ([value isEqualToString:@"0"]) {
            self.isActivity = NO;
        }else {
            self.isActivity = YES;
        }

    }
}


@end
