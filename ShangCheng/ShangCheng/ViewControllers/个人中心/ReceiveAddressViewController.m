//
//  ReceiveAddressViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/29.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ReceiveAddressViewController.h"
#import "ReceiveAddressTableViewCell.h"
#import "AddReceiveAddressViewController.h"
#import "ReceiveAddressModel.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "KongImageView.h"
@interface ReceiveAddressViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *receiveAddressTableView;
@property (nonatomic,strong)KongImageView *kongImageView;

@end

@implementation ReceiveAddressViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    if (self.selectModelBlock != nil) {
        self.selectModelBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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

    
    
    // 让cell自适应高度
    self.receiveAddressTableView.rowHeight = UITableViewAutomaticDimension;
    //设置估算高度
    self.receiveAddressTableView.estimatedRowHeight = 44;
    
    [self downPushRefresh];
    
    [self.receiveAddressTableView headerBeginRefreshing];
    
}

//空白页中的重新刷新
- (void)reloadAgainButtonAction:(IndexButton *)sender {
    [self.receiveAddressTableView headerBeginRefreshing];
}

//下拉刷新
- (void)downPushRefresh {
    
    [self.receiveAddressTableView addHeaderWithCallback:^{
        NSLog(@"下拉刷新");
        Manager *manager = [Manager shareInstance];
        //取到选择地址id，然后刷新后，还是这个为选择地址
        NSString *tempSelectAddressID ;
        for (ReceiveAddressModel *tempModel in manager.receiveAddressArr) {
            if (tempModel.isSelect == YES) {
                tempSelectAddressID = tempModel.receiverID;
            }
        }
       
        [self reloadAddressDataWithSelectAddress:tempSelectAddressID];
    }];

}

//加载地址数据
- (void)reloadAddressDataWithSelectAddress:(NSString *)selectAddress {
    Manager *manager = [Manager shareInstance];
    //重新刷新列表
    if ([SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];
    }

    [manager receiveAddressListWithUserIdOrReceiveId:manager.memberInfoModel.u_id withAddressListSuccess:^(id successResult) {
        [SVProgressHUD dismiss];
        if (selectAddress!= nil && selectAddress.length > 0) {
            
            //默认地址，进行标记
            for (ReceiveAddressModel *tempModel in manager.receiveAddressArr) {
                if ([tempModel.receiverID isEqualToString:selectAddress]) {
                    tempModel.isSelect = YES;
                }
            }
        }
        
        //下拉刷新效果消失
        [self.receiveAddressTableView headerEndRefreshing];
        
        //刷新列表
        [self.receiveAddressTableView reloadData];
        //不显示空白页
        [self.kongImageView hiddenKongView];
        
    } withAddressListFail:^(NSString *failResultStr) {
        NSLog(@"刷新失败");
        [SVProgressHUD dismiss];
        
        //下拉刷新效果消失
        [self.receiveAddressTableView headerEndRefreshing];
        //
        [self.kongImageView showKongViewWithKongMsg:@"网络问题" withKongType:KongTypeWithNetError];
    }];

}


#pragma mark - tableView delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    return [Manager shareInstance].receiveAddressArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];
    ReceiveAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"receiveCell" forIndexPath:indexPath];
    ReceiveAddressModel *tempModel = manager.receiveAddressArr[indexPath.section];
    
    [cell updateReceiveAddressCell:tempModel withIndex:indexPath];

    
    return cell;
}

//选择某个地址
- (IBAction)selectAddressButtonAction:(IndexButton *)sender {
    Manager *manager = [Manager shareInstance];
    //选中了这个地址,现将所有的选择状态都变为no
    for (ReceiveAddressModel *tempModel in manager.receiveAddressArr) {
        tempModel.isSelect = NO;
    }
    //将选中的那个状态变为YES
    ReceiveAddressModel *selectModel = manager.receiveAddressArr[sender.indexForButton.section];
    selectModel.isSelect = YES;
    [self.receiveAddressTableView reloadData];
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];
    ReceiveAddressModel *selectModel = manager.receiveAddressArr[indexPath.section];
    //编辑地址
    [self performSegueWithIdentifier:@"receiveListToDetailReceiveVC" sender:selectModel];
}

//新增地址
- (IBAction)addReceiveAddressAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"receiveListToDetailReceiveVC" sender:nil];


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

    if ([segue.identifier isEqualToString:@"receiveListToDetailReceiveVC"]) {
        AddReceiveAddressViewController *addReceiveAddressVC = [segue destinationViewController];
        if (sender != nil && [sender isKindOfClass:[ReceiveAddressModel class]]) {
            
            addReceiveAddressVC.tempReceiveAddressModel = sender;
        }
        
        addReceiveAddressVC.refreshAddressListBlock = ^(NSString *motifyOrAddModelStr){
            
            //重新刷新列表
            [self reloadAddressDataWithSelectAddress:motifyOrAddModelStr];
            
        };
    }
}


@end
