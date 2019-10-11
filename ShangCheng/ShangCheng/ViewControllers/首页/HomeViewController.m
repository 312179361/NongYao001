//
//  HomeViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/10/25.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "HomeViewController.h"
#import "Manager.h"
#import "ImageCollectionReusableView.h"
#import "MaxSaleHotCollectionReusableView.h"
#import "HotCollectionReusableView.h"
#import "MainCollectionReusableView.h"
#import "CategoryCollectionViewCell.h"
#import "TodaySaleImageCollectionViewCell.h"
#import "DetailHorizontalCollectionViewCell.h"
#import "DetailVerticalCollectionViewCell.h"
#import "WebPageViewController.h"
#import "ProductDetailViewController.h"
#import "SVProgressHUD.h"
#import "SearchViewController.h"
#import "ClassViewController.h"
#import "ShoppingCarViewController.h"
#import "MJRefresh.h"
#import "WebPageTwoViewController.h"
#import "OrderListViewController.h"
@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//头部的轮播图数据源
@property (nonatomic,strong)NSMutableArray *bannerDataSource;
//八大分类数据源
@property (nonatomic,strong)NSArray *categoryDataSource;
//最惠热点数据源（广告条）
@property (nonatomic,strong)NSMutableArray *adScrollViewDataSourceArr;
//今日特价banner图
@property (nonatomic,strong)NSString *todayBannerImgStr;


@end

@implementation HomeViewController
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //通知，登陆成功
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(toOrderListNotiAction:) name:@"toOrderListNoti" object:nil];
    }
    return self;
}

- (void)toOrderListNotiAction:(NSNotification *) sender {
    [self performSegueWithIdentifier:@"homeToOrderListVC" sender:nil];

}

- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {

    [self performSegueWithIdentifier:@"homeToClassVC" sender:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [SVProgressHUD dismiss];
}

- (IBAction)searchButtonAction:(UIButton *)sender {
    UINavigationController *searchNav = [self.storyboard instantiateViewControllerWithIdentifier:@"searchNavigationController"];
    SearchViewController *searchVC = [searchNav.viewControllers objectAtIndex:0];
    searchVC.productOrPests = Product;
    [self presentViewController:searchNav animated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.

    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"imageHeader"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MaxSaleHotCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"maxSaleHotFooter"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HotCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hotHeader"];

    [self.collectionView registerNib:[UINib nibWithNibName:@"MainCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mainHeader"];
    
    //加载八大分类数据源
    [self upDateHomeEightCategory];
    //请求热销产品
    [self httpHomeHotProduct];
    
    //请求首页数据
    [self httpHomeData];
    
    //网络请求广告条数据
    [self httpAdScrollView];
    //网络请求banner图
    [self httpBanner];
    //网络请求今日特价banner图
    [self httpTodaySale];
    
    //下拉刷新
    [self downRefreshAction];
    
}

//下拉刷新
- (void)downRefreshAction {
    [self.collectionView addHeaderWithCallback:^{
        //请求热销产品
        [self httpHomeHotProduct];
        
        //请求首页数据
        [self httpHomeData];
        
        //网络请求广告条数据
        [self httpAdScrollView];
        //网络请求banner图
        [self httpBanner];
        //网络请求今日特价图
        [self httpTodaySale];
    }];
}

- (void)httpBanner {
    Manager *manager = [Manager shareInstance];
    //头部banner图数据源
    [manager httpBannerScrollViewDataSourceWithBannerType:@"3" withBannerSuccess:^(id successResult) {
        self.bannerDataSource = [NSMutableArray array];

        self.bannerDataSource = successResult;
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        
    } withBannerFail:^(NSString *failResultStr) {
        NSLog(@"%@",failResultStr);
        
    }];

}

- (void)httpTodaySale {
    Manager *manager = [Manager shareInstance];
    //头部banner图数据源
    [manager httpBannerScrollViewDataSourceWithBannerType:@"5" withBannerSuccess:^(id successResult) {
        if ([successResult count] > 0) {
            BannerModel *tempTodayModel = successResult[0];
            self.todayBannerImgStr = tempTodayModel.l_image_path;
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];

        }
        
        
    } withBannerFail:^(NSString *failResultStr) {
        NSLog(@"%@",failResultStr);
        
    }];
}

- (void)httpAdScrollView {
    Manager *manager = [Manager shareInstance];
    //网络请求广告条数据
    [manager httpAdScrollViewDataSourceWithAdSuccess:^(id successResult) {
        self.adScrollViewDataSourceArr = [NSMutableArray array];//初始化数组

        self.adScrollViewDataSourceArr = successResult;
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } withAdFail:^(NSString *failResultStr) {
        NSLog(@"%@",failResultStr);
    }];

}

- (void)httpHomeHotProduct {
    Manager *manager = [Manager shareInstance];
    //网络请求热销产品
    [manager httpHomeHotProductWithCnum:@"4" withHotSuccess:^(id successResult) {
        [self.collectionView reloadData];
    } withHotFail:^(NSString *failResultStr) {
        NSLog(@"%@",failResultStr);
        
    }];

}

- (void)httpHomeData {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];

    //显示风火轮（请求首页数据）
    //增加风火轮
    if ([SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];
    }
    //网络请求首页数据
    [manager httpHomeProductWithRnum:@"8" withSuccessHomeResult:^(id successResult) {
        [self.collectionView headerEndRefreshing];

        if (successResult != nil) {
            //风火轮
            [SVProgressHUD dismiss];
            
            [self.collectionView reloadData];
        }
    } withFailHomeResult:^(NSString *failResultStr) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",failResultStr);
        [alertM showAlertViewWithTitle:nil withMessage:@"网络错误，请检查网络后再试" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }];

}


- (void)upDateHomeEightCategory {
    
    NSString *jsonPath = [[NSBundle mainBundle]pathForResource:@"HomeCategory" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    //解析得到返回结果
    self.categoryDataSource = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    

}

#pragma mark - collectionView Delegate -
//多少个分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //八大分类，今日特价，人气热卖，详情
    NSLog(@"%ld", [[[Manager shareInstance].homeDataSourceDic objectForKey:@"推荐"] count]);
    return 3 + [[[Manager shareInstance].homeDataSourceDic objectForKey:@"推荐"] count];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 8;
            break;
        case 1:
            return 1;
            break;
        case 2:
        {
            return [[[Manager shareInstance].homeDataSourceDic objectForKey:@"热销"] count];
        }
            break;
        default:
        {
            ProductClassModel *tempClassModel = [[[Manager shareInstance].homeDataSourceDic objectForKey:@"推荐"] objectAtIndex:section-3];
            return tempClassModel.productArr.count;

        }
            break;
    }
}


//分区头部大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return CGSizeMake(kScreenW, kScreenW/2);
            break;
        case 1:
            return CGSizeMake(kScreenW, 11);
            break;
        case 2:
            return CGSizeMake(kScreenW, 40+17);
            break;

        default:
        {
            /*
            //如果这个分区有数据才显示分区头
            ProductClassModel *tempClassModel = [[[Manager shareInstance].homeDataSourceDic objectForKey:@"推荐"] objectAtIndex:section-3];
            if (tempClassModel.productArr.count > 0) {
                return CGSizeMake(kScreenW, 70+15);

            }else{
                return CGSizeMake(kScreenW, 0);
            }
            */
            return CGSizeMake(kScreenW, 53+11);
        }
            break;
    }
}

//尾部大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(kScreenW, 44);
    }else{
        return CGSizeMake(0, 0);
    }
}


//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    switch (indexPath.section) {
        case 0:
            //分类
            return CGSizeMake(kScreenW/4, kScreenW/4);
            break;
        case 1:
            //今日特价
            return CGSizeMake(kScreenW, kScreenW/4.7);
            break;
        case 2:
            //人气热卖
//            return CGSizeMake(kScreenW, kScreenW*2/5+71);
            return CGSizeMake(kScreenW/2, kScreenW/2+85+22);

            break;
        default:
            return CGSizeMake(kScreenW/2, kScreenW/2+85);

            break;
    }
    
}

//头尾部设置
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",indexPath.section);
    switch (indexPath.section) {
        case 0:
        {
            if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
                ImageCollectionReusableView *imageHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"imageHeader" forIndexPath:indexPath];
                //设置代理
                imageHeader.imageScrollView.delegate = self;
                imageHeader.imageScrollView.tag = 500;
                NSMutableArray *imgArr = [NSMutableArray array];
                for (BannerModel *tempModel in self.bannerDataSource) {
                    [imgArr addObject:tempModel.l_image_path];
                }
                
                [imageHeader updateImageCellWithImgUrlArr:imgArr];
                
                return imageHeader;

            }else{
                MaxSaleHotCollectionReusableView *maxSaleHotFooter = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"maxSaleHotFooter" forIndexPath:indexPath];

                //设置代理
                maxSaleHotFooter.cycleView.delegate = self;
                maxSaleHotFooter.cycleView.tag = 501;

                NSMutableArray *titleArr = [NSMutableArray array];
                for (PestsListModel *tempModel in self.adScrollViewDataSourceArr) {
                    [titleArr addObject:tempModel.i_title];
                }
                [maxSaleHotFooter updateMaxSaleHotCell:titleArr];
                return maxSaleHotFooter;

            }
            
        }
            break;
        case 1: {
            UICollectionReusableView *spaceHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"spaceHeader" forIndexPath:indexPath];

            return spaceHeader;
        }
        case 2:
        {
            HotCollectionReusableView *hotHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hotHeader" forIndexPath:indexPath];
//            hotHeader.backgroundColor = [UIColor yellowColor];

            return hotHeader;
        }

            break;

        default:
        {

            MainCollectionReusableView *mainHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mainHeader" forIndexPath:indexPath];

            
            //得到分类
            ProductClassModel *tempClassModel = [[[Manager shareInstance].homeDataSourceDic objectForKey:@"推荐"] objectAtIndex:indexPath.section-3];
            
            [mainHeader updateMainHomeCell:tempClassModel.productClassName withSection:indexPath.section];
            
            //更多按钮实现的方法
            mainHeader.morebuttonIndexBlock = ^(NSInteger moreButtonIndex){
                ProductClassModel *tempClassModel1 = [[[Manager shareInstance].homeDataSourceDic objectForKey:@"推荐"] objectAtIndex:moreButtonIndex-3];

                NSLog(@"%@--%@",tempClassModel1.productClassID,tempClassModel1.productClassName);
            };
            
            return mainHeader;

        }
            break;
    }
    
}


//cellForItem
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%ld===%ld",indexPath.section,indexPath.row);
    Manager *manager = [Manager shareInstance];
    
    switch (indexPath.section) {
        case 0:
        {
            CategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier1" forIndexPath:indexPath];
            [cell updateCategoryCellWithDic:self.categoryDataSource[indexPath.row]];
            return cell;

        }
            break;
        case 1:
        {
            TodaySaleImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier2" forIndexPath:indexPath];
            [cell updateTodayBannerImg:self.todayBannerImgStr];


            return cell;

        }
            break;
            
        case 2:
        {
            
            DetailVerticalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier4" forIndexPath:indexPath];
            
            //得到分类
            ProductModel *tempModel = [[manager.homeDataSourceDic objectForKey:@"热销"] objectAtIndex:indexPath.row];

            [cell updateDetailVerticalCollectionViewCell:tempModel withIndexPath:indexPath];
            
            return cell;
            
            /*
            //两个横向
            DetailHorizontalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier3" forIndexPath:indexPath];
            ProductModel *tempModel1 = [[manager.homeDataSourceDic objectForKey:@"热销"] objectAtIndex:0];
            ProductModel *tempModel2 = [[manager.homeDataSourceDic objectForKey:@"热销"] objectAtIndex:1];
            ProductModel *tempModel3 = [[manager.homeDataSourceDic objectForKey:@"热销"] objectAtIndex:2];
            [cell updateDetailHorizontalCollectionViewCellWithLeftModel:tempModel1 UpModel:tempModel2 withDownModel:tempModel3];
            return cell;
             */

        }
            break;

        default:
        {
            //详情，都是纵向
            DetailVerticalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier4" forIndexPath:indexPath];
            
            //得到分类
            ProductClassModel *tempClassModel = [[[Manager shareInstance].homeDataSourceDic objectForKey:@"推荐"] objectAtIndex:indexPath.section-3];
            
            ProductModel *tempProductModel = tempClassModel.productArr[indexPath.row];
            [cell updateDetailVerticalCollectionViewCell:tempProductModel withIndexPath:indexPath];
            
            return cell;
        }
            break;
    }
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {

            // 3-我的收藏 6-我的订单 7-我的钱包，需要登录了才可以进入
            if (indexPath.row == 3 || indexPath.row == 6 || indexPath.row == 7) {
                Manager *manager = [Manager shareInstance];
                if ([manager isLoggedInStatus] == YES) {
                    NSString *pushId = [self.categoryDataSource[indexPath.row] objectForKey:@"pushId"];
                    if (pushId.length > 0) {
                        [self performSegueWithIdentifier:pushId sender:indexPath];
                        
                    }
                }else {
                    AlertManager *alertM = [AlertManager shareIntance];
                    [alertM showAlertViewWithTitle:nil withMessage:@"请您先登录" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                        
                        //跳转到登录界面
                        //未登录,跳转到登录界面
                        UINavigationController *loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
                        [self presentViewController:loginNav animated:YES completion:nil];
                        
                    }];
                
                }
            }else {
                NSString *pushId = [self.categoryDataSource[indexPath.row] objectForKey:@"pushId"];
                if (pushId.length > 0) {
                    [self performSegueWithIdentifier:pushId sender:indexPath];
                    
                }

            }
                

                 
        }
            
            break;
        case 1:
            [self performSegueWithIdentifier:@"homeToTodaySaleVC" sender:indexPath];

            break;
        
        default:
            [self performSegueWithIdentifier:@"homeToDetail" sender:indexPath];

            break;
    }
    
}

- (IBAction)selectLeftProductTap:(UITapGestureRecognizer *)sender {
    //index是2-1
    [self performSegueWithIdentifier:@"homeToDetail" sender:[NSIndexPath indexPathForItem:0 inSection:2]];
}

//人气热卖中上面的产品点击事件
- (IBAction)selectUpProductTap:(UITapGestureRecognizer *)sender {
    //index是2-1
    [self performSegueWithIdentifier:@"homeToDetail" sender:[NSIndexPath indexPathForItem:1 inSection:2]];
}

//人气热卖中下面的产品点击事件
- (IBAction)selectDownProductTap:(UITapGestureRecognizer *)sender {
    //index是2-2
    [self performSegueWithIdentifier:@"homeToDetail" sender:[NSIndexPath indexPathForItem:2 inSection:2]];}



#pragma mark  - banner图 和 最惠热点滚动条点击代理方法 -
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"%ld",index);
    if (cycleScrollView.tag == 500) {
        BannerModel *tempModel = self.bannerDataSource[index];
        
        if ([tempModel.l_remark isEqualToString:@"activity"]) {
            //原生活动
            [self performSegueWithIdentifier:@"homeToBannerShopVC" sender:tempModel];

        }else{
            //普通公告，就跳转到webView
            [self performSegueWithIdentifier:@"homeToWebViewVC" sender:@[tempModel.l_title,tempModel.l_link_path]];

        }
        
    }
    
    
    if (cycleScrollView.tag == 501) {
        PestsListModel *model = self.adScrollViewDataSourceArr[index];
        NSLog(@"%@", model.i_source_url);
        [self performSegueWithIdentifier:@"homeToWebTwoViewVC" sender:@[model.i_title,model.i_id]];
    }
    
}

#pragma mark - 右上角的消息 -
- (IBAction)rightBarButtonAction:(UIBarButtonItem *)sender {
    Manager *manager = [Manager shareInstance];
    if ([manager isLoggedInStatus] == YES) {
        [self performSegueWithIdentifier:@"homeToMessageVC" sender:nil];
        
    }else{
        AlertManager *alertM = [AlertManager shareIntance];
        [alertM showAlertViewWithTitle:nil withMessage:@"您还没有登录" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
            //跳转到登录界面
            //未登录,跳转到登录界面
            UINavigationController *loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
            [self presentViewController:loginNav animated:YES completion:nil];
        }];
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
    
       //到详情页面
    if ([segue.identifier isEqualToString:@"homeToDetail"]) {
        //传值
        NSIndexPath *selectIndex = sender;
        NSLog(@"%ld -- %ld",selectIndex.section ,selectIndex.row);
        
        ProductDetailViewController *productDetailVC = [segue destinationViewController];

        //人气热卖
        if (selectIndex.section == 2) {
            ProductModel *hotProductModel = [[[Manager shareInstance].homeDataSourceDic objectForKey:@"热销"] objectAtIndex:selectIndex.row];
//            productDetailVC.productID = hotProductModel.productID;
            productDetailVC.productID = hotProductModel.productID;
            productDetailVC.type = @"pid";

            
        }
        //推荐产品
        if (selectIndex.section > 2) {
            //得到分类
            ProductClassModel *tempClassModel = [[[Manager shareInstance].homeDataSourceDic objectForKey:@"推荐"] objectAtIndex:selectIndex.section-3];
            
            ProductModel *tempProductModel = tempClassModel.productArr[selectIndex.row];
//            productDetailVC.productID = @"42DE00CD74E340D9B0527469593CA93C";
            productDetailVC.productID = tempProductModel.productID;
            productDetailVC.type = @"pid";
        }

    }
    //webView
    if ([segue.identifier isEqualToString:@"homeToWebViewVC"]) {
        WebPageViewController *webPageVC = [segue destinationViewController];
        webPageVC.tempTitleStr = sender[0];
        webPageVC.webUrl = sender[1];
        
       
    }
    
    //公告
    if ([segue.identifier isEqualToString:@"homeToWebTwoViewVC"]) {
        
        WebPageTwoViewController *webTwoPageVC = [segue destinationViewController];
        webTwoPageVC.tempTitleStr = ((NSMutableArray *)sender)[0];
        webTwoPageVC.tempId = ((NSMutableArray *)sender)[1];
        
    }
    
    //进入分类
    if ([segue.identifier isEqualToString:@"homeToClassVC"]) {
        ClassViewController *classVC = [segue destinationViewController];
        classVC.hidesBottomBarWhenPushed = YES;
        
    }
    //进入购物车
    if ([segue.identifier isEqualToString:@"homeToShoppingCarVC"]) {
        ShoppingCarViewController *shoppingcarVC = [segue destinationViewController];
        shoppingcarVC.hidesBottomBarWhenPushed = YES;
        
    }
    
    
    //我的订单
    if ([segue.identifier isEqualToString:@"homeToOrderListVC"]) {
        OrderListViewController *orderListVC = [segue destinationViewController];
        orderListVC.whichTableView = @"1";
    }
    
    
}


@end
