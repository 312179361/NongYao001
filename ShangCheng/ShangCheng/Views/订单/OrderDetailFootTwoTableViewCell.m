//
//  OrderDetailFootTwoTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/20.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "OrderDetailFootTwoTableViewCell.h"

@implementation OrderDetailFootTwoTableViewCell

- (void)updateOrderDetailTwoFootCell:(SupOrderModel *)tempSupModel {
    
    
    //未付款，
    if ([tempSupModel.p_status isEqualToString:@"0"] || [tempSupModel.p_status isEqualToString:@"1A"] || [tempSupModel.p_status isEqualToString:@"1B"]) {
        
        self.needPayPriceLabel.text = [NSString stringWithFormat:@"需付款：￥%.2f", [tempSupModel.p_o_price_total floatValue] - [tempSupModel.p_discount floatValue]];
        //付款时间隐藏
        self.payTimeLabel.hidden = YES;

    }else {
        //已付款
        self.needPayPriceLabel.text = [NSString stringWithFormat:@"实付款：￥%.2f", [tempSupModel.p_o_price_total floatValue] - [tempSupModel.p_discount floatValue]];
        self.payTimeLabel.hidden = NO;
        self.payTimeLabel.text = [NSString stringWithFormat:@"付款时间：%@",tempSupModel.p_time_pay];

    }
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
