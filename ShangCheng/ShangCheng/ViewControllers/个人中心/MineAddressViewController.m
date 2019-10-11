//
//  MineAddressViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/18.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MineAddressViewController.h"
#import "MineAddressTableViewCell.h"
#import "MineAddressFootTableViewCell.h"
#import "AddReceiveAddressViewController.h"
#import "KongImageView.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
@interface MineAddressViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *addressListTableView;
@property (nonatomic,strong)KongImageView *kongImageView;

@end

@implementation MineAddressViewController
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
    
    //加载空白页
    self.kongImageView = [[[NSBundle mainBundle] loadNibNamed:@"KongImageView" owner:self options:nil] firstObject];
    [self.kongImageView.reloadAgainButton addTarget:self action:@selector(reloadAgainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.kongImageView.frame = self.addressListTableView.bounds;
    [self.addressListTableView addSubview:self.kongImageView];
    
    //下拉刷新
    [self downPushRefresh];
    //请求数据
    [self httpReceiveAddressList];
    
}

- (void)reloadAgainButtonAction:(IndexButton *)sender {
    [self httpReceiveAddressList];

}

- (void)downPushRefresh {
    [self.addressListTableView addHeaderWithCallback:^{
        [self httpReceiveAddressList];
    }];
}

- (void)httpReceiveAddressList {
    Manager *manager = [Manager shareInstance];
    if ([SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];
    }
    
    [manager receiveAddressListWithUserIdOrReceiveId:manager.memberInfoModel.u_id withAddressListSuccess:^(id successResult) {
        [SVProgressHUD dismiss];
        
        [self.addressListTableView reloadData];
        [self.addressListTableView headerEndRefreshing];

    } withAddressListFail:^(NSString *failResultStr) {
        NSLog(@"失败");
        [SVProgressHUD dismiss];
        
        [self.addressListTableView headerEndRefreshing];

        [self isShowKongImageViewWithType:KongTypeWithNetError withKongMsg:@"网络错误"];
    }];

}


#pragma mark - tableView delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [Manager shareInstance].receiveAddressArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > 0) {
        return 10;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 47;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    MineAddressFootTableViewCell *footViewCell = [tableView dequeueReusableCellWithIdentifier:@"mineAddressFootCell"];
    Manager *manager =  [Manager shareInstance];
    ReceiveAddressModel *tempAddressModel = manager.receiveAddressArr[section];
    
    footViewCell.defaultAddressButton.indexForButton = [NSIndexPath indexPathForRow:0 inSection:section];
    footViewCell.editAddressButton.indexForButton = [NSIndexPath indexPathForRow:0 inSection:section];
    footViewCell.deleteAddressButton.indexForButton = [NSIndexPath indexPathForRow:0 inSection:section];


    [footViewCell updateMineAddressFootCellWithModel:tempAddressModel];
    
    return footViewCell;
}
//默认地址选择按钮
- (IBAction)defaltButtonAction:(IndexButton *)sender {
    Manager *manager =  [Manager shareInstance];
    ReceiveAddressModel *tempAddressModel = manager.receiveAddressArr[sender.indexForButton.section];

    [manager defaultReceiveAddressWithAddressModel:tempAddressModel withDefaultSuccess:^(id successResult) {
        
        [self.addressListTableView reloadData];
        
    } withDefaultFail:^(NSString *failResultStr) {
        
    }];
    
}
//编辑按钮
- (IBAction)editButtonAction:(IndexButton *)sender {
    Manager *manager =  [Manager shareInstance];
    ReceiveAddressModel *tempAddressModel = manager.receiveAddressArr[sender.indexForButton.section];
    [self performSegueWithIdentifier:@"mineAddressToDetailReceiveVC" sender:tempAddressModel];
}

//删除按钮
- (IBAction)deleteButtonAction:(IndexButton *)sender {
    Manager *manager =  [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    
    [alertM showAlertViewWithTitle:nil withMessage:@"是否要删除这个收货地址" actionTitleArr:@[@"取消",@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
        if (actionBlockNumber == 1) {
            ReceiveAddressModel *tempAddressModel = manager.receiveAddressArr[sender.indexForButton.section];
            [manager deleteReceiveAddressWithAddressModel:tempAddressModel withDeleteAddressSuccess:^(id successResult) {
                
                if ([successResult isEqualToString:@"1"]) {
                    //由于删除了默认地址，需要重新请求地址
                    [self httpReceiveAddressList];
                }
                
                //刷新UI
                [self.addressListTableView reloadData];
                
                
            } withDeleteAddressFail:^(NSString *failResultStr) {
                [alertM showAlertViewWithTitle:nil withMessage:@"删除地址失败，请稍后再试" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
            }];

        }
    }];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mineAddressCell" forIndexPath:indexPath];

    Manager *manager =  [Manager shareInstance];
    ReceiveAddressModel *tempAddressModel = manager.receiveAddressArr[indexPath.section];
    
    [cell updateMineAddressCellWithModel:tempAddressModel];
    
    return cell;
    
}

#pragma mark - 添加收货地址 -
- (IBAction)addAddressButtonAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"mineAddressToDetailReceiveVC" sender:nil];
    
}


//空白页
- (void)isShowKongImageViewWithType:(KongType )kongType withKongMsg:(NSString *)msg {
    Manager *manager = [Manager shareInstance];
    if (manager.receiveAddressArr.count == 0 ) {
        [self.kongImageView showKongViewWithKongMsg:msg withKongType:kongType];
        
    }else {
        [self.kongImageView hiddenKongView];
        
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
    
    Manager *manager = [Manager shareInstance];
    if ([segue.identifier isEqualToString:@"mineAddressToDetailReceiveVC"]) {
        AddReceiveAddressViewController *addReceiveAddressVC = [segue destinationViewController];
        if (sender != nil && [sender isKindOfClass:[ReceiveAddressModel class]]) {
            
            addReceiveAddressVC.tempReceiveAddressModel = sender;
        }
        
        addReceiveAddressVC.refreshAddressListBlock = ^(NSString *motifyOrAddModelStr){
            //重新刷新列表
            [manager receiveAddressListWithUserIdOrReceiveId:manager.memberInfoModel.u_id withAddressListSuccess:^(id successResult) {
                
                //将修改或者添加的地址作为默认地址，进行标记
                for (ReceiveAddressModel *tempModel in manager.receiveAddressArr) {
                    if ([tempModel.receiverID isEqualToString:motifyOrAddModelStr]) {
                        tempModel.isSelect = YES;
                    }
                }
                //刷新列表
                [self.addressListTableView reloadData];
                
            } withAddressListFail:^(NSString *failResultStr) {
                NSLog(@"刷新失败");
            }];
        };
        
        
    }

    
}


@end
