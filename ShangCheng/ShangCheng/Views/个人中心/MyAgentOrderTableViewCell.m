//
//  MyAgentOrderTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyAgentOrderTableViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation MyAgentOrderTableViewCell
- (void)updateMyAgentOrderCellWithOrderModel:(MyAgentOrderModel *)tempModel {

//    self.orderHeaderImageView
    self.orderNameLabel.text = tempModel.u_truename;
    NSString *currentPhoneStr = [tempModel.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.orderPhoneLabel.text = currentPhoneStr;
    if (tempModel.o_buyer_address != nil) {
        self.orderAddressLabel.text = tempModel.o_buyer_address;
    }else {
        self.orderAddressLabel.text = [NSString stringWithFormat:@"%@ %@ %@",tempModel.capitalname,tempModel.cityname,tempModel.countyname];
    }
    
    //收益
    if (tempModel.p_money_agent == nil) {
        self.orderAgentMoneyLabel.hidden = YES;
    }else {
        self.orderAgentMoneyLabel.hidden = NO;
        self.orderAgentMoneyLabel.text = [NSString stringWithFormat:@"￥%@", tempModel.p_money_agent];

    }
    
    //产品
    [self.orderImageView setWebImageURLWithImageUrlStr:tempModel.product_icon  withErrorImage:[UIImage imageNamed:@"icon_pic_cp.png"] withIsCenter:YES];
    self.orderProductLabel.text = tempModel.product_name;
    self.orderFormatLabel.text = tempModel.product_format;
    self.orderFactoryLabel.text = tempModel.product_factory;
    
    
    self.orderTimeLabel.text = tempModel.p_time_create;
    self.orderTotalMoneyLabel.text = [NSString stringWithFormat:@"共%@件商品,总金额:￥%@",tempModel.p_num,tempModel.p_o_price_total];
}

//更新收藏
- (void)updateMyAgentFavoriteCellWithFavoriteModel:(MyAgentFavoriteModel *)tempModel {
    
    self.orderNameLabel.text = tempModel.u_truename;
    self.orderPhoneLabel.text = @"";
    self.orderAddressLabel.text = @"";
    
    //收益隐藏
    self.orderAgentMoneyLabel.hidden = YES;
    
    //产品
    [self.orderImageView setWebImageURLWithImageUrlStr:tempModel.p_icon  withErrorImage:[UIImage imageNamed:@"icon_pic_cp.png"] withIsCenter:YES];
    self.orderProductLabel.text = tempModel.productname;
    self.orderFormatLabel.text = tempModel.s_standard;
    self.orderFactoryLabel.text = tempModel.f_name;
    
    
    self.orderTimeLabel.text = tempModel.f_time_create;
    self.orderTotalMoneyLabel.text = @"";
}


- (void)updateMyAgentShopCarCellWithShopCarModel:(MyAgentShopCarModel *)tempModel {
    self.orderNameLabel.text = tempModel.u_truename;
    self.orderPhoneLabel.text = tempModel.u_mobile;
    self.orderAddressLabel.text = @"";
    
    //收益隐藏
    self.orderAgentMoneyLabel.hidden = YES;
    
    //产品
    [self.orderImageView setWebImageURLWithImageUrlStr:tempModel.s_image_fir  withErrorImage:[UIImage imageNamed:@"icon_pic_cp.png"] withIsCenter:YES];
    self.orderProductLabel.text = tempModel.productname;
    self.orderFormatLabel.text = tempModel.s_standard;
    self.orderFactoryLabel.text = tempModel.f_name;
    
    
    self.orderTimeLabel.text = tempModel.c_time_create;
    self.orderTotalMoneyLabel.text = [NSString stringWithFormat:@"共%@件商品，总金额%@元",tempModel.c_number,tempModel.amount];
    
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
