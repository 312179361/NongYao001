//
//  DownLinePayViewController.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/18.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectBalanceBlock)();
@interface DownLinePayViewController : UIViewController
//订单号数组
@property (nonatomic,strong)NSArray *orderIDArr;
@property (nonatomic,assign)BOOL isSelectBalance;//是否选择使用余额
@property (nonatomic,assign)float memberBalanceFloat;//账户余额
//订单总额
@property (nonatomic,assign)float orderTotalAmountFloat;
//选择余额
@property (nonatomic,copy)SelectBalanceBlock selectBalanceBlock;

//收货人电话和姓名
@property(nonatomic,strong)NSString *receiverName;
@property(nonatomic,strong)NSString *receiverPhone;

@end
