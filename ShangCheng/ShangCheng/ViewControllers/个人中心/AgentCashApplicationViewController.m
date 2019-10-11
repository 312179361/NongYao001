//
//  AgentCashApplicationViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/2.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "AgentCashApplicationViewController.h"
#import "Manager.h"
#import "SVProgressHUD.h"
//下面两个宏 是用于输入金额的限制
#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"
@interface AgentCashApplicationViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *selectAgentTypeView;//选择提现方式的view
@property (weak, nonatomic) IBOutlet UIImageView *selectAgentTypeIntoIcon;//右边的into箭头
@property (weak, nonatomic) IBOutlet UIImageView *selectTypeImageView;//提现图标，是支付宝还是微信等
@property (weak, nonatomic) IBOutlet UILabel *selectTypeNameLabel;//提现名称，


@property (weak, nonatomic) IBOutlet UIView *nameView;//姓名view
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameViewHeightLayout;//姓名view的高度
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;//姓名输入框

@property (weak, nonatomic) IBOutlet UIView *codeView;//账号view
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeViewHeightLayout;//账号view的高度
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;//账号输入框

@property (weak, nonatomic) IBOutlet UITextField *agentCashAmountTextField;//提现金额

@property (weak, nonatomic) IBOutlet UILabel *userBalanceLabel;//可用金额Label

@property (weak, nonatomic) IBOutlet UILabel *cashRemindLabel;//提醒Label

@property (weak, nonatomic) IBOutlet UIButton *enterAgentCashButton;//确认提现button

//选择的方式0-支付宝，1-微信，2-银行卡
@property (nonatomic,assign)NSInteger selectTypeInt;


//

@end

@implementation AgentCashApplicationViewController
//输入金额的限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    // 判断是否输入内容，或者用户点击的是键盘的删除按钮
    if (![string isEqualToString:@""]) {
        NSCharacterSet *cs;
        // 小数点在字符串中的位置 第一个数字从0位置开始
        
        NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
        
        // 判断字符串中是否有小数点，并且小数点不在第一位
        
        // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
        
        // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
        
        if (dotLocation == NSNotFound && range.location != 0) {
            
            // 取只包含“myDotNumbers”中包含的内容，其余内容都被去掉
            
            /* [NSCharacterSet characterSetWithCharactersInString:myDotNumbers]的作用是去掉"myDotNumbers"中包含的所有内容，只要字符串中有内容与"myDotNumbers"中的部分内容相同都会被舍去在上述方法的末尾加上invertedSet就会使作用颠倒，只取与“myDotNumbers”中内容相同的字符
             */
            cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers] invertedSet];
            if (range.location >= 9) {
                NSLog(@"单笔金额不能超过亿位");
                if ([string isEqualToString:@"."] && range.location == 9) {
                    return YES;
                }
                return NO;
            }
        }else {
            
            cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
            
        }
        // 按cs分离出数组,数组按@""分离出字符串
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        BOOL basicTest = [string isEqualToString:filtered];
        
        if (!basicTest) {
            
            NSLog(@"只能输入数字和小数点");
            
            return NO;
            
        }
        
        if (dotLocation != NSNotFound && range.location > dotLocation + 2) {
            
            NSLog(@"小数点后最多两位");
            
            return NO;
        }
        if (textField.text.length > 11) {
            
            return NO;
            
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.cashType isEqualToString:@"agentCash"]) {
        //代理商收益提现
        NSInteger availInt = [textField.text integerValue];
        textField.text = [NSString stringWithFormat:@"%ld", availInt/50 * 50];
    }
    
    
}


- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Manager *manager = [Manager shareInstance];    
    //用户余额提现
    if ([self.cashType isEqualToString:@"userCash"]) {
        self.cashRemindLabel.text = @"";
        
        //可提现金额的展示
//        NSInteger u_amount_avail_Int = manager.memberInfoModel.u_amount_avail;
        self.userBalanceLabel.text = [NSString stringWithFormat:@"可提现金额：%.2f元",manager.memberInfoModel.u_amount_avail];
    }else {
        //代理商收益提现
        NSInteger u_amount_avail_Int = [self.agentCashCommission integerValue];
        self.userBalanceLabel.text = [NSString stringWithFormat:@"余额:%.2f，可提现金额：%ld元",[self.agentCashCommission floatValue],u_amount_avail_Int/50 * 50];

    }
    
    [self updateInfoViewWithUType:manager.memberInfoModel.u_type];

    
}

//刷新View
- (void)updateInfoViewWithUType:(NSString *)u_type {
    Manager *manager = [Manager shareInstance];
    if ([u_type isEqualToString:@"1"]) {
        //代理商
        //不用提现类型
        self.selectAgentTypeView.userInteractionEnabled = NO;
        //姓名和账号隐藏
        self.nameView.hidden = YES;
        self.nameViewHeightLayout.constant = 0;
        self.codeView.hidden = YES;
        self.codeViewHeightLayout.constant = 0;
        self.selectAgentTypeIntoIcon.hidden = YES;
        
        //给提现的银行开始赋值
        
        if (manager.memberInfoModel.a_bank_code!= nil && manager.memberInfoModel.a_bank_code.length > 0) {
            self.selectTypeInt = 2;
            self.selectTypeImageView.image = [UIImage imageNamed:@"d_icon_yh"];
            
            NSString *tailBankCode = [manager.memberInfoModel.a_bank_code substringFromIndex:manager.memberInfoModel.a_bank_code.length-4];
            self.selectTypeNameLabel.text = [NSString stringWithFormat:@"提现到尾号为**%@的银行卡",tailBankCode];
            
        }else {
            self.selectTypeInt = -1;
            self.selectTypeImageView.image = [UIImage imageNamed:@"d_icon_yh"];
            self.selectTypeNameLabel.text = @"未绑定银行卡，请先绑定银行卡";
        }
        
    }else {
        //其他用户，
        //需要提现类型
        self.selectAgentTypeView.userInteractionEnabled = YES;
        //姓名和账号显示
        self.nameView.hidden = NO;
        self.nameViewHeightLayout.constant = 50;
        self.codeView.hidden = NO;
        self.codeViewHeightLayout.constant = 50;
        self.selectAgentTypeIntoIcon.hidden = YES;
        
        //默认是第一个支付方式
        self.selectTypeInt = 0;
        self.selectTypeImageView.image = [UIImage imageNamed:@"d_icon_zfb"];
        
    }
}


//点击切换提现方式
- (IBAction)changeTypeTap:(UITapGestureRecognizer *)sender {
    [self keyboardDismissAction];

    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提现到" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.selectTypeInt = 0;
        self.selectTypeImageView.image = [UIImage imageNamed:@"d_icon_zfb"];
        self.selectTypeNameLabel.text = @"提现到支付宝";
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.selectTypeInt = 1;
        self.selectTypeImageView.image = [UIImage imageNamed:@"d_icon_wxzf"];
        self.selectTypeNameLabel.text = @"提现到微信";
    }];
  
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:action1];
    [alertC addAction:action2];

    [alertC addAction:action4];
    [self presentViewController:alertC animated:YES completion:nil];
    
}


//确认提现功能
- (IBAction)enterAgentCashButtonAction:(UIButton *)sender {
    [self keyboardDismissAction];
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];

    NSString *bankNameStr = @"";
    NSString *nameStr;
    NSString *codeStr;
    
    float amount = [self.agentCashAmountTextField.text floatValue];
    
    BOOL isCommit = NO;
    NSString *notCommitStr = @"提现信息填写不完整";
    
    if ([manager.memberInfoModel.u_type isEqualToString:@"1"]) {
        //代理商
        nameStr = manager.memberInfoModel.u_truename;
        bankNameStr = manager.memberInfoModel.a_bank_name;
        codeStr = manager.memberInfoModel.a_bank_code;
    }else if([manager.memberInfoModel.u_type isEqualToString:@"2"]){
        //普通用户
        nameStr = self.nameTextField.text;
        codeStr = self.codeTextField.text;
    }
    
    //用户余额提现
    if ([self.cashType isEqualToString:@"userCash"]) {
        //只有姓名、账号、金额都是有效的才可以提交
        if (nameStr.length > 0 && codeStr.length > 0 && amount > 0 && amount <= manager.memberInfoModel.u_amount_avail) {
            isCommit = YES;
        }else{
            if (amount <= 0) {
                notCommitStr = @"提现金额不能小于0元";
            }
            if (amount > manager.memberInfoModel.u_amount_avail) {
                notCommitStr = @"提现金额不能大于可提现金额";
            }
            
        }
        
    }else {
        //代理商收益提现
        //只有姓名、账号、金额都是有效的才可以提交
        if (nameStr.length > 0 && codeStr.length > 0 && amount > 0 && amount <= [self.agentCashCommission floatValue]) {
            isCommit = YES;
        }else{
            if (amount <= 0) {
                notCommitStr = @"提现金额至少为50元";
            }
            if (amount > [self.agentCashCommission floatValue]) {
                notCommitStr = @"提现金额不能大于可提现金额";
            }
            
        }
    }
    
    
    
    
    //如果支付宝或者微信，bankNameStr可以为空,其余的不能为空
    if (self.selectTypeInt > 1 && bankNameStr.length == 0) {
        isCommit = NO;
        notCommitStr = @"还没有选择提现的银行";
    }
    
    
    if (isCommit == YES) {
        if ([SVProgressHUD isVisible] == NO) {
            [SVProgressHUD show];
        }
        
        NSLog(@"可以提现%@",self.agentCashAmountTextField.text);

        [manager httpUserAgentCashApplicationWithCashType:self.cashType withUserId:manager.memberInfoModel.u_id withType:[NSString stringWithFormat:@"%ld",self.selectTypeInt] withBankName:bankNameStr withName:nameStr withCode:codeStr withAmount:self.agentCashAmountTextField.text withNote:@"" withAgentCashSuccess:^(id successResult) {
            [SVProgressHUD dismiss];
            
            [alertM showAlertViewWithTitle:nil withMessage:@"申请成功" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                if ([self.cashType isEqualToString:@"userCash"]) {
                    //发送通知，刷新界面 用户余额提现
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMoney" object:self userInfo:nil];
                }else {
                    //发送通知，刷新界面 代理商收益提现
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMoneyNew" object:self userInfo:nil];

                }
                
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
 
            
            
        } withAgentCashFail:^(NSString *failResultStr) {
            [SVProgressHUD dismiss];
            [alertM showAlertViewWithTitle:nil withMessage:@"申请提现失败，请联系客服" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

        }];


    }else {
        [alertM showAlertViewWithTitle:nil withMessage:notCommitStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }
    
    
}

- (void)keyboardDismissAction {
    [self.codeTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    [self.agentCashAmountTextField resignFirstResponder];
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
