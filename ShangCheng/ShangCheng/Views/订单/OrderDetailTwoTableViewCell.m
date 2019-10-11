//
//  OrderDetailTwoTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/20.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "OrderDetailTwoTableViewCell.h"

@implementation OrderDetailTwoTableViewCell
- (void)updateOrderDetailTwoCellDataSourceDic:(NSDictionary *)tempDic {

    self.titleLeftLabel.text = [[tempDic allKeys] firstObject];
    self.rightPriceLabel.text = [[tempDic allValues] firstObject];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
