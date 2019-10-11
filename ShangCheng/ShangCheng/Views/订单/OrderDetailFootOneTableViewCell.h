//
//  OrderDetailFootOneTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/20.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexButton.h"
#import "SonOrderModel.h"

//typedef void(^ButtonActionTypeBlock)(IndexButton *footButton,NSInteger buttonActionTypeBlock);
@interface OrderDetailFootOneTableViewCell : UITableViewCell
//总价
@property (weak, nonatomic) IBOutlet UILabel *orderTotalPriceLabel;
//右边第一个button
@property (weak, nonatomic) IBOutlet IndexButton *buttonOne;
//右边第二个button
@property (weak, nonatomic) IBOutlet IndexButton *buttonTwo;

/*button代表的功能block
 1 -- 取消子订单
 2 -- 查看物流（待发货状态中的详情也是物流信息）
 3 -- 确认收货
 4 -- 立即评价
 5 -- 再次购买
*/
//@property (nonatomic,strong)ButtonActionTypeBlock buttonActionTypeBlock;

@property (nonatomic,strong)SonOrderModel *tempSonOrder;

- (void)updateOrderDetailFootOneCell:(SonOrderModel *)tempSonOrderModel;

@end
