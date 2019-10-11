//
//  OrderDetailViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/20.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailOneTableViewCell.h"
#import "OrderDetailTwoTableViewCell.h"
#import "OrderDetailFootOneTableViewCell.h"
#import "OrderDetailFootTwoTableViewCell.h"
#import "ProductDetailViewController.h"
#import "LogisticsViewController.h"
#import "CommentViewController.h"
#import "PayViewController.h"
#import "MJRefresh.h"
@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
//头部View的控件
//父订单编号
@property (weak, nonatomic) IBOutlet UILabel *supOrderCodeLabel;
//父订单状态
@property (weak, nonatomic) IBOutlet UILabel *supOrderStatusLabel;
//收货人
@property (weak, nonatomic) IBOutlet UILabel *consignorLabel;
//收货人手机
@property (weak, nonatomic) IBOutlet UILabel *consignorMobileLabel;
//收货地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

//子订单TableView
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

//底部商品总额等信息数据
@property (nonatomic,strong)NSArray *cellTwoDataSource;

//底部view的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation OrderDetailViewController
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}




- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    // 让cell自适应高度
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    //设置估算高度
//    self.tableView.estimatedRowHeight = 44;
    
    //更新头部
    [self updateHeaderView];

    
    NSDictionary *dic1 =@{@"商品总额":self.tempSupOrderModel.p_o_price_total};
    NSDictionary *dic2 =@{@"优惠金额":self.tempSupOrderModel.p_discount};
    NSDictionary *dic3 =@{@"数量":self.tempSupOrderModel.p_num};
    NSDictionary *dic4 =@{@"下单时间":self.tempSupOrderModel.p_time_create};

    self.cellTwoDataSource = @[dic1,dic2,dic3,dic4];
    
    if ([self.tempSupOrderModel.p_status isEqualToString:@"0"] || [self.tempSupOrderModel.p_status isEqualToString:@"1B"]) {
        self.bottomView.hidden = NO;
        self.bottomViewHeight.constant = 40;

    }else {
        self.bottomView.hidden = YES;
        self.bottomViewHeight.constant = 0;

    }
    //下拉刷新
    [self downRefreshAction];
}

//下拉刷新
- (void)downRefreshAction {
    Manager *manager = [Manager shareInstance];
    [self.detailTableView addHeaderWithCallback:^{
        //重新网络请求这个订单
        [manager httpGetOrderInfoWithOrderId:self.tempSupOrderModel.p_id withOrderInfoSuccess:^(id successResult) {
            //请求到了最新订单信息
            self.tempSupOrderModel = successResult;
            
            //更新头部
            [self updateHeaderView];
            
            NSDictionary *dic1 =@{@"商品总额":self.tempSupOrderModel.p_o_price_total};
            NSDictionary *dic2 =@{@"优惠金额":self.tempSupOrderModel.p_discount};
            NSDictionary *dic3 =@{@"数量":self.tempSupOrderModel.p_num};
            NSDictionary *dic4 =@{@"下单时间":self.tempSupOrderModel.p_time_create};
            
            self.cellTwoDataSource = @[dic1,dic2,dic3,dic4];
            
            if ([self.tempSupOrderModel.p_status isEqualToString:@"0"] || [self.tempSupOrderModel.p_status isEqualToString:@"1B"]) {
                self.bottomView.hidden = NO;
                self.bottomViewHeight.constant = 40;
                
            }else {
                self.bottomView.hidden = YES;
                self.bottomViewHeight.constant = 0;
                
            }
            [self.detailTableView reloadData];
            
            //下拉动画消失
            [self.detailTableView headerEndRefreshing];
            
        } withOrderInfoFail:^(NSString *failResultStr) {
            //下拉动画消失
            [self.detailTableView headerEndRefreshing];
        }];
        
    }];
}


//刷新头部视图的信息：父订单号 状态 收货人信息等
- (void)updateHeaderView {
    //父订单号
    self.supOrderCodeLabel.text = self.tempSupOrderModel.p_code;
    //父订单状态
    self.supOrderStatusLabel.text = self.tempSupOrderModel.statusvalue;
    //收货人
    self.consignorLabel.text = self.tempSupOrderModel.p_truename;
    //收货人手机
    if (self.tempSupOrderModel.p_mobile.length > 0) {
        self.consignorMobileLabel.text = self.tempSupOrderModel.p_mobile;
    }else if (self.tempSupOrderModel.p_telephone.length > 0) {
        self.consignorMobileLabel.text = self.tempSupOrderModel.p_telephone;
    }
    //收货地址
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",self.tempSupOrderModel.capitalname,self.tempSupOrderModel.cityname,self.tempSupOrderModel.countyname,self.tempSupOrderModel.p_address];
}

#pragma mark - TableView delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //子订单个数 + 1；  那个+1就是商品总额优惠金额支付时间等底部的cell
    return self.tempSupOrderModel.subOrderArr.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.tempSupOrderModel.subOrderArr.count) {
        return 1;
    }else {
        return 4;
    }
    
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.tempSupOrderModel.subOrderArr.count) {
        return 133  ;
        
    }else {
        return 40;
    }
}

//footView高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section < self.tempSupOrderModel.subOrderArr.count) {
        
        //1A状态没有footView
        SonOrderModel *tempSonOrderModel = self.tempSupOrderModel.subOrderArr[section];
        if ([tempSonOrderModel.o_status isEqualToString:@"1A"]) {
            return 1;
        }else {
            return 47;
        }
        
    }else{
        return 60;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    //返回值就是区页脚。那么我们就让他返回footViewCell
    if (section < self.tempSupOrderModel.subOrderArr.count) {
        SonOrderModel *tempSonOrderModel = self.tempSupOrderModel.subOrderArr[section];
        if ([tempSonOrderModel.o_status isEqualToString:@"1A"]){
            //空view
            UIView *kongView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
            return kongView;
        }else {
            OrderDetailFootOneTableViewCell *footViewCellOne = [tableView dequeueReusableCellWithIdentifier:@"footViewOne"];
            footViewCellOne.buttonOne.indexForButton = [NSIndexPath indexPathForRow:0 inSection:section];
            footViewCellOne.buttonTwo.indexForButton = [NSIndexPath indexPathForRow:0 inSection:section];
            footViewCellOne.tempSonOrder = tempSonOrderModel;
            [footViewCellOne updateOrderDetailFootOneCell:tempSonOrderModel];

            
            return footViewCellOne;
        }
        

    }else {
        OrderDetailFootTwoTableViewCell *footViewCellTwo = [tableView dequeueReusableCellWithIdentifier:@"footViewTwo"];
        
        [footViewCellTwo updateOrderDetailTwoFootCell:self.tempSupOrderModel];
        return footViewCellTwo;

    }
    
}


/*button代表的功能block
 1 -- 取消子订单
 2 -- 查看物流（待发货状态中的详情也是物流信息）
 3 -- 确认收货
 4 -- 立即评价
 5 -- 再次购买
 */

//footView的第一个按钮
- (IBAction)oneFootButtonAction:(IndexButton *)sender {
    //子订单
    SonOrderModel *tempSonOrderModel = self.tempSupOrderModel.subOrderArr[sender.indexForButton.section];

    NSInteger typeInt = 0;
    //待支付 带确认 都是取消订单
    if ([tempSonOrderModel.o_status isEqualToString:@"0"] || [tempSonOrderModel.o_status isEqualToString:@"1B"]) {
        //
        typeInt = 1;
    }
    
    if ([tempSonOrderModel.o_status isEqualToString:@"1"] || [tempSonOrderModel.o_status isEqualToString:@"2"] || [tempSonOrderModel.o_status isEqualToString:@"3A"] || [tempSonOrderModel.o_status isEqualToString:@"3B"] || [tempSonOrderModel.o_status isEqualToString:@"3"] || [tempSonOrderModel.o_status isEqualToString:@"4A"] || [tempSonOrderModel.o_status isEqualToString:@"4"] ) {
        typeInt = 2;
    }
    
    if ([tempSonOrderModel.o_status isEqualToString:@"5A"] || [tempSonOrderModel.o_status isEqualToString:@"5B"]) {
        //
        typeInt = 2;
    }
    
    if ([tempSonOrderModel.o_status isEqualToString:@"5"] ) {
        //
        typeInt = 2;
    }
    
    if ([tempSonOrderModel.o_status isEqualToString:@"9"]) {
        typeInt = 5;
    }
    
    //对子订单的操作
    [self sonOrderActionWithTypeInt:typeInt withSonOrder:tempSonOrderModel];
}
//footView的第二个按钮
- (IBAction)twoFootButtonAction:(IndexButton *)sender {
    SonOrderModel *tempSonOrderModel = self.tempSupOrderModel.subOrderArr[sender.indexForButton.section];

    NSInteger typeInt = 0;

    //待收货 确认收货
    if ([tempSonOrderModel.o_status isEqualToString:@"5"]) {

        typeInt = 3;//确认收货
    }
    
    //已完成 立即评价
    if ([tempSonOrderModel.o_status isEqualToString:@"9"]) {

        typeInt = 4;
    }

    //对子订单的操作
    [self sonOrderActionWithTypeInt:typeInt withSonOrder:tempSonOrderModel];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section < self.tempSupOrderModel.subOrderArr.count) {
        OrderDetailOneTableViewCell *oneCell = [tableView dequeueReusableCellWithIdentifier:@"orderDetailOneCell" forIndexPath:indexPath];
        [oneCell updateOrderDetailOneCellWithSonOrder:self.tempSupOrderModel.subOrderArr[indexPath.section]];
        
        return oneCell;
        
    }else{
        OrderDetailTwoTableViewCell *twoCell = [tableView dequeueReusableCellWithIdentifier:@"orderDetailTwoCell" forIndexPath:indexPath];
        [twoCell updateOrderDetailTwoCellDataSourceDic:self.cellTwoDataSource[indexPath.row]];
        return twoCell;
    }
    
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section < self.tempSupOrderModel.subOrderArr.count) {
        SonOrderModel *tempSonOrderModel = self.tempSupOrderModel.subOrderArr[indexPath.section];
        [self performSegueWithIdentifier:@"orderToDetailVC" sender:tempSonOrderModel.o_specification_id];
        
        
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 子订单的操作 -
- (void)sonOrderActionWithTypeInt:(NSInteger)typeInt withSonOrder:(SonOrderModel *)tempSonOrder {
    AlertManager *alertM = [AlertManager shareIntance];
    Manager *manager = [Manager shareInstance];
    
    switch (typeInt) {
        case 1:
        {
            [alertM showAlertViewWithTitle:nil withMessage:@"是否确认取消该产品" actionTitleArr:@[@"取消",@"确认"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                if (actionBlockNumber == 1) {
                    [manager cancelSonOrderWithUserId:manager.memberInfoModel.u_id withOrderID:tempSonOrder.o_id withCancelMessage:@"不喜欢" withCancelSuccessResult:^(id successResult) {
                        //取消成功后
                        self.tempSupOrderModel = successResult;
                        //刷新UI
                        [self.detailTableView reloadData];
                        
                        //刷新一下底部view
                        if ([self.tempSupOrderModel.p_status isEqualToString:@"0"] || [self.tempSupOrderModel.p_status isEqualToString:@"1B"]) {
                            self.bottomView.hidden = NO;
                            self.bottomViewHeight.constant = 40;
                            
                        }else {
                            self.bottomView.hidden = YES;
                            self.bottomViewHeight.constant = 0;
                            
                        }

                        
                        //发送通知到订单列表界面，刷新列表数据
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:self userInfo:nil];
                        
                    } withCancelFailResult:^(NSString *failResultStr) {
                        NSLog(@"取消失败");
                        [alertM showAlertViewWithTitle:nil withMessage:@"取消失败,请稍后再试" actionTitleArr:nil withViewController:self withReturnCodeBlock:nil];
                    }];

                }
            }];

        }
            break;
        case 2:
            NSLog(@"物流");
            //跳转到物流界面
            [self performSegueWithIdentifier:@"orderDetailToLogisticsVC" sender:tempSonOrder];
            break;
        case 3:
        {
            NSLog(@"确认收货");
            [alertM showAlertViewWithTitle:nil withMessage:@"是否要确认收货" actionTitleArr:@[@"取消",@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                
                if (actionBlockNumber == 1) {
                    //确认收货
                    [manager httpSonOrderEnterReceiptWithUserId:manager.memberInfoModel.u_id withSonOrderId:tempSonOrder.o_id withReceiptSuccess:^(id successResult) {
                        //确认收货成功
                        self.tempSupOrderModel = successResult;
                        //刷新UI
                        [self.detailTableView reloadData];
                        
                        //刷新一下底部view
                        if ([self.tempSupOrderModel.p_status isEqualToString:@"0"] || [self.tempSupOrderModel.p_status isEqualToString:@"1B"]) {
                            self.bottomView.hidden = NO;
                            self.bottomViewHeight.constant = 40;
                            
                        }else {
                            self.bottomView.hidden = YES;
                            self.bottomViewHeight.constant = 0;
                            
                        }
                        
                        //发送通知到订单列表界面，刷新列表数据
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:self userInfo:nil];

                    } withReceiptFail:^(NSString *failResultStr) {
                        [alertM showAlertViewWithTitle:nil withMessage:@"确认收货失败,请稍后再试" actionTitleArr:nil withViewController:self withReturnCodeBlock:nil];

                    }];
                    
                    
                }
            }];
            
            
            
        }
            
            break;
        case 4:
            NSLog(@"立即评价");
            [self performSegueWithIdentifier:@"orderDetailToCommentVC" sender:tempSonOrder];
            break;
        case 5:
            NSLog(@"再次购买");

            [self performSegueWithIdentifier:@"orderToDetailVC" sender:tempSonOrder.o_specification_id];
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 底部的view上的两个按钮的功能，这两个操作是对这个父订单的操作 -
//底部  去付款
- (IBAction)paySupOrderAction:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"orderDetailToPayVC" sender:self.tempSupOrderModel];
    
}

//底部  取消订单
- (IBAction)cancelSupOrderAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    
    [alertM showAlertViewWithTitle:nil withMessage:@"是否确认取消该订单" actionTitleArr:@[@"取消",@"确认"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
        if (actionBlockNumber == 1) {
            [manager cancelSupOrderWithUserID:manager.memberInfoModel.u_id wiOrderID:self.tempSupOrderModel.p_id withCancelSuccessResult:^(id successResult) {

                [alertM showAlertViewWithTitle:nil withMessage:@"取消订单成功" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                    //取消订单后，刷新 当前TableView。其他的在切换的时候刷新
                    self.tempSupOrderModel = successResult;
                    [self.detailTableView reloadData];
                    //取消后，底部按钮view消失
                    self.bottomView.hidden = YES;
                    self.bottomViewHeight.constant = 0;
                    
                    //block
                    self.refreshOrderListBlock();
                }];
                
                
            } withCancelFailResult:^(NSString *failResultStr) {
                [alertM showAlertViewWithTitle:nil withMessage:@"取消订单失败" actionTitleArr:nil withViewController:self withReturnCodeBlock:nil];
            }];

        }
    }];
    

    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //到产品详情中
    if ([segue.identifier isEqualToString:@"orderToDetailVC"]) {
        ProductDetailViewController *productDetailVC = [segue destinationViewController];
        productDetailVC.productID = sender;
        productDetailVC.type = @"sid";

    }
    //物流
    if ([segue.identifier isEqualToString:@"orderDetailToLogisticsVC"]) {
        LogisticsViewController *logisticsVC = [segue destinationViewController];
        logisticsVC.tempSonOrderModel = sender;
        
    }
    
    //评价
    if ([segue.identifier isEqualToString:@"orderDetailToCommentVC"]) {
        CommentViewController *commentVC = [segue destinationViewController];
        commentVC.tempSonOrderModel = sender;
        commentVC.RefreshCommentAfterBlock = ^(){
            //评价后，刷新UI
            [self.detailTableView reloadData];
        };
        
    }
    
    //到去支付页面
    if ([segue.identifier isEqualToString:@"orderDetailToPayVC"]) {
        NSMutableArray *payVCIdArr = [NSMutableArray array];
        [payVCIdArr addObject:self.tempSupOrderModel.p_id];
        
        PayViewController *payVC = [segue destinationViewController];
        payVC.orderIDArr = payVCIdArr;
        payVC.totalAmountFloat = [self.tempSupOrderModel.p_o_price_total floatValue] - [self.tempSupOrderModel.p_discount floatValue];
        payVC.receiverName = self.tempSupOrderModel.p_truename;
        payVC.receiverPhone = self.tempSupOrderModel.p_mobile;

    }
    
}


@end
