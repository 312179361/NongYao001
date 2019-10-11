//
//  TodaySaleListCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/1.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "TodaySaleListCollectionViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation TodaySaleListCollectionViewCell
- (void)updateTodaySaleListCellWithModel:(TodaySaleListModel *)tempModel {
    
    [self.todaySaleListImageView setWebImageURLWithImageUrlStr:tempModel.p_icon withErrorImage:[UIImage imageNamed:@""] withIsCenter:YES];


    self.todaySaleListTitleLabel.text = tempModel.p_name;

    self.todaySaleListFormatLabel.text = tempModel.s_standard;
    self.todaySaleListSaleVolLabel.text = tempModel.s_sales_volume;
    
    self.todaySaleListPriceLabel.text = [NSString stringWithFormat:@"￥%@", tempModel.d_price];
    //原价，要有删除线
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"原价￥%@",tempModel.s_price_backup]
                                   attributes:
     @{
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:k666666Color}];
    
    self.todaySaleListOldPriceLabel.attributedText = attrStr;
    
//    self.todaySaleListOldPriceLabel.text = [NSString stringWithFormat:@"原价￥%@",tempModel.s_price_backup];
    
    if ([tempModel.d_activity_id isEqualToString:@"0"]) {
        //没有活动
        self.saleImageView.hidden = YES;
        self.todaySaleListOldPriceLabel.hidden = YES;
    }else {
        //有活动
        self.saleImageView.hidden = NO;
        self.todaySaleListOldPriceLabel.hidden = NO;


    }
    
}

@end
