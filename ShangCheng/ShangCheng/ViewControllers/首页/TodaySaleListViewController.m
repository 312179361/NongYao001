//
//  TodaySaleListViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/1.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "TodaySaleListViewController.h"
#import "TodaySaleHeaderCollectionViewCell.h"
#import "TodaySaleListCollectionViewCell.h"
#import "Manager.h"
#import "MJRefresh.h"
#import "KongImageView.h"
#import "SVProgressHUD.h"
#import "ProductDetailViewController.h"
@interface TodaySaleListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)KongImageView *kongImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *todaySaleListCollectionView;
@property (nonatomic,strong)NSMutableArray *todaySaleListArr;

@end

@implementation TodaySaleListViewController
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
    self.title = self.tempTitle;
    
    //加载空白页
    self.kongImageView = [[[NSBundle mainBundle] loadNibNamed:@"KongImageView" owner:self options:nil] firstObject];
    [self.kongImageView.reloadAgainButton addTarget:self action:@selector(reloadAgainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.kongImageView.frame = self.view.bounds;
    [self.view addSubview:self.kongImageView];

    
    [self downPushRefresh];
    //执行一次刷新
    [self.todaySaleListCollectionView headerBeginRefreshing];
}

//重新加载按钮
- (void)reloadAgainButtonAction:(IndexButton *)sender {
    
    Manager *manager = [Manager shareInstance];
    if ([SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];
    }
    
    [manager searchTodayActivityWithAid:self.temp_a_id withSearchTodaySuccess:^(id successResult) {
        [SVProgressHUD dismiss];
        //下拉刷新效果消失
        [self.todaySaleListCollectionView headerEndRefreshing];
        
        self.todaySaleListArr = [NSMutableArray arrayWithArray:successResult];
        [self.todaySaleListCollectionView reloadData];
        //查看是否显示空白页
        [self isShowKongImageViewWithType:KongTypeWithKongData withKongMsg:[NSString stringWithFormat:@"暂无%@",self.tempTitle]];
        
    } withSearchTodayFail:^(NSString *failResultStr) {
        [SVProgressHUD dismiss];
        //查看是否显示空白页
        [self isShowKongImageViewWithType:KongTypeWithNetError withKongMsg:@"网络错误"];

    }];
}

- (void)downPushRefresh {
    //加载数据
    [self.todaySaleListCollectionView addHeaderWithCallback:^{
        [self reloadAgainButtonAction:nil];
    }];
    
    
    
}





#pragma mark - collectionView delegate -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.todaySaleListArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenW, kScreenW/3);
    }else {
        return CGSizeMake((kScreenW-1)/2, (kScreenW-1)/2+95);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TodaySaleHeaderCollectionViewCell *headerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"todaySaleListHeaderCell" forIndexPath:indexPath];
        [headerCell updateHeaderCellWithImageUrl:self.headerImageUrl];
        return headerCell;
    }else {
        TodaySaleListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"todaySaleListCollectionCell" forIndexPath:indexPath];
        TodaySaleListModel *tempModel = self.todaySaleListArr[indexPath.row];
        [cell updateTodaySaleListCellWithModel:tempModel];
        return cell;

    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 0) {
        TodaySaleListModel *tempModel = self.todaySaleListArr[indexPath.row];

        [self performSegueWithIdentifier:@"todaySaleToDetailVC" sender:tempModel];
        
        
        
    }
}

//空白页
- (void)isShowKongImageViewWithType:(KongType )kongType withKongMsg:(NSString *)msg {

    if (self.todaySaleListArr.count > 0) {
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
    if ([segue.identifier isEqualToString:@"todaySaleToDetailVC"]) {
        TodaySaleListModel *tempModel =sender;
        ProductDetailViewController *productDetailVC = [segue destinationViewController];
        productDetailVC.productID = tempModel.d_s_id;
        productDetailVC.type = @"sid";
    }
}


@end
