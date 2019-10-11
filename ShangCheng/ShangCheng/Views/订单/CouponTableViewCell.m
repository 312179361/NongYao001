//
//  CouponTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/11.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "CouponTableViewCell.h"

@implementation CouponTableViewCell
- (void)updateCouponCellWith:(CouponModel *)tempCouponModel {
    //部分拉伸
    UIImage *originImage = [UIImage imageNamed:@"m_pic_yhq"];
    self.backImageView.image = [originImage stretchableImageWithLeftCapWidth:100 topCapHeight:0];
    
    self.couponCodeLabel.text = tempCouponModel.c_code;
    self.totalMoneyLabel.text = tempCouponModel.c_amount;
    self.saleMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[tempCouponModel.c_amount floatValue] - [tempCouponModel.c_balance floatValue]];
    self.overMoneyLabel.text = tempCouponModel.c_balance;
    self.timeValidLabel.text = [NSString stringWithFormat:@"绑定时间：%@", tempCouponModel.c_time_binding];
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
