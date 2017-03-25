//
//  PresentViewController.m
//  MoreSDKDemo
//
//  Created by sunshinek31 on 15/4/1.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "PresentViewController.h"
#import "ControllerActivity.h"
#import "DataSigner.h"
#import "Base64Data.h"
#import "SecKeyWrapper.h"
@interface PresentViewController ()
@property (nonatomic, assign) MMMEventType currentEvent;
@property (nonatomic, strong) NSDictionary *currentParams;
@end

@implementation PresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"跳转" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(present:) forControlEvents:UIControlEventTouchUpInside];
    btn.center = self.view.center;
    [self.view addSubview:btn];
    
    NSLog(@"%f",self.view.window.windowLevel);
    
}

-(void)present:(UIButton *)sender{
    
    
    [ControllerActivity enableTestServiceURL:YES];
    
    [ControllerActivity setParams:_currentParams event:_currentEvent signInfoBlock:^NSString *(NSString *signInfo, BOOL isSignWithPrivateKey) {
        if (isSignWithPrivateKey) {
            return [self doRsa:signInfo];
        }else{
            return [self encryptWithString:signInfo];
        }
        
    }
                      resultBlock:^(NSDictionary *result, MMMEventType event) {
                          NSLog(@"%@",result);
                      }
     ];
}
- (NSString *)encryptWithString:(NSString *)content
{
    
    NSData *publicKey = [NSData dataFromBase64String:PartnerPublicKey];
    
    NSData *usernamm = [content dataUsingEncoding: NSUTF8StringEncoding];
    
    NSData *newKey= [SecKeyWrapper encrypt:usernamm publicKey:publicKey];
    
    NSString *result = [newKey base64EncodedString];
    
    return result;
    
}

-(NSString*)doRsa:(NSString*)string
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:string];
    return signedString;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setparams:(NSDictionary *)params event:(MMMEventType)event {
    
    _currentEvent = event;
    _currentParams = params;
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
