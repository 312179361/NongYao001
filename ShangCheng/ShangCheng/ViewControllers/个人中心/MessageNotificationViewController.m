//
//  MessageNotificationViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/31.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MessageNotificationViewController.h"
#import "Manager.h"
#import "MessageOneTableViewCell.h"
#import "MessageTwoTableViewCell.h"
#import "WebPageTwoViewController.h"
#import "KongImageView.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
@interface MessageNotificationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (nonatomic,strong)KongImageView *kongImageView;
//当前有页数
@property (nonatomic,assign)NSInteger currentPage;
//总共的页数
@property (nonatomic,assign)NSInteger totalPage;


@end

@implementation MessageNotificationViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//     让cell自适应高度
//    self.messageTableView.rowHeight = UITableViewAutomaticDimension;
//    设置估算高度
//    self.messageTableView.estimatedRowHeight = 44;
    
    
    //加载空白页
    self.kongImageView = [[[NSBundle mainBundle] loadNibNamed:@"KongImageView" owner:self options:nil] firstObject];
    [self.kongImageView.reloadAgainButton addTarget:self action:@selector(reloadAgainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.kongImageView.frame = self.messageTableView.bounds;
    [self.messageTableView addSubview:self.kongImageView];
    

    //加载下拉刷新
    [self downPushRefresh];
    //上拉加载
    [self upPushLoad];

    
    //首次进入执行一次下拉刷新
    [self.messageTableView headerBeginRefreshing];
    

  
}

#pragma mark - 下拉刷新 -
//下拉刷新
- (void)downPushRefresh {
    [self.messageTableView addHeaderWithCallback:^{
        NSLog(@"下拉");
        [self httpMessageListWithPageIndex:1];
        
    }];
}

//上拉加载
- (void)upPushLoad {
    [self.messageTableView addFooterWithCallback:^{
        NSLog(@"上拉");
        //当前页小于总页数，可以进行加载
        if (self.currentPage < self.totalPage) {
            [self httpMessageListWithPageIndex:self.currentPage+1];
        }else {
            [self.messageTableView footerEndRefreshing];
        }
        
        
    }];
    
}

//重新加载
- (void)reloadAgainButtonAction:(IndexButton *)sender {
    
    [self.messageTableView headerBeginRefreshing];
    
}

//网络请求消息列表
- (void)httpMessageListWithPageIndex:(NSInteger)pageIndex {
    Manager *manager = [Manager shareInstance];
    
    if (pageIndex == 1 && [SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];
        
    }

    
    [manager httpMessageNotificationWithType:@"99" withTitle:@"" withKeyword:@"" withIntroduce:@"" withPageindex:1 withMessageSuccess:^(id successResult) {
        [self.messageTableView reloadData];
        
        //得到总页数
        self.totalPage = [successResult integerValue];
        //如果是下拉刷新，将currentpage重置为1
        if (pageIndex == 1) {
            [SVProgressHUD dismiss];//风火轮消失
            
            self.currentPage = 1;
            //取消效果
            [self.messageTableView headerEndRefreshing];
            
            //查看是否空白页
            [self isShowKongImageViewWithType:KongTypeWithKongData withKongMsg:@"暂无我的评价"];
            
        }else {
            //如果是加载，那么更新currentpage
            self.currentPage = pageIndex;
            //取消效果
            [self.messageTableView footerEndRefreshing];
            
        }
        [self.messageTableView reloadData];

    } withMessageFail:^(NSString *failResultStr) {
        [SVProgressHUD dismiss];
        
        [self.messageTableView headerEndRefreshing];
        [self.messageTableView footerEndRefreshing];
        
        [self isShowKongImageViewWithType:KongTypeWithNetError withKongMsg:@"网络错误"];
        

    }];

    
   
}


#pragma mark - TableView delegate -
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return manager.messageArr.count;
//
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Manager *manager = [Manager shareInstance];
    return manager.messageArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];
    
    MessageNotificationModel *messageModel = manager.messageArr[indexPath.row];
//    if (messageModel.i_icon_path!= nil && messageModel.i_icon_path.length > 0) {
//        MessageOneTableViewCell *oneCell = [tableView dequeueReusableCellWithIdentifier:@"messageOneCell" forIndexPath:indexPath];
//        [oneCell updateMessageCellWithModel:messageModel];
//        return oneCell;
//    }else {
        MessageTwoTableViewCell *twoCell = [tableView dequeueReusableCellWithIdentifier:@"messageTwoCell" forIndexPath:indexPath];
        [twoCell updateMessageCellWithModel:messageModel];
        return twoCell;
//    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Manager *manager = [Manager shareInstance];
    MessageNotificationModel *messageModel = manager.messageArr[indexPath.row];
    [self performSegueWithIdentifier:@"messageListToWebViewTwoVC" sender:messageModel];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//空白页
- (void)isShowKongImageViewWithType:(KongType )kongType withKongMsg:(NSString *)msg {
    Manager *manager = [Manager shareInstance];
    if (manager.messageArr.count == 0) {
        [self.kongImageView showKongViewWithKongMsg:msg withKongType:kongType];
        
    }else {
        [self.kongImageView hiddenKongView];
        
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
//    MessageDetailViewController *messageDetailVC = [segue destinationViewController];
    //    messageDetailVC.messageModel = tempModel;

    
    MessageNotificationModel *tempModel = sender;

    WebPageTwoViewController *webPageTwoVC = [segue destinationViewController];
    webPageTwoVC.tempTitleStr = tempModel.i_time_create;
    webPageTwoVC.tempId = tempModel.i_id;
    
    
}

@end
