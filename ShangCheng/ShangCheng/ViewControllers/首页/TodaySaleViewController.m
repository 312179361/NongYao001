//
//  TodaySaleViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/1.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "TodaySaleViewController.h"
#import "TodaySaleTableViewCell.h"
#import "TodaySaleListViewController.h"
#import "Manager.h"
#import "MJRefresh.h"
#import "KongImageView.h"
#import "SVProgressHUD.h"
@interface TodaySaleViewController ()<UITableViewDelegate,UITableViewDataSource>
//空白页
@property (nonatomic,strong)KongImageView *kongImageView;

@property (weak, nonatomic) IBOutlet UITableView *todaySaleTableView;
@property (nonatomic,strong)NSMutableArray *todaySaleDataSourceArr;
@end

@implementation TodaySaleViewController
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
    
    [self downPushRefresh];
    [self.todaySaleTableView headerBeginRefreshing];
    
    
}

//重新加载
- (void)reloadAgainButtonAction:(IndexButton *)sender {
    [self.todaySaleTableView headerBeginRefreshing];

    
}

//刷新
- (void)downPushRefresh {
    Manager *manager = [Manager shareInstance];

    [self.todaySaleTableView addHeaderWithCallback:^{

        //增加风火轮
        if ([SVProgressHUD isVisible] == NO) {
            [SVProgressHUD show];
        }

        
        
        [manager todayActivityWithTodaySuccess:^(id successResult) {
            //风火轮消失
            [SVProgressHUD dismiss];
            //消失刷新效果
            [self.todaySaleTableView headerEndRefreshing];
            self.todaySaleDataSourceArr = [NSMutableArray arrayWithArray:successResult];
            [self.todaySaleTableView reloadData];
            //是否显示空白页
            [self isShowKongImageViewWithType:KongTypeWithKongData withKongMsg:@"暂无今日特价"];

        } withTodayFail:^(NSString *failResultStr) {
            //风火轮消失
            [SVProgressHUD dismiss];
            //消失刷新效果
            [self.todaySaleTableView headerEndRefreshing];
            [self isShowKongImageViewWithType:KongTypeWithNetError withKongMsg:@"网络错误"];
            
        }];
        
    }];
}

//空白页
- (void)isShowKongImageViewWithType:(KongType )kongType withKongMsg:(NSString *)msg {

    if (self.todaySaleDataSourceArr.count > 0) {
        [self.kongImageView hiddenKongView];
    }else {
        [self.kongImageView showKongViewWithKongMsg:msg withKongType:kongType];
    }
    
}


#pragma mark - tableView delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.todaySaleDataSourceArr.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TodaySaleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todaySaleCell" forIndexPath:indexPath];
    TodaySaleModel *tempModel = self.todaySaleDataSourceArr[indexPath.section];
    [cell updateTodaySaleCellWithModel:tempModel];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TodaySaleModel *tempModel = self.todaySaleDataSourceArr[indexPath.section];

    NSString *tempTitle ;
    if (indexPath.section == 0) {
        tempTitle = @"今日特价";
    }else {
        tempTitle = @"明日特价";
    }
    [self performSegueWithIdentifier:@"todaySaleVCToTodaySaleListVC" sender:@[tempModel,tempTitle]];
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
    if ([segue.identifier isEqualToString:@"todaySaleVCToTodaySaleListVC"]) {
        TodaySaleListViewController *todaySaleListVC = [segue destinationViewController];
        TodaySaleModel *tempModel = sender[0];
        todaySaleListVC.headerImageUrl = tempModel.a_image2;
        todaySaleListVC.temp_a_id = tempModel.a_id;
        todaySaleListVC.tempTitle = sender[1];
    }
    
}


@end
