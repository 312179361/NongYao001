//
//  PayViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/13.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "PayViewController.h"
#import "PayTableViewCell.h"
#import "DownLinePayViewController.h"
#import "Manager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "WXApi.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "ShoppingCarViewController.h"
@interface PayViewController ()<UITableViewDataSource,UITableViewDelegate,WXApiDelegate>

@property (weak, nonatomic) IBOutlet UITableView *payTableView;
//订单金额
@property (weak, nonatomic) IBOutlet UILabel *orderAmountLabel;
//选择账户余额的按钮
@property (weak, nonatomic) IBOutlet UIButton *selectMemberBalanceButton;
@property (nonatomic,assign)BOOL isSelectBalance;//是否选择了余额
@property (nonatomic,assign)float useBalanceFloat;//使用的余额数量
//账户余额Label
@property (weak, nonatomic) IBOutlet UILabel *memberBalanceLabel;
@property (nonatomic,assign)float memberBalanceFloat;//账户余额
//另需支付
@property (weak, nonatomic) IBOutlet UILabel *otherPayLabel;

//支付方式datasource
@property (nonatomic,strong)NSMutableArray *payKindDataSourceArr;
//选择了哪种支付方式  0-支付宝 1-微信
@property (nonatomic,assign)NSInteger payKindInt;

//底部的两个Label
@property (weak, nonatomic) IBOutlet UILabel *bottomNeedPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomBalanceLabel;

@end

@implementation PayViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //通知，登陆成功
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payCompleteAction:) name:@"payComplete" object:nil];
    }
    return self;
}

//三方支付完成后 返回本应用的跳转
- (void)payCompleteAction:(NSNotification *)noti {
    AlertManager *alertM = [AlertManager shareIntance];
    NSString *msg =  [noti.userInfo objectForKey:@"msg"];
    [alertM showAlertViewWithTitle:@"支付结果" withMessage:msg actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
        //支付成功后，跳转到支付成功界面
        [self performSegueWithIdentifier:@"toPayCompleteVC" sender:nil];
    }];
    
}

//返回按钮
- (IBAction)backBarButtonAction:(UIBarButtonItem *)sender {
    NSLog(@"%@",self.navigationController.viewControllers);
    if ([self.navigationController.viewControllers[0] isKindOfClass:[ShoppingCarViewController class]]) {
        [self.navigationController popToRootViewControllerAnimated:YES];

    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



//默认的一些信息
- (void)defaultSomeData {
    //支付类型
    NSMutableDictionary *aliPayDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"d_icon_zfb",@"payImg",@"支付宝支付",@"payTitle",@"0",@"isSelectPay", nil];
    NSMutableDictionary *weiXinPayDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"d_icon_wxzf",@"payImg",@"微信支付",@"payTitle",@"0",@"isSelectPay", nil];
    NSMutableDictionary *downLinePayDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"d_icon_yhzz",@"payImg",@"线下银行转账",@"payTitle",@"0",@"isSelectPay", nil];
    
    NSArray *uplinePayArr = @[ @[aliPayDic], @[weiXinPayDic] ];
    NSArray *downlinePayArr = @[ @[downLinePayDic] ];
    self.payKindDataSourceArr = [NSMutableArray arrayWithObjects:uplinePayArr,downlinePayArr, nil];

    
    //默认的余额为零，等请求了余额信息后，在重新赋值
    self.memberBalanceFloat = 0.00;
    //由于余额为零，就只能三方支付，不能选择余额了
    self.selectMemberBalanceButton.enabled = NO;//选择余额按钮禁止点击
    [self isSelectBalanceUIWithSelectYesOrNo:NO];//
    //刷新UI
    [self updateHeaderView];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [SVProgressHUD dismiss];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //一些默认信息
    [self defaultSomeData];
    
    
    //查询账户余额
    Manager *manager = [Manager shareInstance];
    if ([SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];
    }

    [manager searchUserAmount:manager.memberInfoModel.u_id withAmountSuccessBlock:^(id successResult) {
        
        [SVProgressHUD dismiss];
        
//        self.memberBalanceFloat = 2.00;
        self.memberBalanceFloat = [[[successResult objectAtIndex:0] objectForKey:@"u_amount"] floatValue];
        //将最新的余额存入模型中
        manager.memberInfoModel.u_amount = [[[successResult objectAtIndex:0] objectForKey:@"u_amount"] floatValue];
        manager.memberInfoModel.u_amount_avail = [[[successResult objectAtIndex:0] objectForKey:@"u_amount_avail"] floatValue];
        manager.memberInfoModel.u_amount_frozen = [[[successResult objectAtIndex:0] objectForKey:@"u_amount_frozen"] floatValue];

        //有了余额 重新更新一下信息/
        if (self.memberBalanceFloat > 0) {
            //开启余额选择按钮
            self.selectMemberBalanceButton.enabled = YES;
            //有余额就默认选择余额
            [self isSelectBalanceUIWithSelectYesOrNo:YES];
            //刷新UI
            [self updateHeaderView];
            
        }
        
    } withAmountFailBlock:^(NSString *failResultStr) {
        [SVProgressHUD dismiss];
        
    }];
    
}



//选择余额与否
- (void)isSelectBalanceUIWithSelectYesOrNo:(BOOL)yesOrNo {

    if (yesOrNo == YES) {
        //如果是YES。修改UI和判断
        self.isSelectBalance = YES;
        //如果余额不足，那么 使用余额=余额全部；如果余额充足，那么 使用余额=总价格
        if (self.memberBalanceFloat < self.totalAmountFloat) {
            //余额不足
            self.useBalanceFloat = self.memberBalanceFloat;
            //需要三方支付.默认是支付宝
            self.payKindInt = 0;
        }else {
            //余额充足
            self.useBalanceFloat = self.totalAmountFloat;
            //不需要三方支付
            self.payKindInt = -1;

        }
        //
        //另需支付=总价格-使用余额
        self.otherPayLabel.text = [NSString stringWithFormat:@"%.2f",self.totalAmountFloat-self.useBalanceFloat];
        
        [self.selectMemberBalanceButton setBackgroundImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];
        
    }else {
        //否则。另需支付=总价格
        self.isSelectBalance = NO;
        self.useBalanceFloat = 0.00;
//        self.selectMemberBalanceButton.backgroundColor = [UIColor lightGrayColor];
        [self.selectMemberBalanceButton setBackgroundImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];

        //需要三方支付.默认是支付宝
        self.payKindInt = 0;
        
        self.otherPayLabel.text = [NSString stringWithFormat:@"%.2f",self.totalAmountFloat];
        
    }
    
    //底部还需支付。如果余额不足，还需支付和另需支付一样
    self.bottomNeedPayLabel.text = [NSString stringWithFormat:@"  还需支付:￥%@", self.otherPayLabel.text ];
    //底部的余额支付，就是使用余额
    self.bottomBalanceLabel.text = [NSString stringWithFormat:@"  余额支付:￥%.2f",self.useBalanceFloat ];
    
    //刷新一下TableView的UI，主要是三方支付的选择按钮状态
    [self.payTableView reloadData];

}




- (void)updateHeaderView {
    self.orderAmountLabel.text = [NSString stringWithFormat:@"%.2f",self.totalAmountFloat ];
    
    self.memberBalanceLabel.text = [NSString stringWithFormat:@"账户余额：%.2f",self.memberBalanceFloat];
    
}

//选择余额按钮
- (IBAction)selectBalanceButtonAction:(UIButton *)sender {
    self.isSelectBalance = !self.isSelectBalance;
    [self isSelectBalanceUIWithSelectYesOrNo:self.isSelectBalance];
    

}

#pragma mark - TableViewDelegate - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.payKindDataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.payKindDataSourceArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PayTableViewCell *payCell = [tableView dequeueReusableCellWithIdentifier:@"payCellIdentifier" forIndexPath:indexPath];
    
    NSDictionary *jsonDic = [[self.payKindDataSourceArr[indexPath.section] objectAtIndex:indexPath.row] firstObject];
    
    if (indexPath.section == 0 && self.payKindInt == indexPath.row) {
        [payCell updatePayCellWithJsonDic:jsonDic withShowSelectPayKind:YES];
    }else {
        [payCell updatePayCellWithJsonDic:jsonDic withShowSelectPayKind:NO];
    }
    
    return payCell;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

   //没有选择余额，或者余额不足，就需要三方支付
    if (self.isSelectBalance == NO || self.memberBalanceFloat < self.totalAmountFloat) {
        NSLog(@"需要三方支付");
        //线上支付
        if (indexPath.section == 0) {
            //记录下，支付方式
            self.payKindInt = indexPath.row;
            [self.payTableView reloadData];
        }
        
        //如果是线下支付，就跳转
        if (indexPath.section == 1) {
            [self performSegueWithIdentifier:@"toDownLinePayVC" sender:nil];
        }
        
    }else{
        NSLog(@"不需要三方支付");
    }
    
    
//    if ([self.totalAmountStr floatValue] > [self.selectBalanceStr floatValue]) {
//        NSLog(@"需要三方支付");
//        
//        //先清空所有的状态
//        for (NSArray *tempPayKindArr in self.payKindDataSourceArr) {
//            
//            for (NSArray *tempDetailKindArr in tempPayKindArr) {
//                NSDictionary *tempJsonDic = [tempDetailKindArr firstObject];
//                [tempJsonDic setValue:@"0" forKey:@"isSelectPay"];
//            }
//        }
//        
//        //选择了某种支付方式
//        NSDictionary *jsonDic = [[self.payKindDataSourceArr[indexPath.section] objectAtIndex:indexPath.row] firstObject];
//        [jsonDic setValue:@"1" forKey:@"isSelectPay"];
//        
//        if (indexPath.section == 0) {
//            switch (indexPath.row) {
//                case 0:
//                    //支付宝
//                    self.payKindInt = 11;
//                    break;
//                case 1:
//                    //微信
//                    self.payKindInt = 12;
//                    break;
//                default:
//                    break;
//            }
//        }else {
//            //section == 1
//            //线下
//            self.payKindInt = 21;
//        }
//        
//        //刷新UI
//        [self.payTableView reloadData];
//
//        
//    }else {
//        NSLog(@"三方不需支付");
//    }
//
    
    
   
}

#pragma mark - 支付 -

- (IBAction)enterPayButtonAction:(UIButton *)sender {
    AlertManager *alertM = [AlertManager shareIntance];
    //没有选择余额，或者余额不足，就需要三方支付，即网上支付，线下支付，会跳转到其他页面
    Manager *manager = [Manager shareInstance];
    NSLog(@"总价：%@ -- 使用余额：%@ -- 支付金额%@",[NSString stringWithFormat:@"%.2f",self.totalAmountFloat],[NSString stringWithFormat:@"%.2f",self.useBalanceFloat],[NSString stringWithFormat:@"%.2f",self.totalAmountFloat-self.useBalanceFloat]);
    
   
    [alertM showAlertViewWithTitle:nil withMessage:@"立即支付此订单?" actionTitleArr:@[@"否",@"是"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
        if (actionBlockNumber == 1) {
            if (self.isSelectBalance == NO || self.memberBalanceFloat < self.totalAmountFloat) {
                
                if (self.payKindInt == 0) {
                    //进行支付验证 --- 支付宝
                    if ([SVProgressHUD isVisible] == NO) {
                        [SVProgressHUD show];
                    }
                    
                    [manager paybeforeVerifyWithUserId:manager.memberInfoModel.u_id withTotalAmount:[NSString stringWithFormat:@"%.2f",self.totalAmountFloat] withBalance:[NSString stringWithFormat:@"%.2f",self.useBalanceFloat] withPayAmount:[NSString stringWithFormat:@"%.2f",self.totalAmountFloat-self.useBalanceFloat] withOrderIdArr:self.orderIDArr withPayType:@"0" withVerifySuccessBlock:^(id successResult) {
                        [SVProgressHUD dismiss];
                        
                        //验证成功，可以支付了。，
                        [self aliPayActionWithOrderInfo:[successResult objectForKey:@"orderinfo"]];
                        
                    } withVerfityFailBlock:^(NSString *failResultStr) {
                        [SVProgressHUD dismiss];
                        [alertM showAlertViewWithTitle:nil withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
                        
                        
                    }];
                    
                }else {
                    //微信
                    if ([SVProgressHUD isVisible] == NO) {
                        [SVProgressHUD show];
                    }
                    [manager paybeforeVerifyWithUserId:manager.memberInfoModel.u_id withTotalAmount:[NSString stringWithFormat:@"%.2f",self.totalAmountFloat] withBalance:[NSString stringWithFormat:@"%.2f",self.useBalanceFloat] withPayAmount:[NSString stringWithFormat:@"%.2f",self.totalAmountFloat-self.useBalanceFloat] withOrderIdArr:self.orderIDArr withPayType:@"1" withVerifySuccessBlock:^(id successResult) {
                        [SVProgressHUD dismiss];
                        
                        //验证成功，可以支付了。，
                        [self weixinPayAction:successResult];
                        
                    } withVerfityFailBlock:^(NSString *failResultStr) {
                        [SVProgressHUD dismiss];
                        [alertM showAlertViewWithTitle:nil withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
                        
                    }];
                    
                }
                
            }else {
                //风火轮
                if ([SVProgressHUD isVisible] == NO) {
                    [SVProgressHUD show];
                }
                
                //        //直接通过余额支付
                //        [self performSegueWithIdentifier:@"toPayCompleteVC" sender:nil];
                
                NSLog(@"%@",[NSString stringWithFormat:@"%.2f",self.totalAmountFloat]);
                NSLog(@"%@",[NSString stringWithFormat:@"%.2f",self.useBalanceFloat]);
                NSLog(@"%@",[NSString stringWithFormat:@"%.2f",self.totalAmountFloat-self.useBalanceFloat]);

                
                
                //验证
                [manager paybeforeVerifyWithUserId:manager.memberInfoModel.u_id withTotalAmount:[NSString stringWithFormat:@"%.2f",self.totalAmountFloat] withBalance:[NSString stringWithFormat:@"%.2f",self.useBalanceFloat] withPayAmount:[NSString stringWithFormat:@"%.2f",self.totalAmountFloat-self.useBalanceFloat] withOrderIdArr:self.orderIDArr withPayType:@"6" withVerifySuccessBlock:^(id successResult) {
                    
                    //验证成功后，进行余额支付
                    [manager userConfirmPayWithUserID:manager.memberInfoModel.u_id withRID:[successResult objectForKey:@"tradeno"] withPayCode:@""  withBank:@"" withUserConfirmPaySuccess:^(id successResult) {
                        [SVProgressHUD dismiss];//风火轮消失
                        
                        
                        //支付成功后，跳转到支付成功界面
                        [self performSegueWithIdentifier:@"toPayCompleteVC" sender:nil];
                        
                    } withPayFail:^(NSString *failResultStr) {
                        [SVProgressHUD dismiss];//风火轮消失
                        [alertM showAlertViewWithTitle:nil withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
                        
                    }];
                    
                    
                    
                    
                } withVerfityFailBlock:^(NSString *failResultStr) {
                    [SVProgressHUD dismiss];
                    
                }];
                
                
            }

        }
    }];
    
}




#pragma mark - 支付宝支付 -
- (void)aliPayActionWithOrderInfo:(NSString *)orderInfo {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];

    NSString *appScheme = @"Nongyao001Alisdk";

    //区分是充值还是支付 将支付id传到appdelegate
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    app.payType = PayTypePayOrder;//支付方式

    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderInfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"同步reslut = %@",resultDic);
        if (resultDic != nil) {
            
            NSData *jsonData = [[resultDic objectForKey:@"result"] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            
            NSString *tempPayId = [[dic objectForKey:@"alipay_trade_app_pay_response"] objectForKey:@"out_trade_no"];
            NSLog(@"%@",tempPayId);
            
            
            //如果支付成功，就可以进行验证签名了
            [manager afterPayOrderPaymentVerifyWithPayId:tempPayId withVerifyCount:5 withPaymentVerifySuccess:^(id successResult) {
                NSLog(@"%@",successResult);
                
#warning 支付成功后，返回到哪个界面
                //支付成功后，跳转到支付成功界面
                [self performSegueWithIdentifier:@"toPayCompleteVC" sender:nil];

                
            } withPaymentVerifyFail:^(NSString *failResultStr) {
                NSLog(@"%@",failResultStr);
                [alertM showAlertViewWithTitle:nil withMessage:@"支付验证失败，请尽快联系客服处理" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
            }];
            
        }
        
    }];

    
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
//    NSString *appID = appId;
//    NSString *privateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
//    //partner和seller获取失败,提示
//    if ([appID length] == 0 ||
//        [privateKey length] == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"缺少appId或者私钥。"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
    
    /*
     *生成订单信息及签名
     */
    /*
    //userid
    NSString *tempUserId = manager.memberInfoModel.u_id;

    NSString *tempTotalamount = [NSString stringWithFormat:@"%.2f",self.totalAmountFloat ]; //订单总额;
    NSString *tempBalance = [NSString stringWithFormat:@"%.2f",self.useBalanceFloat ];
    
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appId;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    order.format = @"json";
    order.notify_url = @"http://118.178.224.54:8001/api/AlipayNotifyUrl";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type设置
    order.sign_type = @"RSA";
    //回传参数

    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = @"导演最帅";
    order.biz_content.subject = @"1";
    //支付ID
    order.biz_content.out_trade_no = payId; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = payMoney; //商品价格
    
    //订单数组封装成字典
    NSMutableArray *tempOrderIDArr = [NSMutableArray array];
    for (NSString *tempOrderID in self.orderIDArr) {
        NSDictionary *tempOrderIdDic = @{@"pid":tempOrderID};
        [tempOrderIDArr addObject:tempOrderIdDic];
    }
    
    NSString *tempPassback_params = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[self dictionaryToJson:@{@"userid":tempUserId,@"totalamount":tempTotalamount,@"balance":tempBalance,@"item":tempOrderIDArr}], NULL, (CFStringRef)@"!*'();:@&=+ $,./?%#[]", kCFStringEncodingUTF8));

    order.biz_content.passback_params = tempPassback_params;
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    NSLog(@"orderSpec2222 = %@",orderInfoEncoded);

    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
     */
//    //开始签名接口
//    [manager aliPaySignDataStr:orderInfoEncoded withSignSuccessResult:^(id successResult) {
//        
//        //签名后的字符串
//        NSString *signedString = [successResult objectForKey:@"sign"];
////        NSString *signedString = @"";
////        NSString *orderAndSing = [NSString stringWithFormat:@"%@&sign=%@",orderInfo ,[successResult objectForKey:@"sign"] ];
//        
//        
////           NSString *signedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)oldsignedString, NULL, (CFStringRef)@"!*'();:@&=+ $,./?%#[]", kCFStringEncodingUTF8));
//        
//        
//        
//        // NOTE: 如果加签成功，则继续执行支付
//        if (signedString != nil) {
//            //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
//            NSString *appScheme = @"Nongyao001Alisdk";
//            
//            // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
//            
//            NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",orderInfoEncoded, signedString];
//            
//            // NOTE: 调用支付结果开始支付
//            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//                NSLog(@"同步reslut = %@",resultDic);
//                if (resultDic != nil) {
//
//                    NSData *jsonData = [[resultDic objectForKey:@"result"] dataUsingEncoding:NSUTF8StringEncoding];
//                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//                    
//                    NSString *tempPayId = [[dic objectForKey:@"alipay_trade_app_pay_response"] objectForKey:@"out_trade_no"];
//                    NSLog(@"%@",tempPayId);
//
//                    //如果支付成功，就可以进行验证签名了
//                    [manager afterPayOrderPaymentVerifyWithPayId:tempPayId withPaymentVerifySuccess:^(id successResult) {
//                        NSLog(@"%@",successResult);
//                        
//#warning 支付成功后，返回到哪个界面
//                        
//                    } withPaymentVerifyFail:^(NSString *failResultStr) {
//                        NSLog(@"%@",failResultStr);
//                    }];
//                    
//                }
//
//                
//            }];
//
//            
//            
//        }
//        
//        
//    } withSignFailResult:^(NSString *failResultStr) {
//        //签名失败
//    }];
    
    
 
    
}

#pragma mark - 微信支付 -
//微信支付
- (void)weixinPayAction:(NSDictionary *)orderReq {
    
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = [orderReq objectForKey:@"partnerid"];
    req.prepayId            = [orderReq objectForKey:@"prepayid"];
    req.nonceStr            = [orderReq objectForKey:@"noncestr"];
    req.timeStamp           = [[orderReq objectForKey:@"timestamp"] intValue];
    req.package             = @"Sign=WXPay";
    req.sign                = [orderReq objectForKey:@"sign"];
    [WXApi sendReq:req];
    
    //区分是充值还是支付 将支付id传到appdelegate
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];

    app.payType = PayTypePayOrder;//支付方式
    app.weiXinTradeNo = [orderReq objectForKey:@"tradeno"];
    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[orderReq objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );

    
}



#pragma mark - 将字典变为json格式的字符串 -
- (NSString *)dictionaryToJson:(id )dic {
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *tempStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return tempStr;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"toDownLinePayVC"]) {
        DownLinePayViewController *downLinePayVC = [segue destinationViewController];
        downLinePayVC.isSelectBalance = self.isSelectBalance;
        downLinePayVC.memberBalanceFloat = self.memberBalanceFloat;
        downLinePayVC.orderTotalAmountFloat = self.totalAmountFloat;
        downLinePayVC.orderIDArr = self.orderIDArr;
        downLinePayVC.receiverName = self.receiverName;
        downLinePayVC.receiverPhone = self.receiverPhone;
        downLinePayVC.selectBalanceBlock = ^{
            //默认选择余额
            self.isSelectBalance = YES;
            [self isSelectBalanceUIWithSelectYesOrNo:self.isSelectBalance];


        };
        
        
    }
}




@end
