//
//  TradeTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/11/16.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerTradeModel.h"
@interface TradeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

- (void)updateTradeCellWithTradeModel:(BannerTradeModel *)tradeModel;
@end
