//
//  WebPageViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/7.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "WebPageViewController.h"
#import "KongImageView.h"
#import "SVProgressHUD.h"
#import "Manager.h"
@interface WebPageViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)KongImageView *kongImageView;
@property (weak, nonatomic) IBOutlet UIWebView *tempWebView;


@end

@implementation WebPageViewController

- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.tempTitleStr;
    
    
    //加载空白页
    self.kongImageView = [[[NSBundle mainBundle] loadNibNamed:@"KongImageView" owner:self options:nil] firstObject];
//    self.kongImageView.backgroundColor = [UIColor yellowColor];
    [self.kongImageView.reloadAgainButton addTarget:self action:@selector(reloadAgainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.kongImageView.frame = self.view.bounds;
    [self.view addSubview:self.kongImageView];

    
    
    [self.tempWebView setUserInteractionEnabled:YES];//是否支持交互
    self.tempWebView.delegate=self;
    [self.tempWebView setOpaque:NO];//opaque是不透明的意思
    [self.tempWebView setScalesPageToFit:YES];//自动缩放以适应屏幕
    
    //加载网页
    [self reloadAgainButtonAction:nil];
}


//加载数据
- (void)reloadAgainButtonAction:(IndexButton *)sender {
    //加载网页的方式
    NSLog(@"++%@",self.webUrl);
    if (self.webUrl != nil && ![self.webUrl isEqualToString:@""]) {
        if (![self.webUrl containsString:@"https://"]) {
            self.webUrl = [NSString stringWithFormat:@"https://%@", self.webUrl];
        }

        if (self.isUTF8Code == YES) {
            NSString * strUrl = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:self.webUrl] encoding:NSUTF8StringEncoding error:nil];
            
            [self.tempWebView loadHTMLString:strUrl baseURL:nil];
        }else {
            NSURL *url = [NSURL URLWithString: self.webUrl];
            
            [self.tempWebView loadRequest:[NSURLRequest requestWithURL:url]];
        }
        
        

        
        
        
        
    }else {
    
        [self.kongImageView showKongViewWithKongMsg:@"此链接暂不存在" withKongType:KongTypeWithKongData];

    }

    

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
    
    [self.kongImageView showKongViewWithKongMsg:@"加载失败" withKongType:KongTypeWithNetError];
    
}
- (void)viewWillDisappear:(BOOL)animated {
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
