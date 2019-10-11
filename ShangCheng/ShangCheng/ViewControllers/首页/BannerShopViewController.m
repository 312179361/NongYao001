//
//  BannerShopViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/11/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "BannerShopViewController.h"
#import "BannerCellOneCollectionViewCell.h"
#import "BannerCellTwoCollectionViewCell.h"
#import "BannerCellThreeCollectionViewCell.h"
#import "BannerCellFourCollectionViewCell.h"
#import "TradeTableViewCell.h"
#import "BannerShopCollectionReusableView.h"
#import "Manager.h"
#import "BannerTradeModel.h"
#import "SaleProductListViewController.h"
#import "ProductDetailViewController.h"

@interface BannerShopViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property(nonatomic,strong)UIView *searchView;
@property(nonatomic,strong)UISearchBar *searchBar;


@property (weak, nonatomic) IBOutlet UICollectionView *bannerCollectionView;


//产品的分类键数组
@property (nonatomic,strong)NSArray *keyArr;
//产品数据源
@property (nonatomic,strong)NSMutableDictionary *dataSourceDic;

//参与厂家
@property(nonatomic,strong)NSMutableArray *factoryDataArr;
//参与厂家 现在是第几页
@property(nonatomic,assign)NSInteger factoryPageInt;
//一共有几页
@property(nonatomic,assign)NSInteger factoryTotalPageInt;

//交易记录
@property(nonatomic,strong)NSMutableArray *tradeDataArr;
//销量 现在是第几页
@property(nonatomic,assign)NSInteger tradePageInt;
//一共有几页
@property(nonatomic,assign)NSInteger tradeTotalPageInt;


//定时器
@property(nonatomic,strong)NSTimer *tempTimer;
//厂家最下面的cell的index
@property(nonatomic,assign)NSInteger tempFactoryIndex;
//销量最下面的cell的index
@property(nonatomic,assign)NSInteger tempTradeIndex;

//
@property(nonatomic,strong)UITableView *factoryTableView;
@property(nonatomic,strong)UITableView *tradeTableView;


//banner图片链接
@property(nonatomic,strong)NSString *activityBannerImgStr;

@end

@implementation BannerShopViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self scrollViewDidScroll:self.bannerCollectionView];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    Manager *manager = [Manager shareInstance];
    [self.navigationController.navigationBar setBackgroundImage:[manager getImageWithAlpha:1] forBarMetrics:UIBarMetricsDefault];
    //显示navigation 那条线
    [manager isClearNavigationBarLine:NO withNavigationController:self.navigationController];
    
    //停止倒计时
    [self.tempTimer invalidate];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建导航栏中的搜索框
    [self addSearchBarOnNavigation];
    
    if (@available(iOS 11.0, *)) {
        NSLog(@"iOS11以上");
        self.bannerCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    }else {
        NSLog(@"iOS11以下");
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //注册cell
    [self.bannerCollectionView registerNib:[UINib nibWithNibName:@"BannerCellOneCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"bannerCellOne"];
    [self.bannerCollectionView registerNib:[UINib nibWithNibName:@"BannerCellTwoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"bannerShopCellTwo"];


    self.keyArr = @[@"4",@"7",@"5",@"6",@"9",@"8",@"13"];
    
    for (NSString *tempKey in self.keyArr) {
       //请求活动产品
        [self httpActivityProductWithType:tempKey];
        
    }
    
    //还没有请求 所以厂家页数为0
    self.factoryPageInt = 0;
    self.factoryTotalPageInt = 2;//先默认一共有两页
    //网络请求厂家
    [self httpActivityFactoryWithPageIndex:self.factoryPageInt];
    
    
    //还没有请求 所以销量页数为0
    self.tradePageInt = 0;
    self.tradeTotalPageInt = 2;//先默认一共有两页
    //网络请求销
    [self httpActivityTradeWithPageIndex:self.tradePageInt];

    
    //开启定时器
    self.tempTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    //初始化最下面cell的index
    self.tempFactoryIndex = 9;
    self.tempTradeIndex = 4;
    
    
    //网络请求banner图片
    [self httpActivityBanner];

}


//添加搜索框到导航栏
- (void)addSearchBarOnNavigation {
    //创建一个UIView当做titleView
    self.searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, NSIntegerMax, 44)];
//    self.searchView.backgroundColor = [UIColor blueColor];
    self.navigationItem.titleView = self.searchView;
    
    //导航条的搜索条
    self.searchBar = [[UISearchBar alloc]init];
    [self.searchBar setTintColor:k333333Color];
    [self.searchBar setPlaceholder:@"请输入产品名称或成分"];
    UITextField *searchField = [self.searchBar valueForKey:@"_searchField"];
    self.searchBar.delegate = self;
//    searchField.returnKeyType = UIReturnKeySearch;
    searchField.font = [UIFont systemFontOfSize:13];
    [self.searchView addSubview:_searchBar];
}

#pragma mark - searchBar代理 -
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    UITextField *searchField = [searchBar valueForKey:@"_searchField"];

    //进行搜索
    [self performSegueWithIdentifier:@"bannerShopToSaleList" sender:@[@"search",searchField.text]];
}

#pragma mark - 网络请求 -
//网络请求banner图片
- (void)httpActivityBanner {
    
    Manager *manager = [Manager shareInstance];
    //头部banner图数据源
    [manager httpBannerScrollViewDataSourceWithBannerType:@"7" withBannerSuccess:^(id successResult) {
        if ([successResult count] > 0) {
            BannerModel *tempTodayModel = successResult[0];
            self.activityBannerImgStr = tempTodayModel.l_image_path;
            [self.bannerCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            
        }
        
        
    } withBannerFail:^(NSString *failResultStr) {
        NSLog(@"%@",failResultStr);
        
    }];
}

//网络请求商品信息
//4 杀虫剂  7杀螨剂  5杀菌剂  6除草剂  9调节剂  8叶面肥  13其他
- (void)httpActivityProductWithType:(NSString *)tempType {
    //网络请求活动列表数据
    Manager *manager = [Manager shareInstance];
    [manager httpActivityProductListWithType:tempType withKeyword:@"" withPageIndex:1 withPageSize:@"8" withActivityListSuccess:^(id successResult) {
        
        [self.dataSourceDic setObject:[successResult objectForKey:@"content"] forKey:tempType];
        
        [self.bannerCollectionView reloadData];
        
    } withActivityFail:^(NSString *failResultStr) {
        
    }];
}

//请求活动厂家
- (void)httpActivityFactoryWithPageIndex:(NSInteger)tempPageIndex {
    //如果还不是最后一页，就可以进行请求下一页
    if (tempPageIndex < self.factoryTotalPageInt) {
        tempPageIndex++;
        
        Manager *manager = [Manager shareInstance];
        [manager httpActivityFactoryListWithPageIndex:tempPageIndex withPageSize:@"20" withFactoryListSuccess:^(id successResult) {
            NSLog(@"请求厂家成功");
            
            [self.factoryDataArr addObjectsFromArray:[successResult objectForKey:@"content"]];
            self.factoryPageInt = tempPageIndex;
            self.factoryTotalPageInt = [[successResult objectForKey:@"totalpages"] integerValue];
            
            [self.factoryTableView reloadData];
            
        } withFactoryListFail:^(NSString *failResultStr) {
            
        }];
        
    }else {
        NSLog(@"厂家已经是最后一页了");
    }
    
}

//网络请求销量
- (void)httpActivityTradeWithPageIndex:(NSInteger)tempPageIndex {
    //如果还不是最后一页，就可以进行请求下一页
    if (tempPageIndex < self.tradeTotalPageInt) {
        tempPageIndex++;
        
        Manager *manager = [Manager shareInstance];
        [manager httpActivityTradeListWithPageIndex:tempPageIndex withPageSize:@"20" withTradeListSuccess:^(id successResult) {
            NSLog(@"请求销量成功");
            [self.tradeDataArr addObjectsFromArray:[successResult objectForKey:@"content"]];
            self.tradePageInt = tempPageIndex;
            self.tradeTotalPageInt = [[successResult objectForKey:@"totalpages"] integerValue];
            
            [self.tradeTableView reloadData];
        } withTradeListFail:^(NSString *failResultStr) {
            
        }];
        
        
    }else {
        NSLog(@"销量已经是最后一页了");
    }
}


#pragma mark - 懒加载 -
- (NSMutableDictionary *)dataSourceDic {
    if (_dataSourceDic == nil) {
        self.dataSourceDic = [NSMutableDictionary dictionary];
    }
    return _dataSourceDic;
}
- (NSMutableArray *)factoryDataArr {
    if (_factoryDataArr == nil) {
        self.factoryDataArr = [NSMutableArray array];
    }
    return _factoryDataArr;
}

- (NSMutableArray *)tradeDataArr {
    if (_tradeDataArr == nil) {
        self.tradeDataArr = [NSMutableArray array];
    }
    return _tradeDataArr;
}

//厂家TableView懒加载
- (UITableView *)factoryTableView {
    if (_factoryTableView == nil) {
        //厂家collectionCell
        BannerCellThreeCollectionViewCell *threeCell = (BannerCellThreeCollectionViewCell *)[self.bannerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1+self.keyArr.count]];
        //
        if (![threeCell.subviews[0] isKindOfClass:[NSNull class]]) {
            if ([threeCell.subviews[0].subviews[0] isKindOfClass:[UITableView class]]) {

                //厂家的tableView
                self.factoryTableView = threeCell.subviews[0].subviews[0];
            }
        }
    }
    return _factoryTableView;
}

//销量TableView懒加载
- (UITableView *)tradeTableView {
    if (_tradeTableView == nil) {
        //销量collectionCell
        BannerCellFourCollectionViewCell *fourCell = (BannerCellFourCollectionViewCell *)[self.bannerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1+self.keyArr.count + 1]];
        
        if (![fourCell.subviews[0] isKindOfClass:[NSNull class]]) {
            if ([fourCell.subviews[0].subviews[0] isKindOfClass:[UITableView class]]) {

                //销量的tableView
                self.tradeTableView = fourCell.subviews[0].subviews[0];
            }
        }
    }
    return _tradeTableView;
}


#pragma mark - collectionView -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1 + self.keyArr.count + 2 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0 || section == self.keyArr.count+1 || section == self.keyArr.count+2) {
        return 1;
    }else {
        //
        NSMutableArray *dataSorceArr = [self.dataSourceDic objectForKey:self.keyArr[section-1]];
        return dataSorceArr.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return CGSizeMake(kScreenW, 0);
    }else{
        
        return CGSizeMake(kScreenW, 65);
    }
}

    
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenW, kScreenW/36*29 + 46); //46是搜索栏
    }else if (indexPath.section == self.keyArr.count + 1){
        //参与厂家
        return CGSizeMake(kScreenW, 300);
    }else if(indexPath.section == self.keyArr.count + 2){
        //交易记录
        return CGSizeMake(kScreenW, 210);

    }else{
        return CGSizeMake((kScreenW-30)/2, (kScreenW-30)/2+117);
        
    }
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        BannerShopCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"bannerShopHeadView" forIndexPath:indexPath];
        
        [headerView updateBannerHeadViewWithTempSection:indexPath.section withTotalSection:1 + self.keyArr.count + 2];
        
        //更多按钮
        headerView.moreButtonBlock = ^(NSInteger btnIndex) {
            NSLog(@"%ld",btnIndex);
            [self performSegueWithIdentifier:@"bannerShopToSaleList" sender:@[@"more",self.keyArr[btnIndex]]];
        };
        
        return headerView;
    }
    return 0;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //banner
        BannerCellOneCollectionViewCell *bannerOneCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bannerCellOne" forIndexPath:indexPath];
        [bannerOneCell updateBannerCellWithImageUrl:self.activityBannerImgStr];
        bannerOneCell.searchBlock = ^(NSString *searchStr) {
            NSLog(@"%@",searchStr);
            //进行搜索
            [self performSegueWithIdentifier:@"bannerShopToSaleList" sender:@[@"search",searchStr]];
            
            
        };
        return bannerOneCell;
        
    }else if (indexPath.section == self.keyArr.count + 1){
        //厂家
        BannerCellThreeCollectionViewCell *bannerThreeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bannerShopCellThree" forIndexPath:indexPath];

        return bannerThreeCell;

    }else if(indexPath.section == self.keyArr.count + 2){
        //销量cell
        BannerCellFourCollectionViewCell *bannerFourCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bannerShopCellFour" forIndexPath:indexPath];
        
        return bannerFourCell;
        
    }else {
        //产品cell
        BannerCellTwoCollectionViewCell *bannerTwoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bannerShopCellTwo" forIndexPath:indexPath];
        
        NSMutableArray *dataSorceArr = [self.dataSourceDic objectForKey:self.keyArr[indexPath.section-1]];
        ActivityProductModel *tempModel = dataSorceArr[indexPath.row];
        
//        if (indexPath.row == 0) {
//            tempModel.s_activity_id = @"0";
//        }
        
        [bannerTwoCell updateBannerShopTwoCellWithActivityModel:tempModel];
        
        return bannerTwoCell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section != 0 && indexPath.section != self.keyArr.count + 1 && indexPath.section != self.keyArr.count + 2) {
        //产品的
        NSMutableArray *dataSorceArr = [self.dataSourceDic objectForKey:self.keyArr[indexPath.section-1]];
        ActivityProductModel *tempModel = dataSorceArr[indexPath.row];
        
        [self performSegueWithIdentifier:@"saleShopToDetailVC" sender:tempModel];
        
    }
    
}


#pragma mark - TableView Delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 510) {
        //参与厂家
        return self.factoryDataArr.count;
    }else {
        //交易记录
        return self.tradeDataArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 510) {
        //参与厂家
        return 30;
    }else {
        //交易记录
        return 35;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 511) {
        //交易记录
        return 40;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 511) {
        //返回值就是区页眉。那么我们就让他返回headViewCell
        UITableViewCell *headViewCell = [tableView dequeueReusableCellWithIdentifier:@"factoryHeadView"];
        
        return headViewCell;
    }
    
    return 0;
    
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 510) {
        //参与厂家
        UITableViewCell *fCell = [tableView dequeueReusableCellWithIdentifier:@"factoryTableCell" forIndexPath:indexPath];
        fCell.textLabel.text = [NSString stringWithFormat:@"%@", [self.factoryDataArr[indexPath.row] objectForKey:@"p_factory_name"]];
        return fCell;
    }else {
        //交易记录
        BannerTradeModel *bannerModel = self.tradeDataArr[indexPath.row];
        TradeTableViewCell *tCell = [tableView dequeueReusableCellWithIdentifier:@"tradeTableCell" forIndexPath:indexPath];
        [tCell updateTradeCellWithTradeModel:bannerModel];

        return tCell;
    }
}





#pragma mark - 定时器 -
- (void)timerAction:(NSTimer *)timer {

    if (self.factoryTableView != nil) {
        self.tempFactoryIndex++;
        
//        NSLog(@"开始滚动厂家 %ld",self.tempFactoryIndex);
        //厂家滚动
        if (self.tempFactoryIndex < self.factoryDataArr.count) {
            [self.factoryTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.tempFactoryIndex inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
        }
        if (self.tempFactoryIndex == self.factoryDataArr.count) {
            self.tempFactoryIndex = 9;
            [self.factoryTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.tempFactoryIndex inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:NO];
        }
        
        //如果还剩5条数据，就可以进行请求下一页了
        if (self.tempFactoryIndex == self.factoryDataArr.count-5) {
            [self httpActivityFactoryWithPageIndex:self.factoryPageInt];
        }
        
    }
    

    
    if (self.tradeTableView != nil) {
        self.tempTradeIndex++;
        //销量滚动
        if (self.tempTradeIndex < self.tradeDataArr.count) {
            [self.tradeTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.tempTradeIndex inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
        }
        if (self.tempTradeIndex == self.tradeDataArr.count) {
            self.tempTradeIndex = 4;
            [self.tradeTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.tempTradeIndex inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:NO];
        }
        //如果还剩5条数据，就可以进行请求下一页了
        if (self.tempTradeIndex == self.tradeDataArr.count-5) {
            [self httpActivityTradeWithPageIndex:self.tradePageInt];

        }
    }
    
  
}

#pragma mark - 底部八个按钮 -
- (IBAction)bottonOneAction:(UIButton *)sender {
    
    [self collectionScrollToSection:1];
}

- (IBAction)bottonTwoAction:(UIButton *)sender {
    [self collectionScrollToSection:2];

}

- (IBAction)bottonThreeAction:(UIButton *)sender {
    [self collectionScrollToSection:3];

}

- (IBAction)bottonFourAction:(UIButton *)sender {
    [self collectionScrollToSection:4];

}

- (IBAction)bottonFiveAction:(UIButton *)sender {
    [self collectionScrollToSection:5];

}

- (IBAction)bottonSixAction:(UIButton *)sender {
    [self collectionScrollToSection:6];

}

- (IBAction)bottonSevenAction:(UIButton *)sender {
    [self collectionScrollToSection:7];

}

- (IBAction)bottonEightAction:(UIButton *)sender {
    [self.bannerCollectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}


- (void)collectionScrollToSection:(NSInteger)sectionInt{
    // scroll to selected index
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:0 inSection:sectionInt];
    UICollectionViewLayoutAttributes* attr = [self.bannerCollectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:cellIndexPath];
    
    CGRect rect = CGRectMake(attr.frame.origin.x, attr.frame.origin.y-64, self.bannerCollectionView.frame.size.width, self.bannerCollectionView.frame.size.height);
    
    [self.bannerCollectionView scrollRectToVisible:rect animated:YES];
}

#pragma mark - 头部隐藏 -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    Manager *manager = [Manager shareInstance];
    
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        
        CGFloat yOffset  = scrollView.contentOffset.y;

        [self.navigationController setNavigationBarHidden:NO animated:NO];
        CGFloat alpha=yOffset/80.0f>1.0f?1:yOffset/80.0f;
//        NSLog(@"%f",alpha);
        //改变navigation的背景色
        [self.navigationController.navigationBar setBackgroundImage:[manager getImageWithAlpha:alpha] forBarMetrics:UIBarMetricsDefault];
        //改变通知按钮的颜色
        if (alpha>0.6) {
            self.navigationItem.rightBarButtonItem.tintColor = kColor(57, 209, 103, 1);
            [manager isClearNavigationBarLine:NO withNavigationController:self.navigationController];
            
           

            
        }else{
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
            [manager isClearNavigationBarLine:YES withNavigationController:self.navigationController];
            
           
            
        }
        NSLog(@"+++++%f",yOffset);
        //显示或者隐藏导航栏上的输入框
        if (yOffset > kScreenW/36*29 + 20 - 64) {
            //导航栏上的搜索框显示
            self.navigationItem.titleView = self.searchView;
            self.searchBar.frame = CGRectMake(0, 0, self.searchView.bounds.size.width, 44);
        }else {
            //导航栏上的搜索框隐藏
            self.navigationItem.titleView = nil;

        }
        
        
        //隐藏键盘
        if ([[self.bannerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]] isKindOfClass:[BannerCellOneCollectionViewCell class]]) {
            BannerCellOneCollectionViewCell *tempCell = (BannerCellOneCollectionViewCell *)[self.bannerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            [tempCell.searchTextField resignFirstResponder];
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
    
    if ([segue.identifier isEqualToString:@"bannerShopToSaleList"]) {
        SaleProductListViewController *saleProductListVC = [segue destinationViewController];
        //搜索
//        if ([sender[0] isEqualToString:@"search"]) {
            saleProductListVC.showType = sender[0];
            saleProductListVC.tempKeyword = sender[1];
            
//        }
        
        
    }
    
    if ([segue.identifier isEqualToString:@"saleShopToDetailVC"]) {
        ProductDetailViewController *productDetailVC = [segue destinationViewController];
        
        ActivityProductModel *saleListModel = (ActivityProductModel *)sender;

        productDetailVC.productID = saleListModel.d_p_id;
        productDetailVC.type = @"pid";
        
    }
}


@end
