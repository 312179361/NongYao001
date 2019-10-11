//
//  ProductDetailOneBottomTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/5/23.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "ProductDetailOneBottomTableViewCell.h"

@implementation ProductDetailOneBottomTableViewCell
- (void)updateProductDetailOneBottomCellWithUseInfoDic:(ProductDetailModel *)productDetailModel withIndex:(NSIndexPath *)indexPath {

    self.titleLabel.text = @"使用方法：";
    NSString *contentStr4 = productDetailModel.p_method_Arr[indexPath.row/4];
    if ([contentStr4 isEqualToString:@""]) {
        contentStr4 = @"暂无";
    }
    
    self.contentLabel.text = contentStr4;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
