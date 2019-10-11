//
//  AboutUsViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/18.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "AboutUsViewController.h"
#import "WebPageViewController.h"

@interface AboutUsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *aboutUsTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArr;
@end

@implementation AboutUsViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSourceArr = [NSMutableArray arrayWithObjects:@[@"公司介绍"],@[@"帮助中心",@"用户协议"],@[@"联系我们"], nil];
    
}

#pragma mark - Tableview Delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *tempArr = self.dataSourceArr[section];
    return tempArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutUsCell" forIndexPath:indexPath];
    
    NSString *tempStr = [self.dataSourceArr[indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = tempStr;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        //公司介绍
        [self performSegueWithIdentifier:@"aboutUsToWebVC" sender:@[@"公司介绍",@"http://www.ertj.cn/webpage/pc/help/about.html"]];
    }
    if (indexPath.section == 1 ) {
        if (indexPath.row == 0) {
            //帮助中心
            [self performSegueWithIdentifier:@"aboutUsToWebVC" sender:@[@"帮助中心",@"http://www.ertj.cn/webpage/pc/help/problem.html"]];

        }
        if (indexPath.row == 1) {
            //用户协议
            [self performSegueWithIdentifier:@"aboutUsToWebVC" sender:@[@"用户协议",@"http://www.ertj.cn/webpage/pc/help/service.html"]];

        }
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        //联系我们
        [self performSegueWithIdentifier:@"aboutUsToWebVC" sender:@[@"联系我们",@"http://www.ertj.cn/webpage/pc/help/28.html"]];

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
    WebPageViewController *webPageVC = [segue destinationViewController];
    webPageVC.webUrl = sender[1];
    webPageVC.tempTitleStr = sender[0];
    webPageVC.isUTF8Code = YES;
    
}


@end
