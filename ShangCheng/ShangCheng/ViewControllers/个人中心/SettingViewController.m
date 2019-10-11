//
//  SettingViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/2.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "SettingViewController.h"
#import "Manager.h"
#import "SDImageCache.h"
//#import "AppDelegate.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
//退出登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginOffButton;

//tableView
@property (weak, nonatomic) IBOutlet UITableView *setTableView;

@property (nonatomic,strong)NSArray *dataSourceArr;

//缓存大小
@property (nonatomic,assign)NSUInteger cacheSize;
@end

@implementation SettingViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置group类型的顶部大小
    self.setTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 15)];
    
    NSLog(@"%@",NSHomeDirectory());
    
    self.dataSourceArr = @[@[@"清除缓存"],@[@"我要评价"]];
    
    //判断是否登录了，如果没有登录，退出登录就要隐藏
    Manager *manager = [Manager shareInstance];
    if ([manager isLoggedInStatus] == YES) {
        self.loginOffButton.hidden = NO;
    }else {
        self.loginOffButton.hidden = YES;
    }
    
    //计算缓存
    self.cacheSize = [[SDImageCache sharedImageCache]getSize];
    
}

#pragma mark - TableView Delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    [cell.textLabel setTextColor:k333333Color];
    cell.textLabel.text = [self.dataSourceArr[indexPath.section] objectAtIndex:indexPath.row];
    
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
    [cell.detailTextLabel setTextColor:k999999Color];
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.detailTextLabel.text = [self cacheSizeToString];
        
    }else {
        cell.detailTextLabel.text = @"";
    }

    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        //清理缓存
        AlertManager *alertM = [AlertManager shareIntance];
        [alertM showAlertViewWithTitle:nil withMessage:@"是否要清理缓存" actionTitleArr:@[@"取消",@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
            if (actionBlockNumber == 1) {
                if (self.cacheSize > 0) {
                    //清理缓存
                    [[SDImageCache sharedImageCache]clearDisk];
                    //重新计算
                    self.cacheSize = [[SDImageCache sharedImageCache]getSize];
                    //更新UI
                    [self.setTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    
                }
            }
        }];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        //跳转到App Store中进行评价
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1234823386?mt=8"]];
    }
    
}

//退出登录按钮
- (IBAction)logOffButtonAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    
    AlertManager *alert = [AlertManager shareIntance];
    [alert showAlertViewWithTitle:nil withMessage:@"确定退出登录" actionTitleArr:@[@"确定" ,@"取消"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
        if (actionBlockNumber == 0) {
            //确定按钮， 退出登录；
            [manager logOffAction];
            //返回到个人中心首页
            [self.navigationController popToRootViewControllerAnimated:YES];

        }
    }];
    
}


//缓存计算
- (NSString *)cacheSizeToString {
    float tempCacheFloat = self.cacheSize;
    
    if (tempCacheFloat > 0) {
        //如果大于1K,就换算成K
        if (tempCacheFloat >= 1024) {
            tempCacheFloat = tempCacheFloat / 1024.0;
            
            //看看有没有达到 1M的
            if (tempCacheFloat >= 1024) {
                tempCacheFloat = tempCacheFloat / 1024.0;
                
                //看看有没有达到 1G的
                if (tempCacheFloat >= 1024) {
                    tempCacheFloat = tempCacheFloat / 1024.0;
                    return [NSString stringWithFormat:@"%.2f G",tempCacheFloat];

                }else {
                    //不满1G
                    return [NSString stringWithFormat:@"%.2f M",tempCacheFloat];
                }
                
            }else {
                //不满1M
                return [NSString stringWithFormat:@"%.2f K",tempCacheFloat];
            }
            
        }else {
            //不满1K
            return [NSString stringWithFormat:@"%.2f B",tempCacheFloat];
        }
        
        
    }else {
        return @"0 KB";
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
