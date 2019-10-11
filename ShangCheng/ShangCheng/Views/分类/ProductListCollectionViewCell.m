//
//  ProductListCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/11/19.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "ProductListCollectionViewCell.h"
#import "UIImageView+ImageViewCategory.h"

@implementation ProductListCollectionViewCell

- (void)updateProductListCellWithProductModel:(SearchListModel *)tempModel {
    
    [self.productListImageView setWebImageURLWithImageUrlStr:tempModel.p_icon withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    self.productListNameLabel.text = tempModel.p_name;
    self.productListCompanyLabel.text = tempModel.f_name;
    self.productListFormatLabel.text = tempModel.p_standard;
    self.productListPriceLabel.text = [NSString stringWithFormat:@"￥%@", tempModel.p_price ];
    self.productListSalesvolLabel.text = [NSString stringWithFormat:@"销量：%@",tempModel.salesvol];
    
    if ([tempModel.p_activity_show_id isEqualToString:@"0"]) {
        self.activityImageView.hidden = YES;
        self.productListCostPriceLabel.text = @"";
        
    }else {
        self.activityImageView.hidden = NO;
        NSString *costPriceStr = [NSString stringWithFormat:@"￥%@", tempModel.p_price_backup ];
        NSUInteger length = [costPriceStr length];
        
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:costPriceStr];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:k666666Color range:NSMakeRange(0, length)];
        [self.productListCostPriceLabel setAttributedText:attri];
        
        
//        self.productListCostPriceLabel.text = @"￥原价";

    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
