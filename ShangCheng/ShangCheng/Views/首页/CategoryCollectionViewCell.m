//
//  CategoryCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/10/28.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "CategoryCollectionViewCell.h"

@implementation CategoryCollectionViewCell
- (void)updateCategoryCellWithDic:(NSDictionary *)tempDic {
    self.categoryImageView.image = [UIImage imageNamed:[tempDic objectForKey:@"img"]];
    self.categoryNameLabel.text = [tempDic objectForKey:@"categoryName"];
    
}

@end
