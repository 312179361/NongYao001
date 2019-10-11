//
//  MineViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/1.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "MineViewController.h"
#import "MineHeaderCollectionReusableView.h"
#import "MineCollectionViewCellOne.h"
#import "MineCollectionViewCellTwo.h"
#import "MineCollectionViewCellThree.h"
#import "MineCollectionViewCellFour.h"
#import "Manager.h"
#import "MyTradeRecordViewController.h"
#import "MemberManagerViewController.h"
#import "MyFavoriteListViewController.h"
#import "OrderListViewController.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
@interface MineViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *mineCollectionView;

@property (nonatomic,strong)NSMutableArray *mineDataSource;

@property (nonatomic,strong)NSDictionary *myAgentDic;
//代付款
@property (nonatomic,strong)NSString *waitPayCount;
//待收货
@property (nonatomic,strong)NSString *waitReceiveCount;


@end

@implementation MineViewController
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //通知，登陆成功
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logedInAction:) name:@"logedIn" object:nil];
        //通知，退出登录
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logOffAction:) name:@"logOff" object:nil];
        //通知，刷新优惠券个数
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCouponAction:) name:@"refreshCouponCount" object:nil];
        //通知，刷新账户信息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMemberHeaderViewUI:) name:@"refreshMemberInfoUI" object:nil];
        //通知，刷新金额
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMoney:) name:@"refreshMoney" object:nil];
        //通知，刷新代理商信息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMoneyNew:) name:@"refreshMoneyNew" object:nil];


        
    }
    return self;
}
//登录成功后的通知
- (void)logedInAction:(NSNotification *) sender {
    //判断是不是代理，然后就更新UI，
    Manager *manager = [Manager shareInstance];
    [self updateDatasourceWithUserType:manager.memberInfoModel.u_type withIsReloadData:YES];
    
    //如果是代理。请求代理数据
    [self updateMyAgentDataWithUserType:manager.memberInfoModel.u_type];
    [self updateMyWalletWithIsLogin:YES];
   
    
    
}
//退出登录后的通知
- (void)logOffAction:(NSNotification *) sender {
    [self updateDatasourceWithUserType:@"2" withIsReloadData:YES];//退出登陆了，就默认显示普通用户模式
    [self updateMyWalletWithIsLogin:NO];
   
    

    
}

//刷新我的钱包 即优惠券个数
- (void)refreshCouponAction:(NSNotification *)sender {
    [self updateMyWalletWithIsLogin:YES];
}

//刷新用户头像
- (void)refreshMemberHeaderViewUI:(NSNotification *)sender {
    //刷新一下用户的信息如头像，名称等
    [self.mineCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

//刷新用户金额
- (void)refreshMoney:(NSNotification *)sender {
    [self updateMyWalletWithIsLogin:YES];

}
//刷新代理商金额
- (void)refreshMoneyNew:(NSNotification *)sender {
    Manager *manager = [Manager shareInstance];
    [self updateMyAgentDataWithUserType:manager.memberInfoModel.u_type];
}


//加载模块数据源
- (void)updateDatasourceWithUserType:(NSString *)userType withIsReloadData:(BOOL)isReloadData {
    NSString *jsonPath = [[NSBundle mainBundle]pathForResource:@"mineDataSource" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    //解析得到返回结果
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSInteger userTypeNum = [userType integerValue];
    
    
    switch (userTypeNum) {
        case 1:
            //代理商
            self.mineDataSource = [jsonDic objectForKey:@"delegateUser"];
            break;
        case 2:
            //普通用户
            self.mineDataSource = [jsonDic objectForKey:@"ordinaryUser"];
            break;
        default:
            //其他用户，暂时显示普通用户模式
            self.mineDataSource = [jsonDic objectForKey:@"ordinaryUser"];

            break;
    }
    if (isReloadData == YES) {
        [self.mineCollectionView reloadData];

    }

    
}

//网络请求代理数据
- (void)updateMyAgentDataWithUserType:(NSString *)userType {
    Manager *manager = [Manager shareInstance];
    //如果是代理。请求代理数据
    if ([userType integerValue] == 1) {
        [manager httpMyAgentBaseDataWithUserId:manager.memberInfoModel.u_id withMyAgentSuccess:^(id successResult) {
            
            self.myAgentDic = successResult;
            
            [self.mineCollectionView reloadSections:[NSIndexSet indexSetWithIndex:3]];
            
            
        } withMyagentFail:^(NSString *failResultStr) {
            
        }];
        
    }

}
//我的钱包
- (void)updateMyWalletWithIsLogin:(BOOL)isLogin {
    Manager *manager = [Manager shareInstance];
   
    if (isLogin == YES) {
        if ([SVProgressHUD isVisible] == NO) {
            [SVProgressHUD show];
        }

        [manager httpMyWalletWithUserId:manager.memberInfoModel.u_id withMyWalletSuccess:^(id successResult) {
            [SVProgressHUD dismiss];
            [self.mineCollectionView headerEndRefreshing];
            [self.mineCollectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
            
        } withMyWalletFail:^(NSString *failResultStr) {
            [SVProgressHUD dismiss];
            [self.mineCollectionView headerEndRefreshing];

        }];

    }else {
        [self.mineCollectionView headerEndRefreshing];

        manager.myWalletDic = nil;
        [self.mineCollectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
    }
    
    
}


//网络请求代付款订单个数
- (void)updateWaitPayCountWithIsLogin:(BOOL)isLogin {
    Manager *manager = [Manager shareInstance];
    
    if (isLogin == YES) {
        
        [manager httpWaitPayAndWaitReceiveCountWithUserid:manager.memberInfoModel.u_id withCountSuccess:^(id successResult) {
            self.waitPayCount = [successResult objectAtIndex:0];
            self.waitReceiveCount = [successResult objectAtIndex:1];
            ;
            [self.mineCollectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
            [self.mineCollectionView headerEndRefreshing];

        } withCountFail:^(NSString *failResultStr) {
            [self.mineCollectionView headerEndRefreshing];
        }];
        
    }else {
        [self.mineCollectionView headerEndRefreshing];
        self.waitPayCount = @"0";
        self.waitReceiveCount = @"0";
        [self.mineCollectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        NSLog(@"iOS11以上");
        self.mineCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    }else {
        NSLog(@"iOS11以下");
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    Manager *manager = [Manager shareInstance];
    
    //判断状态，现在是否登陆了，用户显示是代理商还是普通用户
    if ([manager isLoggedInStatus] == YES) {
        //已经登录
        [self updateDatasourceWithUserType:manager.memberInfoModel.u_type withIsReloadData:NO];

        //如果是代理。请求代理数据
        [self updateMyAgentDataWithUserType:manager.memberInfoModel.u_type];
        
        //请求余额 可提现 优惠卷个数
        [self updateMyWalletWithIsLogin:YES];
        
        
        

        
    }else {
        //未登录
        [self updateDatasourceWithUserType:@"2" withIsReloadData:NO];//未登录，默认显示普通用户
        [self updateMyWalletWithIsLogin:NO];


        
    }
    
    //下拉刷新
    [self downRefreshAction];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self scrollViewDidScroll:self.mineCollectionView];
    self.waitPayCount = @"0";
    self.waitReceiveCount = @"0";
    //刷新代付款和待收货个数
    Manager *manager = [Manager shareInstance];
    [self updateWaitPayCountWithIsLogin:[manager isLoggedInStatus]];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    Manager *manager = [Manager shareInstance];
    [self.navigationController.navigationBar setBackgroundImage:[manager getImageWithAlpha:1] forBarMetrics:UIBarMetricsDefault];
    //显示navigation 那条线
    [manager isClearNavigationBarLine:NO withNavigationController:self.navigationController];

    [SVProgressHUD dismiss];
}

#pragma mark - 下拉刷新 -
- (void)downRefreshAction {
    
    [self.mineCollectionView addHeaderWithCallback:^{
        
        Manager *manager = [Manager shareInstance];
        //判断状态，现在是否登陆了，用户显示是代理商还是普通用户
        if ([manager isLoggedInStatus] == YES) {
            //已经登录
            [self updateDatasourceWithUserType:manager.memberInfoModel.u_type withIsReloadData:NO];
            
            //如果是代理。请求代理数据
            [self updateMyAgentDataWithUserType:manager.memberInfoModel.u_type];
            
            //请求余额 可提现 优惠卷个数
            [self updateMyWalletWithIsLogin:YES];
           
            

            
        }else {
            //未登录
            [self updateDatasourceWithUserType:@"2" withIsReloadData:NO];//未登录，默认显示普通用户
            [self updateMyWalletWithIsLogin:NO];
           
            
        }

        
    }];
    
}


#pragma mark - 头部隐藏 -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    Manager *manager = [Manager shareInstance];
    CGFloat yOffset  = scrollView.contentOffset.y;
    NSLog(@"++%f",yOffset);

    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    CGFloat alpha=yOffset/80.0f>1.0f?1:yOffset/80.0f;
    NSLog(@"%f",alpha);
    //改变navigation的背景色
    [self.navigationController.navigationBar setBackgroundImage:[manager getImageWithAlpha:alpha] forBarMetrics:UIBarMetricsDefault];
    //改变通知按钮的颜色
    if (alpha>0.6) {
        self.navigationItem.rightBarButtonItem.tintColor = kColor(57, 209, 103, 1);
        [manager isClearNavigationBarLine:NO withNavigationController:self.navigationController];
        
    }else{
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        [manager isClearNavigationBarLine:YES withNavigationController:self.navigationController];

        
    }
    
}



#pragma mark - 头部的一些事件 -
//点击头像，如果没有登录，就登录，如果登录了就切换头像
- (IBAction)headerButtonAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    if ([manager isLoggedInStatus] == YES) {
        //已经登录
    }else {
        //未登录,跳转到登录界面
        UINavigationController *loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        [self presentViewController:loginNav animated:YES completion:nil];
    }
}


- (IBAction)memberManagerAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"mineToMemberManager" sender:nil];

}


#pragma mark - collectionView Delegate - 
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.mineDataSource.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    return [[self.mineDataSource objectAtIndex:section] count];
}

//分区头部大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 2 || section == 3) {
        //如果有这个分区有内容，才有这个分区头。否则就不要分区头
        if ([[self.mineDataSource objectAtIndex:section] count] > 0) {
            return CGSizeMake(kScreenW, 40);

        }else{
            return CGSizeMake(kScreenW, 0);

        }
    }else {
        return CGSizeMake(kScreenW, 0);
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if ([[self.mineDataSource objectAtIndex:section] count]==0) {
        return CGSizeMake(kScreenW, 0);
    }
    return CGSizeMake(kScreenW, 11);
}

//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return CGSizeMake(kScreenW, 182);
            break;
        case 1:
        case 2:
            return CGSizeMake(kScreenW/[[self.mineDataSource objectAtIndex:indexPath.section] count], 68);
            break;
        case 3:
            return CGSizeMake(kScreenW/3, 68);
            break;
        case 4:
            return CGSizeMake((kScreenW-3)/4, kScreenW/4);
        default:
            return CGSizeMake(kScreenW, 0);
            break;
    }
    
}
//头部设置
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MineHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mineHeader" forIndexPath:indexPath];
        
        switch (indexPath.section) {
            case 1:
                [headerView updateHeaderCellWithTitleStr:@"我的订单" withButtonTitle:@"查看全部订单"];
                break;
            case 2:
                [headerView updateHeaderCellWithTitleStr:@"我的钱包" withButtonTitle:@"查看"];

                break;
            case 3:
                [headerView updateHeaderCellWithTitleStr:@"我的代理" withButtonTitle:@"查看"];
                
                break;
            default:
                break;
        }
        
        headerView.headerCellButton.indexForButton = indexPath;
        
        
        
        return headerView;
    }else {
        UICollectionReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"mineFoot" forIndexPath:indexPath];
        return footView;
    }
    
//    return 0;
}

- (IBAction)headerButtoonAction:(IndexButton *)sender {
    NSLog(@"%ld",sender.indexForButton.section);
    
    //需要先登录才能进入
    Manager *manager = [Manager shareInstance];
    if ([manager isLoggedInStatus] == YES) {
        switch (sender.indexForButton.section) {
            case 1:
            {
                //跳转到全部订单
                [self performSegueWithIdentifier:@"mineToOrderListVC" sender:nil];

            }
                break;
            case 2:
            {
                //跳转到我的钱包
                [self performSegueWithIdentifier:@"mineToMyWallet" sender:nil];
            }
                break;
            case 3:
            {
                //跳转到我的代理
                [self performSegueWithIdentifier:@"mineToAgentVC" sender:nil];
            }
                break;
                
            default:
                break;
        }

    }else {
        //没登录，提醒
        AlertManager *alertM = [AlertManager shareIntance];
        [alertM showAlertViewWithTitle:nil withMessage:@"您还未登录，请先登录" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
            //未登录,跳转到登录界面
            UINavigationController *loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
            [self presentViewController:loginNav animated:YES completion:nil];
        }];
    }
    
    
}


//设置collectionViewCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];

    NSDictionary *infoDic = [[self.mineDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    
    switch (indexPath.section) {
        case 0:
        {
            MineCollectionViewCellOne *cellOne = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineCellOne" forIndexPath:indexPath];
            [cellOne updateMineCollectionViewCellOne];
            
            return cellOne;
        }
            break;
            
        case 1:
        {
            MineCollectionViewCellTwo *cellTwo = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineCellTwo" forIndexPath:indexPath];
            if (indexPath.row == 0) {
                [cellTwo updateCellWithHeaderImage:[infoDic objectForKey:@"icon1"] withInfoStr:[infoDic objectForKey:@"info"] withFontFloat:12 withLineViewHide:YES withCount:self.waitPayCount];

            }else {
                [cellTwo updateCellWithHeaderImage:[infoDic objectForKey:@"icon1"] withInfoStr:[infoDic objectForKey:@"info"] withFontFloat:12 withLineViewHide:YES withCount:self.waitReceiveCount];

            }
            return cellTwo;
            
        }
            break;

        case 2:
        {
            if (indexPath.row < 3) {
                //上文字，下文字
                MineCollectionViewCellThree *cellThree = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineCellThree" forIndexPath:indexPath];
                NSString *detailInfo = @"--";
                switch (indexPath.row) {
                    case 0:
                        detailInfo = [manager.myWalletDic objectForKey:@"u_amount"];
                        break;
                    case 1:
                        detailInfo = [manager.myWalletDic objectForKey:@"u_amount_avail"];
                        break;
                    case 2:
                        detailInfo = [manager.myWalletDic objectForKey:@"coupon"];
                        break;
                    default:
                        break;
                }
                [cellThree updateCellWithHeaderStr:detailInfo withInfoStr:[infoDic objectForKey:@"info"]];
                return cellThree;
            }else {
                MineCollectionViewCellTwo *cellTwo = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineCellTwo" forIndexPath:indexPath];
                [cellTwo updateCellWithHeaderImage:[infoDic objectForKey:@"icon1"] withInfoStr:[infoDic objectForKey:@"info"] withFontFloat:12 withLineViewHide:YES withCount:@"0"];

                return cellTwo;
            }
        }
            break;
        case 3:
        {
            MineCollectionViewCellFour *cellFour = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineCellFour" forIndexPath:indexPath];
            NSString *detailInfo = @"--";
            switch (indexPath.row) {
                case 0:
                    detailInfo = [self.myAgentDic objectForKey:@"a_commission"];
                    break;
                case 1:
                    detailInfo = [self.myAgentDic objectForKey:@"ordernum"];
                    break;
                case 2:
                    detailInfo = [self.myAgentDic objectForKey:@"peonum"];
                    break;
     
                default:
                    break;
            }
            
            [cellFour updateCellWithInfoStr1:[infoDic objectForKey:@"info"] withInfoStr2:detailInfo];
            return cellFour;
            
        }
            break;
            
        case 4:
        {
            MineCollectionViewCellTwo *cellTwo = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineCellTwo" forIndexPath:indexPath];
            [cellTwo updateCellWithHeaderImage:[infoDic objectForKey:@"icon1"] withInfoStr:[infoDic objectForKey:@"info"] withFontFloat:15 withLineViewHide:NO withCount:@"0"];
            return cellTwo;
            
        }
            break;

        default:
            return 0;
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld -- %ld",indexPath.section,indexPath.row);
    Manager *manager = [Manager shareInstance];
    //跳转id
    NSString *pushID = [[self.mineDataSource[indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"pushId"];
    //关于我们 意见反馈 设置，可以直接跳转
    if (indexPath.section == 4 && indexPath.row > 4) {
        if (pushID.length > 0) {
            [self performSegueWithIdentifier:pushID sender:indexPath];
        }
    }else {
        //其余的都要登陆了才可以进行跳转
        if ([manager isLoggedInStatus] == YES) {
            if (pushID.length > 0) {
                [self performSegueWithIdentifier:pushID sender:indexPath];
                
            }
            /*
            if (indexPath.section == 1 && indexPath.row < 3) {
                //直接跳转到订单
                
                [self switchToOrderTabbarWithOrderType:indexPath.row+2];
            }else {
                //跳转
                
            }
            */

        }else {
            AlertManager *alertM = [AlertManager shareIntance];
            [alertM showAlertViewWithTitle:nil withMessage:@"您还没有登录" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                //跳转到登录界面
                //未登录,跳转到登录界面
                UINavigationController *loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
                [self presentViewController:loginNav animated:YES completion:nil];
            }];
        }
        
        
      
        
        
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 切换到订单页面 -
- (void)switchToOrderTabbarWithOrderType:(NSInteger )orderType {
    /*
     orderType 订单的类型
     1-全部  2-待付款  3-待收货  4-已完成
     */
    //发送通知到订单界面，切换订单类型
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mineToOrderListVC" object:self userInfo:@{@"orderType":[NSString stringWithFormat:@"%ld",orderType]}];
    [self.tabBarController setSelectedIndex:3];
    
}

#pragma mark - Navigation



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"mineVCToTradeRecordVC"]) {
        //提现记录 或者 交易记录
        MyTradeRecordViewController *myRecordVC = [segue destinationViewController];
        
        NSIndexPath *tempIndex = (NSIndexPath *)sender;
        if (tempIndex.row == 3) {
            myRecordVC.isCash = YES;
        }
        if (tempIndex.row == 4) {
            myRecordVC.isCash = NO;
        }
    }
    
    
    //浏览记录和收藏是一个控制器，这里区别一下
    if ([segue.identifier isEqualToString:@"mineToMyFavoriteVC"]) {
        MyFavoriteListViewController *myFavoriteListVC = [segue destinationViewController];
        NSIndexPath *tempIndex = (NSIndexPath *)sender;

        if (tempIndex.row == 2 ) {
            //我的收藏
            myFavoriteListVC.isFavoriteOrBrowse = IsFavorite;
        }
        if (tempIndex.row == 3) {
            //浏览记录
            myFavoriteListVC.isFavoriteOrBrowse = IsBrowse;
        }
    }
    
    //订单
    if ([segue.identifier isEqualToString:@"mineToOrderListVC"]) {
        OrderListViewController *orderListVC = [segue destinationViewController];
        if (sender == nil) {
            //全部
            orderListVC.whichTableView = @"1";

        }else {
            NSIndexPath *tempIndex = (NSIndexPath *)sender;
            
            if (tempIndex.section == 1 && tempIndex.row == 0) {
                //待付款
                orderListVC.whichTableView = @"2";
            }
            if (tempIndex.section == 1 && tempIndex.row == 1) {
                //待收货
                orderListVC.whichTableView = @"3";
                
            }
            if (tempIndex.section == 1 && tempIndex.row == 2) {
                //已完成
                orderListVC.whichTableView = @"4";
                
            }
        }
        
        
        
        

        
        
    }
    
    
}


@end
