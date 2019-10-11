//
//  AgentCashApplicationViewController.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/2.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgentCashApplicationViewController : UIViewController
/*
 userCash用户提现。包含普通用户和代理商的余额提现
 agentCash代理商收益提现。即代理商的收益金额提现
 */
@property(nonatomic,strong)NSString *cashType;
//代理商收益提现 -- 可提现金额
@property(nonatomic,strong)NSString *agentCashCommission;
@end
