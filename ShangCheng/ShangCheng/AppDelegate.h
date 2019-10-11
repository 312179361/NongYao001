//
//  AppDelegate.h
//  ShangCheng
//
//  Created by TongLi on 2016/10/25.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
//枚举，用于区别是支付商品，还是充值
typedef NS_ENUM(NSInteger , PayType) {
    //枚举值
    PayTypePayOrder ,
    PayTypeRecharge
};

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//付款类型，是支付商品，还是充值
@property (nonatomic,assign)PayType payType;
//微信支付号
@property (nonatomic,strong)NSString *weiXinTradeNo;

@end

