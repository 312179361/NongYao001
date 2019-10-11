//
//  OrderDetailViewController.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/20.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"
typedef void(^RefreshOrderList)();

@interface OrderDetailViewController : UIViewController
@property (nonatomic,strong)NSString *whichTable;//主要用户对子订单操作后，记录那个TableView，对父订单进行刷新
@property (nonatomic,strong)SupOrderModel *tempSupOrderModel;

//
@property (nonatomic,copy)RefreshOrderList refreshOrderListBlock;


@end
