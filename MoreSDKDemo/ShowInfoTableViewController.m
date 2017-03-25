//
//  ShowInfoTableViewController.m
//  MoreSDKDemo
//
//  Created by sunshinek31 on 15/1/28.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "ShowInfoTableViewController.h"
#import "ControllerActivity.h"
#import "DataSigner.h"
#import "Base64Data.h"
#import "SecKeyWrapper.h"
#import "JSONKit.h"
#import "TimeUtil.h"

@interface ShowInfoTableViewController ()
<UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) NSArray *cellInfoArr;
@property (nonatomic, strong) NSMutableDictionary *cellInfoDic;
@property (nonatomic) MMMEventType currentEvent;
@property (nonatomic, strong) UITextField *textField;
@end


@implementation ShowInfoTableViewController
{
    NSString *_currentKey;
    NSString *_currentValue;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeView:) name:@"MMMBaseViewControllerRemove" object:nil];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeView:) name:@"MMMBaseViewControllerRemove" object:nil];
}
-(void)removeView:(NSNotification *)notification {
    NSLog(@"页面移除");
    
    
//    double delayInSeconds = 2;
//    
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"test" message:@"移除乾多多插件页面" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//    });
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     NSLog(@"页面出现++++++++++++++");
}

-(void)setparams:(NSDictionary *)params event:(MMMEventType)event {
    
    
    _currentEvent = event;
    _cellInfoDic = [NSMutableDictionary dictionaryWithDictionary:params];
    _cellInfoArr = [NSMutableArray array];
    switch (event) {
        case MMMRegisterEvent:
            _cellInfoArr = @[@{@"RegisterType":@"注册类型"},
                             @{@"AccountType":@"账户类型"},
                             @{@"Mobile":@"手机号"},
                             @{@"Email":@"邮箱"},
                             @{@"RealName":@"真实姓名"},
                             @{@"IdentificationNo":@"证件号"},
                             @{@"Image1":@"证件照正面"},
                             @{@"Image2":@"证件照反面"},
                             @{@"LoanPlatformAccount":@"平台账号"},
                             @{@"PlatformMoneymoremore":@"乾多多标识"},
                             @{@"RandomTimeStamp":@"随机时间戳"},
                             @{@"Remark1":@"自定义备注1"},
                             @{@"Remark2":@"自定义备注2"},
                             @{@"Remark3":@"自定义备注3"},
                             @{@"NotifyURL":@"后台通知网址"}];
            break;
        case MMMLoanEvent:
            _cellInfoArr = @[@{@"RechargeMoneymoremore":@"充值人乾多多标识"},
                             @{@"PlatformMoneymoremore":@"乾多多标识"},
                             @{@"OrderNo":@"订单号"},
                             @{@"Amount":@"金额"},
//                             @{@"Fee":@"用户承担的手续费"},
//                             @{@"FeePlatform":@"平台承担的手续费"},
//                             @{@"RechargeType":@"充值类型"},
                             @{@"FeeType":@"手续费类型"},
                             @{@"CardNo":@"银行卡号"},
                             @{@"RandomTimeStamp":@"随机时间戳"},
                             @{@"Remark1":@"自定义备注1"},
                             @{@"Remark2":@"自定义备注2"},
                             @{@"Remark3":@"自定义备注3"},
                             @{@"NotifyURL":@"后台通知网址"}];
            break;
        case MMMWithdrawEvent:
            _cellInfoArr = @[@{@"WithdrawMoneymoremore":@"提醒人乾多多标识"},
                             @{@"PlatformMoneymoremore":@"乾多多标识"},
                             @{@"OrderNo":@"订单号"},
                             @{@"Amount":@"金额"},
                             @{@"FeePercent":@"平台承担的手续费比例"},
                             @{@"FeeMax":@"用户承担的手续费比例"},
                             @{@"FeeRate":@"上浮费率"},
                             @{@"CardNo":@"银行卡号"},
                             @{@"CardType":@"银行卡类型"},
                             @{@"BankCode":@"银行卡代码"},
                             @{@"BranchBankName":@"开户行支行名称"},
                             @{@"Province":@"开户行省份"},
                             @{@"City":@"开户行城市"},
                             @{@"RandomTimeStamp":@"随机时间戳"},
                             @{@"Remark1":@"自定义备注1"},
                             @{@"Remark2":@"自定义备注2"},
                             @{@"Remark3":@"自定义备注3"},
                             @{@"NotifyURL":@"后台通知网址"}];
            break;
        case MMMTransferEvent:
            _cellInfoArr = @[@{@"LoanJsonList":@"转账列表"},
                             @{@"PlatformMoneymoremore":@"乾多多标识"},
                             @{@"TransferAction":@"转账类型"},
                             @{@"Action":@"操作类型"},
                             @{@"TransferType":@"转账方式"},
                             @{@"NeedAudit":@"通过是否需要审核"},
                             @{@"RandomTimeStamp":@"随机时间戳"},
                             @{@"Remark1":@"自定义备注1"},
                             @{@"Remark2":@"自定义备注2"},
                             @{@"Remark3":@"自定义备注3"},
                             @{@"NotifyURL":@"后台通知网址"}];
            break;
        case MMMAuthorizationEvent:
            _cellInfoArr = @[@{@"MoneymoremoreId":@"用户乾多多标识"},
                             @{@"PlatformMoneymoremore":@"乾多多标识"},
                             @{@"AuthorizeTypeOpen":@"开启授权类型"},
                             @{@"AuthorizeTypeClose":@"关闭授权类型"},
                             @{@"RandomTimeStamp":@"随机时间戳"},
                             @{@"Remark1":@"自定义备注1"},
                             @{@"Remark2":@"自定义备注2"},
                             @{@"Remark3":@"自定义备注3"},
                             @{@"NotifyURL":@"后台通知网址"}];
            break;
        case MMMThreeInOneEvent:
            _cellInfoArr = @[@{@"MoneymoremoreId":@"用户乾多多标识"},
                             @{@"PlatformMoneymoremore":@"乾多多标识"},
                             @{@"Action":@"操作类型"},
                             @{@"CardNo":@"银行卡号"},
                             @{@"WithholdBeginDate":@"代扣开始日期"},
                             @{@"WithholdEndDate":@"代扣结束日期"},
                             @{@"SingleWithholdLimit":@"单笔代扣限额"},
                             @{@"TotalWithholdLimit":@"代扣总限额"},
                             @{@"RandomTimeStamp":@"随机时间戳"},
                             @{@"Remark1":@"自定义备注1"},
                             @{@"Remark2":@"自定义备注2"},
                             @{@"Remark3":@"自定义备注3"},
                             @{@"NotifyURL":@"后台通知网址"}];
            break;
        default:
            break;
    }
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(0, self.tableView.frame.size.height, [UIScreen mainScreen].bounds.size.width, 44)];
    _textField.hidden = YES;
    [self.view addSubview:_textField];
    _textField.delegate = self;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.layer.masksToBounds = YES;
    _textField.layer.borderWidth = 0.5f;
    _textField.layer.borderColor = [UIColor grayColor].CGColor;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(postData:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.tableView reloadData];
}

-(void)postData:(id)sender {
    [_textField resignFirstResponder];
    
//    [ControllerActivity enableTestServiceURL:YES];
    
//    [ControllerActivity setServiceURL:@"http://222.92.117.57" withEvent:MMMWithdrawEvent];
    
    __block NSDictionary *dfs = [_cellInfoArr copy];
    [ControllerActivity setParams:_cellInfoDic event:_currentEvent
                    signInfoBlock:^NSString *(NSString *signInfo, BOOL isSignWithPrivateKey) {
        if (isSignWithPrivateKey) {
            return [self doRsa:signInfo];
        }else{
//            return @"";
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = _cellInfoArr.count;
    
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ShowInfoTableViewCellIdentifier = @"ShowInfoTableViewCellIdentifier";
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ShowInfoTableViewCellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    NSString *title = [[[_cellInfoArr objectAtIndex:indexPath.row] allValues]firstObject];
    NSString *key = [[[_cellInfoArr objectAtIndex:indexPath.row] allKeys]firstObject];
    NSString *value = @"";
    if ([[_cellInfoDic allKeys] containsObject:key]) {
        value = [_cellInfoDic objectForKey:key];
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = value;
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    _textField.placeholder = nil;
    _currentKey = [[[_cellInfoArr objectAtIndex:indexPath.row] allKeys]firstObject];
    
    if ([[_cellInfoDic allKeys] containsObject:_currentKey]) {
        _currentValue = [_cellInfoDic objectForKey:_currentKey];
    }
    
    tableView.userInteractionEnabled = NO;
    [_textField becomeFirstResponder];
    _textField.text = _currentValue;
    _textField.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    _textField.hidden = NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.text && ![textField.text isEqualToString:@""]) {
        [_cellInfoDic setObject:textField.text forKey:_currentKey];
    }else{
        [_cellInfoDic removeObjectForKey:_currentKey];
    }
    self.tableView.userInteractionEnabled = YES;
    _textField.text = nil;
    [_textField resignFirstResponder];
    [_textField setFrame:CGRectMake(0, self.tableView.frame.size.height, [UIScreen mainScreen].bounds.size.width, 44)];
    _textField.hidden = YES;
    _currentValue = nil;
    [self.tableView reloadData];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1001 && buttonIndex == 1) {
        
        [ControllerActivity enableTestServiceURL:YES];
        
        [ControllerActivity setParams:_cellInfoDic event:_currentEvent signInfoBlock:^NSString *(NSString *signInfo, BOOL isSignWithPrivateKey) {
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
}

@end
