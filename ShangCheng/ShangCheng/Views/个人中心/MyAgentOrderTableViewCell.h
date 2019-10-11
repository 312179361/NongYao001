//
//  MyAgentOrderTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/2/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"
@interface MyAgentOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *orderHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPhoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderAgentMoneyLabel;//收益


@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderProductLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderFormatLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderFactoryLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTotalMoneyLabel;//总价

//更新订单
- (void)updateMyAgentOrderCellWithOrderModel:(MyAgentOrderModel *)tempModel ;
//更新收藏
- (void)updateMyAgentFavoriteCellWithFavoriteModel:(MyAgentFavoriteModel *)tempModel ;
//更新购物车
- (void)updateMyAgentShopCarCellWithShopCarModel:(MyAgentShopCarModel *)tempModel ;
@end
