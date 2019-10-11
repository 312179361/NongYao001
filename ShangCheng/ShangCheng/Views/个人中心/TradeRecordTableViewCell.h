//
//  TradeRecordTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/12/5.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"
@interface TradeRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tradeTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *tradeMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeDetailLabel;
//交易记录
- (void)updateTradeRecordCellWithModel:(MyTradeRecordModel *)tradeRecordModel;
//提现记录
- (void)updateCashRecordCellWithModel:(MyAgentCashModel *)cashRecordModel;

@end
