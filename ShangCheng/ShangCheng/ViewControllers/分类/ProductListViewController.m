//
//  ProductListViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/3.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "ProductListViewController.h"
//#import "SearchBarButton.h"
#import "Manager.h"
#import "MJRefresh.h"
#import "ProductListCollectionViewCell.h"
#import "ProductListCollectionReusableView.h"
#import "KongImageView.h"
#import "ProductDetailViewController.h"
#import "SVProgressHUD.h"
@interface ProductListViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic,strong)KongImageView *kongImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *productListCollectionView;

@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,assign)NSInteger totalPage;
@property (nonatomic,assign)SortType sortType;
@end

@implementation ProductListViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)rightBarButtonAction:(UIBarButtonItem *)sender {

}
- (IBAction)tapSearchButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];

}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%ld",self.productSearchOrType);
    NSLog(@"%@",self.tempCode);
    NSLog(@"%@",self.tempKeyword);
    
    //注册cell
    [self.productListCollectionView registerNib:[UINib nibWithNibName:@"ProductListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"productListCell"];
    
    //加载空白页
    self.kongImageView = [[[NSBundle mainBundle] loadNibNamed:@"KongImageView" owner:self options:nil] firstObject];
    [self.kongImageView.reloadAgainButton addTarget:self action:@selector(reloadAgainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.kongImageView.frame = self.view.bounds;
    [self.view addSubview:self.kongImageView];

    //清空原有数据
    Manager *manager = [Manager shareInstance];
    manager.searchProductListDataSourceArr = nil;
    
//    SearchBarButton *searchBarButton = [[[NSBundle mainBundle] loadNibNamed:@"SearchBarButton" owner:self options:nil] firstObject];
//    [searchBarButton.tapSearchBarButton addTarget:self action:@selector(tapSearchAction:)];
//    self.navigationItem.titleView = searchBarButton;
    
    //排序为默认排序
    self.sortType = DefaultType;
    
    //加载下拉和上啦
    [self downRefreshAction];
    [self upLoadDataAction];
    //首次进入刷新数据
    [self.productListCollectionView headerBeginRefreshing];

}

//重新加载按钮
- (void)reloadAgainButtonAction:(IndexButton *)sender {
    [self.productListCollectionView headerBeginRefreshing];

}

//下拉刷新
- (void)downRefreshAction {
    [self.productListCollectionView addHeaderWithCallback:^{
       //如果是搜索
        if (self.productSearchOrType == SearchProduct) {
            [self httpSearchDataWithPageIndex:1];
        }
        
        //如果是分类
        if (self.productSearchOrType == TypeProduct) {
            [self httpTypeDataWithPageIndex:1];
        }

    }];
}

//上拉加载
- (void)upLoadDataAction {
    [self.productListCollectionView addFooterWithCallback:^{
        //如果是搜索
        if (self.productSearchOrType == SearchProduct) {
            //当前页小于总页数，可以进行加载
            if (self.currentPage < self.totalPage) {
                [self httpSearchDataWithPageIndex:self.currentPage+1];
            }else {
                [self.productListCollectionView footerEndRefreshing];
            }

        }
        //如果是分类
        if (self.productSearchOrType == TypeProduct) {
            
            //当前页小于总页数，可以进行加载
            if (self.currentPage < self.totalPage) {
                [self httpTypeDataWithPageIndex:self.currentPage+1];
            }else {
                [self.productListCollectionView footerEndRefreshing];
            }

        }
       
    
    
    }];
}

//搜索的 网络请求数据
- (void)httpSearchDataWithPageIndex:(NSInteger )pageIndex {
    Manager *manager = [Manager shareInstance];
    if (pageIndex == 1 && [SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];
    }
    NSString *sortStr ;
    NSString *descStr ;
    switch (self.sortType) {
        case HitsDown:
            sortStr = @"hits";
            descStr = @"1";
            break;
        case HitsUp:
            sortStr = @"hits";
            descStr = @"0";
            break;
        case SalesDown:
            sortStr = @"sales";
            descStr = @"1";
            break;
        case SalesUp:
            sortStr = @"sales";
            descStr = @"0";
            break;
        case PriceUp:
            sortStr = @"price";
            descStr = @"0";
            break;
        case PriceDown:
            sortStr = @"price";
            descStr = @"1";
            break;
        case DateDown:
            sortStr = @"date";
            descStr = @"1";
            break;
        case DateUp:
            sortStr = @"date";
            descStr = @"0";
            break;
        case DefaultType:
            sortStr = @"";
            descStr = @"1";
            break;
        default:
            break;
    }
    
    [manager searchActionWithKeyword:self.tempKeyword withType:@"产品库" withSort:sortStr withDesc:descStr withPageindex:pageIndex withSearchSuccess:^(id successResult) {
        
        //请求成功，得到总页数
        self.totalPage = [successResult integerValue];
        //如果是下拉刷新，将currentpage重置为1
        if (pageIndex == 1) {
            [SVProgressHUD dismiss];//风火轮消失
            self.currentPage = 1;
            //取消效果
            [self.productListCollectionView headerEndRefreshing];

            [self isShowKongImageViewWithType:KongTypeWithSearchKong withKongMsg:@"暂无搜索内容"];

        }else {
            //如果是加载，那么更新currentpage
            self.currentPage = pageIndex;
            //取消效果

            [self.productListCollectionView footerEndRefreshing];

        }
        [self.productListCollectionView reloadData];

        
    } withSearchFail:^(NSString *failResultStr) {
        [SVProgressHUD dismiss];//风火轮消失
        [self.productListCollectionView headerEndRefreshing];
        [self.productListCollectionView footerEndRefreshing];
        [self isShowKongImageViewWithType:KongTypeWithNetError withKongMsg:@"网络错误"];

    }];
    
}


//分类的 网络请求数据
- (void)httpTypeDataWithPageIndex:(NSInteger )pageIndex {
    Manager *manager = [Manager shareInstance];
    //只要刷新才有风火轮
    if (pageIndex == 1 && [SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];
    }
    
    NSString *sortStr ;
    NSString *descStr ;
    switch (self.sortType) {
        case HitsDown:
            sortStr = @"hits";
            descStr = @"1";
            break;
        case HitsUp:
            sortStr = @"hits";
            descStr = @"0";
            break;
        case SalesDown:
            sortStr = @"sales";
            descStr = @"1";
            break;
        case SalesUp:
            sortStr = @"sales";
            descStr = @"0";
            break;
        case PriceUp:
            sortStr = @"price";
            descStr = @"0";
            break;
        case PriceDown:
            sortStr = @"price";
            descStr = @"1";
            break;
        case DateDown:
            sortStr = @"date";
            descStr = @"1";
            break;
        case DateUp:
            sortStr = @"date";
            descStr = @"0";
            break;
        case DefaultType:
            sortStr = @"";
            descStr = @"1";
            break;
        default:
            break;
    }
    
    [manager httpProductTypeWithCode:self.tempCode withSort:sortStr withDesc:descStr withPageIndex:pageIndex withTypeSuccess:^(id successResult) {
        //请求成功，得到总页数
        self.totalPage = [successResult integerValue];
        //如果是下拉刷新，将currentpage重置为1
        if (pageIndex == 1) {
            [SVProgressHUD dismiss];
            self.currentPage = 1;
            //取消效果
            [self.productListCollectionView headerEndRefreshing];
            [self isShowKongImageViewWithType:KongTypeWithKongData withKongMsg:@"暂无对应的产品"];
            
        }else {
            //如果是加载，那么更新currentpage
            self.currentPage = pageIndex;
            //取消效果
            
            [self.productListCollectionView footerEndRefreshing];
            
        }
        [self.productListCollectionView reloadData];
    } withTypeFail:^(NSString *failResultStr) {
        [SVProgressHUD dismiss];

        [self.productListCollectionView headerEndRefreshing];
        [self.productListCollectionView footerEndRefreshing];
        [self isShowKongImageViewWithType:KongTypeWithNetError withKongMsg:@"网络错误"];


    }];
    
}




#pragma mark - 头部四个button -
- (IBAction)buttonOneAction:(UIButton *)sender {
    //如果关注度是降序，那么点击后为升序。其余情况点击后都是降序
    if (self.sortType == HitsDown) {
        self.sortType = HitsUp;
    }else {
        self.sortType = HitsDown;
    }
    
    //如果是搜索
    if (self.productSearchOrType == SearchProduct) {
        //请求数据
        [self httpSearchDataWithPageIndex:1];
        
    }
    //如果是分类
    if (self.productSearchOrType == TypeProduct) {
        //请求数据
        [self httpTypeDataWithPageIndex:1];
    }

}
- (IBAction)buttonTwoAction:(UIButton *)sender {
    //如果销量是降序，那么点击后为升序。其余情况点击后都是降序
    if (self.sortType == SalesDown) {
        self.sortType = SalesUp;
    }else {
        self.sortType = SalesDown;
    }
    
    //如果是搜索
    if (self.productSearchOrType == SearchProduct) {
        //请求数据
        [self httpSearchDataWithPageIndex:1];
        
    }
    //如果是分类
    if (self.productSearchOrType == TypeProduct) {
        //请求数据
        [self httpTypeDataWithPageIndex:1];
    }

    
}
- (IBAction)buttonThreeAction:(UIButton *)sender {
    //如果价格是升序，那么点击后为降序。其余情况点击后都是升序
    if (self.sortType == PriceUp) {
        self.sortType = PriceDown;
    }else {
        self.sortType = PriceUp;
    }
    
    //如果是搜索
    if (self.productSearchOrType == SearchProduct) {
        //请求数据
        [self httpSearchDataWithPageIndex:1];
        
    }
    //如果是分类
    if (self.productSearchOrType == TypeProduct) {
        //请求数据
        [self httpTypeDataWithPageIndex:1];
    }

}
- (IBAction)buttonFourAction:(UIButton *)sender {
    //如果时间是降序，那么点击后为升序。其余情况点击后都是降序
    if (self.sortType == DateDown) {
        self.sortType = DateUp;
    }else {
        self.sortType = DateDown;
    }
    
    //如果是搜索
    if (self.productSearchOrType == SearchProduct) {
        //请求数据
        [self httpSearchDataWithPageIndex:1];
        
    }
    //如果是分类
    if (self.productSearchOrType == TypeProduct) {
        //请求数据
        [self httpTypeDataWithPageIndex:1];
    }

}


#pragma mark - collectionView delegate -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    Manager *manager = [Manager shareInstance];
    
    return manager.searchProductListDataSourceArr.count;
    
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenW-1)/2, (kScreenW-1)/2+105);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ProductListCollectionReusableView *headerCell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"productListHeaderCell" forIndexPath:indexPath];
        [headerCell updateProductListCollectionHeaderViewWithSortType:self.sortType];
        return headerCell;
    }
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"productListCell" forIndexPath:indexPath];
    Manager *manager = [Manager shareInstance];
    SearchListModel *searchListModel = manager.searchProductListDataSourceArr[indexPath.row];
    [cell updateProductListCellWithProductModel:searchListModel];
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];
    SearchListModel *searchListModel = manager.searchProductListDataSourceArr[indexPath.row];

    [self performSegueWithIdentifier:@"searchToDetailVC" sender:searchListModel];
    
    
    NSLog(@"aaa");
}


#pragma mark - 空白页 -
- (void)isShowKongImageViewWithType:(KongType )kongType withKongMsg:(NSString *)msg {
    Manager *manager = [Manager shareInstance];
    if (manager.searchProductListDataSourceArr.count > 0) {
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
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"searchToDetailVC"]) {
        SearchListModel *searchListModel = (SearchListModel *)sender;
        ProductDetailViewController *productDetailVC = [segue destinationViewController];
        productDetailVC.productID = searchListModel.p_id;
        productDetailVC.type = @"pid";
    }
    
}


@end
