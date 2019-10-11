//
//  PestsTreeModel.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/6.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "PestsTreeModel.h"

@implementation PestsTreeModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"item"]) {
        NSArray *itemArr = value;
        self.itemArr = [NSMutableArray array];
        for (NSDictionary *itemDic in itemArr) {
            PestsTreeModel *model = [[PestsTreeModel alloc] init];
            [model setValuesForKeysWithDictionary:itemDic];
            [self.itemArr addObject:model];
        }
        
    }
}

@end
