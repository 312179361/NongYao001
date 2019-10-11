//
//  RegisterDelegateViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/17.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "RegisterDelegateViewController.h"
#import "SelectAddressView.h"
#import "Manager.h"
#import "SVProgressHUD.h"
@interface RegisterDelegateViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UIButton *selectAreaButton;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;


@property (nonatomic,strong) SelectAddressView *selectAddressView;

//地区编码
@property (nonatomic,strong)NSString *areaID;



@end

@implementation RegisterDelegateViewController
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL isRed = NO;
    //姓名输入框操作，只有手机号输入框内容等于11，才有可能会变红
    if (textField == self.nameTextField && self.phoneTextField.text.length == 11) {
        /*下面两个满足一个就变红
         1、姓名输入框在输入内容,
         2、姓名输入框消去内容，内容还大于0,
         */
        
        if (string.length > 0 ) {
            isRed = YES;
        }
        
        if (string.length == 0) {
            if (textField.text.length - range.length > 0) {
                isRed = YES;
            }
        }
    }
    
    //手机号输入框，类似上面
    if (textField == self.phoneTextField && self.nameTextField.text.length > 0) {
        /*下面两个满足一个就变红
         1、手机号输入框在输入内容,内容等于11位
         2、手机号入框消去内容，内容等于11位
         */
        if (string.length > 0 ) {
            if (textField.text.length + string.length == 11) {
                isRed = YES;
            }
            
        }
        if (string.length == 0 ) {
            if (textField.text.length - range.length == 11) {

                isRed = YES;
            }
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
    [SVProgressHUD dismiss ];
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
            NSLog(@"地区请求失败");
            [SVProgressHUD dismiss];
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


//注册按钮
- (IBAction)registerButtonAction:(UIButton *)sender {
    [self keyboardDismissAction];

    if (self.areaID != nil && ![self.areaID isEqualToString:@""]) {
        if (self.nameTextField.text.length > 0) {
            if (self.phoneTextField.text.length == 11) {
                //注册
                NSLog(@"注册代理商");
                if ([SVProgressHUD isVisible] == NO) {
                    [SVProgressHUD show];
                }

                [[Manager shareInstance] httpRegisterDelegateWithTrueName:self.nameTextField.text withPhone:self.phoneTextField.text withAreaId:self.areaID withRegisterSuccessResult:^(id successResult) {
                    [SVProgressHUD dismiss];
                    
                    AlertManager *alert = [AlertManager shareIntance];
                    
                    [alert showAlertViewWithTitle:@"注册成功" withMessage:successResult actionTitleArr:successResult withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    
                } withRegisterFailResult:^(NSString *failResultStr) {
                    [SVProgressHUD dismiss];
                    
                    AlertManager *alert = [AlertManager shareIntance];
                    [alert showAlertViewWithTitle:@"注册失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
                }];
                
            }else {
                AlertManager *alert = [AlertManager shareIntance];
                [alert showAlertViewWithTitle:nil withMessage:@"请您输入正确的电话号码" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

            }
        }else {
            AlertManager *alert = [AlertManager shareIntance];
            [alert showAlertViewWithTitle:nil withMessage:@"请您输入真实姓名" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

        }
        
    }else {
        AlertManager *alert = [AlertManager shareIntance];
        [alert showAlertViewWithTitle:nil withMessage:@"请您选择所在地区" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

    }
}
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)keyboardDismissAction {
    [self.nameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    
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
