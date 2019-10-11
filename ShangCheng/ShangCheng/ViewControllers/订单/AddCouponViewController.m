//
//  AddCouponViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/23.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "AddCouponViewController.h"
#import "Manager.h"
#import "SVProgressHUD.h"
@interface AddCouponViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *couponIdTextField;
@property (weak, nonatomic) IBOutlet UIButton *enterAddButton;

@end

@implementation AddCouponViewController
- (IBAction)leftBarbuttonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL isRed = NO;
    //只要有输入内容就可以变红
    if (string.length > 0 ) {
        isRed = YES;
    }
    
    //如果消去，但是没有消去完，也可以是红色
    if (string.length == 0 ) {
        if (textField.text.length - range.length >0) {
            isRed = YES;
        }
    }

    
    if (isRed == YES) {
        //红色可点击
        self.enterAddButton.enabled = YES;
        self.enterAddButton.backgroundColor = kMainColor;
    }else {
        //灰色不可点击
        self.enterAddButton.enabled = NO;
        self.enterAddButton.backgroundColor = kccccccColor;
    }
    
    return YES;
}


//确认绑定按钮
- (IBAction)addButtonAction:(UIButton *)sender {
    AlertManager *alertM = [AlertManager shareIntance];

    Manager *manager = [Manager shareInstance];
    if (self.couponIdTextField.text != nil && self.couponIdTextField.text.length > 0) {
        if ([SVProgressHUD isVisible] == NO) {
            [SVProgressHUD show];
        }

        [manager addCouponWithCouponId:self.couponIdTextField.text withUserId:manager.memberInfoModel.u_id withAddCouponSuccess:^(id successResult) {
            [SVProgressHUD dismiss];
            
            //添加成功
            [alertM showAlertViewWithTitle:nil withMessage:@"添加成功" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                //发送通知刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCouponCount" object:self userInfo:nil];
                
                //返回
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            
        } withAddCouponFail:^(NSString *failResultStr) {
            //失败
            [SVProgressHUD dismiss];
            [alertM showAlertViewWithTitle:nil withMessage:@"添加优惠券失败，轻松好后再试，或者联系客服" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }];
        
    }else {
        [alertM showAlertViewWithTitle:nil withMessage:@"请输入优惠券码" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.couponIdTextField resignFirstResponder];
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
