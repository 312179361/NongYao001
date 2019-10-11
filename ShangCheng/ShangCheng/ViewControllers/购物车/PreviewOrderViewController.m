//
//  PreviewOrderViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/9.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "PreviewOrderViewController.h"
#import "PreviewOrderTableViewCell.h"
#import "ReceiveAddressViewController.h"
#import "SelectCouponViewController.h"
#import "PayViewController.h"
#import "Manager.h"
#import "SVProgressHUD.h"
#import "AlertManager.h"
#import "WebPageViewController.h"

@interface PreviewOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

//couponId:优惠卷id  saleCode:优惠码  saleMoney:优惠金额
@property (nonatomic,strong)NSDictionary *saleMoneyDic;
//记录下单时间
@property (nonatomic,strong) NSTimer *tempTimer;


//------------------footView上的控件
//优惠券
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
//产品价格
@property (weak, nonatomic) IBOutlet UILabel *productTotalPriceLabel;
//优惠金额
@property (weak, nonatomic) IBOutlet UILabel *salePriceLabel;
//数量
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
//需付款
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
//-----------底部控件----------------------
//底部的实付款Label
@property (weak, nonatomic) IBOutlet UILabel *bottomPayMoneyLabel;

@property (nonatomic,strong)NSString *creatOrderId;

//------收货地址-----------
//收货地址控件
@property (weak, nonatomic) IBOutlet UILabel *selectReceiveNameAndMobileLabel;

@property (weak, nonatomic) IBOutlet UILabel *selectReceiveAddressLabel;

@end

@implementation PreviewOrderViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Manager *manager = [Manager shareInstance];
    //默认是没有选择优惠券
    self.saleMoneyDic = @{@"couponId":@"",@"saleCode":@"",@"saleMoney":@"0"};
    
    //更新一下footView
    [self upFootview];
   //底部实付款
    self.bottomPayMoneyLabel.text = [NSString stringWithFormat:@"  实付款：￥%.2f", [self computeProductTotalPrice] - [[self.saleMoneyDic objectForKey:@"saleMoney"] integerValue]];
    //风火轮
    if ([SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];
    }

    //网络请求收货地址
    [manager receiveAddressListWithUserIdOrReceiveId:manager.memberInfoModel.u_id withAddressListSuccess:^(id successResult) {
        [SVProgressHUD dismiss];
        
        if (manager.receiveAddressArr.count > 0) {
            for (ReceiveAddressModel *tempModel in manager.receiveAddressArr) {
                if (tempModel.defaultAddress == YES) {
                    //首次进入，默认的地址就是选择的地址
                    tempModel.isSelect = YES;
                    //刷新收货地址UI
                    [self updateReceiveViewUI];
                    
                    break;
                }
                
            }

        }else {
            self.selectReceiveNameAndMobileLabel.text = @"暂无地址，请添加新地址";
            self.selectReceiveAddressLabel.text = @"---";
        }
        
    } withAddressListFail:^(NSString *failResultStr) {
        [SVProgressHUD dismiss];
    }];

}

//刷新收货地址UI
- (void)updateReceiveViewUI {
    Manager *manager = [Manager shareInstance];
    
    
    ReceiveAddressModel *selectReceiveModel = [manager selectedReceiveAddressModel];
    
    NSString *phoneStr = @"";
    if (selectReceiveModel.receiveMobile != nil && selectReceiveModel.receiveMobile.length > 0) {
        phoneStr = selectReceiveModel.receiveMobile;
    }

    self.selectReceiveNameAndMobileLabel.text = [NSString stringWithFormat:@"%@  %@",selectReceiveModel.receiverName,phoneStr];
    
    
    //地址赋值
    NSString *detailAddressStr = @"" ;
    if (selectReceiveModel.capitalname!= nil && selectReceiveModel.capitalname.length > 0) {
        detailAddressStr = [detailAddressStr stringByAppendingString:selectReceiveModel.capitalname];
        detailAddressStr = [detailAddressStr stringByAppendingString:@" "];
    }
    
    if (selectReceiveModel.cityname!= nil && selectReceiveModel.cityname.length > 0) {
        detailAddressStr = [detailAddressStr stringByAppendingString:selectReceiveModel.cityname];
        detailAddressStr = [detailAddressStr stringByAppendingString:@" "];
    }
    
    if (selectReceiveModel.countyname!= nil && selectReceiveModel.countyname.length > 0) {
        detailAddressStr = [detailAddressStr stringByAppendingString:selectReceiveModel.countyname];
        detailAddressStr = [detailAddressStr stringByAppendingString:@" "];
    }
    
    if (selectReceiveModel.receiveAddress!= nil && selectReceiveModel.receiveAddress.length > 0) {
        detailAddressStr = [detailAddressStr stringByAppendingString:selectReceiveModel.receiveAddress];
        detailAddressStr = [detailAddressStr stringByAppendingString:@" "];
    }
    self.selectReceiveAddressLabel.text = detailAddressStr;

    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //开始展示下单时间
    self.tempTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}
- (void)timerAction:(NSTimer *)timer {
    NSLog(@"aaaa");
    Manager *manager = [Manager shareInstance];
    self.payTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@",[manager getNowTimeStr]];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
    //界面消失，下单时间停止
    [self.tempTimer invalidate];
    [SVProgressHUD dismiss];
}

//计算总金额
- (float)computeProductTotalPrice {
    float totalPrice = 0;
    for (ShoppingCarModel *tempModel in self.selectedProductArr) {
        
//        if (tempModel.isActivity == NO) {
            
            totalPrice += [tempModel.totalprice floatValue];
//        }
       
    }
    return totalPrice;

}

//非动产品总金额 为了计算是否可用优惠券
- (float)computeNoSaleProductTotalPrice {
    float noSaleTotalPrice = 0;
    for (ShoppingCarModel *tempModel in self.selectedProductArr) {
        
        if (tempModel.isActivity == NO) {
        
            noSaleTotalPrice += [tempModel.totalprice floatValue];
        }
        
    }
    return noSaleTotalPrice;
    
}

//刷新FootView
- (void)upFootview {
    Manager *manager = [Manager shareInstance];
    
    //优惠券
    if ([[self.saleMoneyDic objectForKey:@"saleCode"] isEqualToString:@""]) {
        self.couponLabel.text = @"未选择";

    }else {
        self.couponLabel.text = [NSString stringWithFormat:@"优惠劵码：%@", [self.saleMoneyDic objectForKey:@"saleCode"] ];

    }

    
    //总金额
    self.productTotalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self computeProductTotalPrice]];
    
    //优惠金额
    self.salePriceLabel.text = [NSString stringWithFormat:@"-￥%.2f",  [[self.saleMoneyDic objectForKey:@"saleMoney"] floatValue]];
    
    
    //产品的总个数
    int totalCount = 0;
    for (ShoppingCarModel *tempModel in self.selectedProductArr) {
        totalCount += [tempModel.c_number integerValue];
    }
    self.productCountLabel.text = [NSString stringWithFormat:@"%d件",totalCount];
    
   
    
    //需付款
    self.payMoneyLabel.text = [NSString stringWithFormat:@"需付款：%.2f", [self computeProductTotalPrice] - [[self.saleMoneyDic objectForKey:@"saleMoney"] floatValue]];
    //时间
    self.payTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@",[manager getNowTimeStr]];
   
    
}


#pragma mark - tableViewDelegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedProductArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PreviewOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"previewOrderTCell" forIndexPath:indexPath];
    ShoppingCarModel *tempShoppingModel = self.selectedProductArr[indexPath.row];
    
    [cell updatePreviewOrderCellWithShoppingCarModel:tempShoppingModel];
    
    return cell;
    
}





#pragma mark - 联系客服 -
- (IBAction)telToPeopleService:(UIButton *)sender {
    
    //跳转cc客服
    [self performSegueWithIdentifier:@"previewOrderToWebViewVC" sender:nil];
    
    /*
    
    AlertManager *alertM = [AlertManager shareIntance];
    [alertM showAlertViewWithTitle:@"拨打客服电话" withMessage:@"是否要拨打客服电话400-635-8880" actionTitleArr:@[@"取消",@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
        if (actionBlockNumber == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4006358880"]];
            
        }
    }];
*/
}


#pragma mark - 底部功能 -
//提交订单，即生成订单
- (IBAction)submitOrderButtonAction:(UIButton *)sender {
    AlertManager *alertM = [AlertManager shareIntance];
    //得到地区数据
    Manager *manager = [Manager shareInstance];
    ReceiveAddressModel *selectReceiveModel = [manager selectedReceiveAddressModel];
    if (selectReceiveModel != nil && selectReceiveModel.receiverID != nil) {
        if ([SVProgressHUD isVisible] == NO) {
            [SVProgressHUD show];
        }

        [manager creatOrderWithUserID:manager.memberInfoModel.u_id withReceivedID:selectReceiveModel.receiverID withTotalAmount:[NSString stringWithFormat:@"%.2f",[self computeProductTotalPrice]] withDiscount:[self.saleMoneyDic objectForKey:@"saleMoney"] withCouponId:[self.saleMoneyDic objectForKey:@"couponId"] withArr:self.selectedProductArr withOrderSuccessResult:^(id successResult) {
            //风火轮消失
            [SVProgressHUD dismiss];
            self.creatOrderId = successResult;
            //发送通知通知订单列表刷新页面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:self userInfo:nil];
            //提交订单后，就进入支付界面
            [self performSegueWithIdentifier:@"previewOrderVCToPayVC" sender:sender];
            
            
        } withOrderFailResult:^(NSString *failResultStr) {
            [SVProgressHUD dismiss];
            [alertM showAlertViewWithTitle:nil withMessage:@"订单生成失败，请稍后再试" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

        }];
    }else {
        NSLog(@"未选择地址");
        [alertM showAlertViewWithTitle:nil withMessage:@"您尚未选择地址" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

    }

    
     
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
    Manager *manager = [Manager shareInstance];
    //选择收货地址
    if ([segue.identifier isEqualToString:@"previewOrderToAddressListVC"]) {
        ReceiveAddressViewController *receiveAddressVC = [segue destinationViewController];

        receiveAddressVC.selectModelBlock = ^(){
            
            if (manager.receiveAddressArr.count > 0) {
                //刷新UI
                [self updateReceiveViewUI];
            }else {
                self.selectReceiveNameAndMobileLabel.text = @"暂无地址，请添加新地址";
                self.selectReceiveAddressLabel.text = @"---";
            }
            
        };
        
    }
    
    //选择优惠劵
    if ([segue.identifier isEqualToString:@"toSelectCouponVC"]) {
        //大于等于1000才能进入优惠券界面
        if ([self computeNoSaleProductTotalPrice] >= 1000) {
            //将产品模型传值到选择优惠券界面
            SelectCouponViewController *selectCouponVC = [segue destinationViewController];
            selectCouponVC.isSelectCoupon = YES;
            selectCouponVC.previewOrderProductArr = self.selectedProductArr;
            selectCouponVC.couponDicBlock = ^(NSDictionary *couponDicBlock){
                //优惠金额赋值
                self.saleMoneyDic = couponDicBlock;
                //刷新footView 的ui
                [self upFootview];
                
                self.bottomPayMoneyLabel.text = [NSString stringWithFormat:@"  实付款：￥%.2f", [self computeProductTotalPrice] - [[self.saleMoneyDic objectForKey:@"saleMoney"] floatValue]];
                
            };
            
        }else {
            //
            AlertManager *alertManager = [AlertManager shareIntance];
            [alertManager showAlertViewWithTitle:@"优惠券不可用" withMessage:@"非活动产品未达到1000元" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }

    }
    
    //提交订单，进入支付界面
    if ([segue.identifier isEqualToString:@"previewOrderVCToPayVC"]) {
        PayViewController *payVC = [segue destinationViewController];
        payVC.orderIDArr = @[self.creatOrderId];
        payVC.totalAmountFloat = [self computeProductTotalPrice] - [[self.saleMoneyDic objectForKey:@"saleMoney"] floatValue];
        ReceiveAddressModel *selectReceiveModel = [manager selectedReceiveAddressModel];
        payVC.receiverName = selectReceiveModel.receiverName;
        payVC.receiverPhone = selectReceiveModel.receiveMobile;

    }
    
    //跳转到cc客服
    if ([segue.identifier isEqualToString:@"previewOrderToWebViewVC"]) {
        WebPageViewController *webPageVC = [segue destinationViewController];

        webPageVC.tempTitleStr = @"在线客服";
        webPageVC.webUrl = @"http://kefu.qycn.com/vclient/chat/?m=m&websiteid=99706";
    }
    
}


@end
