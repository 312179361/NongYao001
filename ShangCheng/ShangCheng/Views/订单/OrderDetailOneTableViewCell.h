//
//  OrderDetailOneTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/20.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SonOrderModel.h"
@interface OrderDetailOneTableViewCell : UITableViewCell
//订单号label
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
//订单状态或者总价
@property (weak, nonatomic) IBOutlet UILabel *statusAndTotalPriceLabel;
//产品图片
@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;
//订单名称，即产品名字
@property (weak, nonatomic) IBOutlet UILabel *orderTitleLabel;
//产品的公司
@property (weak, nonatomic) IBOutlet UILabel *orderCompanyLabel;
//产品规格和数量
@property (weak, nonatomic) IBOutlet UILabel *orderFormatAndCountLabel;
//单价
@property (weak, nonatomic) IBOutlet UILabel *orderUnitPriceLabel;

//活动图片
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;


- (void)updateOrderDetailOneCellWithSonOrder:(SonOrderModel *)tempSonOrderModel;

@end
