//
//  BannerCellTwoCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/11/20.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "BannerCellTwoCollectionViewCell.h"
#import "UIImageView+ImageViewCategory.h"

@implementation BannerCellTwoCollectionViewCell
- (void)updateBannerShopTwoCellWithActivityModel:(ActivityProductModel *)activityModel {
    
    [self.productImageView setWebImageURLWithImageUrlStr:activityModel.p_icon withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    
    self.productNameLabel.text = activityModel.p_title;
    self.productFactoryLabel.text = activityModel.p_factory_name;
    self.productStandardLabel.text = activityModel.s_standard;
    
    self.volumeLabel.text = [NSString stringWithFormat:@"销量:%@",activityModel.p_sales_volume];

    
    if ([activityModel.s_activity_id isEqualToString:@"0"]) {
        //没有活动
        self.activityImageView.hidden = YES;//活动图片隐藏
        self.backPriceLabel.hidden = YES;//原价Label隐藏
        self.salePriceLabel.text = [NSString stringWithFormat:@"￥%@", activityModel.s_price_backup];//活动价格为原价

        
    }else {
        self.activityImageView.hidden = NO;
        self.backPriceLabel.hidden = NO;//原价Label显示
        //原价添加删除线
        self.backPriceLabel.attributedText = [self addDeleteLineWithStr:[NSString stringWithFormat:@"￥%@",activityModel.s_price_backup]];
//        self.backPriceLabel.text = [NSString stringWithFormat:@"￥%@",activityModel.s_price_backup];
        
        self.salePriceLabel.text = [NSString stringWithFormat:@"活动价:￥%@", activityModel.s_price];


    }
    
}


//添加删除线
- (NSAttributedString *)addDeleteLineWithStr:(NSString *)deleteStr {
    
    NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:deleteStr
                                   attributes:
     @{
       //删除线的样式和颜色
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName: k999999Color}];
    
    return attrStr;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
