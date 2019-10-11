//
//  MyFavoriteListViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/5.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyFavoriteListViewController.h"
#import "Manager.h"
#import "MyFavoriteListTableViewCell.h"
#import "ProductDetailViewController.h"
#import "KongImageView.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
@interface MyFavoriteListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myfavoriteTableView;
@property (nonatomic,strong)KongImageView *kongImageView;
@end

@implementation MyFavoriteListViewController

//返回
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
    
    //加载空白页
    self.kongImageView = [[[NSBundle mainBundle] loadNibNamed:@"KongImageView" owner:self options:nil] firstObject];
    [self.kongImageView.reloadAgainButton addTarget:self action:@selector(reloadAgainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.kongImageView.frame = self.myfavoriteTableView.bounds;
    [self.myfavoriteTableView addSubview:self.kongImageView];

    
    //下拉刷新
    [self downPushRefresh];
    
    //加载数据
    [self.myfavoriteTableView headerBeginRefreshing];
    
    if (self.isFavoriteOrBrowse == IsFavorite) {
        self.title = @"我的收藏";
    }else {
        self.title = @"浏览记录";

    }

}

//重新加载
- (void)reloadAgainButtonAction:(IndexButton *)sender {
    [self.myfavoriteTableView headerBeginRefreshing];
}

//下拉刷新
- (void)downPushRefresh {
    [self.myfavoriteTableView addHeaderWithCallback:^{
        
        Manager *manager = [Manager shareInstance];
       
        //如果是收藏
        if (self.isFavoriteOrBrowse == IsFavorite) {
            if ([SVProgressHUD isVisible] == NO) {
                [SVProgressHUD show];
            }
            [manager httpMyFavoriteListWithUserId:manager.memberInfoModel.u_id withMyFavoriteSuccess:^(id successResult) {
                [SVProgressHUD dismiss];
                
                [self.myfavoriteTableView reloadData];
                [self.myfavoriteTableView headerEndRefreshing];
                [self isShowKongImageViewWithType:KongTypeWithKongData withKongMsg:@"暂无收藏"];
                
                
            } withMyFavoriteFail:^(NSString *failResultStr) {
                [SVProgressHUD dismiss];

                [self.myfavoriteTableView headerEndRefreshing];
                
                [self isShowKongImageViewWithType:KongTypeWithNetError withKongMsg:@"网络错误"];
            }];

        }else {
            //浏览记录
            if (manager.mybrowseListArr == nil || manager.mybrowseListArr.count == 0) {
                //第一次进入，从本地获取浏览记录
                [manager getLocationBrowseList];
                
            }
            //刷新
            [self.myfavoriteTableView reloadData];
            [self.myfavoriteTableView headerEndRefreshing];

            [self isShowKongImageViewWithType:KongTypeWithKongData withKongMsg:@"暂无浏览记录"];
            
        }
        
        
    }];
}


#pragma mark - TableView delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Manager *manager = [Manager shareInstance];
    if (self.isFavoriteOrBrowse == IsFavorite) {
        return manager.myFavoriteArr.count;

    }else{
        return manager.mybrowseListArr.count;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Manager *manager = [Manager shareInstance];
    MyFavoriteListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myFavotiteCell" forIndexPath:indexPath];
    cell.deleteButton.indexForButton = indexPath;
    cell.joinShoppingCarButton.indexForButton = indexPath;

    if (self.isFavoriteOrBrowse == IsFavorite){
        
        MyFavoriteListModel *tempFavoriteModel = manager.myFavoriteArr[indexPath.row];
        [cell updateMyFavoriteListCell:tempFavoriteModel];
        
    }else {
        ProductDetailModel *tempBrowerModel = manager.mybrowseListArr[indexPath.row];
        [cell updateMyBrowerListCell:tempBrowerModel.productModel];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];

    if (self.isFavoriteOrBrowse == IsFavorite) {
        MyFavoriteListModel *tempFavoriteModel = manager.myFavoriteArr[indexPath.row];
        [self performSegueWithIdentifier:@"myFavoriteToDetailVC" sender:tempFavoriteModel.favoriteProductFormatID];
    }else {
        ProductDetailModel *tempBrowerModel = manager.mybrowseListArr[indexPath.row];
        [self performSegueWithIdentifier:@"myFavoriteToDetailVC" sender:tempBrowerModel.productModel.productFormatID];
    }
    
   
}


#pragma mark - 删除收藏产品 -
- (IBAction)deleteFavoriteProductAction:(IndexButton *)sender {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    [alertM showAlertViewWithTitle:nil withMessage:@"是否要删除这个产品" actionTitleArr:@[@"取消",@"确认"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
        if (actionBlockNumber == 1) {
            if (self.isFavoriteOrBrowse == IsFavorite) {
                MyFavoriteListModel *tempFavoriteModel = manager.myFavoriteArr[sender.indexForButton.row];
                [manager httpDeleteFavoriteProductWithFavoriteArr:[NSMutableArray arrayWithObjects:tempFavoriteModel, nil] withDeleteFavoriteSuccess:^(id successResult) {
                    
                    [self.myfavoriteTableView reloadData];
                    //看看是否为空白页
                    [self isShowKongImageViewWithType:KongTypeWithKongData withKongMsg:@"暂无收藏产品"];
                    //发送通知到购物车界面，刷新那里的收藏
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyFavorite" object:self userInfo:nil];
                } withDeleteFavoriteFail:^(NSString *failResultStr) {
                    [alertM showAlertViewWithTitle:nil withMessage:@"删除失败，请稍后再试" actionTitleArr:@[@"确认"] withViewController:self withReturnCodeBlock:nil];
                }];
                
            }else {
                //删除浏览记录
                [manager deleteBrowseListActionWithBrowseWithIndex:sender.indexForButton.row];
                //刷新
                [self.myfavoriteTableView reloadData];
                //看看是否为空白页
                [self isShowKongImageViewWithType:KongTypeWithKongData withKongMsg:@"暂无浏览记录"];
            }

        }
    }];

    
}

#pragma mark - 加入购物车 -
- (IBAction)joinShoppingCarButtonAction:(IndexButton *)sender {
    
    Manager *manager = [Manager shareInstance];
    NSString *addProductFormatIdStr ;
    NSString *min_quantityStr;
    if (self.isFavoriteOrBrowse == IsFavorite) {
        MyFavoriteListModel *tempFavoriteModel = manager.myFavoriteArr[sender.indexForButton.row];

        addProductFormatIdStr = tempFavoriteModel.favoriteProductFormatID;
        min_quantityStr = tempFavoriteModel.s_min_quantity;

    }else {
        //浏览记录
        ProductDetailModel *tempBrowerModel = manager.mybrowseListArr[sender.indexForButton.row];
        addProductFormatIdStr = tempBrowerModel.productModel.productFormatID;
        min_quantityStr = tempBrowerModel.p_standard_qty;
    }
    
    AlertManager *alertM = [AlertManager shareIntance];

    //加入购物车
    if (addProductFormatIdStr != nil && addProductFormatIdStr.length > 0 ) {
        if ([SVProgressHUD isVisible] == NO) {
            [SVProgressHUD show];
        }
        
        [manager httpProductToShoppingCarWithFormatIdAndCountDic:@[@{@"sid":addProductFormatIdStr,@"number":min_quantityStr}] withSuccessToShoppingCarResult:^(id successResult) {
            [SVProgressHUD dismiss];
            [alertM showAlertViewWithTitle:nil withMessage:@"加入购物车成功" actionTitleArr:nil withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                //发送通知，让购物车界面刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshShoppingCarVC" object:self userInfo:nil];
            }];
            
        } withFailToShoppingCarResult:^(NSString *failResultStr) {
            NSLog(@"加入失败");
             [SVProgressHUD dismiss];
            [alertM showAlertViewWithTitle:nil withMessage:@"加入购物车失败" actionTitleArr:@[@"确认"] withViewController:self withReturnCodeBlock:nil];
        }];

    }
    
}

//空白页
- (void)isShowKongImageViewWithType:(KongType )kongType withKongMsg:(NSString *)msg {
    Manager *manager = [Manager shareInstance];

    if (self.isFavoriteOrBrowse == IsFavorite) {
        if (manager.myFavoriteArr.count == 0) {
            [self.kongImageView showKongViewWithKongMsg:msg withKongType:kongType];
        }else {
            [self.kongImageView hiddenKongView];
            
        }

    }else {
        //浏览记录
        if (manager.mybrowseListArr.count > 0) {
            [self.kongImageView hiddenKongView];
        }else {
            [self.kongImageView showKongViewWithKongMsg:msg withKongType:kongType];

        }
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
    //点击cell跳转到详情
    if ([segue.identifier isEqualToString:@"myFavoriteToDetailVC"]) {
        ProductDetailViewController *productDetailVC = [segue destinationViewController];
        productDetailVC.productID = sender;
        productDetailVC.type = @"sid";
    }

}


@end
