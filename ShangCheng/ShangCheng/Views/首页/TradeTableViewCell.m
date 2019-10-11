//
//  TradeTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/11/16.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "TradeTableViewCell.h"

@implementation TradeTableViewCell
- (void)updateTradeCellWithTradeModel:(BannerTradeModel *)tradeModel {
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@", tradeModel.truename];
    self.phoneLabel.text = tradeModel.mobile;
    self.productLabel.text = tradeModel.p_name;
    self.numberLabel.text = tradeModel.o_num;
    
    
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
