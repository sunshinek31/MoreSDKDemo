//
//  MMMWithdrawController.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/20.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMWithdrawController.h"
#import "MMMWithdrawObject.h"
#import "MMMConfigUtil.h"
#import "MMMHeaderView.h"
#import "MMMSingleInputCell.h"
#import "MMMFindPasswordViewController.h"

@interface MMMWithdrawController ()
<UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) MMMWithdrawObject *withdrawObject;
@property (nonatomic, assign) BOOL hasGetImformation;
@property (nonatomic, weak) id currentObj;
@property (nonatomic, strong) UIButton *withdrawBtn;
@property (nonatomic, strong) UITableView *withdrawTableView;
@property (nonatomic, strong) MMMSingleInputCell *passwordInputCell;

@property (nonatomic, strong) UIButton *findPasswordBtn;
@end

@implementation MMMWithdrawController
{
    NSString *_platformAccount;
    NSString *_moneymoremoreAccount;
    NSString *_realName;
    NSString *_bankName;
    NSString *_cardNo;
    NSString *_realAmount;
    NSString *_fee;
    NSString *_sumAmount;
    NSString *_cardid;
    NSString *_wid;
    NSString *_amount;
    NSString *_recordId;
    
    NSString *_payPassword;
    
    NSDictionary *_bankNameDic;
    NSIndexPath *_indexPath;
    CGRect _keyboardRect;
}

-(id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisapplear:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

-(void)back:(id)sender {
    [super back:sender];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - NSNoticification

-(void)keyboardWillDisapplear:(NSNotification *)notification {
    
    self.withdrawTableView.contentInset = UIEdgeInsetsZero;
}

-(void)keyboardWillShow:(NSNotification *) aNotification {
    NSDictionary *info = [aNotification userInfo];
    
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    float height = kbRect.size.height;
    
    if (height != 0) {
//        NSLog(@"the height of keyboard: %f",height);
        self.withdrawTableView.contentInset = UIEdgeInsetsMake(0, 0, height, 0);
    }
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (self.passwordInputCell.textField.isEditing) {
//        NSLog(@"正在输入验证码");
        CGRect rect = [self.withdrawTableView convertRect:self.withdrawBtn.frame fromView:self.withdrawBtn];
        [self.withdrawTableView scrollRectToVisible:rect animated:YES];
    }
}

-(void)setParams:(NSDictionary *)params
   signIfnoBlock:(NSString *(^)(NSString *, BOOL))signBlock
     resultBlock:(void (^)(NSDictionary *, MMMEventType))resultBlock
{
    [super setParams:params signIfnoBlock:signBlock resultBlock:resultBlock];
    [self setParams:params];
}

-(void)setParams:(NSDictionary *)params
   signIfnoBlock:(NSString *(^)(NSString *signInfo, BOOL isSignWithPrivateKey))signBlock
{
    [super setParams:params signIfnoBlock:signBlock];
    [self setParams:params];
}
-(void)setParams:(NSDictionary *)params {
    
    self.titleLabel.text = @"乾多多提现";
    
    _withdrawTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height) style:UITableViewStyleGrouped];
    _withdrawTableView.delegate = (id)self;
    _withdrawTableView.dataSource = (id)self;
    _withdrawTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.contentView addSubview:_withdrawTableView];
    
    _withdrawObject = [[MMMWithdrawObject alloc]init];
    [_withdrawObject setValuesForKeysWithDictionary:params];
    
    if (![self checkNecessaryParams:"MMMWithdrawObject" tagertObj:_withdrawObject]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"提交的数据,缺少必要参数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *cc = self.signInfoBlock(_withdrawObject.CardNo,NO);
    NSString *signDataStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                             _withdrawObject.WithdrawMoneymoremore,
                             _withdrawObject.PlatformMoneymoremore,
                             _withdrawObject.OrderNo,
                             _withdrawObject.Amount,
                             _withdrawObject.FeePercent,
                             _withdrawObject.FeeMax,
                             _withdrawObject.FeeRate,
                             _withdrawObject.CardNo,
                             _withdrawObject.CardType,
                             _withdrawObject.BankCode,
                             _withdrawObject.BranchBankName,
                             _withdrawObject.Province,
                             _withdrawObject.City,
                             _withdrawObject.RandomTimeStamp,
                             _withdrawObject.Remark1,
                             _withdrawObject.Remark2,
                             _withdrawObject.Remark3,
                             _withdrawObject.ReturnURL,
                             _withdrawObject.NotifyURL];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:params];
    if ([paramsDic.allKeys containsObject:@"CardNo"]) {
        [paramsDic setObject:cc forKey:@"CardNo"];
        
    }
    
    //  得到RSA签名过后的字符串
    NSString *signString = self.signInfoBlock(signDataStr,YES);
    if (!signString) {
        signString = @"";
    }
    [MMMActivityIndicatorView show];
    
    [MMMConfigUtil sharedConfigUtil].beginServiceWithDict(MMMWithdrawEvent, paramsDic, [signString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],^(NSData *data,NSError *error){
        [MMMActivityIndicatorView remove];
        if (self.view.window) {
            if (!error) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (![dict isKindOfClass:[NSDictionary class]]) {
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    alertView.tag = 1001;
                    [alertView show];
                    
                    return;
                }
                
                [self dealWithRequestCallback:dict];
            }
            //  网络异常
            else{
                [self requestError:error];
            }
        }
    });
    
    _bankNameDic =@{@"中国银行":@"BOC",     //1
                    @"工商银行":@"ICBC",    //2
                    @"农业银行":@"ABC",     //3
                    @"交通银行":@"BCM",     //4
                    @"广发银行":@"CGB",     //5
                    @"深发银行":@"SDB",     //6 无图
                    @"建设银行":@"CCB",     //7
                    @"上海浦发银行":@"SPDB", //8
                    @"浙江泰隆商业银行":@"TLCB",    //9
                    @"招商银行":@"CMB",     //10
                    @"中国邮政储蓄银行":@"PSBC",    //11
                    @"中国民生银行":@"CMBC",  //12
                    @"兴业银行":@"CIB",     //13
                    @"广东发展银行":@"GDB",      //14
                    @"东莞银行":@"DGB",     //15 无图(缩写可能有误)
                    @"深圳发展银行":@"SDB",   //16 同深发
                    @"中信银行":@"CITIC",   //17
                    @"华夏银行":@"HXB",     //18
                    @"中国光大银行":@"CEB",   //19
                    @"北京银行":@"BCCB",    //20
                    @"上海银行":@"BOS",     //21
                    @"天津银行":@"TCCB",    //22
                    @"大连银行":@"DLCB",    //23
                    @"杭州银行":@"HZB",     //24
                    @"宁波银行":@"NBCB",    //25
                    @"厦门银行":@"XMCB",    //26
                    @"广州银行":@"GZCB",   //27
                    @"平安银行":@"PAB",    //28
                    @"浙商银行":@"CZSB",    //29
                    @"上海农村商业银行":@"SBCB",    //30
                    @"重庆银行":@"CQCB",    //31
                    @"江苏银行":@"JSBC",    //32
                    };
}

#pragma mark - 数据回调处理

-(void)dealWithRequestCallback:(NSDictionary *)dict {
    if ([[dict allKeys] containsObject:@"Message"]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[dict objectForKey:@"Message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.tag = 1001;
        [alert show];
        return;
    }
    
    NSLog(@"%@",dict);
    
    _hasGetImformation = YES;
   
    if ([[dict allKeys] containsObject:@"PlatformAccount"]){
        _platformAccount = [dict objectForKey:@"PlatformAccount"];
    }
    if ([[dict allKeys] containsObject:@"MoneymoremoreAccount"]){
        _moneymoremoreAccount = [dict objectForKey:@"MoneymoremoreAccount"];
    }
    if ([[dict allKeys] containsObject:@"RealName"]){
        _realName = [dict objectForKey:@"RealName"];
    }
    if ([[dict allKeys] containsObject:@"BankName"]){
        _bankName = [dict objectForKey:@"BankName"];
    }
    if ([[dict allKeys] containsObject:@"CardNo"]){
        _cardNo = [dict objectForKey:@"CardNo"];
    }
    if ([[dict allKeys] containsObject:@"RealAmount"]){
        _realAmount = [dict objectForKey:@"RealAmount"];
    }
    if ([[dict allKeys] containsObject:@"Fee"]){
        _fee = [dict objectForKey:@"Fee"];
    }
    if ([[dict allKeys] containsObject:@"SumAmount"]){
        _sumAmount = [dict objectForKey:@"SumAmount"];
    }
    if ([[dict allKeys] containsObject:@"cardid"]){
        _cardid = [dict objectForKey:@"cardid"];
    }
    if ([[dict allKeys] containsObject:@"wid"]){
        _wid = [dict objectForKey:@"wid"];
    }
    if ([[dict allKeys] containsObject:@"Amount"]){
        _amount = [dict objectForKey:@"Amount"];
    }
    if ([[dict allKeys] containsObject:@"RecordId"]){
        _recordId = [dict objectForKey:@"RecordId"];
    }
    
//    NSLog(@"提现回调数据: %@",dict);
    
    [self.withdrawTableView reloadData];
}

-(void)requestError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _hasGetImformation?1:0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MMMSingleInputCellIdentifier = @"MMMSingleInputCellIdentifier";
    
    MMMSingleInputCell *singleInputCell;
    
    singleInputCell = [tableView dequeueReusableCellWithIdentifier:MMMSingleInputCellIdentifier];
    
    if (!singleInputCell){
        singleInputCell = [[MMMSingleInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MMMSingleInputCellIdentifier];
        singleInputCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (indexPath.row == 0) {
        [singleInputCell setTitleContent:@"开户名" andDetailContent:_realName];
    }else if (indexPath.row == 1){
        [singleInputCell setTitleContent:@"开户行" andDetailContent:_bankName];
        [singleInputCell.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                [obj removeFromSuperview];
            }
        }];
        
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"MMMBankSDK" ofType:@"bundle"]];
        NSString *bankNicename = [_bankNameDic objectForKey:_bankName];
        UIImage *img;
        if (bankNicename) {
            NSString *alertImagePath = [bundle pathForResource:bankNicename ofType:@"png"];
            img = [UIImage imageWithContentsOfFile:alertImagePath];
        }
        
        if (img) {
            UIImageView *imageView = [[UIImageView alloc]initWithImage:img];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.frame = singleInputCell.textField.frame;
            imageView.frame = CGRectMake(0, 0, imageView.frame.size.width-4, 44);
            imageView.center = singleInputCell.textField.center;
            
            [singleInputCell addSubview:imageView];
            [singleInputCell.textField removeFromSuperview];
            singleInputCell.textField = nil;
        }else{
            
            singleInputCell.textField.text = _bankName;
            singleInputCell.textField.enabled = NO;
        }
        
        
        
    }else if (indexPath.row == 2){
        [singleInputCell setTitleContent:@"银行卡号" andDetailContent:_cardNo];
    }else if (indexPath.row == 3){
        [singleInputCell setTitleContent:@"到账金额" andDetailContent:_realAmount];
    }else if (indexPath.row == 4){
        [singleInputCell setTitleContent:@"手续费" andDetailContent:_fee];
    }else if (indexPath.row == 5){
        [singleInputCell setTitleContent:@"合计扣除" andDetailContent:_sumAmount];
    }else if (indexPath.row == 6){
        if (!_passwordInputCell) {
            _passwordInputCell = [[MMMSingleInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            _passwordInputCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [_passwordInputCell setTitleContent:@"支付密码" andDetailContent:_payPassword];
            _passwordInputCell.textField.secureTextEntry = YES;
            _passwordInputCell.textField.tag = 1001;
            _passwordInputCell.textField.delegate = self;
            _passwordInputCell.textField.enabled = YES;
        }
        [_passwordInputCell setTitleContent:@"支付密码" andDetailContent:_payPassword];
        return _passwordInputCell;
        
    }
    singleInputCell.textField.enabled = NO;
    return singleInputCell;
}

#pragma mark - tableview header 

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        MMMHeaderView *view = [[MMMHeaderView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60) andNumOfLabel:1];
        
        NSString *title_1 = [NSString stringWithFormat:@"平台用户名: %@",_platformAccount];
        
        [view setContext:title_1 headerLabel2:nil hederLabel3:nil];
        return view;
    }
    return nil;
}

#pragma mark - tableview footer

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
        view.backgroundColor = [UIColor clearColor];
        
        if (!_withdrawBtn) {
            _withdrawBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, [UIScreen mainScreen].bounds.size.width-20, 50)];
            _withdrawBtn.backgroundColor = [UIColor colorWithRed:58.0f/255.0f green:108.0f/255.0f blue:241.0f/255.0f alpha:1];
            [_withdrawBtn setTitle:@"确认提现" forState:UIControlStateNormal];
            [_withdrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            _withdrawBtn.layer.masksToBounds = YES;
            _withdrawBtn.layer.cornerRadius = 5.0f;
            [_withdrawBtn addTarget:self action:@selector(withdrawBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (!self.findPasswordBtn) {
            self.findPasswordBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
            self.findPasswordBtn.backgroundColor = [UIColor clearColor];
            [self.findPasswordBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
            [self.findPasswordBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.findPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            self.findPasswordBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
            
            [self.findPasswordBtn addTarget:self action:@selector(findPassword:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [view addSubview:self.findPasswordBtn];
        
        [view addSubview:_withdrawBtn];
        return view;
    }
    return nil;
}

-(void)findPassword:(UIButton *)sender {
    MMMFindPasswordViewController *nextViewController = [[MMMFindPasswordViewController alloc]init
                                                         ];
    [self presentViewController:nextViewController animated:YES completion:^{
        
    }];
}

#pragma mark ------------------------

-(void)withdrawBtnPressed:(UIButton *)sender {
    if (_currentObj) {
        [_currentObj resignFirstResponder];
        _currentObj = nil;
    }
    
    if (!_payPassword || [[_payPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"密码不能为空,请填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    _withdrawBtn.enabled = NO;
    NSDictionary *paramsDic = @{@"payPassword":_payPassword,
                                @"cardid":_cardid,
                                @"wid":_wid,
                                @"Amount":_amount,
                                @"RecordId":_recordId,
                                @"phone":@"1"};
    
    NSString *paramsString = [MMMConfigUtil sharedConfigUtil].setPostString(paramsDic);
    [MMMActivityIndicatorView show];
    [MMMConfigUtil sharedConfigUtil].toLoanWithdraws(paramsString,^(NSData *data, NSError *error){
        _withdrawBtn.enabled = YES;
        [MMMActivityIndicatorView remove];
        if (!error) {
            
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            [self dealwithCallbackOfwithdraw:dict];
        }else{
            [self requestError:error];
        }
    });
    
    
    
}

-(void)dealwithCallbackOfwithdraw:(NSDictionary *)dict {

    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    
    if ([[dict allKeys] containsObject:@"Message"]) {
        [resultDic setObject:[dict objectForKey:@"Message"] forKey:@"Message"];
    }
    if ([[dict allKeys] containsObject:@"LoanNo"]) {
        NSString *string = [dict objectForKey:@"LoanNo"];
        [resultDic setObject:string forKey:@"LoanNo"];
    }
    if ([[dict allKeys] containsObject:@"FeeWithdraws"]) {
        NSString *string = [dict objectForKey:@"FeeWithdraws"];
        string = [string isEqualToString:@""]?@"0.00":string;
        [resultDic setObject:string forKey:@"FeeWithdraws"];
    }
    if ([[dict allKeys] containsObject:@"Fee"]) {
        NSString *string = [dict objectForKey:@"Fee"];
        string = [string isEqualToString:@""]?@"0.00":string;
        [resultDic setObject:string forKey:@"Fee"];
    }
    if ([[dict allKeys] containsObject:@"Amount"]) {
        NSString *string = [dict objectForKey:@"Amount"];
        string = [string isEqualToString:@""]?@"0.00":string;
        [resultDic setObject:string forKey:@"Amount"];
    }
    if ([[dict allKeys] containsObject:@"FeePercent"]) {
        NSString *string = [dict objectForKey:@"FeePercent"];
        [resultDic setObject:string forKey:@"FeePercent"];
    }
    if ([[dict allKeys] containsObject:@"FeeLimit"]) {
        NSString *string = [dict objectForKey:@"FeeLimit"];
        string = [string isEqualToString:@""]?@"0.00":string;
        [resultDic setObject:string forKey:@"FeeLimit"];
    }
    if ([[dict allKeys] containsObject:@"ResultCode"]) {
        [resultDic setObject:[dict objectForKey:@"ResultCode"] forKey:@"ResultCode"];
    }
    if (self.resultBlock)
        self.resultBlock(resultDic, MMMWithdrawEvent);
    
    ///////////////////////////
    
    
    if ([[dict allKeys] containsObject:@"ResultCode"]) {
        if ([[dict objectForKey:@"ResultCode"]isEqualToString:@"88"]) {
            
            self.theAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"提现成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            self.theAlert.tag = 1001;
            if (!self.view.window) {
                self.theAlert.delegate = nil;
            }
            [self.theAlert show];
            return;
        }else if ([[dict objectForKey:@"ResultCode"]isEqualToString:@"90"] || [[dict objectForKey:@"ResultCode"]isEqualToString:@"89"] ){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提现提示" message:[dict objectForKey:@"Message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.tag = 1001;
            if (!self.view.window) {
                alert.delegate = nil;
            }
            [alert show];
            return;
        }
        
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提现提示" message:[dict objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    _currentObj = nil;
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField.tag == 1001) {
        _payPassword = textField.text;
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    _currentObj = nil;
    _currentObj = textField;
}

#pragma mark - UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
   
    if (alertView.tag == 1001) {
        [self back:nil];
    }
}

@end
