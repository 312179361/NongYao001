//
//  ProductDetailOneTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/25.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ProductDetailOneTableViewCell.h"

@implementation ProductDetailOneTableViewCell

- (void)updateProductDetailOneCellWithProductInfoDic:(ProductDetailModel *)productDetailModel withIndex:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
        case 0:
            self.titleLabel.text = @"产品分类：";
//            self.titleLabel.textAlignment = NSTextAlignmentCenter
            if ([productDetailModel.p_typevalue1 isEqualToString:@""]) {
                self.contentLabel.text = @"暂无";
            }else {
                self.contentLabel.text = productDetailModel.p_typevalue1;

            }
            break;
        case 1:
            self.titleLabel.text = @"产品编号：";
            if ([productDetailModel.p_pid isEqualToString:@""]) {
                self.contentLabel.text = @"暂无";
            }else {
                self.contentLabel.text = productDetailModel.p_pid;
            }
            break;
        case 2:
            self.titleLabel.text = @"产品规格：";
            if ([productDetailModel.productModel.productFormatStr isEqualToString:@""]) {
                self.contentLabel.text = @"暂无";
            }else {
                self.contentLabel.text = productDetailModel.productModel.productFormatStr;
            }
            break;
        case 3:
            self.titleLabel.text = @"有效成分：";
            if ([productDetailModel.p_ingredient isEqualToString:@""]) {
                self.contentLabel.text = @"暂无";
            }else {
                self.contentLabel.text = productDetailModel.p_ingredient;
            }
            break;
        case 4:
            self.titleLabel.text = @"推荐起订数量：";
            if ([productDetailModel.p_standard_qty isEqualToString:@""]) {
                self.contentLabel.text = @"暂无";
            }else{
                self.contentLabel.text = productDetailModel.p_standard_qty;
            }
            break;
        case 5:
            self.titleLabel.text = @"生产厂家：";
            if ([productDetailModel.productModel.productCompany isEqualToString:@""]) {
                self.contentLabel.text = @"暂无";
            }else{
                self.contentLabel.text = productDetailModel.productModel.productCompany;
            }
            break;
            
        default:
            break;
    }
    
    
    
    //后两项
    if (indexPath.row == 8 + productDetailModel.p_cerArr.count - 2) {
        self.titleLabel.text = @"发布时间：";
        if ([productDetailModel.p_time_create isEqualToString:@""]) {
            self.contentLabel.text = @"暂无";
        }else{
            self.contentLabel.text = productDetailModel.p_time_create;
        }
    }
    if (indexPath.row == 8 + productDetailModel.p_cerArr.count - 1) {
        self.titleLabel.text = @"防治对象：";
        if ([productDetailModel.p_treatment_str isEqualToString:@""]) {
            self.contentLabel.text = @"暂无";
        }else{
            self.contentLabel.text = productDetailModel.p_treatment_str;
            
        }
    }
    
    //中间可变化的三项
    if (productDetailModel.p_cerArr.count == 1) {
        if (indexPath.row == 6) {
            self.titleLabel.text = [[productDetailModel.p_cerArr[0] allKeys]objectAtIndex:0];
            self.contentLabel.text = [[productDetailModel.p_cerArr[0] allValues]objectAtIndex:0];
        }
        
    }else if (productDetailModel.p_cerArr.count == 2) {
        if (indexPath.row == 6) {
            self.titleLabel.text = [[productDetailModel.p_cerArr[0] allKeys]objectAtIndex:0];
            self.contentLabel.text = [[productDetailModel.p_cerArr[0] allValues]objectAtIndex:0];
        }
        if (indexPath.row == 7) {
            self.titleLabel.text = [[productDetailModel.p_cerArr[1] allKeys]objectAtIndex:0];
            self.contentLabel.text = [[productDetailModel.p_cerArr[1] allValues]objectAtIndex:0];
        }
        
        
    }else if(productDetailModel.p_cerArr.count == 3){
        if (indexPath.row == 6) {
            self.titleLabel.text = [[productDetailModel.p_cerArr[0] allKeys]objectAtIndex:0];
            self.contentLabel.text = [[productDetailModel.p_cerArr[0] allValues]objectAtIndex:0];
        }
        if (indexPath.row == 7) {
            self.titleLabel.text = [[productDetailModel.p_cerArr[1] allKeys]objectAtIndex:0];
            self.contentLabel.text = [[productDetailModel.p_cerArr[1] allValues]objectAtIndex:0];
        }
        if (indexPath.row == 8) {
            self.titleLabel.text = [[productDetailModel.p_cerArr[2] allKeys]objectAtIndex:0];
            self.contentLabel.text = [[productDetailModel.p_cerArr[2] allValues]objectAtIndex:0];
        }
    }
    
    
    
    
    
    
}

- (void)updateProductDetailOneCellWithUseInfoDic:(ProductDetailModel *)productDetailModel withIndex:(NSIndexPath *)indexPath {
    
    switch (indexPath.row % 4) {
        case 0:
        {
            self.titleLabel.text = @"作物(或范围)：";
            NSString *contentStr1 = productDetailModel.p_scope_crop_Arr[indexPath.row/4];
            if ([contentStr1 isEqualToString:@""]) {
                contentStr1 = @"暂无";
            }
            self.contentLabel.text = contentStr1;
        }
            break;
        case 1:
        {
            self.titleLabel.text = @"防治对象：";
            NSString *contentStr2 = productDetailModel.p_treatment_Arr[indexPath.row/4];
            if ([contentStr2 isEqualToString:@""]) {
                contentStr2 = @"暂无";
            }
            self.contentLabel.text = contentStr2;
        }
            break;
        case 2:
        {
            self.titleLabel.text = @"制剂用药量：";
            NSString *contentStr3 = productDetailModel.p_dosage_Arr[indexPath.row/4];
            if ([contentStr3 isEqualToString:@""]) {
                contentStr3 = @"暂无";
            }
            self.contentLabel.text = contentStr3;
        }
            break;
        
        default:
            break;
    }

    
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
