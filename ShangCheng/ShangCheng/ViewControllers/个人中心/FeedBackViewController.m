//
//  FeedBackViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/22.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "FeedBackViewController.h"
#import "PlaceholdTextView.h"
#import "AlertManager.h"
#import "Manager.h"
#import "SVProgressHUD.h"
@interface FeedBackViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet PlaceholdTextView *feedBackTextView;
@property (weak, nonatomic) IBOutlet UITextField *feedBackPhoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation FeedBackViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    PlaceholdTextView *placeHoldTextView = (PlaceholdTextView *)textView;
    if (textView.text.length == 0) {
        placeHoldTextView.holdLabel.text = placeHoldTextView.textViewPlacehold;
    }else{
        placeHoldTextView.holdLabel.text = @"";
    }
    
    
    BOOL isRed = NO;
    //输入意见，只有电话号码正确才有可能变红色
    if (self.feedBackPhoneTextField.text!=nil && self.feedBackPhoneTextField.text.length == 11) {
        if (textView.text.length > 0) {
            isRed = YES;

        }
    }
    if (isRed == YES) {
        //红色可点击
        self.submitButton.enabled = YES;
        self.submitButton.backgroundColor = kMainColor;
    }else {
        //灰色不可点击
        self.submitButton.enabled = NO;
        self.submitButton.backgroundColor = kccccccColor;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL isRed = NO;
    
    //输入电话，只有意见反馈有内容才有可能变红色
    if (self.feedBackTextView.text!=nil && self.feedBackTextView.text.length > 0) {
        
        //1、手机号输入框在输入内容,内容等于11位
        if (string.length > 0 ) {
            if (textField.text.length + string.length == 11) {
                isRed = YES;
            }
            
        }
        //2、手机号入框消去内容，内容等于11位
        if (string.length == 0 ) {
            if (textField.text.length - range.length == 11) {
                isRed = YES;
            }
        }
    }
    if (isRed == YES) {
        //红色可点击
        self.submitButton.enabled = YES;
        self.submitButton.backgroundColor = kMainColor;
    }else {
        //灰色不可点击
        self.submitButton.enabled = NO;
        self.submitButton.backgroundColor = kccccccColor;
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


//提交反馈
- (IBAction)submitButtonAction:(UIButton *)sender {
    AlertManager *alertM = [AlertManager shareIntance];
    Manager *manager = [Manager shareInstance];
    [self keyboardDismissAction];

    if (self.feedBackTextView.text.length > 0) {
        if (self.feedBackPhoneTextField.text.length == 11) {
            //提交意见反馈
            if ([SVProgressHUD isVisible] == NO) {
                [SVProgressHUD show];
            }

            [manager httpSubmitFeedbackWithUserId:manager.memberInfoModel.u_id withContent:self.feedBackTextView.text withPhone:self.feedBackPhoneTextField.text withFeedbackSuccess:^(id successResult) {
                [SVProgressHUD dismiss];
                
                [alertM showAlertViewWithTitle:nil withMessage:@"提交成功" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];

                
            } withFeedbackFail:^(NSString *failResultStr) {
                [SVProgressHUD dismiss];
                [alertM showAlertViewWithTitle:nil withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

            }];
            
            
            
        }else {
            [alertM showAlertViewWithTitle:nil withMessage:@"请输入正确的手机号" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

        }
    }else {
        [alertM showAlertViewWithTitle:nil withMessage:@"请输入要反馈的意见" actionTitleArr:nil withViewController:self withReturnCodeBlock:nil];
    }
    
    
}

- (void)keyboardDismissAction {
    [self.feedBackTextView resignFirstResponder];
    [self.feedBackPhoneTextField resignFirstResponder];
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
