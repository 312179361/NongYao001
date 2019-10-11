//
//  OrderListHeadTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/5/24.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupOrderModel.h"
#import "SonOrderModel.h"
#import "IndexButton.h"

typedef void(^SelectButtonBlock)(IndexButton *selectButton);

@interface OrderListHeadTableViewCell : UITableViewCell
//选中的button
@property (weak, nonatomic) IBOutlet IndexButton *selectOrderButton;
@property (nonatomic,strong)SelectButtonBlock selectButtonBlock;

//选择button的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectButtonWidthLayout;

//订单号
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
//订单状态
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;


- (void)updateOrderListHeadCellWithModel:(SupOrderModel *)model withWhichTableView:(NSString *)whichTableView withCellIndex:(NSIndexPath *)cellIndex;

@end
