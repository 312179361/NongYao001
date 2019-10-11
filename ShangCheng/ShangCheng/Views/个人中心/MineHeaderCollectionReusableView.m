//
//  MineHeaderCollectionReusableView.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/2.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "MineHeaderCollectionReusableView.h"

@implementation MineHeaderCollectionReusableView
- (void)updateHeaderCellWithTitleStr:(NSString *)titleStr withButtonTitle:(NSString *)buttonTitle {
    self.headerCellLabel.text = titleStr;
    
    self.headerCellButton.titleLabel.text = buttonTitle;
    [self.headerCellButton setTitle:buttonTitle forState:UIControlStateNormal];

}

@end
