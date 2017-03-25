//
//  MMMTransferController.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/21.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMTransferController.h"
#import "MMMTransferObject.h"
#import "MMMConfigUtil.h"
#import "MMMTransferInfoCell.h"
#import "MMMSingleInputCell.h"
#import "MMMHeaderView.h"
#import "MMMBankListViewController.h"

typedef void(^Block)(NSDictionary *dict);

@interface MMMTransferController ()
@property (nonatomic, strong) MMMTransferObject *transferObject;
@property (nonatomic, assign) BOOL hasGetImformation;
@property (nonatomic, strong) MMMSingleInputCell *passwordInputCell;
@property (nonatomic, strong) UIButton *transferBtn;
@property (nonatomic, weak) id currentObj;
@property (nonatomic, strong) UITableView *currentTableView;
@end

@implementation MMMTransferController
{
    NSString *_platformAccount;
    NSString *_moneymoremoreAccount;
    NSString *_loanList;
    NSString *_ids;
    NSString *_recordId;
    NSString *_loanJsonList;
    
    NSString *_payPassword;

    CGRect _currentRect;
    
    NSArray *_loanListArr;
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
    
    self.currentTableView.contentInset = UIEdgeInsetsZero;
}

-(void)keyboardWillShow:(NSNotification *) aNotification {
    NSDictionary *info = [aNotification userInfo];
    
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    float height = kbRect.size.height;
    
    if (height != 0) {
//        NSLog(@"the height of keyboard: %f",height);
        self.currentTableView.contentInset = UIEdgeInsetsMake(0, 0, height, 0);
    }
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (self.passwordInputCell.textField.isEditing) {
//        NSLog(@"正在输入验证码");
        CGRect rect = [self.currentTableView convertRect:self.transferBtn.frame fromView:self.transferBtn];
        [self.currentTableView scrollRectToVisible:rect animated:YES];
    }
}


-(void)setParams:(NSDictionary *)params
   signIfnoBlock:(NSString *(^)(NSString *signInfo, BOOL isSignWithPrivateKey))signBlock {
    [super setParams:params signIfnoBlock:signBlock];
    [self setParams:params];
    
}
-(void)setParams:(NSDictionary *)params
   signIfnoBlock:(NSString *(^)(NSString *, BOOL))signBlock
     resultBlock:(void (^)(NSDictionary *, MMMEventType))resultBlock
{
    [super setParams:params signIfnoBlock:signBlock resultBlock:resultBlock];
    [self setParams:params];
}

-(void)setParams:(NSDictionary *)params{
//    self.titleLabel.text = @"乾多多投标";
    self.titleLabel.text = @"乾多多转账";
    
    _currentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height) style:UITableViewStyleGrouped];
    _currentTableView.delegate = (id)self;
    _currentTableView.dataSource = (id)self;
    _currentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.contentView addSubview:_currentTableView];
    
    _transferObject = [[MMMTransferObject alloc]init];
    [_transferObject setValuesForKeysWithDictionary:params];
    
    if (![self checkNecessaryParams:"MMMTransferObject" tagertObj:_transferObject]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"提交的数据,缺少必要参数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([_transferObject.Action isEqualToString:@"2"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"乾多多手机托管暂不支持自动转账" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }

//    _transferObject.LoanJsonList = [self stringByURLEncodingStringParameter:_transferObject.LoanJsonList];
    
    
    NSString *signDataStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@",
                             _transferObject.LoanJsonList,
                             _transferObject.PlatformMoneymoremore,
                             _transferObject.TransferAction,
                             _transferObject.Action,
                             _transferObject.TransferType,
                             _transferObject.NeedAudit,
                             _transferObject.RandomTimeStamp,
                             _transferObject.Remark1,
                             _transferObject.Remark2,
                             _transferObject.Remark3,
                             _transferObject.ReturnURL,
                             _transferObject.NotifyURL];
    
    //  得到RSA签名过后的字符串
    NSString *signString = self.signInfoBlock(signDataStr,YES);
    if (!signString) {
        signString = @"";
    }
    [MMMActivityIndicatorView show];
    
    NSString *loanJson = [self stringByURLEncodingStringParameter:_transferObject.LoanJsonList];
    
    NSMutableDictionary *mParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [mParams setObject:loanJson forKey:@"LoanJsonList"];
    
    [MMMConfigUtil sharedConfigUtil].beginServiceWithDict(MMMTransferEvent, mParams, [signString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],^(NSData *data,NSError *error){
        [MMMActivityIndicatorView remove];
        if (self.view.window) {
            if ([[NSString stringWithFormat:@"%@",_transferObject.Action] isEqualToString:@"2"]) {
                return;
            }
            
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
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([_transferObject.Action isEqualToString:@"2"]) {
        self.currentTableView.delegate = nil;
        self.currentTableView.dataSource = nil;
        [self.currentTableView removeFromSuperview];
        self.currentTableView = nil;
        
        [self.toolbar removeFromSuperview];
        [self.contentView removeFromSuperview];
        [self.titleLabel removeFromSuperview];
        
        self.view.backgroundColor = [UIColor clearColor];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - 数据回调处理

-(void)dealWithRequestCallback:(NSDictionary *)dict {
    
    if ([[dict allKeys] containsObject:@"Message"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[dict objectForKey:@"Message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.delegate = self;
        alert.tag = 1001;
        [alert show];
        return;
    }
    
    if ([[dict allKeys] containsObject:@"LoanJsonList"]) {
        _loanJsonList = [dict objectForKey:@"LoanJsonList"];
    }
    if ([[dict allKeys] containsObject:@"PlatformAccount"]) {
        _platformAccount = [dict objectForKey:@"PlatformAccount"];
    }
    if ([[dict allKeys] containsObject:@"MoneymoremoreAccount"]) {
        _moneymoremoreAccount = [dict objectForKey:@"MoneymoremoreAccount"];
    }
    if ([[dict allKeys] containsObject:@"LoanList"]) {
        _loanList = [dict objectForKey:@"LoanList"];
        NSData *loanListData = [_loanList dataUsingEncoding:NSUTF8StringEncoding];
        _loanListArr = [NSJSONSerialization JSONObjectWithData:loanListData options:NSJSONReadingMutableContainers error:nil];
    }
    if ([[dict allKeys] containsObject:@"RecordId"]) {
        _recordId = [dict objectForKey:@"RecordId"];
    }
    if ([[dict allKeys] containsObject:@"LoanJsonList"]) {
        _loanJsonList = [dict objectForKey:@"LoanJsonList"];
    }
    if ([[dict allKeys] containsObject:@"ids"]) {
        _ids = [dict objectForKey:@"ids"];
    }
    
    _hasGetImformation = YES;
//    NSLog(@"转账回调: %@",dict);
    [_currentTableView reloadData];
}

-(void)requestError:(NSError *)error{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:
                          [error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}


#pragma mark - UITableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _hasGetImformation?1:0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _loanListArr.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MMMTransferInfoCellIdentifier = @"MMMTransferInfoCellIdentifier";
    static NSString *MMMSingleInputCellIdentifier = @"MMMSingleInputCellIdentifier";
    
    MMMSingleInputCell *singleInputCell;
    singleInputCell = [tableView dequeueReusableCellWithIdentifier:MMMSingleInputCellIdentifier];
    
    MMMTransferInfoCell *infoCell;
    infoCell = [tableView dequeueReusableCellWithIdentifier:MMMTransferInfoCellIdentifier];
    
    if (indexPath.row == _loanListArr.count) {
        if (!singleInputCell) {
            singleInputCell = [[MMMSingleInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MMMSingleInputCellIdentifier];
            singleInputCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else{
        if (!infoCell) {
            infoCell = [[MMMTransferInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MMMTransferInfoCellIdentifier];
            infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    if (indexPath.row == _loanListArr.count) {
        [singleInputCell setTitleContent:@"支付密码" andDetailContent:_payPassword];
        singleInputCell.textField.secureTextEntry = YES;
        singleInputCell.textField.tag = 1001;
        singleInputCell.textField.delegate = (id)self;
        return singleInputCell;
    }else{
        NSDictionary *loanObj = _loanListArr[indexPath.row];
        NSString *amount;
        NSString *inName;
        NSString *inMoneymoremore;
        
        if ([[loanObj allKeys] containsObject:@"Amount"]) {
            amount = [loanObj objectForKey:@"Amount"];
        }
        if ([[loanObj allKeys] containsObject:@"InName"]) {
            inName = [loanObj objectForKey:@"InName"];
        }
        if ([[loanObj allKeys] containsObject:@"InMoneymoremore"]) {
            inMoneymoremore = [loanObj objectForKey:@"InMoneymoremore"];
        }
        
        infoCell.titleLabel.text = [NSString stringWithFormat:@"收款人姓名: %@",inName];
        infoCell.contentLabel_1.text = [NSString stringWithFormat:@"乾多多账户: %@",inMoneymoremore];
        infoCell.contentLabel_2.text = [NSString stringWithFormat:@"转账金额: %@",amount];
    }
    
    
    return infoCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < _loanListArr.count) {
        return 100;
    }else
        return 60;
}

#pragma mark - tableview header

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 60;
    }else{
        return 0;
    }
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
    if (section == 0) {
        return 80;
    }else{
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
        view.backgroundColor = [UIColor clearColor];
        if (!self.transferBtn) {
            _transferBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width-20, 50)];
            _transferBtn.backgroundColor = [UIColor colorWithRed:58.0f/255.0f green:108.0f/255.0f blue:241.0f/255.0f alpha:1];
            //        [btn setTitle:@"确认投标" forState:UIControlStateNormal];
            [_transferBtn setTitle:@"确认转账" forState:UIControlStateNormal];
            [_transferBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            _transferBtn.layer.masksToBounds = YES;
            _transferBtn.layer.cornerRadius = 5.0f;
            [_transferBtn addTarget:self action:@selector(transferBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        [view addSubview:_transferBtn];
        return view;
    }
    return nil;
}
-(void)transferBtnPressed:(UIButton *)sender {
    if (_currentObj) {
        [_currentObj resignFirstResponder];
        _currentObj = nil;
    }
    
    if (!_payPassword || [[_payPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"密码不能为空,请填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    sender.enabled = NO;
    
    NSDictionary *paramsDic = @{@"payPassword":_payPassword,
                                @"ids":_ids,
                                @"LoanJsonList":_loanJsonList,
                                @"RecordId":_recordId,
                                @"phone":@"1"};
    
    NSString *paramsString = [MMMConfigUtil sharedConfigUtil].setPostString(paramsDic);
    
    [MMMActivityIndicatorView show];
    [MMMConfigUtil sharedConfigUtil].toLoanact(paramsString,^(NSData *data, NSError *error){
        sender.enabled = YES;
        [MMMActivityIndicatorView remove];
        if (!error) {
            id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            [self dealWithCallbackOfTransfer:obj];
        }else{
            [self requestError:error];
        }
    });
}

-(void)dealWithCallbackOfTransfer:(id)obj {
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    Block block = ^(NSDictionary *dict){
        if ([[dict allKeys] containsObject:@"Message"]) {
            [resultDic setObject:[dict objectForKey:@"Message"] forKey:@"Message"];
        }
        if ([[dict allKeys] containsObject:@"ResultCode"]) {
            [resultDic setObject:[dict objectForKey:@"ResultCode"] forKey:@"ResultCode"];
        }
        if (self.resultBlock) self.resultBlock(resultDic, MMMTransferEvent);
    };
    
    /////////////////////
    Block alertBlock = ^(NSDictionary *dict){
            if ([[dict objectForKey:@"ResultCode"] isEqualToString:@"88"]) {
                
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"投标转账"
                                                               message:[dict objectForKey:@"Message"]
                                                              delegate:self
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                if (!self.view.window) alert.delegate = nil;
                alert.tag = 1001;
                [alert show];
                //            }
                
            }else{
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"投标转账" message:[dict objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        
    };
    
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = obj;
        
        if ([[dict allKeys] containsObject:@"ResultCode"]) {
            alertBlock(dict);
        }
        block(dict);
        
    }else if ([obj isKindOfClass:[NSArray class]]){
        NSDictionary *dict = [obj firstObject];
        if ([[dict allKeys] containsObject:@"ResultCode"]) {
            alertBlock(dict);
        }
        block(dict);
    }else{
        [resultDic setObject:obj forKey:@"Message"];
        [resultDic setObject:@"0" forKey:@"ResultCode"];
        
        if (self.resultBlock) self.resultBlock(resultDic, MMMTransferEvent);
    }
    
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

#pragma mark - UIAlertView delegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1001) {
        [self back:nil];
    }
}

#pragma mark ----------
- (NSString*)stringByURLEncodingStringParameter:(NSString *)string
{
    // NSURL's stringByAddingPercentEscapesUsingEncoding: does not escape
    // some characters that should be escaped in URL parameters, like / and ?;
    // we'll use CFURL to force the encoding of those
    //
    // We'll explicitly leave spaces unescaped now, and replace them with +'s
    //
    // Reference: <a href="%5C%22http://www.ietf.org/rfc/rfc3986.txt%5C%22" target="\"_blank\"" onclick='\"return' checkurl(this)\"="" id="\"url_2\"">http://www.ietf.org/rfc/rfc3986.txt</a>
    
    NSString *resultStr = string;
    
    CFStringRef originalString = (__bridge CFStringRef) string;
    CFStringRef leaveUnescaped = CFSTR(" ");
    CFStringRef forceEscaped = CFSTR("!*'();:@&=+$,/?%#[]");
    
    CFStringRef escapedStr;
    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                         originalString,
                                                         leaveUnescaped,
                                                         forceEscaped,
                                                         kCFStringEncodingUTF8);
    
    if( escapedStr )
    {
        NSMutableString *mutableStr = [NSMutableString stringWithString:(__bridge NSString *)escapedStr];
        CFRelease(escapedStr);
        
        // replace spaces with plusses
        [mutableStr replaceOccurrencesOfString:@" "
                                    withString:@"%20"
                                       options:0
                                         range:NSMakeRange(0, [mutableStr length])];
        resultStr = mutableStr;
    }
    return resultStr;
}
@end
