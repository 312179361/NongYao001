//
//  ProductDetailTwoTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/4/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "ProductDetailTwoTableViewCell.h"

@implementation ProductDetailTwoTableViewCell

- (void)updateProductDetailTwoCell:(NSString *)webIntroduce {
    
    self.heightLayout.constant = self.documentHeight;
    
    NSString* str= [webIntroduce stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    [self.detailWebView loadHTMLString:str baseURL:nil];
    self.detailWebView.scrollView.scrollEnabled = NO;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //宽度适应
    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    //计算高度
    self.documentHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];

    
    //发送通知，修改高度
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getCellHightNotification" object:nil         userInfo:@{@"height":[NSNumber numberWithFloat:self.documentHeight]}];


}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
