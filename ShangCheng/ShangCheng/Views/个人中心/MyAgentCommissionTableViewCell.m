//
//  MyAgentCommissionTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/12/7.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyAgentCommissionTableViewCell.h"

@implementation MyAgentCommissionTableViewCell
- (void)updateMyAgentCommissionCellWithCommissionModel:(MyAgentCommissionModel *)tempModel withIsNew:(BOOL)isNew {

    self.orderIdLabel.text = tempModel.orderId;
    self.incomeLabel.text = [NSString stringWithFormat:@"收益:%@元", tempModel.inComeStr];
    if (isNew == YES) {
        self.detailOneLabel.text = [NSString stringWithFormat:@"姓名:%@ 收货地址:%@%@%@",tempModel.commissionName,tempModel.capitalname,tempModel.cityname,tempModel.countyname];
        self.detailTwoLabel.text = [NSString stringWithFormat:@"产品:%@ 总计:%@元",tempModel.productName,tempModel.productTotalPrice];
    }else {
        self.detailOneLabel.text = [NSString stringWithFormat:@"姓名:%@ 收货电话:%@",tempModel.commissionName,tempModel.commissionPhone];
        self.detailTwoLabel.text = [NSString stringWithFormat:@"产品:%@ ",tempModel.productName];
    }
    self.timeLabel.text = tempModel.commissionTime;
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
