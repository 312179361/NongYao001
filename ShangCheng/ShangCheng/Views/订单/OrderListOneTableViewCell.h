//
//  OrderListOneTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/8.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SupOrderModel.h"
#import "SonOrderModel.h"
#import "IndexButton.h"

@interface OrderListOneTableViewCell : UITableViewCell
//产品图片
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
//产品名
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
//产品规格
@property (weak, nonatomic) IBOutlet UILabel *productFormatLabel;
//产品公司
@property (weak, nonatomic) IBOutlet UILabel *productCompany;
///内容为： 共几件商品，实付款
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
//活动角标
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;

- (void)updateOrderListOneCellWithModel:(SonOrderModel *)model withWhichTableView:(NSString *)whichTableView withCellIndex:(NSIndexPath *)cellIndex;


@end
