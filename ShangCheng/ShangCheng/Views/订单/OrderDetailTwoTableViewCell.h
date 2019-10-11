//
//  OrderDetailTwoTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/20.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupOrderModel.h"
@interface OrderDetailTwoTableViewCell : UITableViewCell
//左边的titleLabel
@property (weak, nonatomic) IBOutlet UILabel *titleLeftLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *rightPriceLabel;

- (void)updateOrderDetailTwoCellDataSourceDic:(NSDictionary *)tempDic;
@end
