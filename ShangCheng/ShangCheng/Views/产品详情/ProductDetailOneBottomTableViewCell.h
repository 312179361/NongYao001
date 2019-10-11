//
//  ProductDetailOneBottomTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/5/23.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailModel.h"
@interface ProductDetailOneBottomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)updateProductDetailOneBottomCellWithUseInfoDic:(ProductDetailModel *)productDetailModel withIndex:(NSIndexPath *)indexPath;

@end
