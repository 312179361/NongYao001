//
//  OrderDetailFootTwoTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/20.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupOrderModel.h"
@interface OrderDetailFootTwoTableViewCell : UITableViewCell
//需付款
@property (weak, nonatomic) IBOutlet UILabel *needPayPriceLabel;
//付款时间
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;

- (void)updateOrderDetailTwoFootCell:(SupOrderModel *)tempSupModel;
@end
