//
//  MyAgentDetailViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/12/5.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyAgentDetailViewController.h"
#import "Manager.h"
#import "MyAgentPeopleTableViewCell.h"
#import "MyAgentOrderTableViewCell.h"
#import "MyAgentCommissionTableViewCell.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
@interface MyAgentDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myAgentDetailTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headButtonHeightLayout;
@property (weak, nonatomic) IBOutlet UIView *headButtonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeadLayout;//TableView距离上面的高度

@property (weak, nonatomic) IBOutlet UIButton *systemNewButton;
@property (weak, nonatomic) IBOutlet UIButton *systemOldButton;
@property (weak, nonatomic) IBOutlet UIView *systemNewLine;
@property (weak, nonatomic) IBOutlet UIView *systemOldLine;


//数据源
@property(nonatomic,assign)BOOL isNew;
@property(nonatomic,strong)NSMutableArray *dataSourceArr;
@property(nonatomic,strong)NSMutableArray *dataSourceArrOld;

@property(nonatomic,assign)NSInteger currentPageindex;//现在是第几页（新的）
@property(nonatomic,assign)NSInteger totalPageindex;//一共有几页（新的）


@property(nonatomic,assign)NSInteger currentPageindexOld;//现在是第几页（老的）
@property(nonatomic,assign)NSInteger totalPageindexOld;//一共有几页（老的）



@end

@implementation MyAgentDetailViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.myAgentType == PeopleOrder || self.myAgentType == Commission) {
        self.headButtonView.hidden = NO;
        self.headButtonHeightLayout.constant = 52;
        self.tableViewHeadLayout.constant = 12;
    }else {
        self.headButtonView.hidden = YES;
        self.headButtonHeightLayout.constant = 0;
        self.tableViewHeadLayout.constant = 0;
    }
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 让cell自适应高度
    self.myAgentDetailTableView.rowHeight = UITableViewAutomaticDimension;
    //设置估算高度
    self.myAgentDetailTableView.estimatedRowHeight = 44;
    
    self.isNew = YES;//默认是新的
    self.currentPageindex = 1;
    self.totalPageindex = NSIntegerMax;
    
    self.currentPageindexOld = 1;
    self.totalPageindexOld = NSIntegerMax;

    //网络请求数据
    switch (self.myAgentType) {
        case MyPeople:
            //我的客户
            self.title = @"我的客户";
            break;
        case PeopleOrder:
            //客户订单
            self.title = @"客户订单";
            break;
        case PeopleFavorite:
            //客户收藏
            self.title = @"客户收藏";
            break;
        case PeopleShopCar:
            //客户购物车
            self.title = @"客户购物车";
            break;
        case Commission:
            //提成流水
            self.title = @"提成流水";
        default:
            break;
    }
    
    
    //添加下拉刷新和上拉加载
    [self upPushRefresh];
    [self downPushLoad];
    
    //网络请求
    [self httpMyActionWithPageindex:1];
    
    
}


#pragma mark - 下拉和上拉 -
- (void)upPushRefresh {
    [self.myAgentDetailTableView addHeaderWithCallback:^{
        [self httpMyActionWithPageindex:1];

    }];
}

- (void)downPushLoad {
    [self.myAgentDetailTableView addFooterWithCallback:^{
        if (self.isNew == YES) {
            //新数据
            if (self.currentPageindex < self.totalPageindex) {
                //说明还有数据可以加载
                [self httpMyActionWithPageindex:self.currentPageindex+1];
            }else {
                //没有数据可以加载了
                [self.myAgentDetailTableView footerEndRefreshing];
            }
        }else {
            //老数据
            if (self.currentPageindexOld < self.totalPageindexOld) {
                //说明还有数据可以加载
                [self httpMyActionWithPageindex:self.currentPageindexOld+1];
            }else {
                //没有数据可以加载了
                [self.myAgentDetailTableView footerEndRefreshing];
            }
            
        }
    }];
}

#pragma mark - 头部两个按钮 切换新老系统 -
- (IBAction)newSystemButtonAction:(UIButton *)sender {
    self.isNew = YES;
    //如果没有数据就请求数据
    if (_dataSourceArr == nil) {
        if (self.myAgentType == PeopleOrder) {
            //订单
            [self httpMyAgentOrderWithIsNew:self.isNew withPageIndex:1];
        }
        if (self.myAgentType == Commission) {
            //提成流水
            [self httpMyAgentCommissionWithIsNew:self.isNew withPageIndex:1];
        }
    }else {
        //如果有数据，就不用请求，直接刷新
        [self.myAgentDetailTableView reloadData];
    }
    //button效果
    [self updateButtonUIWithIsNew:YES];
}

- (IBAction)oldSystemButtonAction:(UIButton *)sender {
    self.isNew = NO;
    if (_dataSourceArrOld == nil) {
        if (self.myAgentType == PeopleOrder) {
            //订单
            [self httpMyAgentOrderWithIsNew:self.isNew withPageIndex:1];
        }
        if (self.myAgentType == Commission) {
            //提成流水
            [self httpMyAgentCommissionWithIsNew:self.isNew withPageIndex:1];
        }
        
    }else {
        //如果有数据，就不用请求，直接刷新
        [self.myAgentDetailTableView reloadData];
    }
    //button效果
    [self updateButtonUIWithIsNew:NO];
}

- (void)updateButtonUIWithIsNew:(BOOL)isNew {
    if (isNew == YES) {
        [self.systemNewButton setTitleColor:kMainColor forState:UIControlStateNormal];
        self.systemNewLine.backgroundColor = kMainColor;
        [self.systemOldButton setTitleColor:k333333Color forState:UIControlStateNormal];
        self.systemOldLine.backgroundColor = [UIColor whiteColor];
    }else {
        [self.systemOldButton setTitleColor:kMainColor forState:UIControlStateNormal];
        self.systemOldLine.backgroundColor = kMainColor;
        [self.systemNewButton setTitleColor:k333333Color forState:UIControlStateNormal];
        self.systemNewLine.backgroundColor = [UIColor whiteColor];
    }
    
    
}


#pragma mark - 网络请求 -
- (NSMutableArray *)dataSourceArr  {
    if (_dataSourceArr == nil) {
        self.dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

- (NSMutableArray *)dataSourceArrOld  {
    if (_dataSourceArrOld == nil) {
        self.dataSourceArrOld = [NSMutableArray array];
    }
    return _dataSourceArrOld;
}

//网络请求各个数据
- (void)httpMyActionWithPageindex:(NSInteger)pageIndex {
    //添加风火轮
    if ([SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];

    }
    //网络请求数据
    switch (self.myAgentType) {
        case MyPeople:
            //我的客户
            [self httpMyAgentPeopleWithPageIndex:pageIndex];
            break;
        case PeopleOrder:
            //客户订单
            [self httpMyAgentOrderWithIsNew:self.isNew withPageIndex:pageIndex];
            break;
        case PeopleFavorite:
            //客户收藏
            [self httpMyAgentPeopleFavoriteWithPageIndex:pageIndex];
            break;
        case PeopleShopCar:
            //客户购物车
            [self httpMyAgentPeopleShopCarWithPageIndex:pageIndex];
            break;
        case Commission:
            //提成流水
            [self httpMyAgentCommissionWithIsNew:self.isNew withPageIndex:pageIndex];
        default:
            break;
    }
}

//请求我的客户
- (void)httpMyAgentPeopleWithPageIndex:(NSInteger)pageIndex {
    Manager *manager = [Manager shareInstance];
    [manager httpMyAgentPeopleListDataWithUserId:manager.memberInfoModel.u_id withPageindex:pageIndex withMyAgentSuccess:^(id successResult) {
        [SVProgressHUD dismiss];

        if (pageIndex == 1) {
            //刷新
            self.dataSourceArr = nil;
            self.dataSourceArr = [successResult objectForKey:@"content"];
            
        }else {

            //加载
            [self.dataSourceArr addObjectsFromArray:[successResult objectForKey:@"content"]];
        }
        
        //记录一下最大页码 和当前页码
        self.totalPageindex = [[successResult objectForKey:@"totalpages"] integerValue];
        self.currentPageindex = pageIndex;
        //刷新UI
        [self.myAgentDetailTableView headerEndRefreshing];
        [self.myAgentDetailTableView footerEndRefreshing];
        [self.myAgentDetailTableView reloadData];
        
    } withMyagentFail:^(NSString *failResultStr) {
        [SVProgressHUD dismiss];
        [self.myAgentDetailTableView headerEndRefreshing];
        [self.myAgentDetailTableView footerEndRefreshing];
    }];
}


//请求客户订单
- (void)httpMyAgentOrderWithIsNew:(BOOL)isNew withPageIndex:(NSInteger)pageIndex{
    Manager *manager = [Manager shareInstance];
    [manager httpMyAgentOrderListDataWithIsNew:isNew withUserId:manager.memberInfoModel.u_id withPageindex:pageIndex withMyAgentSuccess:^(id successResult) {
        [SVProgressHUD dismiss];

        if (pageIndex == 1) {
            //刷新
            if (isNew == YES) {
                self.dataSourceArr = nil;
                self.dataSourceArr = [successResult objectForKey:@"content"];
            }else {
                self.dataSourceArrOld = nil;
                self.dataSourceArrOld = [successResult objectForKey:@"content"];
            }
            
        }else {
            //加载
            if (isNew == YES) {
                [self.dataSourceArr addObjectsFromArray:[successResult objectForKey:@"content"]];
            }else {
                [self.dataSourceArrOld addObjectsFromArray:[successResult objectForKey:@"content"]];
            }
        }
        
        if (isNew == YES) {
            //记录一下最大页码 和当前页码
            self.totalPageindex = [[successResult objectForKey:@"totalpages"] integerValue];
            self.currentPageindex = pageIndex;
        }else {
            //记录一下最大页码 和当前页码
            self.totalPageindexOld = [[successResult objectForKey:@"totalpages"] integerValue];
            self.currentPageindexOld = pageIndex;
        }
        
        //刷新UI
        [self.myAgentDetailTableView headerEndRefreshing];
        [self.myAgentDetailTableView footerEndRefreshing];
        [self.myAgentDetailTableView reloadData];
        
    } withMyagentFail:^(NSString *failResultStr) {
        [SVProgressHUD dismiss];

        [self.myAgentDetailTableView headerEndRefreshing];
        [self.myAgentDetailTableView footerEndRefreshing];
    }];
}

//请求客户收藏
- (void)httpMyAgentPeopleFavoriteWithPageIndex:(NSInteger)pageIndex {
    Manager *manager = [Manager shareInstance];
    [manager httpMyAgentPeopleFavoriteWithUserId:manager.memberInfoModel.u_id withPageIndex:pageIndex withPeopleFavoriteSuccess:^(id successResult) {
        [SVProgressHUD dismiss];

        if (pageIndex == 1) {
            //刷新
            self.dataSourceArr = nil;
            self.dataSourceArr = [successResult objectForKey:@"content"];
            
        }else {
            //加载
            [self.dataSourceArr addObjectsFromArray:[successResult objectForKey:@"content"]];
        }
        
        //记录一下最大页码 和当前页码
        self.totalPageindex = [[successResult objectForKey:@"totalpages"] integerValue];
        self.currentPageindex = pageIndex;
        //刷新UI
        [self.myAgentDetailTableView headerEndRefreshing];
        [self.myAgentDetailTableView footerEndRefreshing];
        [self.myAgentDetailTableView reloadData];
        
    } withPeopleFavoriteFail:^(NSString *failResultStr) {
        [SVProgressHUD dismiss];

        [self.myAgentDetailTableView headerEndRefreshing];
        [self.myAgentDetailTableView footerEndRefreshing];
    }];
    
}

//请求客户购物车
- (void)httpMyAgentPeopleShopCarWithPageIndex:(NSInteger)pageIndex {
    
    Manager *manager = [Manager shareInstance];
    [manager httpMyAgentPeopleShopCarWithUserId:manager.memberInfoModel.u_id withPageIndex:pageIndex withPeopleShopCarSuccess:^(id successResult) {
        [SVProgressHUD dismiss];

        if (pageIndex == 1) {
            //刷新
            self.dataSourceArr = nil;
            self.dataSourceArr = [successResult objectForKey:@"content"];
            
        }else {
            //加载
            [self.dataSourceArr addObjectsFromArray:[successResult objectForKey:@"content"]];
        }
        
        //记录一下最大页码 和当前页码
        self.totalPageindex = [[successResult objectForKey:@"totalpages"] integerValue];
        self.currentPageindex = pageIndex;
        //刷新UI
        [self.myAgentDetailTableView headerEndRefreshing];
        [self.myAgentDetailTableView footerEndRefreshing];
        [self.myAgentDetailTableView reloadData];
        
    } withPeopleShopCarFail:^(NSString *failResultStr) {
        [SVProgressHUD dismiss];

        [self.myAgentDetailTableView headerEndRefreshing];
        [self.myAgentDetailTableView footerEndRefreshing];
    }];
}


//请求提成流水
- (void)httpMyAgentCommissionWithIsNew:(BOOL)isNew withPageIndex:(NSInteger)pageIndex{
    Manager *manager = [Manager shareInstance];
    [manager httpMyAgentCommissionWithIsNew:isNew withUserId:manager.memberInfoModel.u_id withPageIndex:pageIndex withCommissionSuccess:^(id successResult) {
        if (pageIndex == 1) {
            //刷新
            if (isNew == YES) {
                self.dataSourceArr = nil;
                self.dataSourceArr = [successResult objectForKey:@"content"];
            }else {
                self.dataSourceArrOld = nil;
                self.dataSourceArrOld = [successResult objectForKey:@"content"];
            }
            
        }else {
            //加载
            if (isNew == YES) {
                [self.dataSourceArr addObjectsFromArray:[successResult objectForKey:@"content"]];
            }else {
                [self.dataSourceArrOld addObjectsFromArray:[successResult objectForKey:@"content"]];
            }
        }
        
        if (isNew == YES) {
            //记录一下最大页码 和当前页码
            self.totalPageindex = [[successResult objectForKey:@"totalpages"] integerValue];
            self.currentPageindex = pageIndex;
        }else {
            //记录一下最大页码 和当前页码
            self.totalPageindexOld = [[successResult objectForKey:@"totalpages"] integerValue];
            self.currentPageindexOld = pageIndex;
        }
        
        //刷新UI
        [self.myAgentDetailTableView headerEndRefreshing];
        [self.myAgentDetailTableView footerEndRefreshing];
        [self.myAgentDetailTableView reloadData];
        
    } withCommissionFail:^(NSString *failResultStr) {
        [SVProgressHUD dismiss];

        [self.myAgentDetailTableView headerEndRefreshing];
        [self.myAgentDetailTableView footerEndRefreshing];
    }];
    
}


#pragma mark - tableView delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isNew == YES) {
        return self.dataSourceArr.count;
    }else {
        return self.dataSourceArrOld.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.myAgentType) {
        case MyPeople:
        {
            //我的客户
            MyAgentPeopleTableViewCell *peopleCell = [tableView dequeueReusableCellWithIdentifier:@"myAgentPeopleCell" forIndexPath:indexPath];
            [peopleCell updateMyAgentPeopleCellWithAgentModel:self.dataSourceArr[indexPath.row]];
            
            return peopleCell;
        }
            break;
            
        case PeopleOrder:
        {
            //客户订单
            MyAgentOrderTableViewCell *orderCell = [tableView dequeueReusableCellWithIdentifier:@"myAgentOrderCell" forIndexPath:indexPath];
            if (self.isNew == YES) {
                [orderCell updateMyAgentOrderCellWithOrderModel:self.dataSourceArr[indexPath.row]];

            }else {
                [orderCell updateMyAgentOrderCellWithOrderModel:self.dataSourceArrOld[indexPath.row]];
            }
            return orderCell;
        }
            break;
            
        case PeopleFavorite:
        {
            //客户收藏
            MyAgentOrderTableViewCell *favoriteCell = [tableView dequeueReusableCellWithIdentifier:@"myAgentOrderCell" forIndexPath:indexPath];
            [favoriteCell updateMyAgentFavoriteCellWithFavoriteModel:self.dataSourceArr[indexPath.row]];
           
            return favoriteCell;
        }
            break;
        
        case PeopleShopCar:
        {
            //客户购物车
            MyAgentOrderTableViewCell *favoriteCell = [tableView dequeueReusableCellWithIdentifier:@"myAgentOrderCell" forIndexPath:indexPath];
            [favoriteCell updateMyAgentShopCarCellWithShopCarModel:self.dataSourceArr[indexPath.row]];
            
            return favoriteCell;
        }
            break;
        
        case Commission:
        {
            //提成流水
            MyAgentCommissionTableViewCell *commissionCell = [tableView dequeueReusableCellWithIdentifier:@"myAgentCommissionCell" forIndexPath:indexPath];
            if (self.isNew == YES) {
                [commissionCell updateMyAgentCommissionCellWithCommissionModel:self.dataSourceArr[indexPath.row] withIsNew:self.isNew];

            }else {
                [commissionCell updateMyAgentCommissionCellWithCommissionModel:self.dataSourceArrOld[indexPath.row] withIsNew:self.isNew];
            }

            return commissionCell;
            
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    return 0;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
