//
//  MotifyPasswordViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MotifyPasswordViewController.h"
#import "Manager.h"
#import "AlertManager.h"
#import "SVProgressHUD.h"
@interface MotifyPasswordViewController ()<UITextFieldDelegate, TimerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


@end

@implementation MotifyPasswordViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    Manager *manager = [Manager shareInstance];
    
    BOOL isRed = NO;
  
    //验证码输入框，手机号码必须11位，才有可能会变红
   
    if (textField == self.codeTextField && manager.memberInfoModel.u_mobile.length == 11) {
        /*下面两个满足一个就变红
         1、id输入框在输入内容，
         2、id输入框消去内容，没有消除完
         */

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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Manager *manager = [Manager shareInstance];
    NSString *secMobile = [manager.memberInfoModel.u_mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    self.mobileLabel.text = [NSString stringWithFormat:@"当前绑定手机号：%@",secMobile];
    

}



#pragma mark - 获取验证码 和 倒计时 -
//开始倒计时
- (void)startTimeDown {
    //开始60秒倒计时
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

    Manager *manager = [Manager shareInstance];
    
    if (manager.memberInfoModel.u_mobile.length == 11) {
        if ([Manager shareInstance].tempTimer == nil) {
            [manager httpMobileCodeWithMobileNumber:manager.memberInfoModel.u_mobile withCodeSuccessResult:^(id successResult) {
                
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

       
        
    }else {
        AlertManager *alert = [AlertManager shareIntance];
        [alert showAlertViewWithTitle:nil withMessage:@"手机号不正确" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }
    
}

//下一步
- (IBAction)nextButtonAction:(UIButton *)sender {
//    [self performSegueWithIdentifier:@"motifyNextVC" sender:nil];
    
    
    AlertManager *alertM = [AlertManager shareIntance];
    Manager *manager = [Manager shareInstance];
    [self keyboardDismissAction];

    
    if (manager.memberInfoModel.u_mobile.length == 11 ) {
        if (self.codeTextField.text.length > 0) {
            
            if ([SVProgressHUD isVisible] == NO) {
                [SVProgressHUD show];
            }

            //验证一下验证码是否正确
            [[Manager shareInstance] httpCheckMobileCodeWithMobileNumber:manager.memberInfoModel.u_mobile withCode:self.codeTextField.text withCodeSuccessResult:^(id successResult) {
                [SVProgressHUD dismiss];
                if ([successResult isEqualToString:@"200"]) {
                    //下一步
                    [self performSegueWithIdentifier:@"motifyNextVC" sender:nil];

                    
                }
            } withCodeFailResult:^(NSString *failResultStr) {
                //
                [SVProgressHUD dismiss];

                [alertM showAlertViewWithTitle:nil withMessage:[NSString stringWithFormat:@"短信验证码验证失败，%@",failResultStr ] actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                    
                }];
                
            }];
            
        }else {
            NSLog(@"请输入验证码");
            [alertM showAlertViewWithTitle:nil withMessage:@"请输入验证码" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }
    }else {
        NSLog(@"请输入正确的手机号");
        [alertM showAlertViewWithTitle:nil withMessage:@"请输入正确的手机号" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

    }
    
}

- (void)keyboardDismissAction {
    [self.codeTextField resignFirstResponder];

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
