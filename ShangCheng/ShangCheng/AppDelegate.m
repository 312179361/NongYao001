//
//  AppDelegate.m
//  ShangCheng
//
//  Created by TongLi on 2016/10/25.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "AppDelegate.h"
#import "Manager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

#import "SVProgressHUD.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "LeadViewController.h"




@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSLog(@"%f -- %f",kScreenW,kScreenH);
    //状态栏白色
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    Manager *manager = [Manager shareInstance];

    //判断用户是否第一次使用，如果第一次使用，就要进入引导页
    if ([manager isFirstJoinApp] == YES) {
        //第一次登陆将入口设为引导页
        //1.找到storyBoard
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //2.找到第一个storyBoard中的黄色控制器
        LeadViewController *leadVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"identifierLeader"];
        
        self.window.rootViewController = leadVC;
        
    }
    
    
    //获取本地购物车 和 数量
    [manager getLocationShoppingCar];
    [manager getLocationShoppingCarNumber];
    
  
    
    
    
    
    //从本地读取个人信息，然后尝试自动登录一下
    BOOL result = [manager readMemberInfoModelFromLocation];
    if (result == YES) {
        //有个人信息。尝试一下登陆
//        MemberInfoModel *model = [Manager shareInstance].memberInfoModel;
        NSLog(@"%@--%@",manager.memberInfoModel.u_mobile,manager.memberInfoModel.userPassword);
        //风火轮显示
        [SVProgressHUD show];
        [[Manager shareInstance] loginActionWithUserID:manager.memberInfoModel.u_mobile withPassword:manager.memberInfoModel.userPassword withLoginSuccessResult:^(id successResult) {
            NSLog(@"免登陆成功");
            //烽火论消失
            [SVProgressHUD dismiss];
            //获取购物车数量，显示在tabbar上
            [manager httpShoppingCarNumberWithUserid:manager.memberInfoModel.u_id withNumberSuccess:^(id successResult) {

            } withNumberFail:^(NSString *failResultStr) {
                
            }];
            
        } withLoginFailResult:^(NSString *failResultStr) {
            //烽火论消失
            [SVProgressHUD dismiss];
            NSLog(@"免登陆失败--%@",failResultStr);
        }];
        
    }
    //向微信注册
    [WXApi registerApp:@"wxad3c689bdfacc02c"];
    
    //极光注册
    [self registerJpushNotificationWithLaunchOptions:launchOptions];
    //进入程序。清空角标
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];

    //shareSDK分享注册
    [self registerShareSDK];
    
    return YES;
}

- (void)registerShareSDK {
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"1ce4ae67275fd"
     
          activePlatforms:@[
                            //                            @(SSDKPlatformTypeSinaWeibo),
                            //                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            //                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformSubTypeQQFriend),
                            @(SSDKPlatformSubTypeQZone)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxad3c689bdfacc02c"
                                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1104679184"
                                      appKey:@"63WyIVtrcdffzavU"
                                    authType:SSDKAuthTypeBoth];
                 break;
            default:
                 break;
         }
     }];
}


//注册极光
- (void)registerJpushNotificationWithLaunchOptions:(NSDictionary *)launchOptions {

    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"0e7ffb64c4a20b8f8b9cecda"
                          channel:nil
                 apsForProduction:YES
            advertisingIdentifier:nil];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    Manager *manager = [Manager shareInstance];

    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"异步result = %@",resultDic);
            NSData *jsonData = [[resultDic objectForKey:@"result"] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            
            NSString *tempPayId = [[dic objectForKey:@"alipay_trade_app_pay_response"] objectForKey:@"out_trade_no"];
            NSLog(@"%@",tempPayId);
            
            //如果支付成功，就可以进行验证签名了
            [manager afterPayOrderPaymentVerifyWithPayId:tempPayId withVerifyCount:5 withPaymentVerifySuccess:^(id successResult) {
                NSLog(@"%@",successResult);
                
#warning 支付成功后，返回到哪个界面
                [[NSNotificationCenter defaultCenter] postNotificationName:@"payComplete" object:self userInfo:nil];
                
            } withPaymentVerifyFail:^(NSString *failResultStr) {
                NSLog(@"%@",failResultStr);
            }];

        }];
    }else if([url.host isEqualToString:@"pay"]) {
        //微信支付
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{

    //支付宝
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            //支付后了。去后台验证
            if (resultDic != nil) {
                NSData *jsonData = [[resultDic objectForKey:@"result"] dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                //支付宝的支付号
                NSString *tempPayId = [[dic objectForKey:@"alipay_trade_app_pay_response"] objectForKey:@"out_trade_no"];
                NSLog(@"%@",tempPayId);
                
                switch (self.payType) {
                    case PayTypePayOrder:
                        //支付验证
                        [self payOrderVerifyWithPayId:tempPayId];
                        break;
                    case PayTypeRecharge:
                        //充值验证
                        [self rechargeVerifyWithPayId:tempPayId];
                    default:
                        break;
                }
                
                
            }
        }];
    }else if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];

    }
    
    
    return YES;
}

//微信支付的回调
-(void) onResp:(BaseResp*)resp {
    //支付返回结果，实际支付结果需要去微信服务器端查询
    
    switch (resp.errCode) {
        case WXSuccess:
        {
            if (self.weiXinTradeNo!=nil && self.weiXinTradeNo.length > 0) {
                //支付成功,调用接口认证
                switch (self.payType) {
                    case PayTypePayOrder:
                        //支付订单
                        [self payOrderVerifyWithPayId:self.weiXinTradeNo];
                        break;
                    case PayTypeRecharge:
                        //充值
                        [self rechargeVerifyWithPayId:self.weiXinTradeNo];
                    default:
                        break;
                }

            }
        
        }
            break;
            
        default:
        {
            NSString * strMsg = [NSString stringWithFormat:@"支付结果：失败！retstr = %@",resp.errStr];
            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:strMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];

        }
            break;
    }
    
}



//支付验证
- (void)payOrderVerifyWithPayId:(NSString *)payId {
    Manager *manager = [Manager shareInstance];
    //如果支付成功，就可以进行验证签名了
    [manager afterPayOrderPaymentVerifyWithPayId:payId withVerifyCount:5 withPaymentVerifySuccess:^(id successResult) {
        NSLog(@"%@",successResult);
#warning 支付成功后，返回到哪个界面

        [[NSNotificationCenter defaultCenter] postNotificationName:@"payComplete" object:self userInfo:@{@"msg":successResult}];

        
        
        
    } withPaymentVerifyFail:^(NSString *failResultStr) {
        NSLog(@"%@",failResultStr);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"支付验证失败，请联系客服" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];

}

//充值验证
- (void)rechargeVerifyWithPayId:(NSString *)payId {
    Manager *manager = [Manager shareInstance];
    [manager afterRechargeWithTradeno:payId withVerifyCount:5 withVerifySuccess:^(id successResult) {
        NSLog(@"%@",successResult);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:successResult delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
#warning 充值成功后，返回到哪个界面

    } withVerifyFail:^(NSString *failResultStr) {
        NSLog(@"%@",failResultStr);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"支付验证失败，请联系客服" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}







#pragma mark - 注册APNs成功并上报DeviceToken -
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
#pragma mark - 实现注册APNs失败接口（可选） -
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
   
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
