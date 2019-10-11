//
//  MaxSaleHotCollectionReusableView.m
//  ShangCheng
//
//  Created by TongLi on 2016/10/28.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "MaxSaleHotCollectionReusableView.h"

@implementation MaxSaleHotCollectionReusableView
- (void)updateMaxSaleHotCell:(NSMutableArray *)maxSaleHotDataArr {
    //设置一下属性
    self.cycleView.titleLabelBackgroundColor = [UIColor whiteColor];
    self.cycleView.titleLabelTextColor = k333333Color;
    self.cycleView.titleLabelTextFont = [UIFont systemFontOfSize:15];
    
    self.cycleView.onlyDisplayText = YES;
    self.cycleView.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.cycleView.mainView.scrollEnabled = NO;

    self.cycleView.titlesGroup = maxSaleHotDataArr;
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

@end
