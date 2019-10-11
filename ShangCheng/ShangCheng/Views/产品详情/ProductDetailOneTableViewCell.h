//
//  ProductDetailOneTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/11/25.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailModel.h"
@interface ProductDetailOneTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)updateProductDetailOneCellWithProductInfoDic:(ProductDetailModel *)productDetailModel withIndex:(NSIndexPath *)indexPath;

- (void)updateProductDetailOneCellWithUseInfoDic:(ProductDetailModel *)productDetailModel withIndex:(NSIndexPath *)indexPath;


@end
