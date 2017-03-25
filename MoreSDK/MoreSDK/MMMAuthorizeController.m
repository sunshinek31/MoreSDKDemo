//
//  MMMAuthorizeController.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/21.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMAuthorizeController.h"
#import "MMMAuthorizeObject.h"
#import "MMMConfigUtil.h"
#import "MMMHeaderView.h"
#import "MMMPasswordInputCell.h"
#import "MMMAuthorizeInfoCell.h"
#import "MMMSingleInputCell.h"

@interface MMMAuthorizeController ()
<UITextFieldDelegate>
@property (nonatomic, strong) MMMAuthorizeObject *authorizeObject;
@property (nonatomic, strong) UITextView *disclaimerTextView;
@property (nonatomic, assign) BOOL hasGetImformation;
@property (nonatomic, weak) id currentObj;
@property (nonatomic, strong) UIButton *authorizeBtn;       // 授权按钮
@property (nonatomic, strong) MMMSingleInputCell *passwordInputCell;
@property (nonatomic, assign) CGRect authorizeTableViewFrame;
@property (nonatomic, strong) UITableView *currentTableView;
@end

@implementation MMMAuthorizeController
{
    NSString *_loanPlatformAccount;
    NSString *_authorizeOpened;
    NSString *_authorizeOpen;
    NSString *_authorizeClose;
    NSString *_disclaimer;
    NSString *_smid;
    NSString *_authorizeTypeOpen;
    NSString *_authorizeTypeClose;
    NSString *_notifyURL;
    NSString *_randomTimeStamp;
    NSString *_remark1;
    NSString *_remark2;
    NSString *_remark3;
    NSString *_signInfo;
    NSString *_recordId;
    
    NSString *_payPassword;
    
    NSIndexPath *_indexPath;
//    CGRect _keyboardRect;
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
        CGRect rect = [self.currentTableView convertRect:self.authorizeBtn.frame fromView:self.authorizeBtn];
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
    self.titleLabel.text = @"乾多多授权";

    _currentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height) style:UITableViewStyleGrouped];
    _currentTableView.delegate = (id)self;
    _currentTableView.dataSource = (id)self;
    _currentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.contentView addSubview:_currentTableView];
    
    _authorizeObject = [[MMMAuthorizeObject alloc]init];
    [_authorizeObject setValuesForKeysWithDictionary:params];
    
    if (![self checkNecessaryParams:"MMMAuthorizeObject" tagertObj:_authorizeObject]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"提交的数据,缺少必要参数" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *signDataStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",
                             _authorizeObject.MoneymoremoreId,
                             _authorizeObject.PlatformMoneymoremore,
                             _authorizeObject.AuthorizeTypeOpen,
                             _authorizeObject.AuthorizeTypeClose,
                             _authorizeObject.RandomTimeStamp,
                             _authorizeObject.Remark1,
                             _authorizeObject.Remark2,
                             _authorizeObject.Remark3,
                             _authorizeObject.ReturnURL,
                             _authorizeObject.NotifyURL];
    
    //  得到RSA签名过后的字符串
    NSString *signString = self.signInfoBlock(signDataStr,YES);
    if (!signString) {
        signString = @"";
    }
    
    [MMMActivityIndicatorView show];
    [MMMConfigUtil sharedConfigUtil].beginServiceWithDict(MMMAuthorizationEvent, params, [signString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],^(NSData *data,NSError *error){
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

#pragma mark - 数据回调处理

-(void)dealWithRequestCallback:(NSDictionary *)dict {
    
    if ([dict.allKeys containsObject:@"Message"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"验证提示" message:[dict objectForKey:@"Message"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        if (!self.view.window) alert.delegate = nil;
        alert.tag = 1001;
        [alert show];
        
        return;
    }
    _hasGetImformation = YES;
    
    _loanPlatformAccount = [dict objectForKey:@"LoanPlatformAccount"];
    _authorizeOpened = [dict objectForKey:@"AuthorizeOpened"];
    _authorizeOpen = [dict objectForKey:@"AuthorizeOpen"];
    _authorizeClose = [dict objectForKey:@"AuthorizeClose"];
    _disclaimer = [dict objectForKey:@"Disclaimer"];
    _smid = [dict objectForKey:@"smid"];
    _authorizeTypeOpen = [dict objectForKey:@"AuthorizeTypeOpen"];
    _authorizeTypeClose = [dict objectForKey:@"AuthorizeTypeClose"];
    _notifyURL = [dict objectForKey:@"NotifyURL"];
    _randomTimeStamp = [dict objectForKey:@"RandomTimeStamp"];
    _remark1 = [dict objectForKey:@"Remark1"];
    _remark2 = [dict objectForKey:@"Remark2"];
    _remark3 = [dict objectForKey:@"Remark3"];
    _signInfo = [dict objectForKey:@"SignInfo"];
    _recordId = [dict objectForKey:@"RecordId"];
    
    [_currentTableView reloadData];
}

-(void)requestError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _hasGetImformation?2:0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }
    return 0;
}

#pragma mark - UItableViewCell's view

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 60;
    }else if (indexPath.section == 0){
        return 130+10;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MMMAuthorizeInfoCellIdentifier = @"MMMAuthorizeInfoCellIdentifier";
    static NSString *MMMPasswordInputCellIdentifier = @"MMMPasswordInputCellIdentifier";
    
    static NSString *MMMSingleInputCellIdentifier = @"MMMSingleInputCellIdentifier";
    
    MMMSingleInputCell *singleInputCell;
    singleInputCell = [tableView dequeueReusableCellWithIdentifier:MMMSingleInputCellIdentifier];
    
    MMMAuthorizeInfoCell *authorizeInfoCell;
    authorizeInfoCell = [tableView dequeueReusableCellWithIdentifier:MMMAuthorizeInfoCellIdentifier];
    
    if (indexPath.section == 1){
        if (!singleInputCell) {
            singleInputCell = [[MMMSingleInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MMMSingleInputCellIdentifier];
            singleInputCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else if (indexPath.section == 0){
        if (!authorizeInfoCell) {
            authorizeInfoCell = [[MMMAuthorizeInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MMMAuthorizeInfoCellIdentifier];
            authorizeInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    if (indexPath.section == 1){
        if (!self.passwordInputCell) {
            self.passwordInputCell = [[MMMSingleInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        
        [self.passwordInputCell setTitleContent:@"支付密码" andDetailContent:_payPassword];
        self.passwordInputCell.textField.tag = 1001;
        self.passwordInputCell.textField.delegate = self;
        self.passwordInputCell.textField.secureTextEntry = YES;
        return self.passwordInputCell;
    }else if (indexPath.section == 0){
        if (![_authorizeClose isEqualToString:@"无"]) {
            authorizeInfoCell.authorizeTitleLable.text = @"本次关闭:";
            authorizeInfoCell.authorizeContent.text = _authorizeClose;
        }else{
            authorizeInfoCell.authorizeContent.text = _authorizeOpen;
        }
        NSArray *arr = [_authorizeOpened componentsSeparatedByString:@"，"];
        NSMutableString *str = [NSMutableString string];
        for (int i = 0; i<arr.count; i++) {
            if (i== 0) {
                [str appendFormat:@"%@",arr[0]];
            }else{
                [str appendFormat:@"\n%@",arr[i]];
            }
        }
        authorizeInfoCell.authorizeOpenedLabel.text = str;
        return authorizeInfoCell;
    }
    
    return nil;
}

#pragma mark - UITableView's HeaderView

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 50;
    }else if (section == 1){
        return 70;
    }else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view;
    if (section == 0) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60+10)];
        MMMHeaderView *topView = [[MMMHeaderView alloc]initWithFrame:CGRectMake(5, 10, [UIScreen mainScreen].bounds.size.width-10, 60) andNumOfLabel:2];
        topView.backgroundColor = [UIColor clearColor];
        
//        NSString *title1 = [NSString stringWithFormat:@"乾多多账户: %@",_loanPlatformAccount ];
        NSString *title2 = [NSString stringWithFormat:@"您在平台的用户名: %@",_loanPlatformAccount];
        [topView setContext:title2 headerLabel2:nil hederLabel3:nil];
        
        [view addSubview:topView];
        return view;
    }else if (section == 1){
        
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60+10)];
        
        if (!_disclaimerTextView) {
            _disclaimerTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 70)];
            _disclaimerTextView.backgroundColor = [UIColor clearColor];
            _disclaimerTextView.font = [UIFont systemFontOfSize:12];
            _disclaimerTextView.textColor = [UIColor colorWithRed:100.0f/255.0f green:149.0f/255.0f blue:237.0f/255.0f alpha:1];
            _disclaimerTextView.editable = NO;
            _disclaimerTextView.userInteractionEnabled = NO;
        }
        [view addSubview:_disclaimerTextView];
        _disclaimerTextView.text = _disclaimer;
        return view;
    }
    
    return nil;
}

#pragma mark - UITableView's FooterView

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
        view.backgroundColor = [UIColor clearColor];
        
        if (!_authorizeBtn) {
            _authorizeBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width-20, 50)];
            _authorizeBtn.backgroundColor = [UIColor colorWithRed:58.0f/255.0f green:108.0f/255.0f blue:241.0f/255.0f alpha:1];
            [_authorizeBtn setTitle:@"确认认证" forState:UIControlStateNormal];
            [_authorizeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            _authorizeBtn.layer.masksToBounds = YES;
            _authorizeBtn.layer.cornerRadius = 5.0f;
            [_authorizeBtn addTarget:self action:@selector(authorizeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [view addSubview:_authorizeBtn];
        return view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 80;
    }else if (section == 0){
        return 0;
    }
    else{
        return 0;
    }
}

#pragma mark --------------------

-(void)authorizeBtnPressed:(UIButton *)sender {
    
    if (_currentObj){
        [_currentObj resignFirstResponder];
        _currentObj = nil;
    }
    
    
    if (!_payPassword || [[_payPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"密码不能为空,请填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    _authorizeBtn.enabled = NO;
    [self authourize];
}

-(void)authourize {
    
    if (!_randomTimeStamp){
        _randomTimeStamp = @"";
    }
    if (!_recordId) {
        _recordId = @"";
    }
    if (!_remark1) {
        _remark1 = @"";
    }
    if (!_remark2) {
        _remark2 = @"";
    }
    if (!_remark3) {
        _remark3 = @"";
    }
    
    NSDictionary *postDic = @{@"payPassword":_payPassword,
                              @"smid":_smid,
                              @"AuthorizeTypeOpen":_authorizeTypeOpen,
                              @"AuthorizeTypeClose":_authorizeTypeClose,
                              @"NotifyURL": [self stringByURLEncodingStringParameter:_notifyURL],
                              @"RandomTimeStamp":_randomTimeStamp,
                              @"Remark1":_remark1,
                              @"Remark2":_remark2,
                              @"Remark3":_remark3,
                              @"SignInfo":[self stringByURLEncodingStringParameter:_signInfo],
                              @"RecordId":_recordId,
                              @"phone":@"1"};
    
    
    NSString *paramsString = [MMMConfigUtil sharedConfigUtil].setPostString(postDic);
    [MMMActivityIndicatorView show];
    [MMMConfigUtil sharedConfigUtil].toAuthorize(paramsString,^(NSData *data, NSError *error){
        _authorizeBtn.enabled = YES;
        [MMMActivityIndicatorView remove];
        if (!error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [self dealWithRequestOfAuthorize:dict];
        }else{
            [self requestError:error];
        }
    });
    
}

-(void)dealWithRequestOfAuthorize:(NSDictionary *)dict{
    
    
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    [resultDic setObject:[dict objectForKey:@"Message"] forKey:@"Message"];
    if ([dict.allKeys containsObject:@"AuthorizeTypeClose"]) {
        [resultDic setObject:[dict objectForKey:@"AuthorizeTypeClose"] forKey:@"AuthorizeTypeClose"];
    }
    if ([dict.allKeys containsObject:@"AuthorizeTypeOpen"]) {
        [resultDic setObject:[dict objectForKey:@"AuthorizeTypeOpen"] forKey:@"AuthorizeTypeOpen"];
    }
    if ([[dict allKeys] containsObject:@"ResultCode"]) {
        [resultDic setObject:[dict objectForKey:@"ResultCode"] forKey:@"ResultCode"];
    }
    if (self.resultBlock)
        self.resultBlock(resultDic, MMMAuthorizationEvent);
    
    
    ///////////////////////////////
    
        if ([[dict allKeys]containsObject:@"ResultCode"]) {
            if ([[dict objectForKey:@"ResultCode"]isEqualToString:@"88"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"授权成功" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil];
                alert.tag = 1001;
                if (!self.view.window) alert.delegate = nil;
                [alert show];
                return;
            }
        }
        
        
        if ([[dict allKeys]containsObject:@"Message"]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"授权提示" message:[dict objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
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

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    _currentObj = nil;
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
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
