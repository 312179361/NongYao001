//
//  CouponTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/11.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"
@interface CouponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
//优惠券码
@property (weak, nonatomic) IBOutlet UILabel *couponCodeLabel;
//总金额
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
//已优惠金额
@property (weak, nonatomic) IBOutlet UILabel *saleMoneyLabel;
//剩余金额
@property (weak, nonatomic) IBOutlet UILabel *overMoneyLabel;
//有效期
@property (weak, nonatomic) IBOutlet UILabel *timeValidLabel;
- (void)updateCouponCellWith:(CouponModel *)tempCouponModel ;

@end
