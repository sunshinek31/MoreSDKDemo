//
//  MMMBindTableView.m
//  MoreSDKDemo
//
//  Created by sunshinek31 on 15/1/27.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMBindTableView.h"
#import "MMMBindInfoCell.h"
#import "MMMHeaderView.h"
#import "MMMBindListCell.h"
#import "MMMSingleInputCell.h"
#import "MMMConfigUtil.h"
#import "MMMRegisterController.h"
#import "MMMActivityIndicatorView.h"

@interface MMMBindTableView ()
<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) NSMutableDictionary *theParams;
@property (nonatomic, copy) NSString *hint;

@property (nonatomic, assign) BOOL hasGetImformation;
@property (nonatomic, assign) BOOL showRegisterInfo;

@property (nonatomic, strong) NSMutableArray *registeredInfoArr;
@property (nonatomic, weak) id currentObj;

@property (nonatomic, strong) UITextView *disclaimerTextView;
@property (nonatomic, strong) NSMutableArray *bindListArr;

@property (nonatomic, strong) UIButton *bindBtn;
@property (nonatomic, strong) UIButton *reRegisterBtn;

//@property (nonatomic, assign) BOOL isShowMobileRegisterName;    //是否显示手机注册人
//@property (nonatomic, assign) BOOL isShowEmailRegisterName;     //是否显示邮箱注册人

@property (nonatomic, assign) BOOL isShowEmail;
@end

@implementation MMMBindTableView
{
    NSString *_realName;
    NSString *_identificationNo;
    NSString *_questionVerify;
    
    NSString *_loanPlatformAccount;
    NSString *_loanRegisterBindList;
    NSString *_tempid;
    
    NSString *_modifytype1;
    NSString *_mid;
    NSString *_bindId;
    NSString *_password;
    NSString *_paymentCode;
    NSString *_question1;
    NSString *_question2;
    NSString *_question3;
    NSString *_answer1;
    NSString *_answer2;
    NSString *_answer3;
    
    NSString *_emailRegisterName;
    NSString *_emailRegisterIdentificationNo;
    
    NSString *_mobileRegisterName;
    NSString *_mobileRegisterIdentificationNo;
    
    NSUInteger _flag;
    NSIndexPath *_indexPath;
    CGRect _keyboardRect;
    
    NSUInteger _numOfSection;
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
//        _bindTableViewFrame = frame;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisapplear:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark - NSNoticification

-(void)keyboardWillDisapplear:(NSNotification *)notification {
    
    self.contentInset = UIEdgeInsetsZero;
}

////////// 存在bug
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue];
    
    float height = kbRect.size.height;
    
    if (height != 0) {
        
        self.contentInset = UIEdgeInsetsMake(0, 0, height, 0);
        
    }
}

-(void)setParams:(NSDictionary *)params {
    
    
    
    self.theParams = [params mutableCopy];

    NSDictionary *dict;
    _registeredInfoArr = [NSMutableArray array];
    
    if ([params.allKeys containsObject:@"flag"]) {
        _flag = [[params objectForKey:@"flag"] integerValue];
    }
    
    // 
    /////////////////////
    if ([params.allKeys containsObject:@"question1"]) {
        _mobileRegisterName = [params objectForKey:@"question1"];
        _showRegisterInfo = YES;
    }
    if ([params.allKeys containsObject:@"question3"]) {
        _mobileRegisterIdentificationNo = [params objectForKey:@"question3"];
        _showRegisterInfo = YES;
    }
    
    if ([params.allKeys containsObject:@"answer1"]) {
        _emailRegisterName = [params objectForKey:@"answer1"];
        _showRegisterInfo = YES;
    }
    if ([params.allKeys containsObject:@"answer3"]) {
        _emailRegisterIdentificationNo = [params objectForKey:@"answer3"];
        _showRegisterInfo = YES;
    }
    ///////////////////////
    
    switch (_flag) {
        case 1:
            // 相同身份证
            _hint = @"系统检测到您的手机号和邮箱均已注册过乾多多账户";
            
            if ([params.allKeys containsObject:@"question1"]) {
                _mobileRegisterName = [params objectForKey:@"question1"];
                _showRegisterInfo = YES;
            }
            if ([params.allKeys containsObject:@"question3"]) {
                _mobileRegisterIdentificationNo = [params objectForKey:@"question3"];
                _showRegisterInfo = YES;
            }
            
            if ([params.allKeys containsObject:@"answer1"]) {
                _emailRegisterName = [params objectForKey:@"answer1"];
                _showRegisterInfo = YES;
            }
            if ([params.allKeys containsObject:@"answer3"]) {
                _emailRegisterIdentificationNo = [params objectForKey:@"answer3"];
                _showRegisterInfo = YES;
            }
            
            ////////////////////////////
            
            if (_mobileRegisterName && ![[_mobileRegisterName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
                dict = @{@"Name":_mobileRegisterName,@"Id":_mobileRegisterIdentificationNo,@"Title":@"手机注册人"};
                [_registeredInfoArr addObject:[dict copy]];
            }
            
            if (_emailRegisterName && ![[_emailRegisterName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
                dict = @{@"Name":_emailRegisterName,@"Id":_emailRegisterIdentificationNo,@"Title":@"邮箱注册人"};
                [_registeredInfoArr addObject:[dict copy]];
            }
            
//            _isShowMobileRegisterName = YES;
//            _isShowEmailRegisterName = YES;
            
            
//            [self.theParams setObject:@"" forKey:@"Email"];
//            [self.theParams setObject:@"" forKey:@"Mobile"];
            break;
        case 2:
            _hint = @"系统检测到您的手机号和邮箱均已注册过乾多多账户";
            
            if ([params.allKeys containsObject:@"question1"]) {
                _emailRegisterName = _mobileRegisterName = [params objectForKey:@"question1"];
                _showRegisterInfo = YES;
            }
            if ([params.allKeys containsObject:@"question3"]) {
                _emailRegisterIdentificationNo = _mobileRegisterIdentificationNo = [params objectForKey:@"question3"];
                _showRegisterInfo = YES;
            }
            
            ////////////////
            if (_mobileRegisterName && ![[_mobileRegisterName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
                dict = @{@"Name":_mobileRegisterName,@"Id":_mobileRegisterIdentificationNo,@"Title":@"手机注册人"};
                [_registeredInfoArr addObject:[dict copy]];
            }
            
            if (_emailRegisterName && ![[_emailRegisterName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
                dict = @{@"Name":_emailRegisterName,@"Id":_emailRegisterIdentificationNo,@"Title":@"邮箱注册人"};
                [_registeredInfoArr addObject:[dict copy]];
            }
            
//            _isShowMobileRegisterName = YES;
//            _isShowEmailRegisterName = YES;
            
//            [self.theParams setObject:@"" forKey:@"Email"];
//            [self.theParams setObject:@"" forKey:@"Mobile"];
            break;
        case 3:
            //  不同身份证
            _hint = @"系统检测到您的手机号和邮箱均已注册过乾多多账户";
            
            if ([params.allKeys containsObject:@"question1"]) {
                _mobileRegisterName = [params objectForKey:@"question1"];
                _showRegisterInfo = YES;
            }
            if ([params.allKeys containsObject:@"question3"]) {
                _mobileRegisterIdentificationNo = [params objectForKey:@"question3"];
                _showRegisterInfo = YES;
            }
            
            if ([params.allKeys containsObject:@"answer1"]) {
                _emailRegisterName = [params objectForKey:@"answer1"];
                _showRegisterInfo = YES;
            }
            if ([params.allKeys containsObject:@"answer3"]) {
                _emailRegisterIdentificationNo = [params objectForKey:@"answer3"];
                _showRegisterInfo = YES;
            }
            
            ///////////
            if (_mobileRegisterName && ![[_mobileRegisterName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
                dict = @{@"Name":_mobileRegisterName,@"Id":_mobileRegisterIdentificationNo,@"Title":@"手机注册人"};
                [_registeredInfoArr addObject:[dict copy]];
            }
            
            if (_emailRegisterName && ![[_emailRegisterName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
                dict = @{@"Name":_emailRegisterName,@"Id":_emailRegisterIdentificationNo,@"Title":@"邮箱注册人"};
                [_registeredInfoArr addObject:[dict copy]];
            }
            
//            _isShowMobileRegisterName = YES;
//            _isShowEmailRegisterName = YES;
            
//            [self.theParams setObject:@"" forKey:@"Email"];
//            [self.theParams setObject:@"" forKey:@"Mobile"];
            
            break;
        case 4:
            _hint = @"系统检测到您的手机号已注册过乾多多账户";
            if ([params.allKeys containsObject:@"question1"]) {
                _mobileRegisterName = [params objectForKey:@"question1"];
                _showRegisterInfo = YES;
            }
            if ([params.allKeys containsObject:@"question3"]) {
                _mobileRegisterIdentificationNo = [params objectForKey:@"question3"];
                _showRegisterInfo = YES;
            }
            
            ////////////////
            
            if (_mobileRegisterName && ![[_mobileRegisterName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
                dict = @{@"Name":_mobileRegisterName,@"Id":_mobileRegisterIdentificationNo,@"Title":@"手机注册人"};
                [_registeredInfoArr addObject:[dict copy]];
            }
            
//            _isShowMobileRegisterName = YES;
            
//            [self.theParams setObject:@"" forKey:@"Mobile"];
            break;
        case 5:
            _hint = @"系统检测到您的邮箱已注册过乾多多账户";
            
            if ([params.allKeys containsObject:@"question1"]) {
                _emailRegisterName = [params objectForKey:@"question1"];
                _showRegisterInfo = YES;
            }
            if ([params.allKeys containsObject:@"question3"]) {
                _emailRegisterIdentificationNo = [params objectForKey:@"question3"];
                _showRegisterInfo = YES;
            }
            
            ////////////////
            if (_emailRegisterName && ![[_emailRegisterName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
                dict = @{@"Name":_emailRegisterName,@"Id":_emailRegisterIdentificationNo,@"Title":@"邮箱注册人"};
                [_registeredInfoArr addObject:[dict copy]];
            }
            
//            _isShowEmailRegisterName = YES;
            
//            [self.theParams setObject:@"" forKey:@"Email"];
            break;
        case 0:
            _hint = @"";
            break;
        default:
            _hint = @"系统检测到您的手机号和邮箱均已注册过乾多多账户";
            if (_mobileRegisterName && ![[_mobileRegisterName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
                dict = @{@"Name":_mobileRegisterName,@"Id":_mobileRegisterIdentificationNo,@"Title":@"手机注册人"};
                [_registeredInfoArr addObject:[dict copy]];
            }
            
            if (_emailRegisterName && ![[_emailRegisterName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
                dict = @{@"Name":_emailRegisterName,@"Id":_emailRegisterIdentificationNo,@"Title":@"邮箱注册人"};
                [_registeredInfoArr addObject:[dict copy]];
            }
            
//            _isShowMobileRegisterName = YES;
//            _isShowEmailRegisterName = YES;
            
//            [self.theParams setObject:@"" forKey:@"Email"];
//            [self.theParams setObject:@"" forKey:@"Mobile"];
            break;
    }
    
    
    /////////////////////////////
    if ([params.allKeys containsObject:@"RealName"]) {
        _realName = [params objectForKey:@"RealName"];
    }
    
    if ([params.allKeys containsObject:@"IdentificationNo"]) {
        _identificationNo = [params objectForKey:@"IdentificationNo"];
    }
    if ([params.allKeys containsObject:@"tempid"]) {
        _tempid = [params objectForKey:@"tempid"];
    }
    if ([params.allKeys containsObject:@"QuestionVerify"]) {
        _questionVerify = [params objectForKey:@"QuestionVerify"];
    }
    
    if ([params.allKeys containsObject:@"LoanPlatformAccount"]) {
        _loanPlatformAccount = [params objectForKey:@"LoanPlatformAccount"];
    }
    
    if ([params.allKeys containsObject:@"LoanRegisterBindList"]) {
        _loanRegisterBindList = [params objectForKey:@"LoanRegisterBindList"];
        NSData *jsonData = [_loanRegisterBindList dataUsingEncoding:NSUTF8StringEncoding];
        _bindListArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
    }
    
    if (_bindListArr.count > 0) {
        _numOfSection ++;
    }
    
    if (_showRegisterInfo) {
        _numOfSection ++;
    }
    _hasGetImformation = YES;
    [self reloadData];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _hasGetImformation?2:0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (section == 0) {
       return  _registeredInfoArr.count;
//        if (_isShowMobileRegisterName) {
//            count++;
//        }
//        
//        if (_isShowEmailRegisterName) {
//            count++;
//        }
    }else if (section == 1){
        count = _bindListArr.count==0?0:_bindListArr.count+1;
    }
    
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == _bindListArr.count) {
        return 60;
    }
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MMMBindInfoCellIdentifier = @"MMMBindInfoCellIdentifier";
    static NSString *MMMBindListCellIdentifier = @"MMMBindListCellIdentifier";
    static NSString *MMMSingleInputCellIdentifier = @"MMMSingleInputCellIdentifier";
    
    MMMSingleInputCell *singleInputCell = [tableView dequeueReusableCellWithIdentifier:MMMSingleInputCellIdentifier];
    MMMBindInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:MMMBindInfoCellIdentifier];
    MMMBindListCell *listCell = [tableView dequeueReusableCellWithIdentifier:MMMBindListCellIdentifier];
    
    if (indexPath.section == 0) {
        if (!infoCell) {
            infoCell = [[MMMBindInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MMMBindInfoCellIdentifier];
            infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == _bindListArr.count) {
            singleInputCell = [[MMMSingleInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MMMSingleInputCellIdentifier];
            singleInputCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            if (!listCell) {
                listCell = [[MMMBindListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MMMBindListCellIdentifier];
                listCell.selectionStyle = UITableViewCellSelectionStyleNone;
                listCell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    
    
    if (indexPath.section == 0) {
        NSDictionary *dict = [_registeredInfoArr objectAtIndex:indexPath.row];
        NSString *title = [dict objectForKey:@"Title"];
        NSString *name = [dict objectForKey:@"Name"];
        NSString *Id = [dict objectForKey:@"Id"];
        
        [infoCell setRegisterInfo:title
                     registerName:[NSString stringWithFormat:@" 姓名 : %@",name]
                    certificateID:[NSString stringWithFormat:@" 身份证 : %@",Id]];
        
        return infoCell;
    }else if (indexPath.section == 1){
        if (indexPath.row == _bindListArr.count) {
            [singleInputCell setTitleContent:@"支付密码" andDetailContent:_password];
            singleInputCell.textField.tag = 1001;
            singleInputCell.textField.delegate = self;
            singleInputCell.textField.secureTextEntry = YES;
            return singleInputCell;
        }else{
            NSDictionary *dict = [_bindListArr objectAtIndex:indexPath.row];
            NSString *account1;
            NSString *account2;
            NSString *baseId;
            listCell.accessoryType = UITableViewCellAccessoryNone;
            if ([dict.allKeys containsObject:@"MoneymoremoreAccount1"]) {
                account1 = [dict objectForKey:@"MoneymoremoreAccount1"];
            }
            if ([dict.allKeys containsObject:@"MoneymoremoreAccount2"]) {
                account2 = [dict objectForKey:@"MoneymoremoreAccount2"];
            }
            if ([dict.allKeys containsObject:@"baseId"]) {
                baseId = [dict objectForKey:@"baseId"];
            }
            
            if ([_mid isEqualToString:baseId]) {
                listCell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            
            [listCell setTitle:account1
                      account2:account2
                      realName:_realName
                  identifierId:_identificationNo];
            return listCell;
        }
    }
    
    return nil;
}

#pragma mark - tableview header

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40+40;
    }else{
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view;
    if (section == 0) {
        view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
        view.backgroundColor = [UIColor clearColor];
        
        MMMHeaderView *headview = [[MMMHeaderView alloc]initWithFrame:CGRectMake(5, 10, [UIScreen mainScreen].bounds.size.width-10, 30) andNumOfLabel:1];
        
        NSString *title_1 = [NSString stringWithFormat:@"平台用户名: %@",_loanPlatformAccount];
        
        [headview setContext:title_1 headerLabel2:nil hederLabel3:nil];
        
        
        if (!_disclaimerTextView) {
            _disclaimerTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 40, [UIScreen mainScreen].bounds.size.width-20, 40)];
            _disclaimerTextView.backgroundColor = [UIColor clearColor];
            _disclaimerTextView.font = [UIFont systemFontOfSize:12];
            _disclaimerTextView.textColor = [UIColor colorWithRed:100.0f/255.0f green:149.0f/255.0f blue:237.0f/255.0f alpha:1];
            _disclaimerTextView.editable = NO;
        }
        
        NSString *text = [NSString stringWithFormat:@"温馨提示:\n%@",_hint];
        _disclaimerTextView.text = text;
        [view addSubview:headview];
        [view addSubview:_disclaimerTextView];
        _disclaimerTextView.userInteractionEnabled = NO;
    }
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        _mid = nil;
        NSDictionary *dict = [_bindListArr objectAtIndex:indexPath.row];
        
//        NSLog(@"row: %i, \n=============\n%@",indexPath.row, dict);
        if ([dict.allKeys containsObject:@"baseId"]) {
            _mid = [dict objectForKey:@"baseId"];
        }
        
        if ([dict.allKeys containsObject:@"MoneymoremoreId"]) {
            _bindId = [dict objectForKey:@"MoneymoremoreId"];
        }
    }
    [self reloadData];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1 && _bindListArr.count > 0) {
        return @"选择绑定作为托管账户的乾多多账户";
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        if (_bindListArr.count == 0) {
            return 80;
        }else{
            return 60*2 + 10;
        }
    }else{
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1 ) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
        view.backgroundColor = [UIColor clearColor];
        if (_bindListArr.count > 0) {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60*2+10)];
            if (!_bindBtn) {
                _bindBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 50)];
                _bindBtn.backgroundColor = [UIColor colorWithRed:58.0f/255.0f green:108.0f/255.0f blue:241.0f/255.0f alpha:1];
                
                NSString *title = @"确认绑定";
                
                [_bindBtn setTitle:title forState:UIControlStateNormal];
                [_bindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                _bindBtn.layer.masksToBounds = YES;
                _bindBtn.layer.cornerRadius = 5.0f;
                
                [_bindBtn addTarget:self action:@selector(bindBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            [view addSubview:_bindBtn];
            
            if (!_reRegisterBtn) {
                _reRegisterBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 70, [UIScreen mainScreen].bounds.size.width-20, 50)];
                _reRegisterBtn.backgroundColor = [UIColor colorWithRed:58.0f/255.0f green:108.0f/255.0f blue:241.0f/255.0f alpha:1];
                
                NSString *title = @"重新注册";
                
                [_reRegisterBtn setTitle:title forState:UIControlStateNormal];
                [_reRegisterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                _reRegisterBtn.layer.masksToBounds = YES;
                _reRegisterBtn.layer.cornerRadius = 5.0f;
                
                [_reRegisterBtn addTarget:self action:@selector(RA:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            [view addSubview:_reRegisterBtn];
        }else if (_bindListArr.count == 0){
            if (!_reRegisterBtn) {
                _reRegisterBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 50)];
                _reRegisterBtn.backgroundColor = [UIColor colorWithRed:58.0f/255.0f green:108.0f/255.0f blue:241.0f/255.0f alpha:1];
                
                NSString *title = @"重新注册";
                
                [_reRegisterBtn setTitle:title forState:UIControlStateNormal];
                [_reRegisterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                _reRegisterBtn.layer.masksToBounds = YES;
                _reRegisterBtn.layer.cornerRadius = 5.0f;
                
                [_reRegisterBtn addTarget:self action:@selector(RA:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [view addSubview:_reRegisterBtn];
        }
        
        return view;
    }
    return nil;
}

#pragma mark -----------
// 绑定页面跳转到注册页面
-(void)RA:(UIButton *)sender {
    
    if (self.ownerDelegate && [self.ownerDelegate isKindOfClass:[MMMRegisterController class]]) {
        
        [self.ownerDelegate RA:self.theParams];
//        [self.ownerDelegate RA:self.theParams isShowEmail:_isShowEmailRegisterName];
    }
}

-(void)bindBtnPressed:(UIButton *)sender {
    if (_currentObj) {
        [_currentObj resignFirstResponder];
    }
    
    
    if (!_mid || [[_mid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:[NSString stringWithFormat:@"%@",@"请选择绑定账户"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        _bindBtn.enabled = YES;
        return;
    }
    
    if (!_password || [[_password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:[NSString stringWithFormat:@"%@",@"请输入支付密码"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        _bindBtn.enabled = YES;
        return;
    }
    
    
    _bindBtn.enabled = NO;
    
    NSDictionary *paramsDic = @{@"password":_password,
                                @"tempid":_tempid,
                                @"mid":_mid,
                                @"bindId":_bindId,
                                @"phone":@"1"};
    
    NSString *paramsString = [MMMConfigUtil sharedConfigUtil].setPostString(paramsDic);
    
    [MMMActivityIndicatorView show];
    [MMMConfigUtil sharedConfigUtil].toLoanBind(paramsString,^(NSData *data, NSError *error){
        _bindBtn.enabled = YES;
        [MMMActivityIndicatorView remove];
        if (!error) {
            id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [self dealWithCallbackOfBind:obj];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[error localizedDescription] delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
            [alert show];
        }
    });
    
}

-(void)dealWithCallbackOfBind:(id)obj {
    
    __weak MMMRegisterController *vc;
    if (self.ownerDelegate && [self.ownerDelegate isKindOfClass:[MMMRegisterController class]]) {
        vc = self.ownerDelegate;
    }
    
    if ([obj isKindOfClass:[NSDictionary class]]){
        NSDictionary *dict = obj;
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        
        if ([[dict allKeys] containsObject:@"Message"]) {
            [resultDic setObject:[dict objectForKey:@"Message"] forKey:@"Message"];
        }
        if ([[dict allKeys] containsObject:@"AccountNumber"]) {
            [resultDic setObject:[dict objectForKey:@"AccountNumber"] forKey:@"AccountNumber"];
        }
        if ([[dict allKeys] containsObject:@"ResultCode"]) {
            [resultDic setObject:[dict objectForKey:@"ResultCode"] forKey:@"ResultCode"];
        }
        if ([[dict allKeys] containsObject:@"MoneymoremoreId"]) {
            [resultDic setObject:[dict objectForKey:@"MoneymoremoreId"] forKey:@"MoneymoremoreId"];
        }
        
        if (vc.resultBlock)
            vc.resultBlock(resultDic, MMMRegisterEvent);
        
        if ([[dict allKeys] containsObject:@"ResultCode"]) {
            if ([[dict objectForKey:@"ResultCode"]isEqualToString:@"88"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[dict objectForKey:@"Message"] delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil];
                alert.tag = 1001;
                if (!self.window) alert.delegate = nil;
                [alert show];
                return;
            }
        }
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"绑定提示" message:[dict objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    _currentObj = nil;
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    _currentObj = nil;
    _currentObj = textField;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField.tag == 1001) {
        _password = textField.text;
    }
    [self reloadData];
    return YES;
}

#pragma mark - UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        if (self.ownerDelegate && [self.ownerDelegate isKindOfClass:[MMMRegisterController class]]) {
            [self.ownerDelegate back:nil];
        }
    }
}
@end
