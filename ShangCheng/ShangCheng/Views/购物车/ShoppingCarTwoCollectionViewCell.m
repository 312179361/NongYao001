//
//  ShoppingCarTwoCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/8.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "ShoppingCarTwoCollectionViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation ShoppingCarTwoCollectionViewCell
- (void)updateShoppingCarTwoCellWithModel:(MyFavoriteListModel *)tempModel {
    
    [self.myFavoriteImageView setWebImageURLWithImageUrlStr:tempModel.productImageUrl withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    
    self.myFavoriteTitleLabel.text = tempModel.favoriteProductTitleStr;
//    self.productCompanyLabel.text = tempModel.favoriteProductCompanyStr;
    self.myFavoriteFormatLabel.text = tempModel.favoriteProductFormatStr;
    self.myFavoritePriceLabel.text = [NSString stringWithFormat:@"￥%@", tempModel.favoriteProductPriceStr];
}

@end
