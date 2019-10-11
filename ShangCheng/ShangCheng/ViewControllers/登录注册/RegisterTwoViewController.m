//
//  RegisterTwoViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/4.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "RegisterTwoViewController.h"
#import "SelectAddressView.h"
#import "Manager.h"
#import "SVProgressHUD.h"
@interface RegisterTwoViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTextField;

@property (weak, nonatomic) IBOutlet UIButton *selectAreaButton;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;


@property (nonatomic,strong) SelectAddressView *selectAddressView;
//红包背景页面
@property (weak, nonatomic) IBOutlet UIView *coupleBackView;

//地区编码
@property (nonatomic,strong)NSString *areaID;



@end

@implementation RegisterTwoViewController
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
    
    //第二个密码输入框，同上
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
        self.registerButton.enabled = YES;
        self.registerButton.backgroundColor = kMainColor;
    }else {
        //灰色不可点击
        self.registerButton.enabled = NO;
        self.registerButton.backgroundColor = kccccccColor;
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
    //加载地区pickview
    self.selectAddressView = [[[NSBundle mainBundle] loadNibNamed:@"SelectAddressView" owner:self options:nil] firstObject];
    self.selectAddressView.frame = self.view.frame;
    //首先先隐藏
    self.selectAddressView.hidden = YES;
    [self.view addSubview:self.selectAddressView];

    
    
}

- (IBAction)selectAreaInfoButton:(UIButton *)sender {
    
    [self keyboardDismissAction];
    
    
    //得到地区数据，然后显示
    Manager *manager = [Manager shareInstance];
    if (manager.areaArr.count > 0 ) {
        //说明有数据
        NSLog(@"地区成功1");
        //显示pickView
        [self showAddressPickView];

    }else {
        //没有数据，就从本地获取或者网络请求
        if ([SVProgressHUD isVisible] == NO) {
            [SVProgressHUD show];
        }

        
        [manager httpAreaTreeWithSuccessAreaInfo:^(id successResult) {
            NSLog(@"地区成功2");
            [SVProgressHUD dismiss];
            //刷新pickView
            [self showAddressPickView];
            
        } withFailAreaInfo:^(NSString *failResultStr) {
            [SVProgressHUD dismiss];
            NSLog(@"地区请求失败");
            [[AlertManager shareIntance] showAlertViewWithTitle:nil withMessage:@"地区读取失败" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

        }];
    }
}

//显示pickView
- (void)showAddressPickView {
    [self.selectAddressView showPickerViewEnterSelectAreaWithAreaInfo:^(NSString *areaId, NSString *shengStr, NSString *shiStr, NSString *quStr) {
        
        NSLog(@"地区id%@",areaId);
        self.areaID = areaId;
        [self.selectAreaButton setTitle:[NSString stringWithFormat:@"%@ %@ %@",shengStr,shiStr,quStr] forState:UIControlStateNormal];
    }];

}




//注册
- (IBAction)registerButtonAction:(UIButton *)sender {
    [self keyboardDismissAction];

    
    if (self.areaID != nil && ![self.areaID isEqualToString:@""]) {
        if ([self.passwordTextField.text isEqualToString:self.passwordAgainTextField.text]) {
            //注册
            if ([SVProgressHUD isVisible] == NO) {
                [SVProgressHUD show];
            }

            [[Manager shareInstance] httpRegisterWithMobileNumber:self.mobileNumber withPassword:self.passwordTextField.text withUserType:@"2" withAreaId:self.areaID withRegisterSuccess:^(id successResult) {
                [SVProgressHUD dismiss];
                
                if ([successResult isEqualToString:@"注册成功"]) {
                    AlertManager *alert = [AlertManager shareIntance];

                    //注册成功后，就要发红包
                    [[Manager shareInstance] httpRegisterCouponWithMobile:self.mobileNumber withRegisterCouponSuccess:^(id successResult) {
                        
                        NSLog(@"红包成功");
                        //发送红包成功。显示红包界面
                        self.coupleBackView.hidden = NO;
                        
                    } withRegisterCouponFail:^(NSString *failResultStr) {
                        NSLog(@"红包失败");
                        //发送红包失败
                        [alert showAlertViewWithTitle:nil withMessage:@"注册成功，但红包请求失败，请联系客服" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }];
                    }];
                    
                }
                
                
            } withRegisterFailResult:^(NSString *failResultStr) {
                [SVProgressHUD dismiss];
                AlertManager *alert = [AlertManager shareIntance];
                [alert showAlertViewWithTitle:nil withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
                
            }];
            
        }else {
            AlertManager *alert = [AlertManager shareIntance];
            [alert showAlertViewWithTitle:nil withMessage:@"两个密码输入的不一致" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];        }
    }else {
        AlertManager *alert = [AlertManager shareIntance];
        [alert showAlertViewWithTitle:nil withMessage:@"请您选择所在地区" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }
}



//注册成功后，红包，立即使用的按钮
- (IBAction)useCoupleNowAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
