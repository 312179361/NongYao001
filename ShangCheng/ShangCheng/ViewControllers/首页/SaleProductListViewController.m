//
//  SaleProductListViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/11/19.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "SaleProductListViewController.h"
#import "Manager.h"
#import "KongImageView.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "BannerCellTwoCollectionViewCell.h"
#import "ProductDetailViewController.h"

@interface SaleProductListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)KongImageView *kongImageView;

@property (weak, nonatomic) IBOutlet UICollectionView *saleCollectionView;
@property (nonatomic,strong)NSMutableArray *saleDataSourceArr;

@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,assign)NSInteger totalPage;


@end

@implementation SaleProductListViewController
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
    
    
    //注册cell
    [self.saleCollectionView registerNib:[UINib nibWithNibName:@"BannerCellTwoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"bannerShopCellTwo"];
    
    //加载空白页
    self.kongImageView = [[[NSBundle mainBundle] loadNibNamed:@"KongImageView" owner:self options:nil] firstObject];
    [self.kongImageView.reloadAgainButton addTarget:self action:@selector(reloadAgainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.kongImageView.frame = self.view.bounds;
    [self.view addSubview:self.kongImageView];
    
    //加载下拉和上啦
    [self downRefreshAction];
    [self upLoadDataAction];
    //首次进入刷新数据
    [self.saleCollectionView headerBeginRefreshing];
}

//重新加载按钮
- (void)reloadAgainButtonAction:(IndexButton *)sender {
    [self.saleCollectionView headerBeginRefreshing];
    
}

//下拉刷新
- (void)downRefreshAction {
    [self.saleCollectionView addHeaderWithCallback:^{
        //搜索
        if ([self.showType isEqualToString:@"search"]) {
            [self httpSearchSaleProductWithType:@"" withKeyword:self.tempKeyword pageIndex:1];
        }
        
        //更多
        if ([self.showType isEqualToString:@"more"]) {
            [self httpSearchSaleProductWithType:self.tempKeyword withKeyword:@"" pageIndex:1];

        }
        
        
    }];
}

//上拉加载
- (void)upLoadDataAction {
    [self.saleCollectionView addFooterWithCallback:^{

        //当前页小于总页数，可以进行加载
        if (self.currentPage < self.totalPage) {
            if ([self.showType isEqualToString:@"search"]) {
                [self httpSearchSaleProductWithType:@"" withKeyword:self.tempKeyword pageIndex:self.currentPage+1];

            }
            //更多
            if ([self.showType isEqualToString:@"more"]) {
                [self httpSearchSaleProductWithType:self.tempKeyword withKeyword:@"" pageIndex:self.currentPage+1];

            }

        }else {
            [self.saleCollectionView footerEndRefreshing];
        }

    }];
}


- (void)httpSearchSaleProductWithType:(NSString *)tempType withKeyword:(NSString *)keyword pageIndex:(NSInteger)tempPageIndex {
    
    if (tempPageIndex == 1 && [SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];
    }
    Manager *manager = [Manager shareInstance];
    [manager httpActivityProductListWithType:tempType withKeyword:keyword withPageIndex:tempPageIndex withPageSize:@"10" withActivityListSuccess:^(id successResult) {
        //请求成功，得到总页数
        self.totalPage = [[successResult objectForKey:@"totalpages"] integerValue];
        //如果是下拉刷新，将currentpage重置为1
        if (tempPageIndex == 1) {
            self.saleDataSourceArr = nil;
            self.saleDataSourceArr = [successResult objectForKey:@"content"];
            
            [SVProgressHUD dismiss];//风火轮消失
            self.currentPage = 1;
            //取消效果
            [self.saleCollectionView headerEndRefreshing];
            
            [self isShowKongImageViewWithType:KongTypeWithSearchKong withKongMsg:@"暂无搜索内容"];
            
        }else {
            [self.saleDataSourceArr addObjectsFromArray:[successResult objectForKey:@"content"]];

            
            //如果是加载，那么更新currentpage
            self.currentPage = tempPageIndex;
            //取消效果
            
            [self.saleCollectionView footerEndRefreshing];
            
        }
        [self.saleCollectionView reloadData];
        
    } withActivityFail:^(NSString *failResultStr) {
        [SVProgressHUD dismiss];//风火轮消失
        [self.saleCollectionView headerEndRefreshing];
        [self.saleCollectionView footerEndRefreshing];
        [self isShowKongImageViewWithType:KongTypeWithNetError withKongMsg:@"网络错误"];

    }];
}


#pragma mark - collectionView Delegate -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%ld",self.saleDataSourceArr.count);
    return self.saleDataSourceArr.count;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenW-1)/2, (kScreenW-1)/2+105);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BannerCellTwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bannerShopCellTwo" forIndexPath:indexPath];

    ActivityProductModel *tempModel = self.saleDataSourceArr[indexPath.row];

    [cell updateBannerShopTwoCellWithActivityModel:tempModel];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ActivityProductModel *tempModel = self.saleDataSourceArr[indexPath.row];
    [self performSegueWithIdentifier:@"saleProductToDetailVC" sender:tempModel];
    
}

#pragma mark - 空白页 -
- (void)isShowKongImageViewWithType:(KongType )kongType withKongMsg:(NSString *)msg {

    if (self.saleDataSourceArr.count > 0) {
        [self.kongImageView hiddenKongView];
    }else {
        [self.kongImageView showKongViewWithKongMsg:msg withKongType:kongType];
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
    // Pass the selected object to the new view controller
    if ([segue.identifier isEqualToString:@"saleProductToDetailVC"]) {
        ActivityProductModel *saleListModel = (ActivityProductModel *)sender;
        ProductDetailViewController *productDetailVC = [segue destinationViewController];
        productDetailVC.productID = saleListModel.d_p_id;
        productDetailVC.type = @"pid";
    }
}


@end
