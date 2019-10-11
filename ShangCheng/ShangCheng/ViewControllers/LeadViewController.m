//
//  LeadViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/5/22.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "LeadViewController.h"
#import "Manager.h"

@interface LeadViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIPageControl *bottomPageView;

@end

@implementation LeadViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)nextButtonAction:(UIButton *)sender {
    
    //进入应用了，就要把plist标记的首次进入应用修改一下状态
    Manager *manager = [Manager shareInstance];
    [manager setFirstJoinAppWithStatus:@"NO"];
    
    [self performSegueWithIdentifier:@"leadToTabbarVC" sender:nil];
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
