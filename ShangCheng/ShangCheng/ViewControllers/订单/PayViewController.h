//
//  PayViewController.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/13.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayViewController : UIViewController
//订单号数组,
@property (nonatomic,strong)NSArray *orderIDArr;
//商品总价
@property (nonatomic,assign)float totalAmountFloat;

//收货人信息
@property (nonatomic,strong)NSString *receiverName;
@property (nonatomic,strong)NSString *receiverPhone;

@end
