//
//  AfterMarketViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/11.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "AfterMarketViewController.h"
#import "AfterMarketTableViewCell.h"
#import "AfterMarketTwoTableViewCell.h"
#import "AfterMarketFootTableViewCell.h"
#import "KongImageView.h"
#import "Manager.h"
#import "MJRefresh.h"
#import "ProductDetailViewController.h"
#import "SVProgressHUD.h"
@interface AfterMarketViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *afterMarketTableView;

@property (nonatomic,strong)NSMutableArray *orderListArr;
//当前有页数
@property (nonatomic,assign)NSInteger currentPage;
//总共的页数
@property (nonatomic,assign)NSInteger totalPage;

@property (nonatomic,strong)KongImageView *kongImageView;

@end

@implementation AfterMarketViewController
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

    // 让cell自适应高度
    self.afterMarketTableView.rowHeight = UITableViewAutomaticDimension;
    //设置估算高度
    self.afterMarketTableView.estimatedRowHeight = 44;
    
    //刚进来设置页数为1
    self.currentPage = 1;
    
    //加载下拉刷新
    [self downPushRefresh];
    //上拉加载
    [self upPushLoad];
    
    
    //首次进入执行一次下拉刷新
    [self.afterMarketTableView headerBeginRefreshing];
    
    //加载空白页
    self.kongImageView = [[[NSBundle mainBundle] loadNibNamed:@"KongImageView" owner:self options:nil] firstObject];
    [self.kongImageView.reloadAgainButton addTarget:self action:@selector(reloadAgainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.kongImageView.frame = self.afterMarketTableView.bounds;
    [self.afterMarketTableView addSubview:self.kongImageView];
    
}
//下拉刷新
- (void)downPushRefresh {
    [self.afterMarketTableView addHeaderWithCallback:^{
        NSLog(@"下拉");
        [self httpOrderListWithPageIndex:1];
        
    }];
}

//上拉加载
- (void)upPushLoad {
    [self.afterMarketTableView addFooterWithCallback:^{
        NSLog(@"上拉");
        //当前页小于总页数，可以进行加载
        if (self.currentPage < self.totalPage) {
            [self httpOrderListWithPageIndex:self.currentPage+1];
        }else {
            [self.afterMarketTableView footerEndRefreshing];
        }
        
        
    }];
    
}

//重新加载
- (void)reloadAgainButtonAction:(IndexButton *)sender {
    
    [self.afterMarketTableView headerBeginRefreshing];
    
}

//网络请求售后
- (void)httpOrderListWithPageIndex:(NSInteger)pageIndex {
    Manager *manager = [Manager shareInstance];
    
    if (pageIndex == 1 && [SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];

    }
   
    [manager httpOrderReturnListWithUserId:manager.memberInfoModel.u_id withCode:@"" withPageIndex:pageIndex withPageSize:10 withOrderReturnSuccess:^(id successResult) {
        
        //得到总页数
        self.totalPage = [successResult integerValue];
        //如果是下拉刷新，将currentpage重置为1
        if (pageIndex == 1) {
            [SVProgressHUD dismiss];//风火轮消失
            
            self.currentPage = 1;
            //取消效果
            [self.afterMarketTableView headerEndRefreshing];
            
            //查看是否空白页
            [self isShowKongImageViewWithType:KongTypeWithKongData withKongMsg:@"暂无我的评价"];
            
        }else {
            //如果是加载，那么更新currentpage
            self.currentPage = pageIndex;
            //取消效果
            [self.afterMarketTableView footerEndRefreshing];
            
        }
        [self.afterMarketTableView reloadData];
        
    } withOrderReturnFail:^(NSString *failResultStr) {
        
        [SVProgressHUD dismiss];
        
        [self.afterMarketTableView headerEndRefreshing];
        [self.afterMarketTableView footerEndRefreshing];
        
        [self isShowKongImageViewWithType:KongTypeWithNetError withKongMsg:@"网络错误"];

    }];
}


#pragma mark - TableView Delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    Manager *manager = [Manager shareInstance];
    NSLog(@"%ld",manager.afterMarketArr.count);
    return manager.afterMarketArr.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 43;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //返回值就是区页眉。那么我们就让他返回headViewCell
    AfterMarketFootTableViewCell *footViewCell = [tableView dequeueReusableCellWithIdentifier:@"afterFootCell"];
    Manager *manager = [Manager shareInstance];
    
    AfterOrderModel *tempModel = manager.afterMarketArr[section];
    footViewCell.totalPriceLabel.text = [NSString stringWithFormat:@"￥%@",tempModel.o_price_total];
    footViewCell.buttonOne.indexForButton = [NSIndexPath indexPathForRow:0 inSection:section];
    
    return footViewCell;
    
}
- (IBAction)footButtonAction:(IndexButton *)sender {
    Manager *manager = [Manager shareInstance];

    AfterOrderModel *tempModel = manager.afterMarketArr[sender.indexForButton.section];
    [self performSegueWithIdentifier:@"afterToProductDetailVC" sender:tempModel];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];
    
    AfterOrderModel *tempModel = manager.afterMarketArr[indexPath.section];
//    if (tempModel.subOrderArr.count == 1) {
        AfterMarketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"afterMarketCell" forIndexPath:indexPath];
        
        [cell updateAfterMarketCellWithOrderModel:tempModel];
        return cell;

//    }else {
//        AfterMarketTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"afterTwoCell" forIndexPath:indexPath];
//        [cell updateAfterMarketTwoCellWithModel:tempModel];
//        return cell;
//
//    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];
    
    AfterOrderModel *tempModel = manager.afterMarketArr[indexPath.section];
    
    [self performSegueWithIdentifier:@"afterToProductDetailVC" sender:tempModel];
    
}

//空白页
- (void)isShowKongImageViewWithType:(KongType )kongType withKongMsg:(NSString *)msg {
    Manager *manager = [Manager shareInstance];
    if (manager.afterMarketArr.count == 0) {
        [self.kongImageView showKongViewWithKongMsg:msg withKongType:kongType];
        
    }else {
        [self.kongImageView hiddenKongView];
        
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
    if ([segue.identifier isEqualToString:@"afterToProductDetailVC"]) {
        AfterOrderModel *tempModel = sender;
        ProductDetailViewController *productDetailVC = [segue destinationViewController];
        
        productDetailVC.productID = tempModel.o_product_id;
        productDetailVC.type = @"pid";
        
       
        
    }
}


@end
