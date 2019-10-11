//
//  LogisticsViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/5.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "LogisticsViewController.h"
#import "LogisticsModel.h"
#import "LogisticsTableViewCell.h"
#import "SVProgressHUD.h"
#import "UIImageView+ImageViewCategory.h"
@interface LogisticsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *logisticsDataSource;
@property (weak, nonatomic) IBOutlet UITableView *logisticsTabelView;

//headView
@property (weak, nonatomic) IBOutlet UIImageView *orderProductImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderProductTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderProductFormatLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderProductPriceLabel;

@end

@implementation LogisticsViewController

- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 让cell自适应高度
    self.logisticsTabelView.rowHeight = UITableViewAutomaticDimension;
    //设置估算高度
    self.logisticsTabelView.estimatedRowHeight = 44;
    
    //刷新头部视图
    [self upHeadView];
    
    self.logisticsDataSource = [NSMutableArray array];
    
    //网络请求物流信息
    Manager *manager = [Manager shareInstance];
    if ([SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];
    }

    [manager orderLogisticsWithOrderId:self.tempSonOrderModel.o_id withSuccessLogisticsBlock:^(id successResult) {
        [SVProgressHUD dismiss];
        
        for (NSDictionary *tempDic in successResult) {
            LogisticsModel *logisticsModel = [[LogisticsModel alloc] init];
            [logisticsModel setValuesForKeysWithDictionary:tempDic];
            [self.logisticsDataSource addObject:logisticsModel];
        }
        //刷新列表
        [self.logisticsTabelView reloadData];
        
        
    } withFailLogisticsBlock:^(NSString *failResultStr) {
        [SVProgressHUD dismiss];
        AlertManager *alertM = [AlertManager shareIntance];
        [alertM showAlertViewWithTitle:nil withMessage:@"物流信息获取失败" actionTitleArr:nil withViewController:self withReturnCodeBlock:nil];
    }];
    
    
    
}

- (void)upHeadView {
    [self.orderProductImageView setWebImageURLWithImageUrlStr:self.tempSonOrderModel.p_icon withErrorImage:[UIImage imageNamed:@"icon_pic_cp.png"] withIsCenter:YES];
    self.orderProductTitleLabel.text = self.tempSonOrderModel.p_name;
    self.orderProductFormatLabel.text = [NSString stringWithFormat:@"规格:%@  数量:%@",self.tempSonOrderModel.productst,self.tempSonOrderModel.o_num];
    self.orderProductPriceLabel.text = [NSString stringWithFormat:@"￥%@",self.tempSonOrderModel.o_price_total];
}




#pragma mark - TableView Delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logisticsDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LogisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"logisticsCell" forIndexPath:indexPath];
    
    LogisticsModel *tempLogisticsModel = self.logisticsDataSource[indexPath.row];
    if (indexPath.row == 0) {
        //隐藏上线
        [cell updateLogisticsCellWithLogisticsModel:tempLogisticsModel withHidenUpLine:YES withHidenDownLine:NO];

    }else if (indexPath.row == self.logisticsDataSource.count-1) {
        //隐藏下线
        [cell updateLogisticsCellWithLogisticsModel:tempLogisticsModel withHidenUpLine:NO withHidenDownLine:YES];
    }else {
        [cell updateLogisticsCellWithLogisticsModel:tempLogisticsModel withHidenUpLine:NO withHidenDownLine:NO];
    }
    
    return cell;
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
