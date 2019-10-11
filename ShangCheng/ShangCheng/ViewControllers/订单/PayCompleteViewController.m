//
//  PayCompleteViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/11.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "PayCompleteViewController.h"
#import "ProductDetailViewController.h"
#import "Manager.h"
#import "KongImageView.h"
#import "CompleteCollectionViewCell.h"

@interface PayCompleteViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic,strong)KongImageView *kongImageView;

@end

@implementation PayCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //加载空白页
    self.kongImageView = [[[NSBundle mainBundle] loadNibNamed:@"KongImageView" owner:self options:nil] firstObject];
    [self.kongImageView.reloadAgainButton addTarget:self action:@selector(reloadAgainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.kongImageView.frame = self.myCollectionView.bounds;
    [self.myCollectionView addSubview:self.kongImageView];
    

    //发送通知到订单列表，刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:self userInfo:nil];
    //请求收藏数据
    [self httpMyFavoriteDataSource];
    
}

- (void)reloadAgainButtonAction:(UIButton *)sender {
    [self httpMyFavoriteDataSource];
    
}

//网络请求我的收藏
- (void)httpMyFavoriteDataSource {
    Manager *manager = [Manager shareInstance];
    if ([manager isLoggedInStatus] == YES) {
        //如果没有我的收藏数据。就要请求
        [manager httpMyFavoriteListWithUserId:manager.memberInfoModel.u_id withMyFavoriteSuccess:^(id successResult) {
            
            [self.myCollectionView reloadData];

            
        } withMyFavoriteFail:^(NSString *failResultStr) {
            NSLog(@"我的收藏数据请求失败");
        }];
        
    }
    
}


- (IBAction)leftBarbuttonAction:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//继续购买
- (IBAction)goOnPayAction:(UIButton *)sender {
    //回到首页
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//查看订单
- (IBAction)lookOrderButtonAction:(UIButton *)sender {
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:NO];
    //发送通知进入订单
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toOrderListNoti" object:self userInfo:nil];
}


#pragma mark - collectionView Delegate -
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"payCompleteHeaderView" forIndexPath:indexPath];
    return headerView;
}

- (CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((kScreenW-1)/2, (kScreenW-1)/2+90);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    Manager *manager = [Manager shareInstance];
//    return 0;
    return manager.myFavoriteArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];
    //我的收藏
    CompleteCollectionViewCell *completeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"payCompleteCell" forIndexPath:indexPath];

    [completeCell updateCompleteCellWithModel:manager.myFavoriteArr[indexPath.row]];
    return completeCell;

    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];
    MyFavoriteListModel *tempFavoriteModel = manager.myFavoriteArr[indexPath.row];
    [self performSegueWithIdentifier:@"completeToProductDetailVC" sender:tempFavoriteModel.favoriteProductFormatID];
    
    
    
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
    if ([segue.identifier isEqualToString:@"completeToProductDetailVC"]) {
        ProductDetailViewController *productDetailVC = [segue destinationViewController];
        productDetailVC.productID = sender;
        productDetailVC.type = @"sid";
    }

  
}


@end
