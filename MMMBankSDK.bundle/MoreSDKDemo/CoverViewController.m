//
//  CoverViewController.m
//  MoreSDKDemo
//
//  Created by sunshinek31 on 15/5/26.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "CoverViewController.h"
#import "AppDelegate.h"

@interface CoverViewController ()
@property (weak, nonatomic) IBOutlet UIButton *hiddenCoverView;

- (IBAction)hiddenCoverVC:(id)sender;
@end

@implementation CoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)hiddenCoverVC:(id)sender {
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.bWindow.hidden = YES;
    [delegate.bWindow resignKeyWindow];
}
@end
