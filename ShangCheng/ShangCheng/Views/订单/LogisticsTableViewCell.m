//
//  LogisticsTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/5.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "LogisticsTableViewCell.h"

@implementation LogisticsTableViewCell

- (void)updateLogisticsCellWithLogisticsModel:(LogisticsModel *)logisticsModel withHidenUpLine:(BOOL)isHidenUpLine withHidenDownLine:(BOOL)isHidenDownLine {
    //默认的是都显示
    self.upLine.hidden = NO;
    self.downLine.hidden = NO;
    self.pointImageView.image = [UIImage imageNamed:@"d_pic_spot_2"];
    //默认是灰色的
    self.logisticsAddressLabel.textColor = k999999Color;
    self.logisticsTimeLabel.textColor = k999999Color;

    if (isHidenUpLine == YES) {
        //隐藏上面的线
        self.upLine.hidden = YES;
        self.pointImageView.image = [UIImage imageNamed:@"d_pic_spot_1"];
        //颜色变为绿色
        self.logisticsAddressLabel.textColor = kColor(71, 161, 27, 1);
        self.logisticsTimeLabel.textColor = kColor(71, 161, 27, 1);
    }
    if (isHidenDownLine == YES) {
        //隐藏下面的先
        self.downLine.hidden = YES;
    }
    
    self.logisticsAddressLabel.text = logisticsModel.t_char_para1;
    self.logisticsTimeLabel.text = logisticsModel.t_time_create;
    
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
