//
//  SelectCouponViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/11.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "SelectCouponViewController.h"
#import "CouponTableViewCell.h"
#import "AddCouponViewController.h"
#import "Manager.h"
#import "KongImageView.h"
#import "SVProgressHUD.h"
@interface SelectCouponViewController ()<UITableViewDelegate,UITableViewDataSource>
//空白页
@property (nonatomic,strong)KongImageView *kongImageView;

@property (nonatomic,strong)NSMutableArray *couponDataSourceArr;
//TableView
@property (weak, nonatomic) IBOutlet UITableView *couponTableView;

@end

@implementation SelectCouponViewController
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //通知,刷新列表
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCouponAction:) name:@"refreshCouponCount" object:nil];
        
        
    }
    return self;
}
//刷新列表
- (void)refreshCouponAction:(NSNotification *)sender {
    [self updateCouponListData];
}

- (IBAction)leftBarbuttonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //加载空白页
    self.kongImageView = [[[NSBundle mainBundle] loadNibNamed:@"KongImageView" owner:self options:nil] firstObject];
    [self.kongImageView.reloadAgainButton addTarget:self action:@selector(reloadAgainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.kongImageView.frame = self.view.bounds;
    [self.view addSubview:self.kongImageView];

    //网络加载数据
    [self updateCouponListData];
    
}

//重新加载按钮
- (void)reloadAgainButtonAction:(UIButton *)sender {
    
    //网络加载数据
    [self updateCouponListData];

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)updateCouponListData {
    //数据请求优惠券
    Manager *manager = [Manager shareInstance];
    if ([SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];
    }

    [manager httpCouponListWithUserID:manager.memberInfoModel.u_id withCouponSuccessResult:^(id successResult) {
        [SVProgressHUD dismiss];//风火轮消失
        [self.kongImageView hiddenKongView];//空白页消失
        self.couponDataSourceArr = successResult;
        //刷新数据
        [self.couponTableView reloadData];
        
    } withCouponFailResult:^(NSString *failResultStr) {
        NSLog(@"%@",failResultStr);
        [SVProgressHUD dismiss];//风火轮消失
        [self.kongImageView showKongViewWithKongMsg:@"网络错误" withKongType:KongTypeWithNetError];
        
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 40;
    }else{
        return 186;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.isSelectCoupon == YES) {
            return 1;
        }else {
            return 0;

        }
    }
    return self.couponDataSourceArr.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 0) {
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"noSelectCouponCell" forIndexPath:indexPath];
        
        return cell1;
    }else {
        CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"couponCell" forIndexPath:indexPath];
        CouponModel *tempModel = self.couponDataSourceArr[indexPath.row];
        
        [cell updateCouponCellWith:tempModel];
        
        return cell;

    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSelectCoupon == YES) {
        if (indexPath.section == 0) {
            //不选择任何购物券
            self.couponDicBlock(@{@"couponId":@"",@"saleCode":@"",@"saleMoney":@"0"});
            //
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            Manager *manager = [Manager shareInstance];
            //得到点击的这个购物券
            CouponModel *tempModel = self.couponDataSourceArr[indexPath.row];
            
            //创建购物车id数组
            NSMutableArray *shoppingCarIdArr = [NSMutableArray array];
            for (ShoppingCarModel *tempCarModel in self.previewOrderProductArr) {
                [shoppingCarIdArr addObject:tempCarModel.c_id];
            }
            AlertManager *alertM = [AlertManager shareIntance];
            //网络请求计算优惠券金额
            [manager httpComputeCouponMoneyWithUserID:manager.memberInfoModel.u_id withCouponID:tempModel.c_id withShoppingCarIDArr:shoppingCarIdArr withComputeMoneySuccessResult:^(id successResult) {
                //去掉“”引号
                //        successResult = [(NSString *)successResult stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                //返回到预订单界面
                self.couponDicBlock(@{@"couponId":tempModel.c_id,@"saleCode":tempModel.c_code,@"saleMoney":successResult});
                //
                [self.navigationController popViewControllerAnimated:YES];
                
                
            } withComputeMoneyFailResult:^(NSString *failResultStr) {
                //
                [alertM showAlertViewWithTitle:nil withMessage:@"优惠券计算失败，请稍后再试，或者联系客服" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
            }];

        }
      
    }
}

//绑定优惠券，即添加优惠券
- (IBAction)addCouponButtonAction:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toAddCouponVC" sender:nil];
    
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
    
    
}


@end
