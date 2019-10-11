//
//  DetailVerticalCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/10/28.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "DetailVerticalCollectionViewCell.h"
#import "UIImageView+ImageViewCategory.h"
#import "UILabel+LabelCategory.h"
@implementation DetailVerticalCollectionViewCell
- (void)updateDetailVerticalCollectionViewCell:(ProductModel *)tempProductModel withIndexPath:(NSIndexPath *)tempIndex {

    [self.productImageView setWebImageURLWithImageUrlStr:tempProductModel.productImageUrlstr withErrorImage:[UIImage imageNamed:@"icon_pic_cp"]withIsCenter:YES];
    
    //是否显示活动角标
    if (tempProductModel.isSaleProduct == YES) {
        self.saleImageView.hidden = NO;
    }else {
        self.saleImageView.hidden = YES;
    }
    
    self.productTitleLabel.text = tempProductModel.productTitle;
         self.productCompanyLabel.text = tempProductModel.productCompany;
    self.productFormatLabel.text = tempProductModel.productFormatStr;
    self.productPriceLabel.text = [NSString stringWithFormat:@"￥%@", tempProductModel.productPrice ];

    self.volumeLabel.text = [NSString stringWithFormat:@"销量:%@", tempProductModel.productVolume];
    
    //如果没销量，就让这个Label高度为0
    if (tempProductModel.productVolume == nil) {
        self.volumeHeightLayout.constant = 0;
        self.volumeBottomLayout.constant = 0;
    }else {
        self.volumeHeightLayout.constant = 13;
        self.volumeBottomLayout.constant = 9;
    }
    
    if (tempIndex.row % 2 == 0) {
        //左边的item
        self.leftLayout.constant = 7.5;
        self.rightLayout.constant = 7.5/2;
    }else {
        self.leftLayout.constant = 7.5/2;
        self.rightLayout.constant = 7.5;
    }
    
}

@end
