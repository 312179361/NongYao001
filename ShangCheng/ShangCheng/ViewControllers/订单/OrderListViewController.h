//
//  OrderListViewController.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/6.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListViewController : UIViewController
//哪个TabelView 1-全部  2-待付款  3-待收货  4-已完成
@property (nonatomic,strong)NSString *whichTableView;

@end
