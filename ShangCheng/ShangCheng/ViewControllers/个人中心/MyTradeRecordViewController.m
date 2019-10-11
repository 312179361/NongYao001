//
//  MyTradeRecordViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/8.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyTradeRecordViewController.h"
#import "TradeRecordTableViewCell.h"
#import "Manager.h"
#import "KongImageView.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
@interface MyTradeRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
//当前有页数
@property (nonatomic,assign)NSInteger currentPage;
//总共的页数
@property (nonatomic,assign)NSInteger totalPage;


@property (weak, nonatomic) IBOutlet UITableView *tradeRecordtableView;
@property (nonatomic,strong)KongImageView *kongImageView;

@end

@implementation MyTradeRecordViewController

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
    //注册cell
    [self.tradeRecordtableView registerNib:[UINib nibWithNibName:@"TradeRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"tradeRecordCell"];
    
    
    //加载空白页
    self.kongImageView = [[[NSBundle mainBundle] loadNibNamed:@"KongImageView" owner:self options:nil] firstObject];
    [self.kongImageView.reloadAgainButton addTarget:self action:@selector(reloadAgainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.kongImageView.frame = self.tradeRecordtableView.bounds;
    [self.tradeRecordtableView addSubview:self.kongImageView];
    
    

    //下拉刷新
    [self downPushRefresh];
    //上啦加载
    [self upPushReload];
    //执行一次刷新
    [self.tradeRecordtableView headerBeginRefreshing];

}


//重新加载按钮
- (void)reloadAgainButtonAction:(IndexButton *)sender {
    [self.tradeRecordtableView headerBeginRefreshing];
}


//下拉刷新
- (void)downPushRefresh {
    [self.tradeRecordtableView addHeaderWithCallback:^{
        [self httpReloadDataWithPageIndex:1];
    }];
}

//上拉加载
- (void)upPushReload {
    [self.tradeRecordtableView addFooterWithCallback:^{
        //当前页小于总页数，可以进行加载
        if (self.currentPage < self.totalPage) {
            [self httpReloadDataWithPageIndex:self.currentPage+1];

        }else {
            [self.tradeRecordtableView footerEndRefreshing];

        }
    }];
}

- (void)httpReloadDataWithPageIndex:(NSInteger )pageIndex {
    Manager *manager = [Manager shareInstance];
    if (self.isCash == YES) {
        self.title = @"提现记录";
        if (pageIndex == 1 && [SVProgressHUD isVisible] == NO) {
            [SVProgressHUD show];
        }
        NSString *userTypeStr = @"2";
        if ([manager.memberInfoModel.u_type isEqualToString:@"1"]) {
            userTypeStr = @"1";
        }
        //单纯的体现记录
        [manager httpSearchUserAgentCashListWithUserId:manager.memberInfoModel.u_id withUserType:userTypeStr withPageIndex:pageIndex withPageSize:10 withSearchSuccess:^(id successResult) {
            
            //得到总页数
            self.totalPage = [successResult integerValue];
            //如果是下拉刷新，将currentpage重置为1
            if (pageIndex == 1) {
                [SVProgressHUD dismiss];
                self.currentPage = 1;
                //取消效果
                [self.tradeRecordtableView headerEndRefreshing];
                
                //查看是否空白页
                [self isShowKongImageViewWithType:KongTypeWithKongData withKongMsg:[NSString stringWithFormat:@"暂时没有%@",self.title]];
                
            }else {
                //如果是加载，那么更新currentpage
                self.currentPage = pageIndex;
                //取消效果
                [self.tradeRecordtableView footerEndRefreshing];
                
            }


            [self.tradeRecordtableView reloadData];
            
        } withSearchFail:^(NSString *failResultStr) {
            [SVProgressHUD dismiss];
            
            [self.tradeRecordtableView headerEndRefreshing];
            [self.tradeRecordtableView footerEndRefreshing];

            //是否显示空白页
            [self isShowKongImageViewWithType:KongTypeWithNetError withKongMsg:@"网络错误"];
            
        }];
        
    }else {
        self.title = @"交易记录";
        if (pageIndex == 1 && [SVProgressHUD isVisible] == NO) {
            [SVProgressHUD show];
        }

        //交易记录
        [manager httpSearchUserAccountListWithUserId:manager.memberInfoModel.u_id withSdt:@"" withEdt:@"" withPageIndex:pageIndex withPageSize:10 withSearchSuccess:^(id successResult) {
            [SVProgressHUD dismiss];
            //得到总页数
            self.totalPage = [successResult integerValue];
            //如果是下拉刷新，将currentpage重置为1
            if (pageIndex == 1) {
                self.currentPage = 1;
                //取消效果
                [self.tradeRecordtableView headerEndRefreshing];
                
                //查看是否空白页
                [self isShowKongImageViewWithType:KongTypeWithKongData withKongMsg:[NSString stringWithFormat:@"暂时没有%@",self.title]];
                
            }else {
                //如果是加载，那么更新currentpage
                self.currentPage = pageIndex;
                //取消效果
                [self.tradeRecordtableView footerEndRefreshing];
                
            }
            
            
            [self.tradeRecordtableView reloadData];
            
            
        } withSearchFail:^(NSString *failResultStr) {
            [SVProgressHUD dismiss];
            //是否显示空白页
            [self.tradeRecordtableView headerEndRefreshing];
            [self.tradeRecordtableView footerEndRefreshing];
            
            //是否显示空白页
            [self isShowKongImageViewWithType:KongTypeWithNetError withKongMsg:@"网络错误"];
        
        }];
        
    }

}




#pragma mark - TableView Delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    Manager *manager = [Manager shareInstance];
    if (self.isCash == YES) {
        //提现
        return manager.cashDateKeyArr.count;

    }else {
        return manager.tradeDateKeyArr.count;

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 37;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Manager *manager = [Manager shareInstance];
    NSString *keyStr;
    if (self.isCash == YES) {
        //提现
        keyStr =  manager.cashDateKeyArr[section];
    }else {
        //交易
        keyStr =  manager.tradeDateKeyArr[section];
    }

    return keyStr;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Manager *manager = [Manager shareInstance];
    if (self.isCash == YES) {
        NSString *keyStr1 = manager.cashDateKeyArr[section];
        NSMutableArray *valusArr1 = [manager.cashDetailDic objectForKey:keyStr1];
        return valusArr1.count;

    }else {
        NSString *keyStr2 =  manager.tradeDateKeyArr[section];
        NSMutableArray *valusArr2 = [manager.tradeDetailDic objectForKey:keyStr2];
        return valusArr2.count;

    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TradeRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tradeRecordCell" forIndexPath:indexPath];
    Manager *manager = [Manager shareInstance];
    
    if (self.isCash == YES) {
        //提现记录
        NSString *keyStr =  manager.cashDateKeyArr[indexPath.section];
        NSMutableArray *valusArr = [manager.cashDetailDic objectForKey:keyStr];
        MyAgentCashModel *tempModel = valusArr[indexPath.row];
        
        [cell updateCashRecordCellWithModel:tempModel];
        
        return cell;

        
    }else {
        NSString *keyStr =  manager.tradeDateKeyArr[indexPath.section];
        NSMutableArray *valusArr = [manager.tradeDetailDic objectForKey:keyStr];
        MyTradeRecordModel *tempModel = valusArr[indexPath.row];
        
        [cell updateTradeRecordCellWithModel:tempModel];
        
        return cell;

    }
    
    
    
}

//空白页
- (void)isShowKongImageViewWithType:(KongType )kongType withKongMsg:(NSString *)msg {
    
    Manager *manager = [Manager shareInstance];
    if (self.isCash == YES) {
        //提现

        if (manager.cashDateKeyArr.count == 0 ) {
            [self.kongImageView showKongViewWithKongMsg:msg withKongType:kongType];
            
        }else {
            [self.kongImageView hiddenKongView];
            
        }

        
    }else {

        if (manager.tradeDateKeyArr.count == 0 ) {
            [self.kongImageView showKongViewWithKongMsg:msg withKongType:kongType];
            
        }else {
            [self.kongImageView hiddenKongView];
            
        }

        
    }

    
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
