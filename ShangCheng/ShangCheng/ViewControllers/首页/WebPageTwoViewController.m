//
//  WebPageTwoViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/4/27.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "WebPageTwoViewController.h"
#import "KongImageView.h"
#import "Manager.h"
#import "SVProgressHUD.h"
@interface WebPageTwoViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)KongImageView *kongImageView;

@property (weak, nonatomic) IBOutlet UILabel *tempTitleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *tempWebView;
@property (weak, nonatomic) IBOutlet UILabel *tempAuthorLabel;

@end

@implementation WebPageTwoViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //加载空白页
    self.kongImageView = [[[NSBundle mainBundle] loadNibNamed:@"KongImageView" owner:self options:nil] firstObject];
    [self.kongImageView.reloadAgainButton addTarget:self action:@selector(reloadAgainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.kongImageView.frame = self.view.bounds;
    [self.view addSubview:self.kongImageView];
    
    
    
    [self.tempWebView setUserInteractionEnabled:YES];//是否支持交互
    self.tempWebView.delegate=self;
    [self.tempWebView setOpaque:NO];//opaque是不透明的意思
    [self.tempWebView setScalesPageToFit:YES];//自动缩放以适应屏幕
    
    //网络请求数据
    [self httpPestsDetaiInfo];
    
    
}

- (void)reloadAgainButtonAction:(IndexButton *)sender {
    [self httpPestsDetaiInfo];
}

- (void)httpPestsDetaiInfo {
    [[Manager shareInstance] httpMessageDetailInfoWithPestsId:self.tempId withDetailInfoSuccess:^(id successResult) {
        
        PestsDetailModel *tempModel = successResult;
        
        if (tempModel.content.length > 0) {
            self.tempTitleLabel.text = tempModel.i_title;
            self.tempAuthorLabel.text = [NSString stringWithFormat:@"%@  %@",tempModel.i_author,tempModel.i_time_create];
            //修改div字体大小
//            tempModel.content = [tempModel.content stringByReplacingOccurrencesOfString:@"16px" withString:@"30px"];
            
            NSString *contentStr = [tempModel.content stringByRemovingPercentEncoding];
            
            [self.tempWebView loadHTMLString:contentStr baseURL:nil];

            
            

        }else {
            [self.kongImageView showKongViewWithKongMsg:@"暂无病虫害内容" withKongType:KongTypeWithKongData];
            
        }
        
        
    } withDetailInfoFail:^(NSString *failResultStr) {
        [self.kongImageView showKongViewWithKongMsg:@"请检查网络后重试" withKongType:KongTypeWithNetError];
    }];
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
