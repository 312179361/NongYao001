//
//  CompleteCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/27.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "CompleteCollectionViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation CompleteCollectionViewCell
- (void)updateCompleteCellWithModel:(MyFavoriteListModel *)tempModel {
    [self.productImageView setWebImageURLWithImageUrlStr:tempModel.productImageUrl withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    
    self.productTitleLabel.text = tempModel.favoriteProductTitleStr;

    self.productFormatLabel.text = tempModel.favoriteProductFormatStr;
    self.productPriceLabel.text = [NSString stringWithFormat:@"￥%@", tempModel.favoriteProductPriceStr];

}

@end
