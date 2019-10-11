//
//  DetailVerticalCollectionViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/10/28.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface DetailVerticalCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *productCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productFormatLabel;
@property (weak, nonatomic) IBOutlet UIImageView *saleImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLayout;
//销量
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *volumeHeightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *volumeBottomLayout;

- (void)updateDetailVerticalCollectionViewCell:(ProductModel *)tempProductModel withIndexPath:(NSIndexPath *)tempIndex;
@end
