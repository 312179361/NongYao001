//
//  CustomerServiceViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/11/21.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "CustomerServiceViewController.h"
#import "SVProgressHUD.h"

@interface CustomerServiceViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *customerServiceWebView;

@end

@implementation CustomerServiceViewController
- (void)viewWillDisappear:(BOOL)animated {
    [SVProgressHUD dismiss];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.customerServiceWebView setUserInteractionEnabled:YES];//是否支持交互
    self.customerServiceWebView.delegate=self;
    [self.customerServiceWebView setOpaque:NO];//opaque是不透明的意思
    [self.customerServiceWebView setScalesPageToFit:YES];//自动缩放以适应屏幕
    
    //加载在线客服
    [self reloadAction];
}


//加载在线客服
- (void)reloadAction {
    //加载网页的方式
    
    NSURL *url = [NSURL URLWithString:@"https://kefu.ziyun.com.cn/vclient/chat/?websiteid=99706&wc=056dc2&visitorid=1164052460&newver=1"];
    [self.customerServiceWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"开始加载");
    
    [SVProgressHUD show];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"加载完毕");
    [SVProgressHUD dismiss];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"加载错误%@",error);
    [SVProgressHUD dismiss];
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
