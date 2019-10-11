//
//  MyCommentListViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyCommentListViewController.h"
#import "MyCommentListTableViewCell.h"
#import "Manager.h"
#import "MJRefresh.h"
#import "KongImageView.h"
#import "SVProgressHUD.h"
@interface MyCommentListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myCommentListTabelView;
//当前有页数
@property (nonatomic,assign)NSInteger currentPage;
//总共的页数
@property (nonatomic,assign)NSInteger totalPage;

@property (nonatomic,strong)KongImageView *kongImageView;
@end

@implementation MyCommentListViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


//下拉刷新
- (void)downPushRefresh {
    [self.myCommentListTabelView addHeaderWithCallback:^{
        NSLog(@"下拉");
        [self httpMyCommentListDataWithPageIndex:1];
        
    }];
}

//上拉加载
- (void)upPushLoad {
    [self.myCommentListTabelView addFooterWithCallback:^{
        NSLog(@"上拉");
        //当前页小于总页数，可以进行加载
        if (self.currentPage < self.totalPage) {
            [self httpMyCommentListDataWithPageIndex:self.currentPage+1];
        }else {
            [self.myCommentListTabelView footerEndRefreshing];
        }
        
        
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [SVProgressHUD dismiss];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 让cell自适应高度
    self.myCommentListTabelView.rowHeight = UITableViewAutomaticDimension;
    //设置估算高度
    self.myCommentListTabelView.estimatedRowHeight = 44;
    
    //刚进来设置页数为1
    self.currentPage = 1;
    
    //加载下拉刷新
    [self downPushRefresh];
    //上拉加载
    [self upPushLoad];
    
    
    //首次进入执行一次下拉刷新
    [self.myCommentListTabelView headerBeginRefreshing];
    
    //加载空白页
    self.kongImageView = [[[NSBundle mainBundle] loadNibNamed:@"KongImageView" owner:self options:nil] firstObject];
    [self.kongImageView.reloadAgainButton addTarget:self action:@selector(reloadAgainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.kongImageView.frame = self.myCommentListTabelView.bounds;
    [self.myCommentListTabelView addSubview:self.kongImageView];

    
}

//重新加载
- (void)reloadAgainButtonAction:(IndexButton *)sender {
    
    [self.myCommentListTabelView headerBeginRefreshing];

}

//网络请求
- (void)httpMyCommentListDataWithPageIndex:(NSInteger )pageIndex {
    Manager *manager = [Manager shareInstance];
    if (pageIndex == 1 && [SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];
    }
    
    [manager myCommentListWithUserId:manager.memberInfoModel.u_id  withPageIndex:pageIndex withPageSize:10 withMyCommentSuccessBlock:^(id successResult) {
        //得到总页数
        self.totalPage = [successResult integerValue];
        //如果是下拉刷新，将currentpage重置为1
        if (pageIndex == 1) {
            [SVProgressHUD dismiss];
            self.currentPage = 1;
            //取消效果
            [self.myCommentListTabelView headerEndRefreshing];
            
            //查看是否空白页
            [self isShowKongImageViewWithType:KongTypeWithKongData withKongMsg:@"暂无我的评价"];
            
        }else {
            //如果是加载，那么更新currentpage
            self.currentPage = pageIndex;
            //取消效果
            [self.myCommentListTabelView footerEndRefreshing];

        }
        [self.myCommentListTabelView reloadData];
        
    } withMyCommentFailBlock:^(NSString *failResultStr) {
        [SVProgressHUD dismiss];

        [self.myCommentListTabelView headerEndRefreshing];
        [self.myCommentListTabelView footerEndRefreshing];

        [self isShowKongImageViewWithType:KongTypeWithNetError withKongMsg:@"网络错误"];

    }];

}


#pragma mark - TableView Delegate -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    Manager *manager = [Manager shareInstance];
    return manager.myCommentArr.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 11  ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCommentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCommentListCell" forIndexPath:indexPath];
    Manager *manager = [Manager shareInstance];
    MyCommentListModel *tempModel = manager.myCommentArr[indexPath.section];
    [cell updateMyCommentCellWithCommentModel:tempModel];
    
    
    return cell;
    
}


//空白页
- (void)isShowKongImageViewWithType:(KongType )kongType withKongMsg:(NSString *)msg {
    Manager *manager = [Manager shareInstance];
    if (manager.myCommentArr.count == 0) {
        [self.kongImageView showKongViewWithKongMsg:msg withKongType:kongType];
        
    }else {
        [self.kongImageView hiddenKongView];
        
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
