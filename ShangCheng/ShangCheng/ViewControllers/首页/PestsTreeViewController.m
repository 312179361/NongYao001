//
//  PestsTreeViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/6.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "PestsTreeViewController.h"
#import "Manager.h"
#import "PestsTableViewCell.h"
#import "PestsCollectionViewCell.h"
#import "PestsCollectionReusableView.h"
#import "SearchViewController.h"
#import "KongImageView.h"
#import "SVProgressHUD.h"
@interface PestsTreeViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)KongImageView *kongImageView;

//左边的TableView
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;

//选择左边分类的标记
@property(nonatomic,assign)NSInteger selectLeftInt;
//右边的collectionView
@property (weak, nonatomic) IBOutlet UICollectionView *rightCollectionView;

@end

@implementation PestsTreeViewController
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
    self.kongImageView.frame = self.view.bounds;
    [self.view addSubview:self.kongImageView];

    //加载数据
    [self reloadAgainButtonAction:nil];
}

- (void)reloadAgainButtonAction:(IndexButton *)sender {
    //请求数据
    Manager *manager = [Manager shareInstance];
    //显示风火轮
    if ([SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];
    }
    [manager httpInformationPestsTreeWithPestsTreeSuccess:^(id successResult) {
        //风火轮消失
        [SVProgressHUD dismiss];
        [self.leftTableView reloadData];
        [self.rightCollectionView reloadData];
        [self isShowKongImageViewWithType:KongTypeWithKongData withKongMsg:@"暂时没有病虫害"];
    } withPestsTreeFail:^(NSString *failResultStr) {
        //风火轮消失
        [SVProgressHUD dismiss];

        NSLog(@"%@",failResultStr);
        [self isShowKongImageViewWithType:KongTypeWithNetError withKongMsg:@"网络错误"];

    }];

}


//空白页
- (void)isShowKongImageViewWithType:(KongType )kongType withKongMsg:(NSString *)msg {
    Manager *manager = [Manager shareInstance];
    if (manager.pestsTreeArr.count > 0) {
        [self.kongImageView hiddenKongView];
    }else {
        [self.kongImageView showKongViewWithKongMsg:msg withKongType:kongType];
    }
    
}



#pragma mark - 搜索 -
- (IBAction)searchAction:(UITapGestureRecognizer *)sender {
    UINavigationController *searchNav = [self.storyboard instantiateViewControllerWithIdentifier:@"searchNavigationController"];
    SearchViewController *searchVC = [searchNav.viewControllers objectAtIndex:0];
    searchVC.productOrPests = Pests;
    [self presentViewController:searchNav animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 左边的 TableView Delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Manager *manager = [Manager shareInstance];
    return manager.pestsTreeArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Manager *manager = [Manager shareInstance];
    
    PestsTableViewCell *leftCell = [tableView dequeueReusableCellWithIdentifier:@"leftPestsCell" forIndexPath:indexPath];
    PestsTreeModel *tempLeftModel = manager.pestsTreeArr[indexPath.row];
    if (indexPath.row == self.selectLeftInt) {
        [leftCell updateLeftCellWithTitle:tempLeftModel.c_name withIsSelectItem:YES];//选中的cell
    }else{
        [leftCell updateLeftCellWithTitle:tempLeftModel.c_name withIsSelectItem:NO];//未选中的cell
    }
    
    return leftCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //如果选择了不同的分类，那么就刷新右边的collectionView
    if (self.selectLeftInt != indexPath.row) {
        self.selectLeftInt = indexPath.row;
        [self.rightCollectionView reloadData];
        
        //更新左边的选中颜色样式
        [self.leftTableView reloadData];
    }
    
    
}

#pragma mark - 右边的 CollectionView Delegate -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    Manager *manager = [Manager shareInstance];
    if (manager.pestsTreeArr.count > 0) {
        NSArray *rightArr = [manager.pestsTreeArr[self.selectLeftInt] itemArr];
        return rightArr.count;
    }
    return 0;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    Manager *manager = [Manager shareInstance];
    NSArray *rightArr = [manager.pestsTreeArr[self.selectLeftInt] itemArr];
    
    PestsTreeModel *tempModel = rightArr[section];
    if (tempModel.isMore == NO && tempModel.itemArr.count > 6) {
        return 6;
    }else {
        return tempModel.itemArr.count;
    }
    
    
    

    
}

////分区头高度
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//
//
//}


//分区头设置
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    PestsCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"rightPestsHeaderView" forIndexPath:indexPath];
    headerView.rightHeaderButton.indexForButton = indexPath;
    
    Manager *manager = [Manager shareInstance];
    NSArray *rightArr = [manager.pestsTreeArr[self.selectLeftInt] itemArr];
    PestsTreeModel *rightModel = rightArr[indexPath.section];
    [headerView updateRightHeaderViewWithModel:rightModel];
    
    headerView.moreButtonIndex = ^(NSIndexPath *moreButtonIndex){
        
        PestsTreeModel *rightModel1 = rightArr[moreButtonIndex.section];
        rightModel1.isMore = !rightModel1.isMore;
        NSIndexSet *setaa = [NSIndexSet indexSetWithIndex:moreButtonIndex.section];
        [self.rightCollectionView reloadSections:setaa];
        
    };
    return headerView;
    
}

//item 大小
- (CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((kScreenW*13/18 - 43-18)/3, 30);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PestsCollectionViewCell *rightCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rightPestsCell" forIndexPath:indexPath];
    Manager *manager = [Manager shareInstance];
    NSArray *rightArr = [manager.pestsTreeArr[self.selectLeftInt] itemArr];
    NSArray *rightDetailArr = [rightArr[indexPath.section] itemArr];
    PestsTreeModel *rightDetailModel = rightDetailArr[indexPath.row];
    [rightCell updateRightCellWithTitle:rightDetailModel.c_name];
    
    return rightCell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];
    NSArray *rightArr = [manager.pestsTreeArr[self.selectLeftInt] itemArr];
    NSArray *rightDetailArr = [rightArr[indexPath.section] itemArr];
    PestsTreeModel *rightDetailModel = rightDetailArr[indexPath.row];
    NSLog(@"%@",rightDetailModel.c_name);
    
    
    UINavigationController *searchNav = [self.storyboard instantiateViewControllerWithIdentifier:@"searchNavigationController"];
    //跳转到列表界面
    [searchNav.viewControllers[0] performSegueWithIdentifier:@"searchToPestsListVC" sender:@[@"TypePests",rightDetailModel.c_catid,rightDetailModel.c_name]];
    
    
    [self presentViewController:searchNav animated:NO completion:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
