//
//  SearchViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/3.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "SearchViewController.h"
#import "ProductListViewController.h"
#import "PestsListViewController.h"
#import "SearchCollectionViewCell.h"
#import "Manager.h"
//#import "SearchBarTextField.h"

@interface SearchViewController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *hotSearchCollectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchTextFieldWidthLayout;

@end

@implementation SearchViewController
//取消
- (IBAction)rightBarButtonAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

//    [self performSegueWithIdentifier:@"searchToListVC" sender:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //加载 搜索框
//    self.searchBarTextField = [[[NSBundle mainBundle] loadNibNamed:@"SearchBarTextField" owner:self options:nil] firstObject];
//    self.searchBarTextField.searchTextField.delegate = self;

//        self.navigationItem.titleView.backgroundColor = [UIColor yellowColor];
//    self.navigationItem.titleView = self.searchBarTextField;
//    [self.navigationController.navigationBar addSubview:self.searchBarTextField]
    
    //只有产品 才显示收藏，如果是病虫害就不显示
    if (self.productOrPests == Product) {
        //如果登陆了 并且没有收藏记录，就请求一下
        Manager *manager = [Manager shareInstance];
        if ([manager isLoggedInStatus] == YES) {
            if (manager.myFavoriteArr == nil || manager.myFavoriteArr.count == 0) {
                [manager httpMyFavoriteListWithUserId:manager.memberInfoModel.u_id withMyFavoriteSuccess:^(id successResult) {
                    
                    [self.hotSearchCollectionView reloadData];
                } withMyFavoriteFail:^(NSString *failResultStr) {
                    NSLog(@"我的收藏数据请求失败");
                    
                }];
            }
        }
    }
    
   
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    self.searchTextFieldWidthLayout.constant = kScreenW/2;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text.length > 0) {
        [textField resignFirstResponder];

        if (self.productOrPests == Product) {
            [self performSegueWithIdentifier:@"searchToListVC" sender:@[@"SearchProduct",textField.text]];

        }
        if (self.productOrPests == Pests) {
            [self performSegueWithIdentifier:@"searchToPestsListVC" sender:@[@"SearchPests",textField.text]];

        }
        
    }

    return YES;
}

#pragma mark - collectionView Delegate -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.productOrPests == Product) {
        Manager *manager = [Manager shareInstance];
        return manager.myFavoriteArr.count;
    }else {
        //病虫害搜索
        return 0;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(130, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenW, 37);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(nonnull NSString *)kind atIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionReusableView *headerCell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hotSearchHead" forIndexPath:indexPath];
    return headerCell;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];
    MyFavoriteListModel *tempModel = manager.myFavoriteArr[indexPath.row];
    
    SearchCollectionViewCell *searchCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"searchCell" forIndexPath:indexPath];
    
    searchCell.nameLabel.text = tempModel.favoriteProductNameStr;
    return searchCell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];
    MyFavoriteListModel *tempModel = manager.myFavoriteArr[indexPath.row];
    
    [self performSegueWithIdentifier:@"searchToListVC" sender:@[@"SearchProduct",tempModel.favoriteProductNameStr]];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchTextField resignFirstResponder];
    
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
    if ([segue.identifier isEqualToString:@"searchToListVC"]) {
        ProductListViewController *productListVC = [segue destinationViewController];
        
        //搜索产品
        if ([[sender objectAtIndex:0] isEqualToString:@"SearchProduct"]) {
            productListVC.tempKeyword = [sender objectAtIndex:1];
            productListVC.productSearchOrType = SearchProduct;
        }
        //分类产品
        if([[sender objectAtIndex:0] isEqualToString:@"TypeProduct"]){
            productListVC.tempCode = [sender objectAtIndex:1];
            productListVC.productSearchOrType = TypeProduct;
        }
        
        
    }
    
    if ([segue.identifier isEqualToString:@"searchToPestsListVC"]) {
        PestsListViewController *pestsListVC = [segue destinationViewController];

        //搜索病虫害
        if([[sender objectAtIndex:0] isEqualToString:@"SearchPests"]){
            pestsListVC.tempKeyword = [sender objectAtIndex:1];
            pestsListVC.pestsIsSearchOrType = SearchPests;
            pestsListVC.showTitleStr = [NSString stringWithFormat:@"%@病虫害",[sender objectAtIndex:1]];
        }

        //分类病虫害
        if([[sender objectAtIndex:0] isEqualToString:@"TypePests"]){
            pestsListVC.tempCode = [sender objectAtIndex:1];
            pestsListVC.pestsIsSearchOrType = TypePests;
            pestsListVC.showTitleStr = [NSString stringWithFormat:@"%@病虫害",[sender objectAtIndex:2] ];

        }

    }
}


@end
