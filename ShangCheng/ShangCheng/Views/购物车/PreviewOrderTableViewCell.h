//
//  PreviewOrderTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/10.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCarModel.h"
@interface PreviewOrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productFormatAndCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;

- (void)updatePreviewOrderCellWithShoppingCarModel:(ShoppingCarModel *)shoppingCarModel;


@end
