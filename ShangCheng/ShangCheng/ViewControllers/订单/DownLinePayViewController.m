//
//  DownLinePayViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/18.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "DownLinePayViewController.h"
#import "DownLineTableViewCell.h"
#import "AlertManager.h"
#import "Manager.h"
#import "SVProgressHUD.h"
@interface DownLinePayViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *bankArr;
//选择余额按钮button
@property (weak, nonatomic) IBOutlet UIButton *selectBalanceButton;
@property (nonatomic,assign) float useBalanceFloat;//使用了多少余额
//账户余额Label
@property (weak, nonatomic) IBOutlet UILabel *memberBalanceLabel;
//总额Label
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
//实际支付金额
@property (weak, nonatomic) IBOutlet UILabel *payAmountLabel;


@end

@implementation DownLinePayViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    NSString *jsonPath = [[NSBundle mainBundle]pathForResource:@"bankJson" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    //解析得到返回结果
     NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    self.bankArr = [NSMutableArray arrayWithArray:jsonArr];
    
    //账户余额
    self.memberBalanceLabel.text = [NSString stringWithFormat:@"账户余额：%.2f",self.memberBalanceFloat];
    
    //有余额按钮才可以点击,
    if (self.memberBalanceFloat > 0.00) {
        self.selectBalanceButton.enabled = YES;
    }else {
        //没有余额，不可点击
        self.selectBalanceButton.enabled = NO;
        self.isSelectBalance = NO;
    }
    //通过余额更新一些信息
    [self updateDataAndUIWithUseBalanceYesOrNo:self.isSelectBalance];
    
    //订单总额
    self.totalAmountLabel.text = [NSString stringWithFormat:@"总额：%.2f", self.orderTotalAmountFloat];
}

//通过是否选择余额更新一些信息
- (void)updateDataAndUIWithUseBalanceYesOrNo:(BOOL)yesOrNo {
    if (yesOrNo == YES) {
        //如果是选择了余额
        //改变button的样式
        [self.selectBalanceButton setImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];

        //余额不足， 使用余额 = 余额全部.
        self.useBalanceFloat = self.memberBalanceFloat;
        
    }else {
        //改变button的样式
        [self.selectBalanceButton setImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];
        //不选择余额，那么余额为0
        self.useBalanceFloat = 0.00;
    }
    //实际转款 = 总额 - 使用余额
    self.payAmountLabel.text = [NSString stringWithFormat:@"%.2f",self.orderTotalAmountFloat - self.useBalanceFloat];
    
}

//选择余额按钮
- (IBAction)selectBalanceButtonAction:(UIButton *)sender {
    
    AlertManager *alertM = [AlertManager shareIntance];
    //反转状态
    self.isSelectBalance = !self.isSelectBalance;
    if (self.isSelectBalance == YES) {
        //余额充足，就可以全部用余额进行付款，就可以返回上个界面
        if (self.memberBalanceFloat >= self.orderTotalAmountFloat) {
            [alertM showAlertViewWithTitle:nil withMessage:@"您的余额可以支付这个订单，不需要银行卡支付，是否选择余额支付" actionTitleArr:@[@"取消",@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                if (actionBlockNumber == 0) {
                    //取消，即不使用余额支付，那么就将账户余额未选择，
                    self.isSelectBalance = NO;
                    [self updateDataAndUIWithUseBalanceYesOrNo:self.isSelectBalance];

                }
                if (actionBlockNumber == 1) {
                    //确定，即使用月支付那么就返回到支付界面
                    //block使得上个界面默认选择余额
                    self.selectBalanceBlock();
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }else {
            //如果余额不充足，那就一部分余额一部分用银行卡支付
            [self updateDataAndUIWithUseBalanceYesOrNo:self.isSelectBalance];

        }
        
    }else {
        //没有选择余额
        //更新
        [self updateDataAndUIWithUseBalanceYesOrNo:self.isSelectBalance];

    }
}


#pragma mark - tableView delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bankArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DownLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bankCellIndentifier" forIndexPath:indexPath];
    //点击cell没有灰色阴影效果
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateBankUIWithBankDic:self.bankArr[indexPath.row]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for (NSMutableDictionary *tempDic in self.bankArr) {
        [tempDic setObject:@"NO" forKey:@"isSelect"];
    }
    
    NSMutableDictionary *selectDic = self.bankArr[indexPath.row];
    [selectDic setObject:@"YES" forKey:@"isSelect"];
    
    [tableView reloadData];
}

#pragma mark - 底部的两个按钮 -
//发送卡号到手机
- (IBAction)sendCardNumberToPhoneButtonAction:(UIButton *)sender {
    //找到点击的是哪个
    
    

    NSInteger selectInt = -1;
    for (int i = 0; i < self.bankArr.count; i++) {
        NSMutableDictionary *tempDic = self.bankArr[i];
        if ([[tempDic objectForKey:@"isSelect"] isEqualToString:@"YES"]) {
            selectInt = i;
        }
    }
    
    
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    NSLog(@"%@ -- %ld",manager.memberInfoModel.u_mobile,selectInt);
    if (manager.memberInfoModel.u_mobile.length == 11 && selectInt >= 0) {
        [alertM showAlertViewWithTitle:nil withMessage:[NSString stringWithFormat:@"是否给%@发送银行卡号",self.receiverPhone] actionTitleArr:@[@"取消",@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
            if (actionBlockNumber == 1) {
                //发送手机号
                /*
                 bankindex，0（中国农业银行），
                 1（中国建设银行）,
                 2（中国工商银行）,
                 3（中国农村信用合作社）,
                 */
                NSLog(@"%@",self.payAmountLabel.text);
                
                [manager httpSendBankCardWithTel:self.receiverPhone withName:self.receiverName withPayAmount:self.payAmountLabel.text withBankType:selectInt withSendBankSuccess:^(id successResult) {
                    [alertM showAlertViewWithTitle:nil withMessage:@"发送成功，请注意查收" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
                    
                } withSendBankFail:^(NSString *failResultStr) {
                    [alertM showAlertViewWithTitle:nil withMessage:@"发送失败，请稍后再试" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

                }];
            }
        }];
    }
    
}


//我已经线下转款按钮
- (IBAction)downLinePayButtonAction:(UIButton *)sender {
    //找到点击的是哪个
    AlertManager *alertM = [AlertManager shareIntance];
    
    NSDictionary *bankDic = [NSDictionary dictionary];
    for (NSMutableDictionary *tempDic in self.bankArr) {
        if ([[tempDic objectForKey:@"isSelect"] isEqualToString:@"YES"]) {
            bankDic = tempDic;
        }
    }
    
    NSLog(@"%@",bankDic);
    NSLog(@"%@",[NSString stringWithFormat:@"%.2f",self.orderTotalAmountFloat - self.useBalanceFloat]);
    //发起线下转账接口
    Manager *manager = [Manager shareInstance];
    //先验证
    if ([SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];
    }

    [manager paybeforeVerifyWithUserId:manager.memberInfoModel.u_id withTotalAmount:[NSString stringWithFormat:@"%.2f",self.orderTotalAmountFloat] withBalance:[NSString stringWithFormat:@"%.2f",self.useBalanceFloat] withPayAmount:[NSString stringWithFormat:@"%.2f",self.orderTotalAmountFloat - self.useBalanceFloat] withOrderIdArr:self.orderIDArr withPayType:@"5" withVerifySuccessBlock:^(id successResult) {
        
        //验证成功后，进行余额支付
        [manager userConfirmPayWithUserID:manager.memberInfoModel.u_id withRID:[successResult objectForKey:@"tradeno"] withPayCode:@"" withBank:[bankDic objectForKey:@"bankName"] withUserConfirmPaySuccess:^(id successResult) {
            [SVProgressHUD dismiss];//风火轮消失
            
            
            //支付成功后，跳转到支付成功界面
            [self performSegueWithIdentifier:@"downLineToCompleteVC" sender:nil];
            
        } withPayFail:^(NSString *failResultStr) {
            [SVProgressHUD dismiss];//风火轮消失
            [alertM showAlertViewWithTitle:nil withMessage:@"支付验证失败，请尽快联系客服" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }];
        
    } withVerfityFailBlock:^(NSString *failResultStr) {
        [SVProgressHUD dismiss];
        [alertM showAlertViewWithTitle:nil withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

    }];

    
    
    
    
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
