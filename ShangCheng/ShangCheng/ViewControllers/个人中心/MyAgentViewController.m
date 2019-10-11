//
//  MyAgentViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyAgentViewController.h"
#import "Manager.h"
#import "MyAgentCollectionViewCell.h"
#import "SVProgressHUD.h"
#import "AgentCashApplicationViewController.h"
#import "MyAgentDetailViewController.h"
#import "MyTradeRecordViewController.h"
@interface MyAgentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//头部收益金额Label
@property (weak, nonatomic) IBOutlet UILabel *incomeAmountLabel;

//收益金额
@property (nonatomic,strong)NSString *incomeAmountStr;

//数据源
@property (nonatomic,strong)NSMutableArray *dataSourceArr;

@property (weak, nonatomic) IBOutlet UICollectionView *myAgentcCollectionView;


@end

@implementation MyAgentViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //通知，刷新代理商信息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMoneyNew:) name:@"refreshMoneyNew" object:nil];
        
    }
    return self;
}

//刷新代理商金额
- (void)refreshMoneyNew:(NSNotification *)sender {
    Manager *manager = [Manager shareInstance];
    [self httpMyAgentDataWithUserType:manager.memberInfoModel.u_type];
}


- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Manager *manager = [Manager shareInstance];
    
    if ([SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];
    }
    
    self.incomeAmountStr = @"0";
    
    
    NSMutableDictionary *oneDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"icon_wdkh",@"img",@"我的客户",@"title",@"0",@"detail", nil];
    NSMutableDictionary *twoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"icon_khdd",@"img",@"客户订单",@"title",@"0",@"detail", nil];
    NSMutableDictionary *threeDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"icon_txjl",@"img",@"提现记录",@"title",@"0",@"detail", nil];
    NSMutableDictionary *fourDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"icon_khsc",@"img",@"客户收藏",@"title",@"0",@"detail", nil];
    NSMutableDictionary *fiveDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"icon_khgwc",@"img",@"客户购物车",@"title",@"0",@"detail", nil];
    NSMutableDictionary *sixDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"icon_tcls",@"img",@"提成流水",@"title",@"0",@"detail", nil];

    self.dataSourceArr = [NSMutableArray arrayWithObjects:oneDic,twoDic,threeDic,fourDic,fiveDic,sixDic, nil];
    
    
    [self httpMyAgentDataWithUserType:manager.memberInfoModel.u_type];
    
}




#pragma mark - 请求代理信息 -
//网络请求代理数据
- (void)httpMyAgentDataWithUserType:(NSString *)userType {
    Manager *manager = [Manager shareInstance];
    //如果是代理。请求代理数据
    if ([userType integerValue] == 1) {
        [manager httpMyAgentBaseDataWithUserId:manager.memberInfoModel.u_id withMyAgentSuccess:^(id successResult) {
            //客户个数
            NSMutableDictionary *oneDic = self.dataSourceArr[0];
            [oneDic setValue:[successResult objectForKey:@"peonum"] forKey:@"detail"];
            //订单个数
            NSMutableDictionary *twoDic = self.dataSourceArr[1];
            [twoDic setValue:[successResult objectForKey:@"ordernum"] forKey:@"detail"];
            [self.myAgentcCollectionView reloadData];
        
            
            self.incomeAmountStr = [successResult objectForKey:@"a_commission"];
            
            [self upHeaderView];

            
            
        } withMyagentFail:^(NSString *failResultStr) {
            
        }];
        
    }
    
}


//更新头部View
- (void)upHeaderView {
    self.incomeAmountLabel.text = self.incomeAmountStr;
}




#pragma mark - Collection Delegate -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenW - 44)/3, (kScreenW - 44)/3);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyAgentCollectionViewCell *myAgentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myAgentCollectionCell" forIndexPath:indexPath];
    [myAgentCell updateMyAgentCollectionCellWithDataDic:self.dataSourceArr[indexPath.row]];
    return myAgentCell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"myAgentToTradeRecordVC" sender:indexPath];

    }else {
        [self performSegueWithIdentifier:@"myAgentToDetailVC" sender:indexPath];
    }
    
}

#pragma mark - 代理商提现 -
- (IBAction)AgentCashBtnAction:(UIButton *)sender {
    AlertManager *alertM = [AlertManager shareIntance];
    if ([self.incomeAmountStr floatValue] > 0) {
        //跳转到提现界面
        [self performSegueWithIdentifier:@"myAgentToCashVC" sender:nil];
        
        
    }else {
        [alertM showAlertViewWithTitle:@"暂时不能提现" withMessage:@"您还没有收益" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
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
    if ([segue.identifier isEqualToString:@"myAgentToCashVC"]) {
        AgentCashApplicationViewController *agentCashVC = [segue destinationViewController];
        agentCashVC.cashType = @"agentCash";
        agentCashVC.agentCashCommission = self.incomeAmountStr;
    }
    
    if ([segue.identifier isEqualToString:@"myAgentToDetailVC"]) {
        MyAgentDetailViewController *myAgentDetailVC = [segue destinationViewController];
        myAgentDetailVC.myAgentType = ((NSIndexPath *)sender).row;
    }
    
    
    if ([segue.identifier isEqualToString:@"myAgentToTradeRecordVC"]) {
        //提现记录
        MyTradeRecordViewController *myRecordVC = [segue destinationViewController];
        myRecordVC.isCash = YES;
    }
    
}


@end
