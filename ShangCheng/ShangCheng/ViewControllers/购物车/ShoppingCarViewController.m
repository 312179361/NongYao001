//
//  ShoppingCarViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/19.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ShoppingCarViewController.h"
#import "ShoppingCarHeaderViewCollectionReusableView.h"
#import "ShoppingCarMainCollectionViewCell.h"
#import "ErrorMsgFootViewCollectionReusableView.h"
#import "ShoppingCarTwoCollectionViewCell.h"
#import "PreviewOrderViewController.h"
#import "ProductDetailViewController.h"
#import "Manager.h"
#import "MJRefresh.h"
#import "KongImageView.h"
#import "SVProgressHUD.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface ShoppingCarViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)KongImageView *kongImageView;

//判断是否需要刷新
@property (nonatomic,assign)BOOL isRefreshVC;
//判断是否需要reloadData我的收藏
@property (nonatomic,assign)BOOL isReloadMyFavorite;

//@property (weak, nonatomic) IBOutlet UITableView *shoppingTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *shoppingCollectionView;

//是否正在编辑
@property (nonatomic,assign)NSInteger isEditing;
//不在编辑
@property (weak, nonatomic) IBOutlet UIView *notEditingView;
//正在编辑
@property (weak, nonatomic) IBOutlet UIView *editingView;
//全选按钮
@property (weak, nonatomic) IBOutlet UIButton *allSelectButton;
//金额label
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//共多少件Label
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;

@end

@implementation ShoppingCarViewController
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.isRefreshVC = YES;//首次创建，一定是要刷新的
        
        //通知，需要刷新
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshShoppingCarNotification:) name:@"refreshShoppingCarVC" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAllNotification:) name:@"logedIn" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAllNotification:) name:@"logOff" object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMyFavoriteNotification:) name:@"refreshMyFavorite" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShoppingCarNumberNotification:) name:@"refreshShoppingCarNumber" object:nil];

    }
    return self;
}

//返回button
- (void)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//更新购物车角标
- (void)refreshShoppingCarNumberNotification:(NSNotification *)sender {
    //如果是从tabbar进入的购物车，才会有这个角标
    if ([[self.navigationController.viewControllers firstObject] isKindOfClass:[ShoppingCarViewController class]]) {
        self.navigationController.tabBarItem.badgeValue = [Manager shareInstance].shoppingNumberStr;

    }
    
}

//切换账号，都需要更新
- (void)refreshAllNotification:(NSNotification *)sender {
    self.isRefreshVC = YES;
    self.isReloadMyFavorite = YES;
}

//标记更新我的购物车
- (void)refreshShoppingCarNotification:(NSNotification *)sender {
    self.isRefreshVC = YES;
}
//标记更新我的收藏
- (void)refreshMyFavoriteNotification:(NSNotification *)sender {
    self.isReloadMyFavorite = YES;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isRefreshVC == YES) {
        //需要刷新
        [self.shoppingCollectionView headerBeginRefreshing];
    }
    
    if (self.isReloadMyFavorite == YES) {
        //需要刷新我的收藏
        [self httpMyFavoriteDataSource];

    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    //页面消失，如果是编辑状态，就恢复
    if (self.isEditing == YES) {
        [self editBarButtonAction:self.navigationItem.rightBarButtonItem];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@",[self.navigationController viewControllers]);
    
    //加载空白页
    self.kongImageView = [[[NSBundle mainBundle] loadNibNamed:@"KongImageView" owner:self options:nil] firstObject];
    [self.kongImageView.reloadAgainButton addTarget:self action:@selector(reloadAgainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.kongImageView.frame = self.shoppingCollectionView.bounds;
    [self.shoppingCollectionView addSubview:self.kongImageView];
    
    
    
    //只有不是跟视图的时候，才有返回按钮
    if ([self.navigationController viewControllers].count > 1) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"s_icon_back"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonAction:)];
        leftItem.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    
    
    //下拉刷新加载
    [self downPushRefresh];
    
    //如果不是tabbar进入的购物车，就要请求购物车和收藏数据。如果是从tabbar进入的就会自动下拉刷新
    if (![[self.navigationController.viewControllers firstObject] isKindOfClass:[ShoppingCarViewController class]]) {
        [self httpShoppingDataSource];
        [self httpMyFavoriteDataSource];

    }
}

//空白页的按钮
- (void)reloadAgainButtonAction:(IndexButton *)sender {
    if (sender.indexForButton.row == 1) {
        //请求购物车和收藏数据
        [self httpShoppingDataSource];
        [self httpMyFavoriteDataSource];
    }
    if (sender.indexForButton.row == 4) {
        //登录
        UINavigationController *loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        [self presentViewController:loginNav animated:YES completion:nil];

    }
    
}


#pragma mark - 下拉刷新 -
- (void)downPushRefresh {

    [self.shoppingCollectionView addHeaderWithCallback:^{
        
        NSLog(@"下拉刷新啦");
        //网络请求购物车数据
        [self httpShoppingDataSource];
        //请求收藏列表
        [self httpMyFavoriteDataSource];
    }];
   
}


//网络请求购物车
- (void)httpShoppingDataSource{
    Manager *manager = [Manager shareInstance];
    if ([manager isLoggedInStatus] == YES) {
    
        if ([SVProgressHUD isVisible] == NO) {
            [SVProgressHUD show];
        }

        //请求数据购物车数据
        [manager httpShoppingCarDataWithUserId:manager.memberInfoModel.u_id WithSuccessResult:^(id successResult) {
            
            [SVProgressHUD dismiss];//风火轮消失
            
            //结束刷新效果
            [self.shoppingCollectionView headerEndRefreshing];
            [self.shoppingCollectionView reloadData];
            
            //看看是否有空白页
            [self isShowKongImageViewWithType:KongTypeWithKongData withKongMsg:@"购物车暂无数据"];
            
            
            //刷新了，将bool值变为No
            self.isRefreshVC = NO;
            
            //刷新一下全选按钮
            if (manager.isAllSelectForShoppingCar == YES) {
                [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];
                
            }else{
                [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];
            }
            
            //计算金额
            self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[manager selectProductTotalPrice]];
            //计算总件数
            self.totalCountLabel.text = [NSString stringWithFormat:@"共%ld件",[manager isSelectProductCount]];
            
            
        } withFailResult:^(NSString *failResultStr) {
            NSLog(@"请求失败");
            [SVProgressHUD dismiss];
            //结束刷新效果
            [self.shoppingCollectionView headerEndRefreshing];
            [self isShowKongImageViewWithType:KongTypeWithNetError withKongMsg:@"网络错误"];
            

        }];
    } else {
        //未登录
        [self.shoppingCollectionView headerEndRefreshing];
        //获取本地的购物车数据
        
        [manager getLocationShoppingCar];
        //刷新
        [self.shoppingCollectionView reloadData];
        //看看是否有空白页
        [self isShowKongImageViewWithType:KongTypeWithKongData withKongMsg:@"购物车暂无数据"];
        
        //刷新了，将bool值变为No
        self.isRefreshVC = NO;
        
        //刷新一下全选按钮
        if (manager.isAllSelectForShoppingCar == YES) {
            [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];
            
        }else{
            [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];
        }
        
        //计算金额
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[manager selectProductTotalPrice]];
        //计算总件数
        self.totalCountLabel.text = [NSString stringWithFormat:@"共%ld件",[manager isSelectProductCount]];
        
        
//        [self isShowKongImageViewWithType:KongTypeWithNotLogin withKongMsg:@""];
        
    }

}

//网络请求我的收藏
- (void)httpMyFavoriteDataSource {
    Manager *manager = [Manager shareInstance];
    if ([manager isLoggedInStatus] == YES) {
        //如果没有我的收藏数据。就要请求
        [manager httpMyFavoriteListWithUserId:manager.memberInfoModel.u_id withMyFavoriteSuccess:^(id successResult) {
            
            [self.shoppingCollectionView reloadData];
            //刷新了，将bool值变为No
            self.isReloadMyFavorite = NO;
            [self isShowKongImageViewWithType:KongTypeWithKongData withKongMsg:@"购物车暂无数据"];
            
        } withMyFavoriteFail:^(NSString *failResultStr) {
            NSLog(@"我的收藏数据请求失败");
            [self isShowKongImageViewWithType:KongTypeWithNetError withKongMsg:@"网络错误"];

        }];

    }
    
}


#pragma mark - collectionView Delegate -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //前面是购物车的产品，最后一个是收藏
    return [Manager shareInstance].shoppingCarDataSourceArr.count + 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    Manager *manager = [Manager shareInstance];
    if (section < manager.shoppingCarDataSourceArr.count) {
        return 1;
    }else {
        //收藏个数
        
        return manager.myFavoriteArr.count;
    }
}

//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Manager *manager = [Manager shareInstance];
    if (indexPath.section < manager.shoppingCarDataSourceArr.count) {
        return CGSizeMake(kScreenW, 120);
    }else {
        return CGSizeMake((kScreenW-1)/2, (kScreenW-1)/2+90);
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];
    if (indexPath.section < manager.shoppingCarDataSourceArr.count) {
        //购物车
        ShoppingCarMainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShoppingCarMainCell" forIndexPath:indexPath];
        //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //删除block
        cell.deleteSuccessBlock = ^(NSIndexPath *deletePath) {
            NSLog(@"%ld--%ld",deletePath.section,deletePath.row);
            //删除TableView的ui
            NSIndexSet *deleteIndexSet = [NSIndexSet indexSetWithIndex:deletePath.section];
            
            [collectionView deleteSections:deleteIndexSet];
            
            //刷新一下全选按钮
            if (manager.isAllSelectForShoppingCar == YES) {
                [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];
                
            }else{
                [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];
            }
            //计算金额
            self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[manager selectProductTotalPrice]];
            //计算总件数
            self.totalCountLabel.text = [NSString stringWithFormat:@"共%ld件",[manager isSelectProductCount]];
            
        };
        
        //刷新全选按钮block
        cell.totalPriceBlock = ^{
            if (manager.isAllSelectForShoppingCar == YES) {
                [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];
            }else{
                [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];
            }
            NSLog(@"++++%.2f",[manager selectProductTotalPrice]);
            //计算金额
            self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[manager selectProductTotalPrice]];
            //计算总件数
            self.totalCountLabel.text = [NSString stringWithFormat:@"共%ld件",[manager isSelectProductCount]];
        };
        
        //刷新UI
        [cell updateCellWithCellIndex:indexPath];
        
        return cell;

    }else {
        //我的收藏
        ShoppingCarTwoCollectionViewCell *shoppingCarTwoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shoppingCarTwoCell" forIndexPath:indexPath];
        shoppingCarTwoCell.joinShoppingCarButton.indexForButton = indexPath;
        [shoppingCarTwoCell updateShoppingCarTwoCellWithModel:manager.myFavoriteArr[indexPath.row]];
        return shoppingCarTwoCell;
    }
}

//分区头部大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    Manager *manager = [Manager shareInstance];
    if (section < manager.shoppingCarDataSourceArr.count) {
        return CGSizeMake(kScreenW, 15);
    }else {
        return CGSizeMake(kScreenW, 52);
    }

}

//分区尾部大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    Manager *manager = [Manager shareInstance];
    if (section < manager.shoppingCarDataSourceArr.count) {
        ShoppingCarModel *shoppingModel = manager.shoppingCarDataSourceArr[section];
        if (![shoppingModel.productErrorMsg isEqualToString:@""]) {
            //有问题的产品
            return CGSizeMake(kScreenW, 20);
            
        }else {
            //没有问题不用显示尾部
            return CGSizeMake(kScreenW, 0);
        }
    }else {
        //收藏没有尾部
        return CGSizeMake(kScreenW, 0);
    }
    
  

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];

    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        ErrorMsgFootViewCollectionReusableView *errorMsgFootView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"errorMsgFootView" forIndexPath:indexPath];
        errorMsgFootView.errorMsgLabel.hidden = YES;//初始隐藏，如果有内容，在显示
        if (indexPath.section < manager.shoppingCarDataSourceArr.count) {
            ShoppingCarModel *shoppingModel = manager.shoppingCarDataSourceArr[indexPath.section];
            
            if (![shoppingModel.productErrorMsg isEqualToString:@""]) {
                //有问题的产品
                errorMsgFootView.errorMsgLabel.hidden = NO;
                [errorMsgFootView updateErrorMsgFootViewWithErrorMsg:shoppingModel.productErrorMsg];

            }
            
        }

        return errorMsgFootView;
    }else {
        ShoppingCarHeaderViewCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"shoppingHeaderView" forIndexPath:indexPath];
        if (indexPath.section < manager.shoppingCarDataSourceArr.count) {
            headView.shoppingHeaderView.hidden = YES;
        }else {
            headView.shoppingHeaderView.hidden = NO;
        }
        
        return headView;
    }

}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];
    if (indexPath.section < manager.shoppingCarDataSourceArr.count) {
            ShoppingCarModel *tempShoppingCarModel = [[[Manager shareInstance] shoppingCarDataSourceArr] objectAtIndex:indexPath.section];
            
            ProductModel *tempProductModel = tempShoppingCarModel.shoppingCarProduct;
            //跳转到详情页
        [self performSegueWithIdentifier:@"shoppingCarToDetailVC" sender:@[tempProductModel.productFormatID,@"sid"]];
        
    }else {
        Manager *manager = [Manager shareInstance];
        MyFavoriteListModel *tempFavoriteModel = manager.myFavoriteArr[indexPath.row];
        [self performSegueWithIdentifier:@"shoppingCarToDetailVC" sender:@[tempFavoriteModel.favoriteProductFormatID,@"sid"]];

        
    }
}

#pragma mark - 加入购物车 -
- (IBAction)joinShoppingCarButtonAction:(IndexButton *)sender {
    NSLog(@"%ld",sender.indexForButton.row);
    AlertManager *alertM = [AlertManager shareIntance];

    Manager *manager = [Manager shareInstance];
    MyFavoriteListModel *tempFavoriteModel = manager.myFavoriteArr[sender.indexForButton.row];
    
    [manager httpProductToShoppingCarWithFormatIdAndCountDic:@[@{@"sid":tempFavoriteModel.favoriteProductFormatID,@"number":tempFavoriteModel.s_min_quantity}] withSuccessToShoppingCarResult:^(id successResult) {
        [alertM showAlertViewWithTitle:nil withMessage:@"加入购物车成功" actionTitleArr:nil withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
            //重新请求购物车列表
            [self httpShoppingDataSource];

        }];
        
    } withFailToShoppingCarResult:^(NSString *failResultStr) {
        NSLog(@"加入失败");
        [alertM showAlertViewWithTitle:nil withMessage:@"加入购物车失败，请稍后再试" actionTitleArr:nil withViewController:self withReturnCodeBlock:nil];
    }];

    
    
    
}


#pragma mark - 导航栏上的功能 -
//导航栏右边编辑按钮
- (IBAction)editBarButtonAction:(UIBarButtonItem *)sender {
    
    self.isEditing = !self.isEditing;
    
    if (self.isEditing == YES) {
        //正在编辑状态
        sender.title = @"完成";
        self.editingView.hidden = NO;
        self.notEditingView.hidden = YES;
        
        
    }else {
        //不在编辑状态
        sender.title = @"编辑";
        self.editingView.hidden = YES;
        self.notEditingView.hidden = NO;
        
    }
}

#pragma mark - 底部功能 -
//全选
- (IBAction)allSelectButtonAction:(UIButton *)sender {
    
    Manager *manager = [Manager shareInstance];
    //如果现在是全选状态，那么就全不选
    if (manager.isAllSelectForShoppingCar == YES) {
        
        for (ShoppingCarModel *tempModel in manager.shoppingCarDataSourceArr) {
            tempModel.isSelectedShoppingCar = NO;
            
        }
        
    }else {
        for (ShoppingCarModel *tempModel in manager.shoppingCarDataSourceArr) {
            tempModel.isSelectedShoppingCar = YES;
            
        }
    }
    //刷新UI
    [self.shoppingCollectionView reloadData];
    
    //判断一下是否全选
    [manager isAllSelectForShoppingCarAction];
    //需要刷新全选按钮
    if (manager.isAllSelectForShoppingCar == YES) {
        [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];
    }else {
        [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];
    }
    //计算总价格
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[manager selectProductTotalPrice]];
    //计算总件数
    self.totalCountLabel.text = [NSString stringWithFormat:@"共%ld件",[manager isSelectProductCount]];
}


//编辑状态的删除按钮
- (IBAction)editDeleteButtonAction:(UIButton *)sender {
    AlertManager *alertM = [AlertManager shareIntance];

    Manager *manager = [Manager shareInstance];
    //如果选择了产品
    if ([manager isSelectAnyOneProduct] == YES) {
        [alertM showAlertViewWithTitle:nil withMessage:@"确定要删除这件产品？" actionTitleArr:@[@"取消",@"确认"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
            if (actionBlockNumber == 1) {
                //设置set为了删除数据源
                NSMutableIndexSet *deleteIndexSet = [NSMutableIndexSet indexSet];
                //从所有产品中，得到选中的产品的下标，即i的值
                for (int i = 0; i < manager.shoppingCarDataSourceArr.count; i++) {
                    if ([manager.shoppingCarDataSourceArr[i] isSelectedShoppingCar] == YES) {
                        //如果选中了这个产品，那么就将下标加入
                        [deleteIndexSet addIndex:i];
                        
                    }
                }
                
                if ([manager isLoggedInStatus] == YES) {
                    //网络删除
                    [manager deleteShoppingCarWithProductIndexSet:deleteIndexSet WithSuccessResult:^(id successResult) {
                        [self.shoppingCollectionView deleteSections:deleteIndexSet];
                        
                        //需要刷新全选按钮
                        if (manager.isAllSelectForShoppingCar == YES) {
                            [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];
                        }else {
                            [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];
                        }
                        //计算总金额
                        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[manager selectProductTotalPrice]];
                        //计算总件数
                        self.totalCountLabel.text = [NSString stringWithFormat:@"共%ld件",[manager isSelectProductCount]];
                        
                    } withFailResult:^(NSString *failResultStr) {
                        //删除失败
                        [alertM showAlertViewWithTitle:nil withMessage:@"删除失败" actionTitleArr:nil withViewController:self withReturnCodeBlock:nil];
                    }];
                }else {
                    //本地删除
                    BOOL saveResult =  [manager deleteLocationShoppingCarWithProductIndexSet:deleteIndexSet];
                    if (saveResult == YES) {
                        
                        [self.shoppingCollectionView deleteSections:deleteIndexSet];

                        //需要刷新全选按钮
                        if (manager.isAllSelectForShoppingCar == YES) {
                            [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];
                        }else {
                            [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];
                        }
                        //计算总金额
                        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[manager selectProductTotalPrice]];
                        //计算总件数
                        self.totalCountLabel.text = [NSString stringWithFormat:@"共%ld件",[manager isSelectProductCount]];
                        
                    }else {
                        NSLog(@"删除失败");
                    }

                }
                
            

            }
        }];

    }else {
        
        [alertM showAlertViewWithTitle:nil withMessage:@"您还没有选择产品" actionTitleArr:nil withViewController:self withReturnCodeBlock:nil];
    }
    
}


//加入收藏
- (IBAction)editJoinFavoriteButtonAction:(UIButton *)sender {
    AlertManager *alertM = [AlertManager shareIntance];
    
    Manager *manager = [Manager shareInstance];
     if ([manager isLoggedInStatus] == YES) {
         //如果选择了产品
         if ([manager isSelectAnyOneProduct] == YES) {
             [alertM showAlertViewWithTitle:nil withMessage:@"确定要收藏这些产品？" actionTitleArr:@[@"取消",@"确认"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                 if (actionBlockNumber == 1) {
                     
                     NSMutableArray *formatIdArr = [NSMutableArray array];
                     for (ShoppingCarModel *tempModel in manager.shoppingCarDataSourceArr) {
                         if (tempModel.isSelectedShoppingCar == YES) {
                             [formatIdArr addObject:tempModel.shoppingCarProduct.productFormatID];
                         }
                     }
                     
                     //收藏
                     [manager httpAddFavoriteWithUserId:manager.memberInfoModel.u_id withFormatIdArr:formatIdArr withAddFavoriteSuccess:^(id successResult) {
                         
                         [alertM showAlertViewWithTitle:nil withMessage:@"收藏成功" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
                         
                     } withAddFavoriteFail:^(NSString *failResultStr) {
                         [alertM showAlertViewWithTitle:nil withMessage:@"收藏失败，请稍后再试！" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
                     }];
                     
                 }
             }];
             
         }else {
             
             [alertM showAlertViewWithTitle:nil withMessage:@"您还没有选择产品" actionTitleArr:nil withViewController:self withReturnCodeBlock:nil];
         }

     }else {
         [alertM showAlertViewWithTitle:nil withMessage:@"请先登录后，在进行收藏" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
             //未登录,跳转到登录界面
             UINavigationController *loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
             [self presentViewController:loginNav animated:YES completion:nil];
         }];
         

         

     }
    
    
}

//分享
- (IBAction)shareButtonAction:(UIButton *)sender {
    AlertManager *alertM = [AlertManager shareIntance];
    
    Manager *manager = [Manager shareInstance];
    
    //如果选择了产品
    if ([manager isSelectAnyOneProduct] == YES) {
        
        //1、创建分享参数
        NSArray* imageArray = @[[UIImage imageNamed:@"mainIcon"]];
        //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
        if (imageArray) {
            
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:@"世纪农药网中国最大最专业的农药网上交易平台"
                                             images:imageArray
                                                url:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1234823386?mt=8"]
                                              title:@"世纪农药网"
                                               type:SSDKContentTypeAuto];
            //有的平台要客户端分享需要加此方法，例如微博
            [shareParams SSDKEnableUseClientShare];
            //2、分享（可以弹出我们的分享菜单和编辑界面）
            [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                     items:nil
                               shareParams:shareParams
                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                           
                           switch (state) {
                               case SSDKResponseStateSuccess:
                               {
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               default:
                                   break;
                           }
                       }
             ];
            
        }

    }else {
        
        [alertM showAlertViewWithTitle:nil withMessage:@"您还没有选择产品" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

    }
    
}



//立即支付按钮
- (IBAction)payButtonAction:(UIButton *)sender {
    
    Manager *manager = [Manager shareInstance];
    AlertManager *alert = [AlertManager shareIntance];

    //只有登录了才可以进行支付
    if ([manager isLoggedInStatus] == YES) {
        //有选择产品才可以支付
        if ([manager isSelectAnyOneProduct] == YES) {
            //将选择的产品下标记录一下，主要用户刷新UI
//            NSMutableIndexSet *selectIndexSet = [NSMutableIndexSet indexSet];
            //将选择的产品id记录一下，传给接口
            NSMutableArray *shoppingCarIdArr = [NSMutableArray array];
            for (int i = 0; i < manager.shoppingCarDataSourceArr.count; i++) {
                ShoppingCarModel *shoppingCarModel = manager.shoppingCarDataSourceArr[i];
                //清空所有的问题产品信息
                shoppingCarModel.productErrorMsg = @"";
                
                if (shoppingCarModel.isSelectedShoppingCar == YES) {
                    //如果选中了这个产品，那么产品下标家属indexSet中,产品id加入数组，
//                    [selectIndexSet addIndex:i];
                    [shoppingCarIdArr addObject:shoppingCarModel.c_id];
                }
            }
            
            //调用订单预支付接口，看看哪些产品不能生成订单
            [manager httpOrderPreviewWithShoppingCarIDArr:shoppingCarIdArr withPreviewSuccessResult:^(id successResult) {
                
                if ([[successResult objectForKey:@"code"] integerValue] == 200) {
                    //全部产品成功,即可生成订单了，跳转到下一页，在跳转下一页的时候，先清空一下上次有错误的产品UI
                    [self.shoppingCollectionView reloadData];
                    
                    //跳转
                    [self performSegueWithIdentifier:@"toPreviewOrderVC" sender:sender];
                    
                    
                }else if ([[successResult objectForKey:@"code"] integerValue] == 400) {
                    //有些产品不成功
                    NSMutableIndexSet *deleteIndexSet = [NSMutableIndexSet indexSet];

                    NSArray *contentArr = [successResult objectForKey:@"content"];
                    for (NSDictionary *contentDic in contentArr) {
                        
                        //遍历返回的不成功的产品,在购物车数组中，做标记
                        for (int j = 0; j < manager.shoppingCarDataSourceArr.count; j++) {
                            ShoppingCarModel *tempShoppingCarModel = manager.shoppingCarDataSourceArr[j];

                            if ([tempShoppingCarModel.c_id isEqualToString:[contentDic objectForKey:@"cartid"]]) {
                                //找到问题产品。做标记
                                tempShoppingCarModel. productErrorMsg = [contentDic objectForKey:@"message"];
                                [deleteIndexSet addIndex:j];
                                
                            }
                        }
                       
                        
                    }
                    
                    //刷新UI,展示问题产品
                    [self.shoppingCollectionView reloadSections:deleteIndexSet];
                    
                    //删除产品
                    if ([manager isLoggedInStatus] == YES) {
                        [manager deleteShoppingCarWithProductIndexSet:deleteIndexSet WithSuccessResult:^(id successResult) {
                            
                            //删除UI
                            [self.shoppingCollectionView deleteSections:deleteIndexSet];

                        } withFailResult:^(NSString *failResultStr) {
                            //删除失败
                            NSLog(@"删除失败");
                        }];
                        
                    }else {
                        //本地删除
                        BOOL saveResult =  [manager deleteLocationShoppingCarWithProductIndexSet:deleteIndexSet];
                        if (saveResult == YES) {
                            [self.shoppingCollectionView deleteSections:deleteIndexSet];

                        }else {
                            NSLog(@"删除失败");
                        }
                        
                    }
                    
                    
                    
                    
                    
                    
                    
//                    [self.shoppingCollectionView deleteSections:[NSIndexSet indexSetWithIndex:0]];
                    
                    
                    
                }
                
            } withPreviewFailResult:^(NSString *failResultStr) {

                [alert showAlertViewWithTitle:nil withMessage:@"未知错误，请稍后再试，或者联系客服" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
            }];
            
        }else {

            [alert showAlertViewWithTitle:nil withMessage:@"您还没有选择产品" actionTitleArr:nil withViewController:self withReturnCodeBlock:nil];
        }

    }else{
        //没有登录
        [alert showAlertViewWithTitle:nil withMessage:@"您还没有登录" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
            //未登录,跳转到登录界面
            UINavigationController *loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
            [self presentViewController:loginNav animated:YES completion:nil];

        }];
        
    }
    
    
    
    
}


//空白页
- (void)isShowKongImageViewWithType:(KongType )kongType withKongMsg:(NSString *)msg {
    Manager *manager = [Manager shareInstance];
    if (manager.shoppingCarDataSourceArr.count == 0 && manager.myFavoriteArr.count == 0) {
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
    Manager *manager = [Manager shareInstance];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toPreviewOrderVC"]) {
        NSMutableArray *selectArr = [NSMutableArray array];
        //找到选择的产品数据
        for (ShoppingCarModel *tempModel in manager.shoppingCarDataSourceArr) {
            if (tempModel.isSelectedShoppingCar == YES) {
                //选择了这个产品，加入数组中
                [selectArr addObject:tempModel];
            }
        }
        
        PreviewOrderViewController *previewOrderVC = [segue destinationViewController];
        previewOrderVC.selectedProductArr = selectArr;

    }
    
    //点击cell跳转到详情
    if ([segue.identifier isEqualToString:@"shoppingCarToDetailVC"]) {
        ProductDetailViewController *productDetailVC = [segue destinationViewController];
        productDetailVC.productID = sender[0];
        productDetailVC.type = sender[1];
    }
    
}


@end
