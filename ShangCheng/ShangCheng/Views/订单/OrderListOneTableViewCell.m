//
//  OrderListOneTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/8.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "OrderListOneTableViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation OrderListOneTableViewCell
- (void)updateOrderListOneCellWithModel:(SonOrderModel *)model withWhichTableView:(NSString *)whichTableView withCellIndex:(NSIndexPath *)cellIndex {

//    产品信息
//    子订单，即产品
//o_num个数
//    o_price单价
    [self.productImageView setWebImageURLWithImageUrlStr:model.p_icon withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    self.productNameLabel.text = model.p_name;
    self.productFormatLabel.text = [NSString stringWithFormat:@"%@ 数量:%@", model.productst,model.o_num];
    self.productCompany.text = model.f_name;
    self.unitPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.o_price];
    
    if ([model.o_activity_id isEqualToString:@"0"]) {
        self.activityImageView.hidden = YES;
    }else {
        self.activityImageView.hidden = NO;

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
