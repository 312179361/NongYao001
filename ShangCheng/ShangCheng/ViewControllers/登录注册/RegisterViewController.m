//
//  RegisterViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/4.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "RegisterViewController.h"
#import "Manager.h"
#import "AlertManager.h"
#import "RegisterTwoViewController.h"
#import "SVProgressHUD.h"
@interface RegisterViewController ()<UITextFieldDelegate,TimerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation RegisterViewController

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL isRed = NO;
    //手机号输入框的操作，只有验证码输入框有内容，才有可能会变红
    if (textField == self.mobileNumberTextField && self.codeTextField.text.length > 0) {
        /*下面两个满足一个就变红
         1、id输入框在输入内容，
         2、id输入框消去内容，没有消除完
         */
        if (string.length > 0) {
            isRed = YES;
        }
        //如果id输入框在消去内容，
        if (string.length == 0 && range.location > 0) {
            isRed = YES;
        }
    }
    
    //验证码输入框，同上
    if (textField == self.codeTextField && self.mobileNumberTextField.text.length > 0) {
        if (string.length > 0 ) {
            isRed = YES;
        }
        if (string.length == 0 && range.location > 0) {
            isRed = YES;
        }
    }
    
    if (isRed == YES) {
        //红色可点击
        self.nextButton.enabled = YES;
        self.nextButton.backgroundColor = kMainColor;
    }else {
        //灰色不可点击
        self.nextButton.enabled = NO;
        self.nextButton.backgroundColor = kccccccColor;
    }
    
    return YES;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

//消失
- (IBAction)dismissRegisterVC:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 获取验证码 和 倒计时 -
//开始倒计时
- (void)startTimeDown {
    NSLog(@"开始点击");
    
    //初始化倒计时。然后指定代理
    [[Manager shareInstance] startTimerWithMaxSecond:5*60];
    //设置代理
    [Manager shareInstance].timerDelegater = self;
    
    //按钮不可点击
    self.getCodeButton.enabled = NO;
    [self.getCodeButton setTitle:[NSString stringWithFormat:@"倒计时 %ld",[Manager shareInstance].countDownTime] forState:UIControlStateNormal];
    //背景变灰色
    self.getCodeButton.backgroundColor = kColor(153, 153, 153, 1);
}

#pragma mark - 倒计时代理 -
- (void)countDowningWithSecond:(NSInteger)second {
    //倒计时中，改变数字
    self.getCodeButton.titleLabel.text = [NSString stringWithFormat:@"倒计时(%ld)",second];
    [self.getCodeButton setTitle:[NSString stringWithFormat:@"倒计时(%ld)",second] forState:UIControlStateNormal];
}

- (void)countDownEndAction {
    //倒计时结束，改变状态
    //按钮可以点击
    self.getCodeButton.enabled = YES;
    [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    //背景色变红
    self.getCodeButton.backgroundColor = kMainColor;
    
}




//获取短信验证码
- (IBAction)getMobileNumber:(UIButton *)sender {
    [self keyboardDismissAction];

    if (self.mobileNumberTextField.text.length == 11 ) {
        if ([Manager shareInstance].tempTimer == nil) {
            
            //获取验证码
            [[Manager shareInstance] httpMobileCodeWithMobileNumber:self.mobileNumberTextField.text withCodeSuccessResult:^(id successResult) {
                if ([successResult isEqualToString:@"200"]) {
                    AlertManager *alert = [AlertManager shareIntance];
                    [alert showAlertViewWithTitle:nil withMessage:@"短信验证码发送成功，请注意查收" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                        //发送成功后，开始倒计时
                        [self startTimeDown];
                        
                    }];
                }
            } withCodeFailResult:^(NSString *failResultStr) {
                AlertManager *alert = [AlertManager shareIntance];
                [alert showAlertViewWithTitle:nil withMessage:[NSString stringWithFormat:@"短信验证发送失败，%@",failResultStr ] actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                    
                }];
            }];
            
            
            
        }else {
            
            NSString *resultStr ;
            //正在倒计时，不能发送短信
            if ([Manager shareInstance].countDownTime < 60) {
                //不到一分钟
                resultStr = [NSString stringWithFormat:@"您请求的太频繁，请在%ld秒后重试",[Manager shareInstance].countDownTime];
            }else {
                resultStr = [NSString stringWithFormat:@"您请求的太频繁，请在%ld分后重试",[Manager shareInstance].countDownTime/60];
            }
            
            AlertManager *alertM = [AlertManager shareIntance];
            
            [alertM showAlertViewWithTitle:@"提示" withMessage:resultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
            
        }
        
    }
    
}

//下一步
- (IBAction)nextButtonAction:(UIButton *)sender {
    [self keyboardDismissAction];

//    [self performSegueWithIdentifier:@"registerNext" sender:sender];
    
    
    AlertManager *alert = [AlertManager shareIntance];

    //先判断一下是否已经注册了
    Manager *manager = [Manager shareInstance];
    if (self.mobileNumberTextField.text.length == 11 ) {
        if ([SVProgressHUD isVisible] == NO) {
            [SVProgressHUD show];
        }

        [manager httpCheckIsUserRegisterWithMobile:self.mobileNumberTextField.text withIsRegisterSuccess:^(id successResult) {
            
            //未注册可以进行下一步
            if (self.codeTextField.text.length > 0) {
                
                //验证一下验证码是否正确
                [[Manager shareInstance] httpCheckMobileCodeWithMobileNumber:self.mobileNumberTextField.text withCode:self.codeTextField.text withCodeSuccessResult:^(id successResult) {
                    [SVProgressHUD dismiss];

                    if ([successResult isEqualToString:@"200"]) {
                        //下一步
                        [self performSegueWithIdentifier:@"registerNext" sender:sender];
                        
                    }
                } withCodeFailResult:^(NSString *failResultStr) {
                    //
                    [SVProgressHUD dismiss];

                    [alert showAlertViewWithTitle:nil withMessage:[NSString stringWithFormat:@"短信验证失败，%@",failResultStr ] actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                        
                    }];
                    
                }];
                
            }else {
                NSLog(@"请输入验证码");
                [SVProgressHUD dismiss];

                [alert showAlertViewWithTitle:nil withMessage:@"请输入验证码" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

            }
            
        } withIsRegisterFail:^(NSString *failResultStr) {
            NSLog(@"%@",failResultStr);
            [SVProgressHUD dismiss];
            [alert showAlertViewWithTitle:nil withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

        }];

    }else {
        NSLog(@"请输入正确的手机号");
        [alert showAlertViewWithTitle:nil withMessage:@"请输入正确的手机号" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

    }
    
    
}

- (void)keyboardDismissAction {
    [self.codeTextField resignFirstResponder];
    [self.mobileNumberTextField resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self keyboardDismissAction];
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
    RegisterTwoViewController *registerTwoVC = [segue destinationViewController];
    registerTwoVC.mobileNumber = self.mobileNumberTextField.text;
}


@end
