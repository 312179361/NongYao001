//
//  OrderListFootOneTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/8.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "OrderListFootOneTableViewCell.h"

@implementation OrderListFootOneTableViewCell
- (void)updateOrderListFootOneCellWithModel:(SupOrderModel *)model {
    if ([model.p_status isEqualToString:@"0"]) {
        self.orderPayButton.hidden = NO;
        self.orderCancelButton.hidden = NO;

    }else {
        self.orderPayButton.hidden = YES;
        self.orderCancelButton.hidden = YES;
    }

    self.orderCountLabel.text = [NSString stringWithFormat:@"共%ld件商品，",model.subOrderArr.count];
    self.orderPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.p_o_price_total floatValue] - [model.p_discount floatValue]];
}

//去支付
- (IBAction)orderPayAction:(IndexButton *)sender {
    
    NSLog(@"%ld",sender.indexForButton.section);
    
    self.footOneButtonBlock(sender.indexForButton, @"orderPay");
}



//取消订单
- (IBAction)cancelOrderAction:(IndexButton *)sender {
    NSLog(@"%ld",sender.indexForButton.section);
    
    self.footOneButtonBlock(sender.indexForButton, @"cancelOrder");}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
