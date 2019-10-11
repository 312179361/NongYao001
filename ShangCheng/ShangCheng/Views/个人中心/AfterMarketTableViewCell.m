//
//  AfterMarketTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/11.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "AfterMarketTableViewCell.h"
#import "SonOrderModel.h"
#import "UIImageView+ImageViewCategory.h"
@implementation AfterMarketTableViewCell
- (void)updateAfterMarketCellWithOrderModel:(AfterOrderModel *)tempModel {
    
    self.orderIdLabel.text = tempModel.o_code;
    self.orderStatusLabel.text = tempModel.statusvalue;
    

    [self.orderProductImageView setWebImageURLWithImageUrlStr:tempModel.p_icon withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    self.orderProductNameLabel.text = tempModel.p_name;
    self.orderProductCompanyLabel.text = tempModel.f_name;
    self.orderProductFormatLabel.text = [NSString stringWithFormat:@"%@ 数量：%@", tempModel.productst,tempModel.o_num];
    self.orderProductPriceLabel.text = [NSString stringWithFormat:@"￥%@",tempModel.o_price];
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
