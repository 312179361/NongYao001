//
//  ProductListCollectionViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/11/19.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchListModel.h"
#import "ActivityProductModel.h"
@interface ProductListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productListImageView;
@property (weak, nonatomic) IBOutlet UILabel *productListNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productListCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *productListFormatLabel;
@property (weak, nonatomic) IBOutlet UILabel *productListCostPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productListPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productListSalesvolLabel;
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;


- (void)updateProductListCellWithProductModel:(SearchListModel *)tempModel;



@end
