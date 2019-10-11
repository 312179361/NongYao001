//
//  ForgetPasswordTwoViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/20.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "ForgetPasswordTwoViewController.h"
#import "AlertManager.h"
#import "Manager.h"
#import "SVProgressHUD.h"
@interface ForgetPasswordTwoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTextField;

@property (weak, nonatomic) IBOutlet UIButton *enterButton;

@end

@implementation ForgetPasswordTwoViewController
- (IBAction)leftBatButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL isRed = NO;
    //姓名输入框操作，只有手机号输入框内容等于11，才有可能会变红
    if (textField == self.passwordTextField && self.passwordAgainTextField.text.length == 11) {
        /*下面两个满足一个就变红
         1、姓名输入框在输入内容,
         2、姓名输入框消去内容，内容还大于0,
         */
        if (string.length > 0 ) {
            if (textField.text.length + string.length == 6) {
                isRed = YES;
            }
        }
        if (string.length == 0 ) {
            if (textField.text.length - range.length == 6) {
                isRed = YES;
            }
        }
    }
    
    //手机号输入框，类似上面
    if (textField == self.passwordAgainTextField && self.passwordTextField.text.length > 0) {
        /*下面两个满足一个就变红
         1、手机号输入框在输入内容,内容等于11位
         2、手机号入框消去内容，内容等于11位
         */
        if (string.length > 0 ) {
            if (textField.text.length + string.length == 6) {
                isRed = YES;
            }
            
        }
        if (string.length == 0 ) {
            if (textField.text.length - range.length == 6) {
                
                isRed = YES;
            }
        }
    }
    
    if (isRed == YES) {
        //红色可点击
        self.enterButton.enabled = YES;
        self.enterButton.backgroundColor = kMainColor;
    }else {
        //灰色不可点击
        self.enterButton.enabled = NO;
        self.enterButton.backgroundColor = kccccccColor;
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



- (IBAction)enterButtonAction:(UIButton *)sender {
    [self keyboardDismissAction];

    AlertManager *alertM = [AlertManager shareIntance];
    Manager *manager = [Manager shareInstance];

    if ([self.passwordTextField.text isEqualToString:self.passwordAgainTextField.text]) {
        //忘记密码重置
        if ([SVProgressHUD isVisible] == NO) {
            [SVProgressHUD show];
        }

        [manager httpForgetPasswordWithMobile:self.tempMobile withPassword:self.passwordTextField.text withForgetSuccess:^(id successResult) {
            [SVProgressHUD dismiss];
            
            [alertM showAlertViewWithTitle:nil withMessage:@"修改成功" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
           
        } withForgetFail:^(NSString *failResultStr) {
            [SVProgressHUD dismiss];
            [alertM showAlertViewWithTitle:nil withMessage:@"修改密码失败，请稍后再试" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }];
    }else {
        [alertM showAlertViewWithTitle:nil withMessage:@"两个密码不一致" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }
    
}

- (void)keyboardDismissAction {
    [self.passwordTextField resignFirstResponder];
    [self.passwordAgainTextField resignFirstResponder];
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
