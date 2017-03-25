//
//  MMMFindPasswordViewController.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/9/2.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMFindPasswordViewController.h"

@interface MMMFindPasswordViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation MMMFindPasswordViewController

-(instancetype)init{
    self = [super init];
    if (self) {
       self.titleLabel.text = @"找回密码";
        
        
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.webView = [[UIWebView alloc]initWithFrame:self.contentView.bounds];
    self.webView.delegate = self;
//    self.webView.scalesPageToFit = YES;
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://my.moneymoremore.com/merchant/findPassword_check.jsp"]];
//    self.webView.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:self.webView];
    [self.webView loadRequest:request];

}

-(void) webViewDidStartLoad:(UIWebView *)webView
{
    //创建UIActivityIndicatorView背底半透明View
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [self.activityIndicator setCenter:view.center];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:self.activityIndicator];
    
    [self.activityIndicator startAnimating];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    NSLog(@"webViewDidFinishLoad");
    
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
}

-(void)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
