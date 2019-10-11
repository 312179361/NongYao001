//
//  DetailHorizontalCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/10/28.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "DetailHorizontalCollectionViewCell.h"
#import "UIImageView+ImageViewCategory.h"
#import "UILabel+LabelCategory.h"
@implementation DetailHorizontalCollectionViewCell
- (void)updateDetailHorizontalCollectionViewCellWithLeftModel:(ProductModel *)leftModel UpModel:(ProductModel *)upModel withDownModel:(ProductModel *)downModel {
    
    //左边
    [self.leftProductImageView setWebImageURLWithImageUrlStr:leftModel.productImageUrlstr withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    if (leftModel.isSaleProduct == YES) {
        self.leftSaleImageView.hidden = NO;
    }else {
        self.leftSaleImageView.hidden = YES;
    }
    self.leftProductTitleLabel.text = leftModel.productTitle;
    self.leftProductFormatLabel.text = leftModel.productFormatStr;
    self.leftProductPriceLabel.text = [NSString stringWithFormat:@"￥%@", leftModel.productPrice ];
//    [self.leftProductPriceLabel setPriceLabelWithPriceStr:leftModel.productPrice withFormatStr:leftModel.productFormatStr];
    
    //上面的产品
    [self.upProductImageView setWebImageURLWithImageUrlStr:upModel.productImageUrlstr withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    if (upModel.isSaleProduct == YES) {
        self.upSaleImageView.hidden = NO;
    }else {
        self.upSaleImageView.hidden = YES;
    }
    self.upProductTitleLabel.text = upModel.productTitle;
    self.upProductFormatLabel.text = upModel.productFormatStr;
    self.upProductPriceLabel.text = [NSString stringWithFormat:@"￥%@", upModel.productPrice ];

    //下面的产品
    [self.downProductImageView setWebImageURLWithImageUrlStr:downModel.productImageUrlstr withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    if (downModel.isSaleProduct == YES) {
        self.downSaleImageView.hidden = NO;
    }else {
        self.downSaleImageView.hidden = YES;
    }
    self.downProductTitleLabel.text = downModel.productTitle;
    self.downProductFormatLabel.text = downModel.productFormatStr;
    self.downProductPriceLabel.text = [NSString stringWithFormat:@"￥%@", downModel.productPrice ];

}


@end
