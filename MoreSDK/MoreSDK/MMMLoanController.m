//
//  MMMLoanController.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/20.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMLoanController.h"
#import "MMMLoanObject.h"
#import "MMMConfigUtil.h"
#import "MMMHeaderView.h"
#import "MMMSingleInputCell.h"
#import "MMMSendMessageCell.h"
#import "MMMBankListTableView.h"
#import "MMMPasswordInputCell.h"
#import "MMMBankObject.h"
#import "MMMBankUtil.h"
#import "MMMOptionTableView.h"
#import "MMMBankListViewController.h"

#define kLoanRequestTag 0
#define kSendMsgTag 1
#define kLoanBtnTag 2

typedef void(^BankListRequestBlock)(void);

@interface MMMLoanController ()
<UIAlertViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *bandBackgroundBtn;
@property (nonatomic, assign) BOOL hasGetImformation;
@property (nonatomic, copy) BankListRequestBlock bankListRequestBlock;
@property (nonatomic, strong) NSArray *bankList;
@property (nonatomic, strong) MMMBankObject *selectedBank;
@property (nonatomic, weak) id currentObj;
@property (nonatomic, strong) UIButton *loanBtn;
@property (nonatomic, weak) UIButton *sendMsgBtn;
@property (nonatomic, strong) UITableView *currentTableView;
@property (nonatomic, strong) MMMSingleInputCell *cardNoInputCell;
@property (nonatomic, strong) MMMSingleInputCell *phoneInputCell;
@property (nonatomic, strong) MMMSendMessageCell *sendMessageCell;

@property(nonatomic, strong) id logObj;
@end

@implementation MMMLoanController
{
@private
    NSString *_amount;
    NSString *_identificationNo;
    NSString *_moneymoremoreAccount;
    NSString *_platformAccount;
    NSString *_realName;
    NSString *_recordId;
    NSString *_rid;
    NSArray *_usedCardList;
    id _tempObj;
    
    NSString *_txtCardType;
    NSString *_txtBankCode;
    NSString *_bankCode;
    NSString *_txtCardNo;
    NSString *_mobile;
    NSString *_paycode;
    
    NSIndexPath *_indexPath;
    CGRect _currentRect;
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
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
        self.currentTableView.contentInset = UIEdgeInsetsMake(0, 0, height, 0);
    }
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (self.sendMessageCell.textField.isEditing) {
//        NSLog(@"正在输入验证码");
        CGRect rect = [self.currentTableView convertRect:self.loanBtn.frame fromView:self.loanBtn];
        [self.currentTableView scrollRectToVisible:rect animated:YES];
    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
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
    self.titleLabel.text = @"乾多多充值";
    
    _currentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height) style:UITableViewStyleGrouped];
    _currentTableView.delegate = (id)self;
    _currentTableView.dataSource = (id)self;
    _currentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.contentView addSubview:_currentTableView];
    
    MMMLoanObject* loanObject = [[MMMLoanObject alloc]init];
    [loanObject setValuesForKeysWithDictionary:params];
    
    if (![self checkNecessaryParams:"MMMLoanObject" tagertObj:loanObject]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"提交的数据,缺少必要参数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *signDataStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@",
                             loanObject.RechargeMoneymoremore,
                             loanObject.PlatformMoneymoremore,
                             loanObject.OrderNo,
                             loanObject.Amount,
                             loanObject.RechargeType,
                             loanObject.FeeType,
                             loanObject.CardNo,
                             loanObject.RandomTimeStamp,
                             loanObject.Remark1,
                             loanObject.Remark2,
                             loanObject.Remark3,
                             loanObject.ReturnURL,
                             loanObject.NotifyURL];
    
    //  得到RSA签名过后的字符串
    NSString *signString = self.signInfoBlock(signDataStr,YES);
    if (!signString) {
        signString = @"";
    }
    
    [MMMActivityIndicatorView show];
    
    double delayInSeconds = 0.3;

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [MMMConfigUtil sharedConfigUtil].beginServiceWithDict(MMMLoanEvent, params, [signString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],^(NSData *data,NSError *error){
            [MMMActivityIndicatorView remove];
            if (self.view.window) {
                if (!error) {
                    [self callBackOfRequest:data withTag:kLoanRequestTag];
                }
                //  网络异常
                else{
                    [super errorOfCallBack:error];
                }
            }
        });
        
    
    });
    
}

#pragma mark - 数据回调处理

-(void)callBackOfRequest:(NSData *)data withTag:(NSUInteger)tag{
    
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if (![dict isKindOfClass:[NSDictionary class]]) {
        
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alertView.tag = 1001;
            [alertView show];
        
        return;
    }
    
    SimpleBlock block_1 = ^{
        if ([[dict allKeys] containsObject:@"Message"]) {
            self.theAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:[dict objectForKey:@"Message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            if (!self.view.window) self.theAlert.delegate = nil;
            self.theAlert.tag = 1001;
            [self.theAlert show];
            return;
        }
        
        _hasGetImformation = YES;
        _amount = [dict objectForKey:@"Amount"];
        _identificationNo = [dict objectForKey:@"IdentificationNo"];
        _moneymoremoreAccount = [dict objectForKey:@"MoneymoremoreAccount"];
        _platformAccount = [dict objectForKey:@"PlatformAccount"];
        _realName = [dict objectForKey:@"RealName"];
        _recordId = [dict objectForKey:@"RecordId"];
        _rid = [dict objectForKey:@"rid"];
        
        if ([dict.allKeys containsObject:@"UsedCardList"]){
            NSString *usedCardListString = [dict objectForKey:@"UsedCardList"];
            _tempObj = [NSJSONSerialization JSONObjectWithData:[usedCardListString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *bankTempArr = [NSMutableArray array];
            for (NSDictionary *bankDic in _tempObj) {
                MMMBankObject *bankObj = [[MMMBankObject alloc]init];
                [bankObj setValuesForKeysWithDictionary:bankDic];
                [bankTempArr addObject:bankObj];
            }
            
            ////////////////////
            _usedCardList = [NSArray arrayWithArray:bankTempArr];
            
            NSMutableArray *listArr = [NSMutableArray array];
            for (MMMBankObject *bankObj in _usedCardList) {
                NSString *string = [NSString stringWithFormat:@"%@ | %@",bankObj.BankName,bankObj.CardNo ];
                [listArr addObject:string];
            }
        }
        
        
        
        [_currentTableView reloadData];
        
        //  请求可用银行列表数据
        NSString *URLString = [MMMConfigUtil sharedConfigUtil].getBanklistByType();
        URLString = [NSString stringWithFormat:@"%@?phone=1&cardtype=0&act=1",URLString];
        NSURL *url = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
        
        NSString *result = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        _bankList = [[[MMMBankUtil alloc]init]parseBankListString:result];

        
    };
    
    ////////////////////
    
    if (tag == kLoanRequestTag) {
        block_1();
    }else if (tag == kSendMsgTag) {
        [_sendMsgBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        _sendMsgBtn.enabled = YES;
        _logObj= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

        [self dealWithCallbackOfSendMsg:_logObj];
    }else if (tag == kLoanBtnTag) {
        _loanBtn.enabled = YES;
        id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [self dealWithCallbackOfLoan:obj];
    }
    
}

-(void)errorOfCallBack:(NSError *)error{
    [super errorOfCallBack:error];
    _loanBtn.enabled = YES;
    [_sendMsgBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    _sendMsgBtn.enabled = YES;
}

#pragma mark - UITableView Delegate


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _hasGetImformation?1:0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_currentObj) {
        [_currentObj resignFirstResponder];
        [tableView reloadData];
        _currentObj = nil;
    }
    
    if (indexPath.row == 3) {
        _bandBackgroundBtn = [[UIButton alloc]initWithFrame:self.view.frame];
        _bandBackgroundBtn.backgroundColor = [UIColor clearColor];
        [_bandBackgroundBtn addTarget:self action:@selector(clearScreen:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat marginTop = 0;
        if ([UIScreen mainScreen].bounds.size.height == 480 ) {
            marginTop = 20.0;
        }else if ([UIScreen mainScreen].bounds.size.height >= 568){
            marginTop = 100;
        }
        
        
        MMMBankListTableView *bankListTableView = [[MMMBankListTableView alloc]initWithFrame:CGRectMake(0, 0, 280, [UIScreen mainScreen].bounds.size.height-64-marginTop*2) style:UITableViewStylePlain bankList:_bankList];
        [_bandBackgroundBtn addSubview:bankListTableView];
        bankListTableView.center = _bandBackgroundBtn.center;
        bankListTableView.center = CGPointMake(bankListTableView.center.x, bankListTableView.frame.size.height/2 + 64+marginTop);
        bankListTableView.tapBlock = ^(NSIndexPath *indexPath, id object){
            if ([object isKindOfClass:[MMMBankObject class]]) {
                _selectedBank = object;
                _txtBankCode = _selectedBank.BankId; //////
                _bankCode = _selectedBank.BankCode;
                [_currentTableView reloadData];
                [self clearScreen:nil];
            }
            
        };
        [self.view addSubview:_bandBackgroundBtn];
    }
}


#pragma mark - UITableViewCell

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MMMSingleInputCellIdentifier = @"MMMSingleInputCellIdentifier";
    static NSString *MMMSendMessageCellIdentifier = @"MMMSendMessageCellIdentifier";
    
    MMMSingleInputCell *singleInputCell;
    MMMSendMessageCell *smsCell;
    
    singleInputCell = [tableView dequeueReusableCellWithIdentifier:MMMSingleInputCellIdentifier];
    smsCell = [tableView dequeueReusableCellWithIdentifier:MMMSendMessageCellIdentifier];
    
    if (indexPath.row <= 5) {
        if (!singleInputCell){
            singleInputCell = [[MMMSingleInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            singleInputCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else if (indexPath.row == 6){
        if (!smsCell) {
            smsCell = [[MMMSendMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MMMSendMessageCellIdentifier];
            smsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    
    if (indexPath.row == 0) {
        [singleInputCell setTitleContent:@"充值金额: " andDetailContent:_amount];
        singleInputCell.textField.enabled = NO;
    }else if (indexPath.row == 1){
        [singleInputCell setTitleContent:@"开户名" andDetailContent:_realName];
        singleInputCell.textField.enabled = NO;
    }else if (indexPath.row == 2){
        [singleInputCell setTitleContent:@"身份证" andDetailContent:_identificationNo];
        singleInputCell.textField.enabled = NO;
    }else if (indexPath.row == 3){
        [singleInputCell setTitleContent:@"开户行" andDetailContent:@"   "];
        singleInputCell.textField.enabled = NO;
        singleInputCell.textField.placeholder = @"";
        if (_selectedBank) {
            NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"MMMBankSDK" ofType:@"bundle"]];
            NSString *alertImagePath = [bundle pathForResource:_selectedBank.BankCode ofType:@"png"];
            UIImage *img = [UIImage imageWithContentsOfFile:alertImagePath];
            
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
                singleInputCell.textField.text = _selectedBank.BankName;
                
            }
            
        }
        
        singleInputCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    ////////////////
    else if (indexPath.row == 4){
        
        if (!_cardNoInputCell) {
            _cardNoInputCell = [[MMMSingleInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [_cardNoInputCell setTitleContent:@"银行卡号" andDetailContent:_txtCardNo];
            _cardNoInputCell.selectionStyle = UITableViewCellSelectionStyleNone;
            _cardNoInputCell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            _cardNoInputCell.textField.delegate = self;
            _cardNoInputCell.textField.tag = 1001;
            _cardNoInputCell.textField.returnKeyType = UIReturnKeyDone;
            if (_usedCardList && _usedCardList.count > 0) {
                
                NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"MMMBankSDK" ofType:@"bundle"]];
                NSString *alertImagePath = [bundle pathForResource:@"bankCard" ofType:@"png"];
                UIImage *img = [UIImage imageWithContentsOfFile:alertImagePath];
            
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn addTarget:self action:@selector(showBankListViewController:) forControlEvents:UIControlEventTouchUpInside];
                if (img) {
                    UIGraphicsBeginImageContext(CGSizeMake(img.size.width/5*2, img.size.height/5*2));
                    [img drawInRect:CGRectMake(0, 0, img.size.width/5*2, img.size.height/5*2)];
                    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                    btn.frame = CGRectMake(0, 0, img.size.width/5*2, img.size.height/5*2);
                    [btn setBackgroundImage:newImage forState:UIControlStateNormal];
                    btn.backgroundColor = [UIColor clearColor];
                    
                    UIGraphicsEndImageContext();
                }else{
                    btn.frame = CGRectMake(0, 0, 25, 25);
                    [btn setTitle:@"选卡" forState:UIControlStateNormal];
                    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                    btn.backgroundColor = [UIColor lightGrayColor];
                }
                _cardNoInputCell.accessoryView = btn;
            }
            
        }
        
        [_cardNoInputCell setTitleContent:@"银行卡号" andDetailContent:_txtCardNo];
        return _cardNoInputCell;
        
    }else if (indexPath.row == 5){
        
        if (!_phoneInputCell) {
            _phoneInputCell = [[MMMSingleInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [_phoneInputCell setTitleContent:@"预留号码" andDetailContent:_mobile];
            _phoneInputCell.textField.delegate = self;
            _phoneInputCell.textField.tag = 1002;
            _phoneInputCell.textField.returnKeyType = UIReturnKeyDone;
            _phoneInputCell.textField.keyboardType = UIKeyboardTypeNamePhonePad;
            _phoneInputCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [_phoneInputCell setTitleContent:@"预留号码" andDetailContent:_mobile];
        return _phoneInputCell;
        
    }else if (indexPath.row == 6){
        
        if (!_sendMessageCell) {
            _sendMessageCell = [[MMMSendMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            _sendMessageCell.textField.delegate = (id)self;
            _sendMessageCell.textField.tag = 1003;
            _sendMessageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            _sendMessageCell.textField.keyboardType = UIKeyboardTypeNamePhonePad;
            _sendMsgBtn = smsCell.sendMsgBtn;
            _sendMessageCell.textField.returnKeyType = UIReturnKeyDone;
            _sendMessageCell.textField.delegate = self;
            [_sendMessageCell sendMessageBtnPressed:^BOOL{
                
                if (_currentObj) {
                    [_currentObj resignFirstResponder];
                    _currentObj = nil;
                }
                
                if (!_bankCode || [[_bankCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""]) {
                    self.theAlert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"开户行为空,请填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [self.theAlert show];
                    return NO;
                }
                
                if (!_txtBankCode || [[_txtBankCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""]) {
                    self.theAlert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"开户行为空,请选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [self.theAlert show];
                    return NO;
                }
                
                
                if (!_txtCardNo || [[_txtCardNo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""]) {
                    self.theAlert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"银行卡号为空,请填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [self.theAlert show];
                    return NO;
                }
                
                if (!_mobile || [[_mobile stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""]) {
                    self.theAlert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"预留号码为空,请填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [self.theAlert show];
                    return NO;
                }
                
                _sendMsgBtn.enabled = NO;
                
                NSDictionary *paramsDic = @{@"bank":_bankCode,
                                            @"cardNumber":_txtCardNo,
                                            @"realName":_realName,
                                            @"paperKind":@"I",
                                            @"paperNO":_identificationNo,
                                            @"phoneNO":_mobile,
                                            @"phone":@"1",
                                            @"amount":_amount};
                
                NSString *paramsString = [MMMConfigUtil sharedConfigUtil].setPostString(paramsDic);
                
                [MMMActivityIndicatorView show];
                [MMMConfigUtil sharedConfigUtil].toSendDKPhoneCode(paramsString,^(NSData *data, NSError *error){
                    [MMMActivityIndicatorView remove];
                    _sendMsgBtn.enabled = YES;
                    if (!error) {
                        [self callBackOfRequest:data withTag:kSendMsgTag];
                    }
                    //  网络异常
                    else{
                        [super errorOfCallBack:error];
                    }
                });
                return YES;
            }];
        }
        _sendMessageCell.textField.text = _paycode;
        _sendMessageCell.textField.placeholder = @"请填写验证码";
        [_sendMessageCell.sendMsgBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        
        return _sendMessageCell;
    }
    
    singleInputCell.textField.delegate = (id)self;
    singleInputCell.textField.returnKeyType = UIReturnKeyDone;
    
    return singleInputCell;
    
}

-(void)showBankListViewController:(UIButton *)sender{
    
    MMMBankListViewController *viewController = [[MMMBankListViewController alloc]init];
    [viewController didSelectIndexPath:^(NSIndexPath *indexPath, MMMBankObject *bankObj) {
        _selectedBank = bankObj;
        _txtBankCode = _selectedBank.BankId;
        _bankCode = _selectedBank.BankCode;
        _txtCardNo = _selectedBank.CardNo;
        _mobile = _selectedBank.Mobile;
        [_currentTableView reloadData];
    }];
    viewController.titleLabel.text = @"银行卡选择";
    [viewController setupBankListData:_usedCardList];
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - UITableView's HeaderView

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (_moneymoremoreAccount && ![[_moneymoremoreAccount stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] ) {
            return 60;
        }else{
            return 50;
        }
    }else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        MMMHeaderView *view ;
        if (_moneymoremoreAccount && ![[_moneymoremoreAccount stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] ) {
            
            view = [[MMMHeaderView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60) andNumOfLabel:2];
            NSString *title_1 = [NSString stringWithFormat:@"平台用户名: %@",_platformAccount];
            NSString *title_2 = [NSString stringWithFormat:@"乾多多账户: %@",_moneymoremoreAccount];
            
            [view setContext:title_1 headerLabel2:title_2 hederLabel3:nil];
            return view;
        }else{
            
            view = [[MMMHeaderView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50) andNumOfLabel:1];
            NSString *title_1 = [NSString stringWithFormat:@"平台用户名: %@",_platformAccount];
            
            [view setContext:title_1 headerLabel2:nil hederLabel3:nil];
            return view;
        }
        
    }
    return nil;
}

#pragma mark - UITableView's FooterView

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 80;
    }else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 90)];
        view.backgroundColor = [UIColor clearColor];
        
        if (!_loanBtn) {
            _loanBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width-20, 50)];
            _loanBtn.backgroundColor = [UIColor colorWithRed:58.0f/255.0f green:108.0f/255.0f blue:241.0f/255.0f alpha:1];
            [_loanBtn setTitle:@"确认充值" forState:UIControlStateNormal];
            [_loanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            _loanBtn.layer.masksToBounds = YES;
            _loanBtn.layer.cornerRadius = 5.0f;
            [_loanBtn addTarget:self action:@selector(loanBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [view addSubview:_loanBtn];
        return view;
    }
    return nil;
}

#pragma mark - ----------------------


-(void)dealWithCallbackOfSendMsg:(id)obj {
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = obj;
        if ([[dict allKeys] containsObject:@"sendResult"]) {
            NSString *message = [dict objectForKey:@"sendResult"];
            if ([message isKindOfClass:[NSNull class]] || message==nil || [message isEqualToString:@""]){
                message = @"系统异常";
            }
            [NSString stringWithFormat:@"%@",message];
            self.theAlert = [[UIAlertView alloc]initWithTitle:@"短信提示" message: [NSString stringWithFormat:@"%@",message] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [self.theAlert show];
        }
    }
}

-(void)clearScreen:(UIButton *)sender {
    if (_bandBackgroundBtn) {
        [_bandBackgroundBtn removeFromSuperview];
        _bandBackgroundBtn=nil;
    }
}

-(void)loanBtnPressed:(UIButton *)sender {
    
    if (_currentObj){
        [_currentObj resignFirstResponder];
        _currentObj = nil;
    }
    
    if (!_txtBankCode || [[_txtBankCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""]) {
        self.theAlert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"开户行为空,请选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [self.theAlert show];
        return;
    }
    
    
    if (!_txtCardNo || [[_txtCardNo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""]) {
        self.theAlert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"银行卡号为空,请填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [self.theAlert show];
        return;
    }
    
    if (!_mobile || [[_mobile stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""]) {
        self.theAlert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"预留号码为空,请填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [self.theAlert show];
        return;
    }
    
    if (!_paycode || [[_paycode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""]){
        self.theAlert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"验证码为空,请填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [self.theAlert show];
        return;
    }
    
    NSString *regex2 = @"^(\\d{15,30})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if (![bankCardPredicate evaluateWithObject:_txtCardNo]){
        self.theAlert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"银行卡号错误,请重新填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [self.theAlert show];
        return;
    }
    
    _loanBtn.enabled = NO;
    
    NSDictionary *paramsDic = @{@"TxtCardType":@"0",
                                @"TxtBankCode":_txtBankCode,
                                @"TxtCardNo":_txtCardNo,
                                @"Mobile":_mobile,
                                @"paycode":_paycode,
                                @"amount":_amount,
                                @"rid":_rid,
                                @"RecordId":_recordId,
                                @"phone":@"1"};
    
    [MMMActivityIndicatorView show];
    [MMMConfigUtil sharedConfigUtil].toRechargeFastPayWithDic(paramsDic,^(NSData *data, NSError *error){
        _loanBtn.enabled = YES;
        [MMMActivityIndicatorView remove];
        if (!error) {
            [self callBackOfRequest:data withTag:kLoanBtnTag];
        }
        //  网络异常
        else{
            [super errorOfCallBack:error];
        }
    });
    
}

-(void)dealWithCallbackOfLoan:(id)obj {
    
    if ([obj isKindOfClass:[NSDictionary class]]){
        NSDictionary *dict = obj;
        
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        
        if ([[dict allKeys] containsObject:@"Message"]) {
            [resultDic setObject:[dict objectForKey:@"Message"] forKey:@"Message"];
        }
        if ([[dict allKeys] containsObject:@"LoanNo"]) {
            [resultDic setObject:[dict objectForKey:@"LoanNo"] forKey:@"LoanNo"];
        }
        if ([[dict allKeys] containsObject:@"ResultCode"]) {
            [resultDic setObject:[dict objectForKey:@"ResultCode"] forKey:@"ResultCode"];
        }
        if (self.resultBlock)
            self.resultBlock(resultDic, MMMLoanEvent);
        
        //////////////////////////////
        
        if (self.view.window) {
            if ([dict.allKeys containsObject:@"ResultCode"]) {
                if ([[dict objectForKey:@"ResultCode"]isEqualToString:@"88"]) {
                    self.theAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"充值成功" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil];
                    if (!self.view.window) self.theAlert.delegate = nil;
                    self.theAlert.tag = 1001;
                    [self.theAlert show];
                    return;
                }
            }
            
            
            self.theAlert = [[UIAlertView alloc]initWithTitle:@"充值出错" message:[dict objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil];
            [self.theAlert show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        alertView.tag = -1;
        [self back:nil];
    }
}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    _currentObj = nil;
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _currentObj = nil;
    _currentObj = textField;
    
    CGRect rect = [self.currentTableView convertRect:textField.frame fromView:textField];
//    NSLog(@"x: %f, y: %f, width: %f, height: %f",rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    _currentRect = rect;
    
    return YES;
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    int tag = (int)textField.tag;
    if (tag == 1001){
        _txtCardNo = textField.text;
    }else if (tag == 1002){
        _mobile = textField.text;
    }else if (tag == 1003){
        _paycode = textField.text;
    }
    
    [_currentTableView reloadData];
    return YES;
}


@end
