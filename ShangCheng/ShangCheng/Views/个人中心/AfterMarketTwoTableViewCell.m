//
//  AfterMarketTwoTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/22.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "AfterMarketTwoTableViewCell.h"
#import "SonOrderModel.h"
#import "UIImageView+ImageViewCategory.h"
@implementation AfterMarketTwoTableViewCell

- (void)updateAfterMarketTwoCellWithModel:(SupOrderModel *)tempModel {
    
    self.orderCodeLabel.text = tempModel.p_code;
    self.orderStatusLabel.text = tempModel.statusvalue;
    SonOrderModel *oneSonOrderModel = tempModel.subOrderArr[0];
    SonOrderModel *twoSonOrderModel = tempModel.subOrderArr[1];

    
    //看看有多少个子订单，模式都显示
    self.productImageViewOne.hidden = NO;
    [self.productImageViewOne setWebImageURLWithImageUrlStr:oneSonOrderModel.p_icon withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    self.productImageViewTwo.hidden = NO;
    [self.productImageViewTwo setWebImageURLWithImageUrlStr:twoSonOrderModel.p_icon withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];

    self.productImageViewThree.hidden = NO;
    self.productImageViewFour.hidden = NO;
    
    switch (tempModel.subOrderArr.count) {
        case 2:
            self.productImageViewThree.hidden = YES;
            self.productImageViewFour.hidden = YES;
            break;
        case 3:
        {
            self.productImageViewFour.hidden = YES;
            SonOrderModel *threeSonOrderModel = tempModel.subOrderArr[2];
            
            [self.productImageViewThree setWebImageURLWithImageUrlStr:threeSonOrderModel.p_icon withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
        }
            break;
        case 4:
        {
            SonOrderModel *threeSonOrderModel = tempModel.subOrderArr[2];
            SonOrderModel *fourSonOrderModel = tempModel.subOrderArr[3];
            
            [self.productImageViewThree setWebImageURLWithImageUrlStr:threeSonOrderModel.p_icon withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
            [self.productImageViewFour setWebImageURLWithImageUrlStr:fourSonOrderModel.p_icon withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
        }

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
