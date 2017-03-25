//
//  MMMRegisterController.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMRegisterController.h"
#import "MMMConfigUtil.h"
#import "MMMEventEnum.h"
#import "MMMRegisterObject.h"
#import "MMMBindTableView.h"
#import "MMMSingleInputCell.h"
#import "MMMHeaderView.h"
#import "MMMRegisterScrollView.h"

@interface MMMRegisterController ()
@property (nonatomic, strong) MMMRegisterObject *registerObject;
@property (nonatomic, weak) id currentObj;
@property (nonatomic, assign) BOOL isShowEmail;     //是否现实邮箱
@property (nonatomic, strong) UISwitch *isSetEmailSwitch;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) MMMRegisterScrollView *registerScrollView;
@property (nonatomic, strong) MMMBindTableView *bindTableView;
@property (nonatomic, strong) NSDictionary *titleNameDic;
@property (nonatomic, strong) UITableView *currentTableView;
@end

@implementation MMMRegisterController
{
@private
    NSString *_PlatformName;
    
    NSString *_tempid;
    NSString *_sidsigninfo;
    
    NSString *_RealName;
    NSString *_IdentificationNo;
    NSString *_Mobile;
    NSString *_Email;
    NSString *_issetemail;
}
-(id)init {
    self = [super init];
    if (self) {
        
        if (!_isSetEmailSwitch) {
            _isSetEmailSwitch = [[UISwitch alloc]init];
            [_isSetEmailSwitch addTarget:self action:@selector(changeEmailCheck:) forControlEvents:UIControlEventValueChanged];
        }
        _isShowEmail = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisapplear:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)changeEmailCheck:(UISwitch *)sender {
//    [self.tableView reloadData];
    _isShowEmail = _isSetEmailSwitch.on;
    [_currentTableView reloadData];
}

-(void)back:(id)sender {
    [super back:sender];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.registerScrollView name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self.registerScrollView name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - NSNoticification

-(void)keyboardWillDisapplear:(NSNotification *)notification {
    
    self.currentTableView.contentInset = UIEdgeInsetsZero;
    
}

////////// 存在bug
- (void)keyboardWasShown:(NSNotification*)aNotification
{
        NSDictionary *info = [aNotification userInfo];
        
        CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue];
        
        float height = kbRect.size.height;
        
        if (height != 0) {
            
            self.currentTableView.contentInset = UIEdgeInsetsMake(0, 0, height, 0);
    }
}

///////////////
-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setParams:(NSDictionary *)params
   signIfnoBlock:(SignInfoBlock)signBlock
{
    [super setParams:params signIfnoBlock:signBlock];
    [self setParam:params];
}
-(void)setParams:(NSDictionary *)params
   signIfnoBlock:(NSString *(^)(NSString *, BOOL))signBlock
     resultBlock:(void (^)(NSDictionary *, MMMEventType))resultBlock
{
    [super setParams:params signIfnoBlock:signBlock resultBlock:resultBlock];
    [self setParam:params];
}


//  配置数据
-(void)setParam:(NSDictionary *)params {
    _registerObject = [[MMMRegisterObject alloc]init];
    [_registerObject setValuesForKeysWithDictionary:params];
    
    if (![self checkNecessaryParams:"MMMRegisterObject" tagertObj:_registerObject]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"提交的数据,缺少必要参数" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.delegate = self;
        alert.tag = 1001;
        [alert show];
        return;
    }
    
    _Email = _registerObject.Email;
    _Mobile = _registerObject.Mobile;
    _RealName = _registerObject.RealName;
    _IdentificationNo = _registerObject.IdentificationNo;
    
    //  如果填写邮箱 则显示
    if (![[_registerObject.Email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        _isShowEmail = YES;
    }else{
        _isShowEmail = NO;
    }
    
    _PlatformName = _registerObject.LoanPlatformAccount;
    
    if ([_registerObject.AccountType isEqualToString:@"1"]) {
        _titleNameDic = @{@"NameTitle":@"企业名称",
                          @"IdentificationNoTitle":@"营业执照"};
    }else{
        _titleNameDic = @{@"NameTitle":@"姓名",
                          @"IdentificationNoTitle":@"身份证号"};
    }
    
    // 原始数据的拼接结果
    NSString *signDataStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                             _registerObject.RegisterType,
                             _registerObject.AccountType,
                             _registerObject.Mobile,
                             _registerObject.Email,
                             _registerObject.RealName,
                             _registerObject.IdentificationNo,
                             _registerObject.Image1,
                             _registerObject.Image2,
                             _registerObject.LoanPlatformAccount,
                             _registerObject.PlatformMoneymoremore,
                             _registerObject.RandomTimeStamp,
                             _registerObject.Remark1,
                             _registerObject.Remark2,
                             _registerObject.Remark3,
                             _registerObject.ReturnURL,
                             _registerObject.NotifyURL];
    
    NSString *paramsString = [MMMConfigUtil sharedConfigUtil].setPostString(params);
    
    //  得到RSA签名过后的字符串
    NSString *signString = self.signInfoBlock(signDataStr,YES);
    if (!signString) {
        signString = @"";
    }
    
//    NSLog(@"%@, %@",signDataStr, paramsString);
    
    [MMMActivityIndicatorView show];
    //  调用接口
    
    [MMMConfigUtil sharedConfigUtil].beginServiceWithDict(MMMRegisterEvent, params, [signString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],^(NSData *data,NSError *error){
        [MMMActivityIndicatorView remove];
        if (self.view.window) {
            if (!error) {
                
                NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if (![dict isKindOfClass:[NSDictionary class]]) {
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    alertView.tag = 1001;
                    [alertView show];
                    
                    return;
                }
                //                NSLog(@"%@",dict);
                [dict setValuesForKeysWithDictionary:_titleNameDic];
                [self dealWithRequestCallback:dict];
            }
            //  网络异常
            else{
                [self requestError:error];
            }
        }
    });
}

#pragma mark - 数据回调处理

-(void)dealWithConfirmBtnCallBack:(NSDictionary *)dict{
    if ([[dict allKeys] containsObject:@"Message"]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[dict objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"了解" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //    NSLog(@"%@",dict);
    
    if ([[dict allKeys] containsObject:@"flag"]){
        [self switchNextController:dict withFlag:[dict objectForKey:@"flag"]];
    }
}

-(void)dealWithRequestCallback:(NSDictionary *)dict {
    
    if ([[dict allKeys] containsObject:@"Message"]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[dict objectForKey:@"Message"] delegate:self cancelButtonTitle:@"了解" otherButtonTitles:nil];
        if (!self.view.window) alert.delegate = nil;
        alert.tag = 1001;
        [alert show];
        return;
    }
    
//    NSLog(@"%@",dict);
    
    if ([[dict allKeys] containsObject:@"flag"]){
        [self switchNextController:dict withFlag:[dict objectForKey:@"flag"]];
    }
}

-(void)requestError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"了解" otherButtonTitles:nil];
    [alert show];
}

-(void)switchNextController:(NSDictionary *)dict withFlag:(id)flag{
    int theFlag = (int)[flag integerValue];
    
    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, self.contentView.frame.size.height);
    switch (theFlag) {
        case 6:
            
            if (!_registerScrollView) {
                _registerScrollView = [[MMMRegisterScrollView alloc]initWithFrame:rect];
                _registerScrollView.isShowEmail = _isShowEmail;
                _registerScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
                [_registerScrollView setParams:dict];
                [self.contentView addSubview: _registerScrollView];
                self.titleLabel.text = @"乾多多账户注册绑定";
                __weak typeof(self) RVC = self  ;
                _registerScrollView.completeBlock = ^{
                    [RVC back:nil];
                };
                _registerScrollView.resultBlock = self.resultBlock;
            }
            
            break;
        case 7:
            // 把默认保留的注册信息清除
            _RealName = nil;
            _Mobile = nil;
            _Email = nil;
            _IdentificationNo = nil;
            
            _currentTableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStyleGrouped];
            _currentTableView.delegate = (id)self;
            _currentTableView.dataSource = (id)self;
            self.titleLabel.text = @"乾多多账户注册";
            [self.contentView addSubview: _currentTableView];
            _currentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [_currentTableView reloadData];
            
            if ([dict.allKeys containsObject:@"tempid"]) {
                _tempid = [dict objectForKey:@"tempid"];
                _tempid = [self stringByURLEncodingStringParameter:_tempid];
            }
            if ([dict.allKeys containsObject:@"sidsigninfo"]) {
                _sidsigninfo = [dict objectForKey:@"sidsigninfo"];
                _sidsigninfo = [self stringByURLEncodingStringParameter:_sidsigninfo];
            }
            
            break;
        default:
            if (!_bindTableView) {
                _bindTableView = [[MMMBindTableView alloc]initWithFrame:rect style:UITableViewStyleGrouped];
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dict];
                if (!_Email) {
                    _Email = @"";
                }
                if (!_Mobile){
                    _Mobile = @"";
                }
                [params setObject:_Email forKey:@"Email"];
                [params setObject:_Mobile forKey:@"Mobile"];
                [_bindTableView setParams:params];
                [self.contentView addSubview: _bindTableView];
                self.titleLabel.text = @"乾多多托管账户绑定";
                _bindTableView.ownerDelegate = self;
            }
            
            break;
    }
    
}

#pragma mark - UITableView's HeaderView

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        MMMHeaderView *topView = [[MMMHeaderView alloc]initWithFrame:CGRectMake(5, -10, [UIScreen mainScreen].bounds.size.width-10, 50) andNumOfLabel:1];
        topView.backgroundColor = [UIColor clearColor];
        NSString *title2 = [NSString stringWithFormat:@"乾多多账户: %@",_PlatformName];
        [topView setContext:title2 headerLabel2:nil hederLabel3:nil];
        return topView;
    }
    
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
#pragma mark - UITableViewCell

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MMMSingleInputCellIdentifier = @"MMMSingleInputCellIdentifier";
    
    MMMSingleInputCell *singleInputCell;
    
    singleInputCell = [tableView dequeueReusableCellWithIdentifier:MMMSingleInputCellIdentifier];
    
    if (!singleInputCell){
        singleInputCell = [[MMMSingleInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        singleInputCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        [singleInputCell setTitleContent:[_titleNameDic objectForKey:@"NameTitle"] andDetailContent:_RealName];
    }else if (indexPath.row == 1){
        [singleInputCell setTitleContent:[_titleNameDic objectForKey:@"IdentificationNoTitle"] andDetailContent:_IdentificationNo];
        singleInputCell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }else if (indexPath.row == 2){
        [singleInputCell setTitleContent:@"手机号" andDetailContent:_Mobile];
        singleInputCell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }else if (indexPath.row == 3){
        [singleInputCell setTitleContent:@"填写邮箱" andDetailContent:@""];
        [singleInputCell.textField removeFromSuperview];
        _isSetEmailSwitch.on = _isShowEmail;
        singleInputCell.accessoryView = _isSetEmailSwitch;
    }else if (indexPath.row == 4){
        [singleInputCell setTitleContent:@"邮箱" andDetailContent:_Email];
        singleInputCell.hidden = !_isSetEmailSwitch.on;
        singleInputCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    
    singleInputCell.textField.tag = indexPath.row + 1000;
    singleInputCell.textField.delegate = (id)self;
    singleInputCell.textField.returnKeyType = UIReturnKeyDone;
    
    return singleInputCell;
    
}
#pragma mark - UITableView's FooterView

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
        view.backgroundColor = [UIColor clearColor];
        
        if (!_confirmBtn) {
            _confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width-20, 50)];
            _confirmBtn.backgroundColor = [UIColor colorWithRed:58.0f/255.0f green:108.0f/255.0f blue:241.0f/255.0f alpha:1];
            [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
            [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            _confirmBtn.layer.masksToBounds = YES;
            _confirmBtn.layer.cornerRadius = 5.0f;
            [_confirmBtn addTarget:self action:@selector(confirmBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [view addSubview:_confirmBtn];
        return view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 80;
    }
    else{
        return 0;
    }
}

#pragma mark ------

-(void)confirmBtnPressed:(UIButton *)sender {
    
    _issetemail = @"1";
    if (_isSetEmailSwitch.on) {
        _issetemail = @"";
    }
    
//    if (!_RealName || [[_RealName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请填写姓名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
//        return ;
//    }
//    if (!_IdentificationNo || [[_IdentificationNo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请输入验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
//        return ;
//    }
//    if (!_Mobile || [[_Mobile stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请输入验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
//        return ;
//    }
//    if (!_Email || [[_Email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请输入验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
//        return ;
//    }
    
    if (!_RealName) {
        _RealName = @"";
    }
    if (!_IdentificationNo) {
        _IdentificationNo = @"";
    }
    if (!_Mobile) {
        _Mobile = @"";
    }
    if (!_Email) {
        _Email = @"";
    }
    
    _confirmBtn.enabled = NO;
    
    NSDictionary *postDic = @{@"Phone":@"1",
                              @"RealName":_RealName,
                              @"IdentificationNo":_IdentificationNo,
                              @"Mobile":_Mobile,
                              @"Email":_Email,
                              @"issetemail":_issetemail,
                              @"sid":_tempid,
                              @"sidsigninfo":_sidsigninfo
                              };
    
    
    NSString *paramsString = [MMMConfigUtil sharedConfigUtil].setPostString(postDic);
    
    [MMMActivityIndicatorView show];
    [MMMConfigUtil sharedConfigUtil].toRegisterExtraBind(paramsString,^(NSData *data, NSError *error){
        _confirmBtn.enabled = YES;
        [MMMActivityIndicatorView remove];
        if (!error) {
            NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [dict setValuesForKeysWithDictionary:_titleNameDic];
//            NSLog(@"%@",result);
            [self dealWithConfirmBtnCallBack:dict];
        }else{
            [self requestError:error];
        }
    });
}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    _currentObj = nil;
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField.tag == 1000) {
        _RealName = textField.text;
    }else if (textField.tag == 1001){
        _IdentificationNo = textField.text;
    }else if (textField.tag == 1002){
        _Mobile = textField.text;
    }else if (textField.tag == 1003){
        
    }else if (textField.tag == 1004){
        _Email = textField.text;
    }
//    [self.tableView reloadData];
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

-(void)RA:(NSDictionary *)params{
    
    if (!_registerScrollView) {
        CGRect rect = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
        _registerScrollView = [[MMMRegisterScrollView alloc]initWithFrame:rect];
        
        _registerObject = [[MMMRegisterObject alloc]init];
        [_registerObject setValuesForKeysWithDictionary:params];
        
        //  如果填写邮箱 则显示
        if (![[_registerObject.Email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
            _isShowEmail = YES;
        }else{
            _isShowEmail = NO;
        }
        
        _registerScrollView.isShowEmail = _isShowEmail;
        _registerScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_registerScrollView setParams:params];
        [self.contentView addSubview:_registerScrollView];
        self.titleLabel.text = @"乾多多账户注册绑定";
        __weak typeof(self) RVC = self  ;
        _registerScrollView.completeBlock = ^{
            [RVC back:nil];
        };
        _registerScrollView.resultBlock = self.resultBlock;
        
        _signDataDic = [params mutableCopy];
    }
    
    
    [_bindTableView removeFromSuperview];
    _bindTableView.ownerDelegate = nil;
    _bindTableView = nil;
    
}

@end
