//
//  RechargeViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/22.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "RechargeViewController.h"
#import "Manager.h"
#import "AlertManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "WXApi.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
//枚举，
typedef NS_ENUM(NSInteger , RechargeType) {
    //枚举值
    RechargeTypeAli ,
    RechargeTypeWX
};

@interface RechargeViewController ()
@property (nonatomic,assign)RechargeType rechargeType;
@property (weak, nonatomic) IBOutlet UITextField *rechargeAmountTextField;
@property (weak, nonatomic) IBOutlet UIImageView *selectAliButton;
@property (weak, nonatomic) IBOutlet UIImageView *selectWXButton;

@end

@implementation RechargeViewController
- (IBAction)leftBarbuttonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}


- (IBAction)rechargeTypeOneAction:(UITapGestureRecognizer *)sender {
    if (self.rechargeType != RechargeTypeAli) {
        self.rechargeType = RechargeTypeAli;
        [self updateSelectButtonUI];
    }
    
}

- (IBAction)rechargeTypeTwoAction:(UITapGestureRecognizer *)sender {
    if (self.rechargeType != RechargeTypeWX) {
        self.rechargeType = RechargeTypeWX;
        [self updateSelectButtonUI];
    }
    
}

//刷新选择button的UI
- (void)updateSelectButtonUI {
    [self keyboardDismissAction];

    if (self.rechargeType == RechargeTypeAli ) {
        [self.selectAliButton setImage:[UIImage imageNamed:@"g_btn_select"]];
        [self.selectWXButton setImage:[UIImage imageNamed:@"g_btn_normal"]];

    }
    if (self.rechargeType == RechargeTypeWX) {
        [self.selectAliButton setImage:[UIImage imageNamed:@"g_btn_normal"]];
        [self.selectWXButton setImage:[UIImage imageNamed:@"g_btn_select"]];
    }
}

//立即充值
- (IBAction)rechargeButtonAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    [self keyboardDismissAction];
    
    [alertM showAlertViewWithTitle:nil withMessage:@"是否要充值" actionTitleArr:@[@"取消",@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
        if (actionBlockNumber == 1) {
            NSLog(@"%@",self.rechargeAmountTextField.text);
            if (self.rechargeAmountTextField.text != nil && self.rechargeAmountTextField.text.length > 0) {
                if ([self.rechargeAmountTextField.text floatValue]>0) {
                    //有金额，调用后台接口，返回支付信息
                    if ([SVProgressHUD isVisible] == NO) {
                        [SVProgressHUD show];
                    }
                    
                    [manager userUserRechargeWithUserId:manager.memberInfoModel.u_id withAmount:self.rechargeAmountTextField.text withPayType:self.rechargeType withPayRechargeSuccess:^(id successResult) {
                        [SVProgressHUD dismiss];
                        
                        switch (self.rechargeType) {
                            case RechargeTypeAli:
                                [self aliPayRechargeActionWithPayInfo:successResult];
                                break;
                            case RechargeTypeWX:
                                [self weixinPayRechargeActionWithPayInfo:successResult];
                                break;
                            default:
                                break;
                        }
                        
                    } withPayRechargeFail:^(NSString *failResultStr) {
                        [SVProgressHUD dismiss];
                        [alertM showAlertViewWithTitle:nil withMessage:@"充值验证失败" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

                    }];
                    
                }else{
                    AlertManager *alertM = [AlertManager shareIntance];
                    [alertM showAlertViewWithTitle:nil withMessage:@"金额要大于0元" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
                }
            }else {
                AlertManager *alertM = [AlertManager shareIntance];
                [alertM showAlertViewWithTitle:nil withMessage:@"请输入充值金额" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
            }

        }
    }];
    
}





//支付宝充值
- (void)aliPayRechargeActionWithPayInfo:(NSDictionary *)payInfo {
    Manager *manager = [Manager shareInstance];
    NSString *orderInfo = [payInfo objectForKey:@"orderinfo"];
    
    NSString *appScheme = @"Nongyao001Alisdk";
    //区分是充值还是支付 将支付id传到appdelegate
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    app.payType = PayTypeRecharge;//充值方式
    // NOTE: 调用充值结果开始支付
    [[AlipaySDK defaultService] payOrder:orderInfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"同步reslut = %@",resultDic);
        if (resultDic != nil) {
            
            NSData *jsonData = [[resultDic objectForKey:@"result"] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            
            NSString *tempPayId = [[dic objectForKey:@"alipay_trade_app_pay_response"] objectForKey:@"out_trade_no"];
            NSLog(@"%@",tempPayId);
            
            //如果充值成功，就可以进行验证
            [manager afterRechargeWithTradeno:tempPayId withVerifyCount:5 withVerifySuccess:^(id successResult) {
                NSLog(@"%@",successResult);
                //验证成功
                AlertManager *alertM = [AlertManager shareIntance];
                [alertM showAlertViewWithTitle:@"充值结果" withMessage:successResult actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                    //返回 刷新充值金额
                    [self.navigationController popViewControllerAnimated:YES];
                }];

            } withVerifyFail:^(NSString *failResultStr) {
                NSLog(@"%@",failResultStr);
                AlertManager *alertM = [AlertManager shareIntance];
                [alertM showAlertViewWithTitle:@"充值结果" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

            }];
            
        }
    }];

    
}


//微信充值
- (void)weixinPayRechargeActionWithPayInfo:(NSDictionary *)payInfo {
    
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = [payInfo objectForKey:@"partnerid"];
    req.prepayId            = [payInfo objectForKey:@"prepayid"];
    req.nonceStr            = [payInfo objectForKey:@"noncestr"];
    req.timeStamp           = [[payInfo objectForKey:@"timestamp"] intValue];
    req.package             = @"Sign=WXPay";
    req.sign                = [payInfo objectForKey:@"sign"];
    [WXApi sendReq:req];
    
    //区分是充值还是支付 将支付id传到appdelegate
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    app.payType = PayTypeRecharge;//充值方式
    app.weiXinTradeNo = [payInfo objectForKey:@"tradeno"];

    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[payInfo objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );

    
    
}


- (void)keyboardDismissAction {
    [self.rechargeAmountTextField resignFirstResponder];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self keyboardDismissAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
