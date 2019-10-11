//
//  TradeRecordTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/12/5.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "TradeRecordTableViewCell.h"

@implementation TradeRecordTableViewCell
- (void)updateTradeRecordCellWithModel:(MyTradeRecordModel *)tradeRecordModel {
    
    switch ([tradeRecordModel.d_type integerValue]) {
        case 0:
            self.tradeTypeImageView.image = [UIImage imageNamed:@"w_icon_cz"];
            break;
        case 1:
            self.tradeTypeImageView.image = [UIImage imageNamed:@"w_icon_yfk"];
            
            break;
        case 2:
            self.tradeTypeImageView.image = [UIImage imageNamed:@"w_icon_tk"];
            
            break;
        case 3:
            self.tradeTypeImageView.image = [UIImage imageNamed:@"w_icon_tx"];
            
            break;
        case 4:
            self.tradeTypeImageView.image = [UIImage imageNamed:@"w_icon_gm"];
            
            break;
        case 5:
            self.tradeTypeImageView.image = [UIImage imageNamed:@"w_icon_lx"];
            
            break;
        default:
            self.tradeTypeImageView.image = [UIImage imageNamed:@"w_icon_yfk"];

            break;
    }
    
    //左边的时间Label
    //    Manager *manager = [Manager shareInstance];
    //    NSDateComponents *dateCom = [manager dateToComponentWithDatestr:tradeRecordModel.time_date];
    
    //    NSDateComponents *dateCom = [manager dateStrToDateAndComponentWithDatestr:tradeRecordModel.d_time_update];
    
    NSString *timeStr = [NSString stringWithFormat:@"%ld-%ld",tradeRecordModel.time_dateComponents.month,tradeRecordModel.time_dateComponents.day];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@\n%@",tradeRecordModel.week,timeStr];
    //图标右边的信息
    self.tradeMoneyLabel.text = tradeRecordModel.accout;
    self.tradeDetailLabel.text = tradeRecordModel.d_note;
    
}


- (void)updateCashRecordCellWithModel:(MyAgentCashModel *)cashRecordModel {
    self.tradeTypeImageView.image = [UIImage imageNamed:@"w_icon_tx"];
    
    //左边的时间Label
    NSString *timeStr = [NSString stringWithFormat:@"%ld-%ld",cashRecordModel.time_dateComponents.month,cashRecordModel.time_dateComponents.day];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@\n%@",cashRecordModel.week,timeStr];
    //图标右边的信息
    self.tradeMoneyLabel.text = cashRecordModel.w_accout;
   
    self.tradeDetailLabel.text = [NSString stringWithFormat:@"提现-%@",cashRecordModel.status];
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
