//
//  MotifyPasswordTwoViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/14.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MotifyPasswordTwoViewController.h"
#import "Manager.h"
#import "AlertManager.h"
#import "SVProgressHUD.h"
@interface MotifyPasswordTwoViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTextField;
@property (weak, nonatomic) IBOutlet UIButton *enterMotifyButton;

@end

@implementation MotifyPasswordTwoViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL isRed = NO;
    //第一个密码输入框操作，只有第二个密码输入框内容大于5，才有可能会变红
    if (textField == self.passwordTextField && self.passwordAgainTextField.text.length > 5) {
        /*下面两个满足一个就变红
         1、第一个密码输入框在输入内容,内容大于等于6,即location>4，
         2、第一个密码输入框消去内容，内容还大于等于6,即location>5
         */
        
        if (string.length > 0 && range.location > 4) {
            isRed = YES;
        }
        //如果id输入框在消去内容，
        if (string.length == 0 && range.location > 5) {
            isRed = YES;
        }
    }
    
    //验证码输入框，同上
    if (textField == self.passwordAgainTextField && self.passwordTextField.text.length > 5) {
        if (string.length > 0 && range.location > 4) {
            isRed = YES;
        }
        if (string.length == 0 && range.location > 5) {
            isRed = YES;
        }
    }
    
    if (isRed == YES) {
        //红色可点击
        self.enterMotifyButton.enabled = YES;
        self.enterMotifyButton.backgroundColor = kMainColor;
    }else {
        //灰色不可点击
        self.enterMotifyButton.enabled = NO;
        self.enterMotifyButton.backgroundColor = kccccccColor;
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

//确认修改
- (IBAction)enterMotifyButtonAction:(UIButton *)sender {
    AlertManager *alertM = [AlertManager shareIntance];
    [self keyboardDismissAction];//键盘消失

    if ([self.passwordTextField.text isEqualToString:self.passwordAgainTextField.text] && self.passwordAgainTextField.text.length > 0 ) {
        if ([SVProgressHUD isVisible] == NO) {
            [SVProgressHUD show];
        }

        
        Manager *manager = [Manager shareInstance];
        [manager httpMotifyPasswordWithUserId:manager.memberInfoModel.u_id withPassword:[manager digest:self.passwordTextField.text] withMotifyPasswordSuccess:^(id successResult) {
            [SVProgressHUD dismiss ];
            
            [alertM showAlertViewWithTitle:nil withMessage:successResult actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                if ([successResult isEqualToString:@"修改成功"]) {

                    //退回到账号管理页面上
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                }
            }];
        
        } withMotifyPasswordFail:^(NSString *failResultStr) {
            [SVProgressHUD dismiss];
            [alertM showAlertViewWithTitle:nil withMessage:@"修改密码失败" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }];

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
