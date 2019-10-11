//
//  PestsListViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/6.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "PestsListViewController.h"
#import "PestsListTableViewCell.h"
#import "MJRefresh.h"
#import "Manager.h"
#import "SearchBarButton.h"
#import "WebPageTwoViewController.h"
#import "KongImageView.h"
#import "SVProgressHUD.h"
@interface PestsListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)KongImageView *kongImageView;
@property (weak, nonatomic) IBOutlet UITableView *pestsListTableView;
@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,assign)NSInteger totalPage;
@end

@implementation PestsListViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.showTitleStr;
    //加载空白页
    self.kongImageView = [[[NSBundle mainBundle] loadNibNamed:@"KongImageView" owner:self options:nil] firstObject];
    [self.kongImageView.reloadAgainButton addTarget:self action:@selector(reloadAgainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.kongImageView.frame = self.view.bounds;
    [self.view addSubview:self.kongImageView];

    Manager *manager = [Manager shareInstance];
    //清空数据
    manager.searchPestsDataSourceArr = nil;

    //加载下拉和上啦
    [self downRefreshAction];
    [self upLoadDataAction];
    //首次进入刷新数据
    [self.pestsListTableView headerBeginRefreshing];

    
    
}

//重新加载
- (void)reloadAgainButtonAction:(IndexButton *)sender {
    //执行一次下拉刷新
    [self.pestsListTableView headerBeginRefreshing];
}

//下拉刷新
- (void)downRefreshAction {
    [self.pestsListTableView addHeaderWithCallback:^{
        //如果是搜索
        if (self.pestsIsSearchOrType == SearchPests) {
            [self httpSearchDataWithPageIndex:1];
        }
        
        //如果是分类
        if (self.pestsIsSearchOrType == TypePests) {
            [self httpTypeDataWithPageIndex:1];
        }
        
    }];
}

//上拉加载
- (void)upLoadDataAction {
    [self.pestsListTableView addFooterWithCallback:^{
        //如果是搜索
        if (self.pestsIsSearchOrType == SearchPests) {
            //当前页小于总页数，可以进行加载
            if (self.currentPage < self.totalPage) {
//                [self httpSearchDataWithPageIndex:self.currentPage+1];
            }else {
                [self.pestsListTableView footerEndRefreshing];
            }
            
        }
        //如果是分类
        if (self.pestsIsSearchOrType == TypePests) {
            
            //当前页小于总页数，可以进行加载
            if (self.currentPage < self.totalPage) {
                [self httpTypeDataWithPageIndex:self.currentPage+1];
            }else {
                [self.pestsListTableView footerEndRefreshing];
            }
            
        }
        
        
    }];
}

#pragma mark - 网络请求 -
//搜索病虫害 网络请求数据
- (void)httpSearchDataWithPageIndex:(NSInteger )pageIndex {
    
    Manager *manager = [Manager shareInstance];
    
    if ([SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];
    }

    [manager searchActionWithKeyword:self.tempKeyword withType:@"病虫害" withSort:@"" withDesc:@"1" withPageindex:pageIndex withSearchSuccess:^(id successResult) {
        [SVProgressHUD dismiss];//风火轮消失
        //请求成功，得到总页数
        self.totalPage = [successResult integerValue];
        //如果是下拉刷新，将currentpage重置为1
        if (pageIndex == 1) {
            self.currentPage = 1;
            //取消效果
            [self.pestsListTableView headerEndRefreshing];
            [self isShowKongImageViewWithType:KongTypeWithSearchKong withKongMsg:@"暂无搜索数据"];
        }else {
            [SVProgressHUD dismiss];//风火轮消失
            //如果是加载，那么更新currentpage
            self.currentPage = pageIndex;
            //取消效果
            
            [self.pestsListTableView footerEndRefreshing];
            
        }
        [self.pestsListTableView reloadData];
        
        
    } withSearchFail:^(NSString *failResultStr) {
        [self.pestsListTableView headerEndRefreshing];
        [self.pestsListTableView footerEndRefreshing];
        [self isShowKongImageViewWithType:KongTypeWithNetError withKongMsg:@"网络错误"];

    }];
    
}



//分类的 网络请求数据
- (void)httpTypeDataWithPageIndex:(NSInteger )pageIndex {
    Manager *manager = [Manager shareInstance];
    if ([SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];
    }

    [manager httpPestsTypeWithCode:self.tempCode withPageIndex:pageIndex withTypeSuccess:^(id successResult) {
        [SVProgressHUD dismiss];//风火轮消失
        //请求成功，得到总页数
        self.totalPage = [successResult integerValue];
        //如果是下拉刷新，将currentpage重置为1
        if (pageIndex == 1) {
            self.currentPage = 1;
            //取消效果
            [self.pestsListTableView headerEndRefreshing];
            [self isShowKongImageViewWithType:KongTypeWithKongData withKongMsg:@"暂无病虫害数据"];
            
        }else {
            [SVProgressHUD dismiss];//风火轮消失
            //如果是加载，那么更新currentpage
            self.currentPage = pageIndex;
            //取消效果
            
            [self.pestsListTableView footerEndRefreshing];
            
        }
        [self.pestsListTableView reloadData];

    } withTypeFail:^(NSString *failResultStr) {
        [self.pestsListTableView headerEndRefreshing];
        [self.pestsListTableView footerEndRefreshing];
        [self isShowKongImageViewWithType:KongTypeWithNetError withKongMsg:@"网络错误"];

    }];
    
    
}


#pragma mark - tableView delegate -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    Manager *manager = [Manager shareInstance];
    
    return manager.searchPestsDataSourceArr.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PestsListTableViewCell *pestsCell = [tableView dequeueReusableCellWithIdentifier:@"pestsListCell" forIndexPath:indexPath];
    Manager *manager = [Manager shareInstance];
    PestsListModel *searchListModel = manager.searchPestsDataSourceArr[indexPath.section];
    [pestsCell updatePestsListCellWithModel:searchListModel];
    
    return pestsCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];
    PestsListModel *searchListModel = manager.searchPestsDataSourceArr[indexPath.section];
    NSLog(@"%@--%@",searchListModel.i_title,searchListModel.i_source_url);
    [self performSegueWithIdentifier:@"pestsListToWebViewVC" sender:searchListModel];
}

//空白页
- (void)isShowKongImageViewWithType:(KongType )kongType withKongMsg:(NSString *)msg {
    Manager *manager = [Manager shareInstance];
    if (manager.searchPestsDataSourceArr.count > 0) {
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
    
    if ([segue.identifier isEqualToString:@"pestsListToWebViewVC"]) {
        PestsListModel *tempModel = (PestsListModel *)sender;
        WebPageTwoViewController *webTwoPageVC = [segue destinationViewController];
        webTwoPageVC.tempTitleStr = tempModel.i_title;
        webTwoPageVC.tempId = tempModel.i_id;
    }
}


@end
