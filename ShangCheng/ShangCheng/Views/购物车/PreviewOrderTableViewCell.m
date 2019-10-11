//
//  PreviewOrderTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/10.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "PreviewOrderTableViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation PreviewOrderTableViewCell
- (void)updatePreviewOrderCellWithShoppingCarModel:(ShoppingCarModel *)shoppingCarModel {
    
    [self.productImageView setWebImageURLWithImageUrlStr:shoppingCarModel.shoppingCarProduct.productImageUrlstr withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    self.productNameLabel.text = shoppingCarModel.shoppingCarProduct.productTitle;
    self.productCompanyLabel.text = shoppingCarModel.shoppingCarProduct.productCompany;
    self.productFormatAndCountLabel.text = [NSString stringWithFormat:@"规格：%@  数量：%@", shoppingCarModel.shoppingCarProduct.productFormatStr,shoppingCarModel.c_number];
    self.productPriceLabel.text = [NSString stringWithFormat:@"￥%@", shoppingCarModel.shoppingCarProduct.productPrice];
    
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
