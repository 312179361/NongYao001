//
//  LoginViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/2.
//  Copyright © 2016年 TongLi. All rights reserved.
//  短信验证码登录

#import "LoginViewController.h"
#import "RegisterAlertView.h"
#import "Manager.h"
#import "ForgetPasswordViewController.h"
#import "SVProgressHUD.h"
@interface LoginViewController ()<UITextFieldDelegate,TimerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *loginScrollView;
@property (nonatomic,strong)RegisterAlertView *registerAlertView;

//密码登录中的账号
@property (weak, nonatomic) IBOutlet UITextField *passwordLoginIDTextField;
//密码登录中的密码
@property (weak, nonatomic) IBOutlet UITextField *passwordLoginPasswordTextField;
//密码登录中的登录按钮
@property (weak, nonatomic) IBOutlet UIButton *passwordLoginButton;


//验证码登录中的账号
@property (weak, nonatomic) IBOutlet UITextField *codeLoginIDTextField;
//验证码登录中的验证码
@property (weak, nonatomic) IBOutlet UITextField *codeLoginCodeTextField;
//验证码登录中的登录按钮
@property (weak, nonatomic) IBOutlet UIButton *codeLoginButton;
//获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;


@end

@implementation LoginViewController

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    //密码登录状态
    if (self.loginScrollView.contentOffset.x == 0) {
        BOOL isRed = NO;
        //id输入框的操作，只有密码输入框有内容，才有可能会变红
        if (textField == self.passwordLoginIDTextField && self.passwordLoginPasswordTextField.text.length > 0) {
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
        
        //密码输入框，同上
        if (textField == self.passwordLoginPasswordTextField && self.passwordLoginIDTextField.text.length > 0) {
            if (string.length > 0 ) {
                isRed = YES;
            }
            if (string.length == 0 && range.location > 0) {
                isRed = YES;
            }
        }
        
        if (isRed == YES) {
            self.passwordLoginButton.enabled = YES;
            self.passwordLoginButton.backgroundColor = kMainColor;
        }else {
            self.passwordLoginButton.enabled = NO;
            self.passwordLoginButton.backgroundColor = kccccccColor;
        }
    }
    
    //验证码登录状态
    if (self.loginScrollView.contentOffset.x == kScreenW) {
        
        BOOL isRed = NO;
        //id输入框的操作，只有验证码输入框有内容，才有可能会变红
        if (textField == self.codeLoginIDTextField && self.codeLoginCodeTextField.text.length > 0) {
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
        
        //密码输入框，同上
        if (textField == self.codeLoginCodeTextField && self.codeLoginIDTextField.text.length > 0) {
            if (string.length > 0 ) {
                isRed = YES;
            }
            if (string.length == 0 && range.location > 0) {
                isRed = YES;
            }
        }
        
        if (isRed == YES) {
            //红色可点击
            self.codeLoginButton.enabled = YES;
            self.codeLoginButton.backgroundColor = kMainColor;
        }else {
            //灰色不可点击
            self.codeLoginButton.enabled = NO;
            self.codeLoginButton.backgroundColor = kccccccColor;
        }

    }
    return YES;
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //注册按钮点击后出现的注册类型视图
//    [self showRegisterAlertView];
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showRegisterAlertView];
}

- (void)showRegisterAlertView {

    UIApplication *application = [UIApplication sharedApplication];
    
    self.registerAlertView = [[[NSBundle mainBundle] loadNibNamed:@"RegisterAlertView" owner:self options:nil] firstObject];
    self.registerAlertView.frame = self.view.bounds;

    [application.keyWindow addSubview:self.registerAlertView];
    
    //alert中普通用户和供应商两个按钮的点击事件block
    __weak LoginViewController *weakVC = self;
    self.registerAlertView.toRegisterVCStr = ^(NSString *toRegisterVCStr){
        if ([toRegisterVCStr isEqualToString:@"generalVC"]) {
            //跳转到普通用户注册
            UINavigationController *registerNav = [weakVC.storyboard instantiateViewControllerWithIdentifier:@"registerNavigationController"];
            [weakVC presentViewController:registerNav animated:YES completion:nil];
            
        }
        
        if ([toRegisterVCStr isEqualToString:@"supplierVC"]) {
            //跳转到供应商注册
            UINavigationController *registerNav = [weakVC.storyboard instantiateViewControllerWithIdentifier:@"registerDelegateNavigationController"];
            [weakVC presentViewController:registerNav animated:YES completion:nil];
            
        }
    };

}

#pragma mark - 获取验证码 和 倒计时 -
//开始倒计时
- (void)startTimeDown {
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


//获取验证码
- (IBAction)getLoginCodeButtonAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    AlertManager *alert = [AlertManager shareIntance];

    if (self.codeLoginIDTextField.text.length == 11) {
        if ([Manager shareInstance].tempTimer == nil) {
            
            //先检查这个手机号是否注册了
            [manager httpCheckIsUserRegisterForLoginWithMobile:self.codeLoginIDTextField.text withIsRegisterSuccess:^(id successResult) {
                
                //如果注册了，就可以获取验证码
                [manager httpMobileCodeWithMobileNumber:self.codeLoginIDTextField.text withCodeSuccessResult:^(id successResult) {
                    if ([successResult isEqualToString:@"200"]) {
                        
                        [alert showAlertViewWithTitle:nil withMessage:@"短信验证码发送成功，请注意查收" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                            //发送成功后，开始倒计时
                            [self startTimeDown];
                            
                        }];
                    }
                    
                } withCodeFailResult:^(NSString *failResultStr) {
                    [alert showAlertViewWithTitle:nil withMessage:@"短信验证码发送失败，请联系客服" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
                }];
                
            } withIsRegisterFail:^(NSString *failResultStr) {
                //
                [alert showAlertViewWithTitle:nil withMessage:@"该手机号尚未注册" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
            }];
            
            
        }else{
            
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
        
        
    }else {
        AlertManager *alert = [AlertManager shareIntance];
        [alert showAlertViewWithTitle:nil withMessage:@"请输入正确的手机号" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }
    
}



#pragma mark - 登录 -
//密码登录按钮
- (IBAction)loginButtonOneAction:(UIButton *)sender {
    //测试号
//    NSString *loginID = @"admin";
//    NSString *loginPassword = @"nongyao001";
    

//    NSString *loginID = @"18535896248";
//    NSString *loginPassword = @"123456";
    
    //代理
//    NSString *loginID = @"13837150011";
//    NSString *loginPassword = @"nongyao001";
    
    
    [self keyboardDismissAction];


    NSString *loginID = self.passwordLoginIDTextField.text;
    NSString *loginPassword = self.passwordLoginPasswordTextField.text ;
    
    Manager *manager = [Manager shareInstance];
    if ([SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];
    }
    AlertManager *alertM = [AlertManager shareIntance];


    [manager loginActionWithUserID:loginID withPassword:[manager digest:loginPassword] withLoginSuccessResult:^(id successResult) {
        [SVProgressHUD dismiss];
        
        if ([[successResult[0] objectForKey:@"code"] isEqualToString:@"0"]) {
            //需要重设密码
            [alertM showAlertViewWithTitle:nil withMessage:@"系统升级，为了您的账户安全，请重置密码" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                //跳转到忘记密码中
                [self performSegueWithIdentifier:@"toForgetPasswordVC" sender:self.passwordLoginIDTextField.text];
                
            }];
        }else {
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    } withLoginFailResult:^(NSString *failResultStr) {
        [SVProgressHUD dismiss];
        [alertM showAlertViewWithTitle:nil withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }];

}


//验证码登录按钮
- (IBAction)loginButtonTwoAction:(UIButton *)sender {
    [self keyboardDismissAction];

    
    NSString *loginTel = self.codeLoginIDTextField.text;
    NSString *loginCode = self.codeLoginCodeTextField.text;
    Manager *manager = [Manager shareInstance];
    if ([SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];
    }
    AlertManager *alertM = [AlertManager shareIntance];

    [manager loginActionWithMobile:loginTel withMobileCode:loginCode withLoginSuccessResult:^(id successResult) {
        [SVProgressHUD dismiss];
        
        if ([[successResult[0] objectForKey:@"code"] isEqualToString:@"0"]) {
            //需要重设密码
            [alertM showAlertViewWithTitle:nil withMessage:@"系统升级，为了您的账户安全，请重置密码" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                //跳转到忘记密码中
                [self performSegueWithIdentifier:@"toForgetPasswordVC" sender:self.codeLoginIDTextField.text];
                
            }];
        }else {
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }

    } withLoginFailResult:^(NSString *failResultStr) {
        [SVProgressHUD dismiss];
        [alertM showAlertViewWithTitle:nil withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

    }];
    
    
    
}

#pragma mark - 切换登录方式 -
//从密码界面到短信登录界面
- (IBAction)toMessageLoginView:(UIButton *)sender {
    [self keyboardDismissAction];

    self.loginScrollView.contentOffset = CGPointMake(kScreenW, 0);
}
//从短信界面到密码登录界面
- (IBAction)toPasswordLoginView:(UIButton *)sender {
    [self keyboardDismissAction];

    //重置验证码
//    [self endTimeDown];
    
    self.loginScrollView.contentOffset = CGPointMake(0, 0);

}


#pragma mark - 注册与忘记密码 -
//密码登录界面的注册按钮
- (IBAction)passwordToRegistVCAction:(UIButton *)sender {
    //弹出注册alert视图
    self.registerAlertView.hidden = NO;
}

//短信登录界面的注册按钮
- (IBAction)messageToRegistVCAction:(UIButton *)sender {
    //弹出注册alert视图
    self.registerAlertView.hidden = NO;
}



//密码登录界面的忘记密码
- (IBAction)passwordToForgetVCAction:(UIButton *)sender {
    
    if (self.passwordLoginIDTextField.text.length == 11) {
        [self performSegueWithIdentifier:@"toForgetPasswordVC" sender:self.passwordLoginIDTextField.text];
    }else {
        AlertManager *alertM = [AlertManager shareIntance];
        [alertM showAlertViewWithTitle:nil withMessage:@"请输入正确的手机号" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }
}

//短信登录界面的忘记密码
- (IBAction)messageToForgetVCAction:(UIButton *)sender {
    if (self.codeLoginIDTextField.text.length == 11) {
        [self performSegueWithIdentifier:@"toForgetPasswordVC" sender:self.codeLoginIDTextField.text];
    }else {
        AlertManager *alertM = [AlertManager shareIntance];
        [alertM showAlertViewWithTitle:nil withMessage:@"请输入正确的手机号" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }
}

- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)keyboardDismissAction {

    [self.codeLoginIDTextField resignFirstResponder];
    [self.codeLoginCodeTextField resignFirstResponder];
    [self.passwordLoginIDTextField resignFirstResponder];
    [self.passwordLoginPasswordTextField resignFirstResponder];

    
}
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    [self keyboardDismissAction];

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
    if ([segue.identifier isEqualToString:@"toForgetPasswordVC"]) {
        ForgetPasswordViewController *forgetPasswordVC = [segue destinationViewController];
        forgetPasswordVC.tempMobile = sender;
    }
}


@end
