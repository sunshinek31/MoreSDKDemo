//
//  MMMToloanfastpayViewController.m
//  MoreSDK
//
//  Created by immortal on 15/7/17.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMToloanfastpayController.h"
#import "MMMToloanfastpayObject.h"
#import "MMMConfigUtil.h"
#import "MMMThreeInOneInfoView.h"
#import "MMMSingleInputView.h"
#import "MMMSendMessageView.h"
#import "MMMBankListViewController.h"
#import "MMMBankListTableView.h"
#import "MMMBankUtil.h"
#import "MMMConfigUtil.h"
#import "MMMRequestUtil.h"
#import "MMMBankObject.h"
#import "MMMCoverView.h"
#import "MMMProvinceAndCityParser.h"
@interface MMMToloanfastpayController ()<UIActionSheetDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong,nonatomic)MMMToloanfastpayObject *toloanfastpayObjext;
@property (nonatomic, assign) BOOL hasGetImformation;
@property (nonatomic,strong) NSDictionary *showInfoDic;
@property (strong,nonatomic) NSArray *bankList;
@property (strong,nonatomic) MMMBankObject *bankObj;
@property (weak,nonatomic) MMMBankListTableView *bankListView;
@property (weak,nonatomic) MMMSingleInputView *bankView;
@property (weak,nonatomic) MMMSingleInputView *modifyTypeView;
@property (weak,nonatomic) UIView *cover;
@property (weak,nonatomic) UIImageView *commitView;
@property (weak,nonatomic) MMMSingleInputView *cardNoView;
@property (weak,nonatomic) MMMSendMessageView *messageView;
@property (weak,nonatomic) MMMSingleInputView *mobileView;
@property (weak,nonatomic) MMMSingleInputView *amountView;
@property (weak,nonatomic) MMMThreeInOneInfoView *infoView;
@property (weak,nonatomic) UIButton *commitButton;
@property (weak,nonatomic) UIScrollView *scrollView;

@property (weak,nonatomic) id correctObj;
@property (strong,nonatomic) NSArray *provincesArr;
@property (strong,nonatomic) NSArray *citysArr;
@property (weak,nonatomic) UIView *pickerView;
@property (weak,nonatomic) MMMSingleInputView *provinceView;
@property (weak,nonatomic) MMMSingleInputView *cityView;
@property (weak,nonatomic) MMMSingleInputView *branchBankView;

@end

@implementation MMMToloanfastpayController
{
    NSString *_flag;
    NSString *_CompanyName;
    NSString *_PlatformName;
    NSString *_LoanPlatformAccount;
    NSString *_MoneymoremoreAccount;
    NSString *_RealName;
    NSString *_IdentificationNo;
    NSString *_AccountType;
    NSString *_CardBindType;
    NSString *_BankName;
    NSString *_CardNo;
    NSString *_CityInfo;
    NSString *_BranchBankName;
    
    NSString *_tempid;
    
    NSString *_modifytype2;
    NSString *_TxtCardType;
    
    NSString *_Mobile;
    NSString *_paycode;
    NSString *_Amount;
    
    NSString *_Province;
    NSString *_City;
    
}

#pragma mark - NSNotification

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisapplear:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
}

-(void)keyboardWillDisapplear:(NSNotification *)notification {
    _scrollView.contentInset = UIEdgeInsetsZero;
}

-(void)keyboardWillShow:(NSNotification *) aNotification {
    NSDictionary *info = [aNotification userInfo];
    
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue];
    
    float height = kbRect.size.height;
    
    if (height != 0) {
        CGFloat b = height;
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, b, 0);
    }
    //[_scrollView scrollRectToVisible:kbRect animated:YES];
    
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (_messageView.textField.isEditing) {
        //        NSLog(@"正在输入验证码");
        CGRect rect = [_scrollView convertRect:_commitButton.frame fromView:_commitButton];
        rect.origin.y += 50;
//        NSLog(@"%f, %f",rect.origin.x,rect.origin.y);
        [_scrollView scrollRectToVisible:rect animated:YES];
    }
}

#pragma mark - --------

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}
- (void)setParams:(NSDictionary *)params signIfnoBlock:(NSString *(^)(NSString *, BOOL))signBlock resultBlock:(void (^)(NSDictionary *, MMMEventType))resultBlock{
    
    [super setParams:params signIfnoBlock:signBlock resultBlock:resultBlock];
    [self setParams:params];
}

- (void)setParams:(NSDictionary *)params{
    
    _toloanfastpayObjext = [[MMMToloanfastpayObject alloc]init];
    [_toloanfastpayObjext setValuesForKeysWithDictionary:params];
    
    if (![self checkNecessaryParams:"MMMToloanfastpayObject" tagertObj:_toloanfastpayObjext]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"提交的数据,缺少必要参数" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *cc = self.signInfoBlock(_toloanfastpayObjext.CardNo,NO);
    NSLog(@"%@",cc);
    if ([_toloanfastpayObjext.Action isEqualToString:@"1"] || [_toloanfastpayObjext.Action isEqualToString:@"2"] ) {
        cc =@"";
        _toloanfastpayObjext.CardNo = @"";
    }
    
    NSString *signDataStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                             _toloanfastpayObjext.MoneymoremoreId,
                             _toloanfastpayObjext.PlatformMoneymoremore,
                             _toloanfastpayObjext.Action,
                             _toloanfastpayObjext.CardNo,
                             _toloanfastpayObjext.WithholdBeginDate,
                             _toloanfastpayObjext.WithholdEndDate,
                             _toloanfastpayObjext.SingleWithholdLimit,
                             _toloanfastpayObjext.TotalWithholdLimit,
                             _toloanfastpayObjext.RandomTimeStamp,
                             _toloanfastpayObjext.Remark1,
                             _toloanfastpayObjext.Remark2,
                             _toloanfastpayObjext.Remark3,
                             _toloanfastpayObjext.ReturnURL,
                             _toloanfastpayObjext.NotifyURL];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:params];
    if ([paramsDic.allKeys containsObject:@"CardNo"]) {
        [paramsDic setObject:cc forKey:@"CardNo"];
        
    }
    
    //NSString *paramsString = [MMMConfigUtil sharedConfigUtil].setPostString(params);
    
    NSString *signString = self.signInfoBlock(signDataStr,YES);
    if (!signString) {
        signString = @"";
        
    }
    
    [MMMActivityIndicatorView show];
    
    [MMMConfigUtil sharedConfigUtil].beginServiceWithDict(MMMThreeInOneEvent,paramsDic,[signString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
        ^(NSData *data,NSError *error){
        
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

}

- (void)dealWithRequestCallback:(NSDictionary *)dict{
    NSLog(@"%@",dict);
     _hasGetImformation = YES;
    if ([dict.allKeys containsObject:@"Message"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"验证提示" message:[dict objectForKey:@"Message"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        if (!self.view.window) alert.delegate = nil;
        alert.tag = 1001;
        [alert show];
        
        return;
    }
    if ([dict.allKeys containsObject:@"flag"]) {
        _flag = dict[@"flag"];
    }
    if ([dict.allKeys containsObject:@"CompanyName"]) {
        _CompanyName = dict[@"CompanyName"];
    }
    if ([dict.allKeys containsObject:@"PlatformName"]) {
        _PlatformName = dict[@"PlatformName"];
    }
    if ([dict.allKeys containsObject:@"LoanPlatformAccount"]) {
        _LoanPlatformAccount = dict[@"LoanPlatformAccount"];
    }
    if ([dict.allKeys containsObject:@"MoneymoremoreAccount"]) {
        _MoneymoremoreAccount = dict[@"MoneymoremoreAccount"];
    }
    if ([dict.allKeys containsObject:@"RealName"]) {
        _RealName = dict[@"RealName"];
    }
    if ([dict.allKeys containsObject:@"IdentificationNo"]) {
        _IdentificationNo = dict[@"IdentificationNo"];
    }
    if ([dict.allKeys containsObject:@"AccountType"]) {
        _AccountType = dict[@"AccountType"];
    }
    if ([dict.allKeys containsObject:@"CardBindType"]) {
        _CardBindType = dict[@"CardBindType"];
    }
    if ([dict.allKeys containsObject:@"BankName"]) {
        _BankName = dict[@"BankName"];
    }
    if ([dict.allKeys containsObject:@"CardNo"]) {
        _CardNo = dict[@"CardNo"];
    }
    if ([dict.allKeys containsObject:@"CityInfo"]) {
        _CityInfo = dict[@"CityInfo"];
    }
    if ([dict.allKeys containsObject:@"BranchBankName"]) {
        _BranchBankName = dict[@"BranchBankName"];
    }
    if ([dict.allKeys containsObject:@"tempid"]) {
        _tempid = dict[@"tempid"];
    }
    
    
    
    //-----------------------------------
#warning flag设置
    //_flag = @"5";
    [self configViewData];
    [self configView];
    
}
- (void)configViewData{
    NSMutableDictionary *showInfoDic = [NSMutableDictionary dictionary];
    showInfoDic[@"公司名"] = _CompanyName;
    showInfoDic[@"平台名"] = _PlatformName;
    showInfoDic[@"平台用户名"] = _LoanPlatformAccount;
    showInfoDic[@"亁多多账户"] = _MoneymoremoreAccount;
    showInfoDic[@"开户名"] = _RealName;
    
    if ([_flag isEqualToString:@"1"]) {
        
        if ([_AccountType isEqualToString:@""]) {
            showInfoDic[@"证件类型"] = @"身份证";
        }
        if ([_AccountType isEqualToString:@"1"]) {
            showInfoDic[@"证件类型"] = @"营业执照";
        }
        if ([_AccountType isEqualToString:@"2"]) {
            showInfoDic[@"证件类型"] = @"护照";
        }
       showInfoDic[@"身份证号"] = _IdentificationNo;
    }
    if ([_flag isEqualToString:@"2"]) {
        showInfoDic[@"身份证号"] = _IdentificationNo;
        
        if ([_AccountType isEqualToString:@""]) {
            showInfoDic[@"证件类型"] = @"身份证";
        }
        if ([_AccountType isEqualToString:@"1"]) {
            showInfoDic[@"证件类型"] = @"营业执照";
        }
        if ([_AccountType isEqualToString:@"2"]) {
            showInfoDic[@"证件类型"] = @"护照";
        }
        
        if ([_CardBindType isEqualToString:@""]) {
            showInfoDic[@"绑卡类型"] = @"快捷支付、汇款";
        }
        if ([_CardBindType isEqualToString:@"1"]) {
            showInfoDic[@"绑卡类型"] = @"快捷支付";
        }
        if ([_CardBindType isEqualToString:@"2"]) {
            showInfoDic[@"绑卡类型"] = @"汇款";
        }
        _modifytype2 = @"1";
    }
    if ([_flag isEqualToString:@"5"]) {
        showInfoDic[@"开户行"] = _BankName;
        showInfoDic[@"银行账户"] = _CardNo;
        showInfoDic[@"开户省市"] = _CityInfo;
        showInfoDic[@"开户支行"] = _BranchBankName;
    }
    _showInfoDic = showInfoDic;
    
    
}



- (void)configView {
    
    MMMThreeInOneInfoView *infoView = [MMMThreeInOneInfoView infoViewWithInfos:_showInfoDic];
    _infoView = infoView;
    
    
    
    NSString *title = @"";
    CGFloat y = CGRectGetMaxY(infoView.frame)+10;
    if ([_flag isEqualToString:@"1"]) {
        title = @"认证";
    }
    if ([_flag isEqualToString:@"2"]) {
        title = @"提现绑卡";
    }
    if ([_flag isEqualToString:@"5"]) {
        title = @"汇款绑卡确认";
    }
     self.titleLabel.text = title;
    
    UIImageView *commitView = [[UIImageView alloc]initWithFrame:CGRectMake(0, y, ScSize.width - 10, 600)];
    _commitView = commitView;
    commitView.userInteractionEnabled = YES;
    
    //////////////////////////
    if ([_flag isEqualToString:@"1"]) {
        _modifytype2 = @"1";
        
        MMMSingleInputView *TxtCardType = [[MMMSingleInputView alloc]initWithFrame:CGRectMake(0,0,ScSize.width - 10,60)];
        [TxtCardType setTitleContent:@"卡类型" andDetailContent:@"借记卡"];
        TxtCardType.userInteractionEnabled = NO;
        [commitView addSubview:TxtCardType];
        TxtCardType.textField.delegate = self;
        
        MMMSingleInputView *TxtBankCode = [[MMMSingleInputView alloc]initWithFrame:CGRectMake(0,60,ScSize.width - 10,60)];
        
        [TxtBankCode setTitleContent:@"开户行" andDetailContent:@""];
        TxtBankCode.textField.placeholder = @"";
        [TxtBankCode setArrow];
        [commitView addSubview:TxtBankCode];
        
        _bankView = TxtBankCode;
        UIButton *btn = [[UIButton alloc]initWithFrame:TxtBankCode.frame];
        [commitView addSubview:btn];
        
        
        [btn addTarget:self action:@selector(showBankList:) forControlEvents:UIControlEventTouchUpInside];
        
        MMMSingleInputView *TxtCardNo = [[MMMSingleInputView alloc]initWithFrame:CGRectMake(0,120,ScSize.width - 10,60)];
        [TxtCardNo setTitleContent:@"卡号" andDetailContent:@""];
        TxtCardNo.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        TxtCardNo.textField.returnKeyType = UIReturnKeyDone;
        _cardNoView = TxtCardNo;
        [commitView addSubview:TxtCardNo];
        TxtCardNo.textField.delegate = self;
        
        
        
        MMMSingleInputView *Mobile = [[MMMSingleInputView alloc]initWithFrame:CGRectMake(0,180,ScSize.width - 10,60)];
        [Mobile setTitleContent:@"手机号" andDetailContent:@""];
        Mobile.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        Mobile.textField.returnKeyType = UIReturnKeyDone;
        self.mobileView = Mobile;
        [commitView addSubview:Mobile];
        Mobile.textField.delegate = self;
        
        MMMSendMessageView *paycode = [[MMMSendMessageView alloc]initWithFrame:CGRectMake(0,240,ScSize.width - 10,60)];
        paycode.textField.placeholder = @"验证码";
        paycode.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        paycode.textField.returnKeyType = UIReturnKeyDone;
        _messageView = paycode;
        paycode.textField.delegate = self;
        [paycode.sendMsgBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [paycode sendMessageBtnPressed:^BOOL{
            [self hiddenKeyBoard];
            if (!_bankObj || [[_bankObj.BankCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""]) {
                self.theAlert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"请选择开户行" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [self.theAlert show];
                return NO;
            }
            
            if (!TxtCardNo.textField.text || [[TxtCardNo.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""]) {
                self.theAlert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"请填写卡号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [self.theAlert show];
                return NO;
            }
            
            if (!Mobile.textField.text || [[Mobile.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""]) {
                self.theAlert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"请填写手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [self.theAlert show];
                return NO;
            }
            
            NSDictionary *paramsDic = @{@"bank":_bankObj.BankCode,
                                        @"cardNumber":TxtCardNo.textField.text,
                                        @"realName":_RealName,
                                        @"paperKind":@"I",
                                        @"paperNO":_IdentificationNo,
                                        @"phoneNO":Mobile.textField.text,
                                        @"phone":@"1",
                                        @"amount":@"0.01"
                                        };
            NSLog(@"%@",paramsDic);
            NSString *paramsString = [MMMConfigUtil sharedConfigUtil].setPostString(paramsDic);
            
            [MMMActivityIndicatorView show];
            [MMMConfigUtil sharedConfigUtil].toSendDKPhoneCodeFor3in1(paramsString,^(NSData *data, NSError *error){
                [MMMActivityIndicatorView remove];
                [self hiddenKeyBoard];
                if (!error) {
                    [self callBackOfRequest:data];
                    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                }
                //  网络异常
                else{
                    [super errorOfCallBack:error];
                }
            });

            return YES;
        }];
        [commitView addSubview:paycode];
        [self createPostButtonInposition:300];
        
    }
    
    
    ///////////////////////////////////
    if ([_flag isEqualToString:@"2"]) {
        MMMSingleInputView *modifytype = [[MMMSingleInputView alloc]initWithFrame:CGRectMake(0, 0,ScSize.width - 10,60)];
        
        if ([_modifytype2 isEqualToString:@"1"]) {
            [modifytype setTitleContent:@"绑卡类型" andDetailContent:@"快捷支付"];
        }
        if ([_modifytype2 isEqualToString:@"2"]) {
            [modifytype setTitleContent:@"绑卡类型" andDetailContent:@"汇款"];
        }
        //_modifytype2 = @"1";
        [modifytype setArrow];
        [commitView addSubview:modifytype];
        _modifyTypeView = modifytype;
        UIButton *button = [[UIButton alloc]initWithFrame:modifytype.frame];
        [button addTarget:self action:@selector(changeModifyType) forControlEvents:UIControlEventTouchUpInside];
        [commitView addSubview:button];
        
        MMMSingleInputView *TxtCardType = [[MMMSingleInputView alloc]initWithFrame:CGRectMake(0,60,ScSize.width - 10,60)];
        [TxtCardType setTitleContent:@"卡类型" andDetailContent:@"借记卡"];
        TxtCardType.userInteractionEnabled = NO;
        [commitView addSubview:TxtCardType];
        
        MMMSingleInputView *TxtBankCode = [[MMMSingleInputView alloc]initWithFrame:CGRectMake(0,120,ScSize.width - 10,60)];
        
        [TxtBankCode setTitleContent:@"开户行" andDetailContent:@""];
        TxtBankCode.textField.placeholder = @"";
        //-------------------------------------------------------------
        [TxtBankCode setArrow];
        [commitView addSubview:TxtBankCode];
        _bankView = TxtBankCode;
        TxtBankCode.textField.placeholder = @"";
        UIButton *btn = [[UIButton alloc]initWithFrame:TxtBankCode.frame];
        [commitView addSubview:btn];
        
        [btn addTarget:self action:@selector(showBankList:) forControlEvents:UIControlEventTouchUpInside];
        
//#warning 省市
        MMMSingleInputView *province = [[MMMSingleInputView alloc]initWithFrame:CGRectMake(0,180,ScSize.width - 10,60)];
        self.provinceView = province;
        [province setTitleContent:@"开户省" andDetailContent:@""];
        province.textField.placeholder = @"";
        [province setArrow];
        [commitView addSubview:province];
        //_bankView = TxtBankCode;
        province.textField.placeholder = @"";
        UIButton *provincebtn = [[UIButton alloc]initWithFrame:CGRectMake(0,180,ScSize.width - 10,60)];
        [commitView addSubview:provincebtn];
        
        [provincebtn addTarget:self action:@selector(showProvincePicker:) forControlEvents:UIControlEventTouchUpInside];
        
        MMMSingleInputView *city = [[MMMSingleInputView alloc]initWithFrame:CGRectMake(0,240,ScSize.width - 10,60)];
        self.cityView = city;
        [city setTitleContent:@"开户市" andDetailContent:@""];
        city.textField.placeholder = @"";
        [city setArrow];
        [commitView addSubview:city];
        //_bankView = TxtBankCode;
        city.textField.placeholder = @"";
        UIButton *citybtn = [[UIButton alloc]initWithFrame:CGRectMake(0,240,ScSize.width - 10,60)];
        [commitView addSubview:citybtn];
        
        [citybtn addTarget:self action:@selector(showProvincePicker:) forControlEvents:UIControlEventTouchUpInside];
        
        
        MMMSingleInputView *branchBank = [[MMMSingleInputView alloc]initWithFrame:CGRectMake(0,300,ScSize.width - 10,60)];
        self.branchBankView = branchBank;
        [branchBank setTitleContent:@"分行" andDetailContent:@""];
        branchBank.textField.placeholder = @"请输入支行";
        branchBank.textField.delegate = self;
        [commitView addSubview:branchBank];

        
        
        
        
        MMMSingleInputView *TxtCardNo = [[MMMSingleInputView alloc]initWithFrame:CGRectMake(0,360,ScSize.width - 10,60)];
        _cardNoView = TxtCardNo;
        [TxtCardNo setTitleContent:@"卡号" andDetailContent:@""];
        TxtCardNo.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        TxtCardNo.textField.returnKeyType = UIReturnKeyDone;
        [commitView addSubview:TxtCardNo];
        TxtCardNo.textField.delegate = self;
        
        MMMSingleInputView *Mobile = [[MMMSingleInputView alloc]initWithFrame:CGRectMake(0,420,ScSize.width - 10,60)];
        [Mobile setTitleContent:@"手机号" andDetailContent:@""];
        Mobile.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        Mobile.textField.returnKeyType = UIReturnKeyDone;
        _mobileView = Mobile;
        Mobile.textField.delegate = self;
        
        
        MMMSendMessageView *paycode = [[MMMSendMessageView alloc]initWithFrame:CGRectMake(0,480,ScSize.width - 10,60)];
        _messageView = paycode;
        paycode.textField.delegate = self;
        paycode.textField.placeholder = @"验证码";
        paycode.textField.returnKeyType = UIReturnKeyDone;
        paycode.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        [paycode.sendMsgBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [paycode sendMessageBtnPressed:^BOOL{
            [self hiddenKeyBoard];
            if (!_bankObj || [[_bankObj.BankCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""]) {
                self.theAlert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"请选择开户行" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [self.theAlert show];
                return NO;
            }
            
            if (!TxtCardNo.textField.text || [[TxtCardNo.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""]) {
                self.theAlert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"请填写卡号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [self.theAlert show];
                return NO;
            }
            
            if (!Mobile.textField.text || [[Mobile.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""]) {
                self.theAlert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"请填写手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [self.theAlert show];
                return NO;
            }
            
            NSDictionary *paramsDic = @{@"bank":_bankObj.BankCode,
                                        @"cardNumber":TxtCardNo.textField.text,
                                        @"realName":_RealName,
                                        @"paperKind":@"I",
                                        @"paperNO":_IdentificationNo,
                                        @"phoneNO":Mobile.textField.text,
                                        @"phone":@"1",
                                        //@"amount":_Amount
                                        };
            NSLog(@"%@",paramsDic);
            NSString *paramsString = [MMMConfigUtil sharedConfigUtil].setPostString(paramsDic);
            
            [MMMActivityIndicatorView show];
            [MMMConfigUtil sharedConfigUtil].toSendDKPhoneCodeFor3in1(paramsString,^(NSData *data, NSError *error){
                [MMMActivityIndicatorView remove];
                [self hiddenKeyBoard];
                if (!error) {
                    [self callBackOfRequest:data];
                    
                }
                //  网络异常
                else{
                    [super errorOfCallBack:error];
                }
            });
            
            return YES;
        }];
        
        
        if ([_modifytype2 isEqualToString: @"1"]) {
            [commitView addSubview:Mobile];
            [commitView addSubview:paycode];
            
            [self createPostButtonInposition:540];
        }
        if ([_modifytype2 isEqualToString:@"2"]) {
            [self createPostButtonInposition:420];
        }
        
        
    }
    
    /////////////////////////////////////////////////////////
    if ([_flag isEqualToString:@"5"]) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScSize.width, 30)];
        label.text = @"请填写亁多多向您银行账户中转入金额";
        [label setTextColor:[UIColor redColor]];
        [label setFont:[UIFont systemFontOfSize:15]];
        MMMSingleInputView *amount = [[MMMSingleInputView alloc]initWithFrame:CGRectMake(0, 30,ScSize.width - 10,60)];
        [amount setTitleContent:@"金额" andDetailContent:@""];
        [commitView addSubview:amount];
        [commitView addSubview:label];

        amount.textField.keyboardType = UIKeyboardTypeNumberPad;
        amount.textField.returnKeyType = UIReturnKeyDone;
        _amountView = amount;
        amount.textField.delegate = self;
        [self createPostButtonInposition:90];

            }
    
    
    
    commitView.userInteractionEnabled = YES;
    commitView.frame = CGRectMake(0, CGRectGetMaxY(infoView.frame)+10, ScSize.width,CGRectGetMaxY(_commitButton.frame));
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScSize.width, ScSize.height-64)];
    //scrollView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetMaxY(commitView.frame)+10, 0);
    scrollView.contentSize = CGSizeMake(ScSize.width, CGRectGetMaxY(commitView.frame)+10);
    
    _scrollView = scrollView;
    [self.contentView addSubview:scrollView];
    [scrollView addSubview:commitView];
    [scrollView addSubview:infoView];
    
    
    
}

- (void)showProvincePicker:(UIButton *)sender{
    [self hiddenKeyBoard];
    
    if (!_pickerView) {
        [_cityView setTitleContent:@"开户市" andDetailContent:@""];
        [_provinceView setTitleContent:@"开户省" andDetailContent:@""];
        
        CGSize size = [UIScreen mainScreen].bounds.size;
        UIView *cover = [[UIView alloc]initWithFrame:CGRectMake(0,size.height, size.width, 350)];
        self.pickerView = cover;
        self.correctObj = self.pickerView;
        cover.backgroundColor = [UIColor grayColor];
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:blur];
        blurView.alpha = 0.5;
        blurView.frame = CGRectMake(0, 0, cover.frame.size.width, cover.frame.size.height);
        [cover addSubview:blurView];
        
        UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, size.width,350)];
        
        
        
        //cover.alpha = 0.5;
        //picker.center = cover.center;
        picker.dataSource = self;
        picker.delegate =self;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(5,CGRectGetMaxY(picker.frame)+10, size.width-10, 50)];
        btn.layer.cornerRadius = 5;
        btn.backgroundColor = [UIColor colorWithRed:58.0f/255.0f green:108.0f/255.0f blue:241.0f/255.0f alpha:1];
        [btn addTarget:self action:@selector(pickerViewDismiss:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"确认" forState:UIControlStateNormal];
        [btn setTintColor:[UIColor whiteColor]];
        
        [cover addSubview:btn];
        [cover addSubview:picker];
        [self.contentView addSubview:cover];
        [UIView animateWithDuration:0.5 animations:^{
            cover.frame = CGRectMake(0, size.height - 350, size.width, 350);
        }];
        
        if (!_provincesArr && !_citysArr) {
            [MMMConfigUtil sharedConfigUtil].toGetProvince(^(NSData *data,NSError *error){
                
                if (!error) {
                    self.provincesArr = [MMMProvinceAndCityParser ProvinceCityParser:data];
                    [picker reloadComponent:0];
                    [self pickerView:picker didSelectRow:0 inComponent:0];
                    
                }else {
                    [super errorOfCallBack:error];
                }
                
            });
            
        }
        else
        {
            for (NSArray *arr in _provincesArr) {
                if ([[arr[1] stringValue] isEqualToString:_Province]) {
                    NSInteger index = [_provincesArr indexOfObject:arr];
                    [picker selectRow:index inComponent:0 animated:NO];
                }
            }
            
        }
        
    };
    
}
                                                       
- (void) createPostButtonInposition:(CGFloat) y {
    UIButton *commitButton = [[UIButton alloc]initWithFrame:CGRectMake(10,y,ScSize.width - 20,50)];
    commitButton.layer.cornerRadius = 5;
    commitButton.backgroundColor = [UIColor colorWithRed:58.0f/255.0f green:108.0f/255.0f blue:241.0f/255.0f alpha:1];
    [commitButton addTarget:self action:@selector(postData) forControlEvents:UIControlEventTouchUpInside];
    [commitButton setTitle:@"确认" forState:UIControlStateNormal];
    [commitButton setTintColor:[UIColor whiteColor]];
    _commitButton = commitButton;
    [_commitView addSubview:commitButton];

}
- (void)requestError:(NSError *)error{

}

-(void)showBankList:(UIButton *)sender{
    
    [self hiddenKeyBoard];
    
        NSString *bankListURL = [MMMConfigUtil sharedConfigUtil].getBanklistByType();
        
    
        NSDictionary *dic = @{@"cardtype":@"0",@"act":_modifytype2};
        
        
        
        [MMMRequestUtil sendRequest:bankListURL withPostDic:dic callbackBlock:^(NSData *data, NSError *error) {
            if (!error) {
                NSString *bankListString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                MMMBankUtil *bankUtil = [[MMMBankUtil alloc]init];
                NSArray *bankArr = [bankUtil parseBankListString:bankListString];
                self.bankList = bankArr;
            }
        }];
    
}


- (void)setBankList:(NSArray *)bankList{
    _bankList = bankList;
    [self creatBankListView];
    
}
- (void)creatBankListView{

    MMMBankListTableView *bankListView = [[MMMBankListTableView alloc]initWithFrame:CGRectMake(0,0,ScSize.width/3*2,ScSize.height/2 ) style:UITableViewStylePlain bankList:_bankList];
    bankListView.center = self.view.center;
    
    bankListView.tapBlock = ^void(NSIndexPath *indexPath, id object){
        self.bankObj = _bankList[indexPath.row];
    };
    CGSize size = self.contentView.frame.size;
    MMMCoverView *cover = [[MMMCoverView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    _cover = cover;
    bankListView.center = cover.center;
    [self.contentView addSubview:cover];
    [cover addSubview:bankListView];
    _bankListView = bankListView;
    
    [bankListView reloadData];
    

}
- (void)setBankObj:(MMMBankObject *)bankObj{
    _bankObj = bankObj;
    [_bankListView removeFromSuperview];
    [_cover removeFromSuperview];
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"MMMBankSDK" ofType:@"bundle"]];
    NSString *alertImagePath = [bundle pathForResource:bankObj.BankCode ofType:@"png"];
    UIImage *img = [UIImage imageWithContentsOfFile:alertImagePath];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:img];
    CGSize size = img.size;
    imageView.frame = CGRectMake(_bankView.textField.frame.origin.x,(60-size.height*0.3)/2,size.width*0.3,size.height*0.3);
    
    [_bankView addSubview:imageView];
}

- (void)changeModifyType{
    [self hiddenKeyBoard];
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"绑卡类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"快捷支付",@"汇款", nil];
    [action showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
    
        _modifytype2 = @"1";
        [_modifyTypeView setTitleContent:@"绑卡类型" andDetailContent:@"快捷支付"];
    }
    if (buttonIndex == 1) {
        _modifytype2 = @"2";
        [_modifyTypeView setTitleContent:@"绑卡类型" andDetailContent:@"汇款"];
    }
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    [self configView];
}

- (void)postData{
    [self hiddenKeyBoard];
  
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    postData[@"tempid"] = _tempid;
    postData[@"phone"] = @"1";
    if ([_flag isEqualToString:@"1"]) {
        postData[@"TxtCardType"] = @"0";
        if (_bankObj) {
            postData[@"TxtBankCode"] = _bankObj.BankId;
        }
        postData[@"TxtCardNo"] = _cardNoView.textField.text;
        postData[@"Mobile"] = _mobileView.textField.text;
        postData[@"paycode"] = _messageView.textField.text;
    }
    if ([_flag isEqualToString:@"2"]) {
        postData[@"TxtCardType"] = @"0";
        postData[@"modifytype2"] = _modifytype2;
        if (_bankObj) {
            postData[@"TxtBankCode"] = _bankObj.BankId;
        }
        postData[@"Province"] = _Province;
        postData[@"City"] = _City;
        postData[@"BranchBankName"] = _branchBankView.textField.text;
        postData[@"TxtCardNo"] = _cardNoView.textField.text;
        if ([_modifytype2 isEqualToString:@"1"]) {
            postData[@"Mobile"] = _mobileView.textField.text;
            postData[@"paycode"] = _messageView.textField.text;
        }
        
    }
    if ([_flag isEqualToString:@"5"]) {
        postData[@"Amount"] = _amountView.textField.text;
    }
    for(NSString *str in [postData allValues]) {
        if ([str isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"拒绝操作" message:@"请正确填写必要信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
        }
    }
    if (![_flag isEqualToString:@"5"]) {
        if ([_cardNoView.textField.text length]<16) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"拒绝操作" message:@"请正确填写卡号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        
        if ([_modifytype2 isEqualToString:@"1"]) {
            if ([_mobileView.textField.text length] < 11) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"拒绝操作" message:@"请正确填写手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                return;
            }
            
            if ([_messageView.textField.text length] < 6) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"拒绝操作" message:@"请正确填写验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                return;
            }
        }
        
    }
    
    //NSLog(@"%@",postData);
    [MMMActivityIndicatorView show];
    
    NSString *paramsString = [MMMConfigUtil sharedConfigUtil].setPostString(postData);
    
   // [MMMConfigUtil sharedConfigUtil].toLoanfastpay(paramsString,^(){});
    [MMMConfigUtil sharedConfigUtil].toLoanfastpay(paramsString,^(NSData *data, NSError *error){
        [MMMActivityIndicatorView remove];
        
        if (!error) {
            //[self callBackOfRequest:data withTag:kSendMsgTag];
            NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [self dealWithCallBack:dict];
        }
        //  网络异常
        else{
            [super errorOfCallBack:error];
        }
    });
    
    
}


- (void)dealWithCallBack:(NSDictionary *)dic{
    
//#warning 处理返回信息
    
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    if ([[dic allKeys] containsObject:@"Message"]) {
        [resultDic setObject:[dic objectForKey:@"Message"] forKey:@"Message"];
    }
    
    if ([[dic allKeys] containsObject:@"ResultCode"]) {
        [resultDic setObject:[dic objectForKey:@"ResultCode"] forKey:@"ResultCode"];
    }

    if (self.resultBlock) {
         self.resultBlock(resultDic,MMMThreeInOneEvent);
    }
   
    if ([[dic objectForKey:@"ResultCode"]isEqualToString:@"88"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"成功" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil];
        alert.tag = 1001;
        if (!self.view.window) alert.delegate = nil;
        [alert show];
        return;
    }
    
    if ([[dic objectForKey:@"ResultCode"]isEqualToString:@"89"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"绑卡申请已提交" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil];
        alert.tag = 1001;
        if (!self.view.window) alert.delegate = nil;
        [alert show];
        return;
    }

    if ([[dic allKeys]containsObject:@"Message"]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"授权提示" message:[dic objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
}

}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.correctObj = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1001) {
        [self back:nil];
    }
}

#pragma mark - ----
                                                       
-(void)hiddenKeyBoard {
    if (self.correctObj != nil) {
        if (self.correctObj == self.pickerView) {
            [self pickerViewDismiss:nil];
        }
        
        
        [self.correctObj resignFirstResponder];
        self.correctObj = nil;
    }
}
- (void)callBackOfRequest:(NSData *)data{
    
    //[_sendMsgBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    //_sendMsgBtn.enabled = YES;
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //        NSLog(@"%@",_logObj);
    
    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    
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

#pragma mark - picekerView Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        NSArray *arr = _provincesArr[row];
        [self.provinceView setTitleContent:@"开户省" andDetailContent:arr[0]];
        _Province = [arr[1] stringValue];
        
            NSDictionary *dic = [NSDictionary dictionaryWithObject:arr[1] forKey:@"cityId"];
            NSString *paramsString = [MMMConfigUtil sharedConfigUtil].setPostString(dic);
            
            [MMMConfigUtil sharedConfigUtil].toGetCityWithProvince(paramsString,^(NSData *data,NSError *error){
                if (!error) {
                    self.citysArr = [MMMProvinceAndCityParser ProvinceCityParser:data];
                    [pickerView reloadComponent:1];
                    [self pickerView:pickerView didSelectRow:0 inComponent:1];
                }
                if (error) {
                    [super errorOfCallBack:error];
                }
                
                
            });
        
 
    }
    if (component == 1) {
        NSArray *arr = _citysArr[row];
        [_cityView setTitleContent:@"开户市" andDetailContent:arr[0]];
        _City = [arr[1] stringValue];
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        NSArray *arr = _provincesArr[row];
        return arr[0];
    }
    if (component == 1) {
        NSArray *arr = _citysArr[row];
        return arr[0];
    }
    return nil;
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.provincesArr.count;
    }else if (component == 1) {
        return self.citysArr.count;
    }
    return 0;
}

- (void)pickerViewDismiss:(UIButton *)sender{
    
    [UIView animateWithDuration:0.3 animations:^{
        _pickerView.frame = CGRectMake(0, ScSize.height, ScSize.width, 350);
    } completion:^(BOOL finished) {
        [_pickerView removeFromSuperview];
    }];
    
    
    //[self check];
}

- (void)check{
    
    for (NSArray *arr in _provincesArr) {
        if ([[arr[1] stringValue] isEqualToString:_Province]) {
            NSLog(@"%@",arr[0]);
        }
    }
    for (NSArray *arr in _citysArr) {
        if ([[arr[1] stringValue] isEqualToString:_City]) {
            NSLog(@"%@",arr[0]);
        }
    }
}

@end
