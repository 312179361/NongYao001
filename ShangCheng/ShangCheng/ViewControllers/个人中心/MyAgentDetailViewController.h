//
//  MyAgentDetailViewController.h
//  ShangCheng
//
//  Created by TongLi on 2017/12/5.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
//枚举
typedef NS_ENUM(NSInteger , MyAgentType) {
    MyPeople,//我的客户
    PeopleOrder, //客户订单
    Kong, //提现记录
    PeopleFavorite,//客户收藏
    PeopleShopCar,//购物车
    Commission//提成流水
};

@interface MyAgentDetailViewController : UIViewController
@property(nonatomic,assign)MyAgentType myAgentType;

@end
