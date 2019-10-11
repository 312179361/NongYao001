//
//  AddReceiveAddressViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/30.
//  Copyright © 2016年 TongLi. All rights reserved.
//  新增收货地址，或者编辑收货地址

#import "AddReceiveAddressViewController.h"
#import "SelectAddressView.h"
#import "SVProgressHUD.h"
@interface AddReceiveAddressViewController ()
@property (weak, nonatomic) IBOutlet UITextField *receiverNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *receiveAddressTextField;

@property (weak, nonatomic) IBOutlet UIButton *areaButton;
//设为默认地址button
@property (weak, nonatomic) IBOutlet UIButton *defaultAddressButton;
//拷贝一个副本，编辑是对其做操作，
@property (nonatomic,strong)ReceiveAddressModel *addressModelCopy;
//地区选择器
@property (nonatomic,strong) SelectAddressView *selectAddressView;


//新增收货地址模型
@property (nonatomic,strong)ReceiveAddressModel *addReceiveAddressModel;
@end

@implementation AddReceiveAddressViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [SVProgressHUD dismiss];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.receiverNameTextField resignFirstResponder];
    [self.mobileTextField resignFirstResponder];
    [self.receiveAddressTextField resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //加载地区pickView
    self.selectAddressView = [[[NSBundle mainBundle] loadNibNamed:@"SelectAddressView" owner:self options:nil] firstObject];
    self.selectAddressView.frame = self.view.frame;
    //首先先隐藏
    self.selectAddressView.hidden = YES;
    [self.view addSubview:self.selectAddressView];
    

    
    if (self.tempReceiveAddressModel != nil) {
        self.title = @"编辑地址";
        //拷贝一个副本，对其做操作
        self.addressModelCopy = [self.tempReceiveAddressModel mutableCopy];
        //把传过来的模型对这个页面的UI进行赋值，即默认值
        [self updateDefalutUIWithModel:self.addressModelCopy];

    }else {
        self.title = @"新增地址";
        //创建一个模型作为数据模型，当成默认地址
        self.addReceiveAddressModel = [[ReceiveAddressModel alloc] init];
        self.addReceiveAddressModel.defaultAddress = YES;
        //按钮状态
        [self.defaultAddressButton setBackgroundImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];
        
    }
    
        //
    
}



- (void)updateDefalutUIWithModel:(ReceiveAddressModel *)model {
    self.receiverNameTextField.text = model.receiverName;
    self.mobileTextField.text = model.receiveMobile;
    [self.areaButton setTitle:[NSString stringWithFormat:@"%@ %@ %@",model.capitalname,model.cityname,model.countyname] forState:UIControlStateNormal];
    
    self.receiveAddressTextField.text = model.receiveAddress;
    //查看是否是默认地址
    if (model.defaultAddress == YES) {

        [self.defaultAddressButton setBackgroundImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];
    }else {

        [self.defaultAddressButton setBackgroundImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];

    }

}


- (IBAction)areaButtonAction:(UIButton *)sender {
    [self.receiverNameTextField resignFirstResponder];
    [self.mobileTextField resignFirstResponder];
    [self.receiveAddressTextField resignFirstResponder];
    
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
        //
        NSLog(@"地区id%@",areaId);
        [self.areaButton setTitle:[NSString stringWithFormat:@"%@ %@ %@",shengStr,shiStr,quStr] forState:UIControlStateNormal];

        if (self.tempReceiveAddressModel != nil) {
            //修改的情况
            self.addressModelCopy.areaID = areaId;
            self.addressModelCopy.capitalname = shengStr;
            self.addressModelCopy.cityname = shiStr;
            self.addressModelCopy.countyname = quStr;

        }else {
            //新增的情况
            self.addReceiveAddressModel.areaID = areaId;
            self.addReceiveAddressModel.capitalname = shengStr;
            self.addReceiveAddressModel.cityname = shiStr;
            self.addReceiveAddressModel.countyname = quStr;
        }
        
    }];
}
//这是默认地址
- (IBAction)defaultAddressButtonAction:(UIButton *)sender {
    if (self.tempReceiveAddressModel != nil) {
        //修改收货地址情况
        //如果本身就是默认的，就不能取消默认了，因为最少要有一个默认地址
        if (self.tempReceiveAddressModel.defaultAddress == NO) {
            //只有原来不是默认的，才能做修改
            self.addressModelCopy.defaultAddress = !self.addressModelCopy.defaultAddress;
            //改变默认地址按钮UI
            if (self.addressModelCopy.defaultAddress == YES) {
                [self.defaultAddressButton setBackgroundImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];

            }else {
                [self.defaultAddressButton setBackgroundImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];

            }
            
        }else {
            //不能取消默认收货地址，因为最少要有一个默认地址
            NSLog(@"aa");
        }

    }else {
        //新增收货地址情况
        self.addReceiveAddressModel.defaultAddress = !self.addReceiveAddressModel.defaultAddress;
        //改变默认地址按钮UI
        if (self.addReceiveAddressModel.defaultAddress == YES) {
            [self.defaultAddressButton setBackgroundImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];

        }else {
            [self.defaultAddressButton setBackgroundImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];

        }

    }
    
    
    
}

//添加收货地址
- (IBAction)addReceiveAddressButtonAction:(UIButton *)sender {
    
    Manager *manager = [Manager shareInstance];
    if (self.tempReceiveAddressModel != nil) {
        //修改收货地址情况
       /*
        1、改变收货人
        2、改变手机号
        3、改变详细地址

        注：是否为默认地址和地区已经修改
        */
        self.addressModelCopy.receiverName = self.receiverNameTextField.text;
        self.addressModelCopy.receiveMobile = self.mobileTextField.text;
        self.addressModelCopy.receiveAddress = self.receiveAddressTextField.text;

        if ([SVProgressHUD isVisible] == NO) {
            [SVProgressHUD show];
        }

        //发起数据请求修改
        [manager motifyReceiveAddressWithReceiveAddressModel:self.addressModelCopy withMotifySuccess:^(id successResult) {
            [SVProgressHUD dismiss];
            [[AlertManager shareIntance] showAlertViewWithTitle:nil withMessage:@"修改收货地址成功" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                //返回刷新
                self.refreshAddressListBlock(self.addressModelCopy.receiverID);

                
                [self.navigationController popViewControllerAnimated:YES];

            }];

            
        } withMotifyFail:^(NSString *failResultStr) {
            NSLog(@"%@",failResultStr);
            [SVProgressHUD dismiss];
            [[AlertManager shareIntance] showAlertViewWithTitle:nil withMessage:@"修改收货地址失败，请稍后再试" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }];
        
    }else {
        //新增收货地址情况
        /*
         1、改变收货人
         2、改变手机号
         3、改变详细地址
         
         注：是否为默认地址和地区已经修改
         */
        self.addReceiveAddressModel.receiverName = self.receiverNameTextField.text;
        self.addReceiveAddressModel.receiveMobile = self.mobileTextField.text;
        self.addReceiveAddressModel.receiveAddress = self.receiveAddressTextField.text;
        if ([SVProgressHUD isVisible] == NO) {
            [SVProgressHUD show];
        }

        //发起请求
        [manager addReceiveAddressWithReceiveAddressModel:self.addReceiveAddressModel withUserId:manager.memberInfoModel.u_id withAddReceiveAddressSuccess:^(id successResult) {
            [SVProgressHUD dismiss];
            
            [[AlertManager shareIntance] showAlertViewWithTitle:nil withMessage:@"新增收货地址成功" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                //返回刷新
                self.refreshAddressListBlock(successResult);
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            
        } withAddReceiveAddressFail:^(NSString *failResultStr) {
            NSLog(@"%@",failResultStr);
            [SVProgressHUD dismiss];
            [[AlertManager shareIntance] showAlertViewWithTitle:nil withMessage:@"新增收货地址失败，请稍后再试" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

        }];
    }
    
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
