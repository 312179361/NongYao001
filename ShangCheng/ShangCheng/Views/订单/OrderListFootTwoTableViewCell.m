//
//  OrderListFootTwoTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/8.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "OrderListFootTwoTableViewCell.h"

@implementation OrderListFootTwoTableViewCell

- (void)updateOrderListFootTwoCellWithModel:(SupOrderModel *)model {
    self.orderTimeLabel.text = [NSString stringWithFormat:@"%@",model.p_time_create];
    
    self.orderCountLabel.text = [NSString stringWithFormat:@"共%ld件商品，",model.subOrderArr.count];
    self.orderPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.p_o_price_total floatValue] - [model.p_discount floatValue]];
}

- (IBAction)orderDetailInfo:(IndexButton *)sender {
    
    self.footTwoButtonBlock(sender.indexForButton);
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
