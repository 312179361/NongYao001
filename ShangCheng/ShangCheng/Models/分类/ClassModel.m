//
//  ClassModel.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/8.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "ClassModel.h"

@implementation ClassModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"item"]) {
        NSArray *itemArr = value;
        self.subItemArr = [NSMutableArray array];
        for (NSDictionary *itemDic in itemArr) {
            
            ClassModel *model = [[ClassModel alloc] init];
            [model setValuesForKeysWithDictionary:itemDic];
            [self.subItemArr addObject:model];
        }
        
    }
}

@end
