//
//  MMMRegisterTableView.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMRegisterTableView.h"
#import "MMMConfigUtil.h"
#import "MMMTableTitleView.h"
#import "MMMHeaderView.h"
#import "MMMSingleInputCell.h"
#import "MMMSendMessageCell.h"
#import "MMMCheckCodeCell.h"
#import "MMMQuestionView.h"
#import "MMMOptionTableView.h"
#import "MMMRegisterController.h"

typedef void(^InitCell)(void);
typedef void(^Block)(void);
typedef BOOL(^BoolBlock)(void);
typedef id (^IdBlock) (void);

@interface MMMRegisterTableView ()
<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSDictionary *theParams;
@property (nonatomic, assign) int QuestionVerify;
@property (nonatomic, assign) int EmailVerify;          //邮箱验证0,1,2 3个值

@property (nonatomic, strong) UIImage *checkCodeImage;
@property (nonatomic, assign) BOOL isNeedNewCheckCodeImage;

@property (nonatomic, weak) id currentObj;

@property (nonatomic, strong) UIButton *registerBtn;

@property (nonatomic, strong) UILabel *mobileCoverLabel;    // 计时遮挡

@property (nonatomic, strong) UILabel *emailCoverLabel;

@property (nonatomic, assign) int countDown_1;  // 计时冷却事件
@property (nonatomic, assign) int countDown_2;

@property (nonatomic, strong) UIView *tableListView;
@property (nonatomic, strong) UIButton *backgroundBtn;

@property (nonatomic, assign) BOOL isSetQuestion;

@property (nonatomic, assign) BOOL isCustomQuestion_1;  //  自定义安保问题开关
@property (nonatomic, assign) BOOL isCustomQuestion_2;
@property (nonatomic, assign) BOOL isCustomQuestion_3;

@property (nonatomic, weak) UIButton *sendSMSBtn;
@property (nonatomic, weak) UIButton *sendEmailBtn;

@property (nonatomic, assign) CGRect registerTableViewFrame; // tableview的frame记录备份

@property (nonatomic, strong) UITextField *lastTextField;
@property (nonatomic, assign) BOOL isBeginWriteToTextField;
@end

@implementation MMMRegisterTableView
{
@private
    NSIndexPath *_indexPath;
    CGRect _keyboardRect;
    
    NSString *_loginPassword;
    NSString *_loginPasswordRe;
    NSString *_securityPassWord;
    NSString *_securityPassWordRe;
    NSString *_question1;
    NSString *_question2;
    NSString *_question3;
    NSString *_answer1;
    NSString *_answer2;
    NSString *_answer3;
    NSString *_Mobile;
    NSString *_mobileCode;
    NSString *_Email;
    NSString *_emailcode;
    NSString *_tempid;
    BOOL _issetquestion;
    BOOL _issetverifyemail;
    NSString *_Code;
    
}

//  构造
-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        _registerTableViewFrame = frame;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisapplear:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

//    正常顺序
-(void)setParams:(NSDictionary *)params {
    self.theParams = [params copy];
    self.QuestionVerify = [[self.theParams objectForKey:@"QuestionVerify"]intValue];
    self.EmailVerify = [[self.theParams objectForKey:@"EmailVerify"]intValue];  // 验证邮箱判断
    
    _tempid = [_theParams objectForKey:@"tempid"];
    _Email = [_theParams objectForKey:@"Email"];
    _Mobile = [_theParams objectForKey:@"Mobile"];
    
    _issetverifyemail =  self.EmailVerify==0?YES:NO;    //  是否验证邮箱
    _issetquestion = self.QuestionVerify==1?YES:NO;     //  是否验证安保问题
    
    if (![_Email isEqualToString:@""]) {
        _isShowEmail = YES;
    }else{
        _issetverifyemail = NO;
    }
    
}

// 从绑定页面进入该方法
-(void)RA:(NSDictionary *)params{
    self.theParams = [params copy];
    self.QuestionVerify = [[self.theParams objectForKey:@"QuestionVerify"]intValue];
    self.EmailVerify = [[self.theParams objectForKey:@"EmailVerify"]intValue];  // 验证邮箱判断
    
    _tempid = [_theParams objectForKey:@"tempid"];
    _Email = [_theParams objectForKey:@"Email"];
    _Mobile = [_theParams objectForKey:@"Mobile"];
    

    _issetverifyemail =  self.EmailVerify==0?YES:NO;    //  是否验证邮箱
    _issetquestion = self.QuestionVerify==1?YES:NO;     //  是否验证安保问题

    if (!_isShowEmail){
        _issetverifyemail = NO;
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - NSNoticification

-(void)keyboardWillDisapplear:(NSNotification *)notification {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = _registerTableViewFrame;
    }];
}

////////// 存在bug
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue];
    
    float height = kbRect.size.height;
    
    if (height != 0) {
        
        _keyboardRect = kbRect;
        
        self.frame = CGRectMake(_registerTableViewFrame.origin.x, _registerTableViewFrame.origin.y, _registerTableViewFrame.size.width, _registerTableViewFrame.size.height-height);
        _isBeginWriteToTextField = YES;
        
        [self scrollToRowAtIndexPath:_indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }
}

#pragma mark - UITableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _theParams ? (_isShowEmail ? 4 : 3) : 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else if (section == 1) {
        return 3;
    }else if (section == 2) {
        return 2;
    }else if (section == 3) {
        switch (_EmailVerify) {
            case 0:
                //必须
                return 2;
                break;
            case 1:
                // 不用
                return 1;
                break;
            case 2:
                //可选
                return 3;
                break;
            default:
                break;
        }
        return 1;
    }else {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MMMCheckCodeCellIdentifier = @"MMMCheckCodeCellIdentifier";
    static NSString *MMMSingleInputCellIdentifier = @"MMMSingleInputCellIdentifier";
    static NSString *MMMSendMessageCellIdentifier = @"MMMSendMessageCellIdentifier";
    
    __block MMMSingleInputCell *singleCell = [tableView dequeueReusableCellWithIdentifier:MMMSingleInputCellIdentifier];
    __block MMMSendMessageCell *smsCell = [tableView dequeueReusableCellWithIdentifier:MMMSendMessageCellIdentifier];
    __block MMMCheckCodeCell *checkCodeCell = [tableView dequeueReusableCellWithIdentifier:MMMCheckCodeCellIdentifier];
    
    UITableViewCell *switchCell;
    
    InitCell smsInitBlock = ^{
        if (!smsCell) {
            smsCell = [[MMMSendMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MMMSendMessageCellIdentifier];
            smsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    };
    
    InitCell singleCellInitBLock = ^{
        if (!singleCell) {
            singleCell = [[MMMSingleInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            singleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    };
    
    InitCell checkCodeCellInitBlock = ^{
        if (!checkCodeCell) {
            checkCodeCell = [[MMMCheckCodeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            checkCodeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    };
    
    
    if (indexPath.section == 2&& indexPath.row == 1) {
        smsInitBlock();
    }
    else if (indexPath.section == 1 && indexPath.row == 2){
        checkCodeCellInitBlock();
    }else if (indexPath.section == 3 && indexPath.row == 0){
        singleCellInitBLock();
    }else if(indexPath.section == 3 && indexPath.row == 1){
        smsInitBlock();
    }else if(indexPath.section == 3 && indexPath.row == 2){
        if (!switchCell) {
            switchCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            switchCell.selectionStyle = UITableViewCellSelectionStyleNone;
            switchCell.backgroundColor = [UIColor clearColor];
        }
    }else{
        singleCellInitBLock();
    }
    
    [singleCell setTitleContent:@"" andDetailContent:@""];  // 先清空显示内容
    
    //  section == 0
    if (indexPath.section == 0 && indexPath.row == 0) {
        [singleCell setTitleContent:@"登陆密码" andDetailContent:_loginPassword];
        singleCell.textField.tag = 1000;
        singleCell.tag = 1000;
        singleCell.textField.secureTextEntry = YES;
        singleCell.textField.clearsOnBeginEditing = YES;
    }else if (indexPath.section == 0 && indexPath.row == 1){
        [singleCell setTitleContent:@"再输入一次" andDetailContent:_loginPasswordRe];
        singleCell.textField.tag = 1001;
        singleCell.tag = 1001;
        singleCell.textField.secureTextEntry = YES;
        singleCell.textField.clearsOnBeginEditing = YES;
    }
    
    //  section == 1
    else if (indexPath.section == 1 && indexPath.row == 0){
        [singleCell setTitleContent:@"支付密码" andDetailContent:_securityPassWord];
        singleCell.textField.tag = 2000;
        singleCell.tag = 2000;
        singleCell.textField.secureTextEntry = YES;
        singleCell.textField.clearsOnBeginEditing = YES;
    }else if (indexPath.section == 1 && indexPath.row == 1){
        [singleCell setTitleContent:@"再输入一次" andDetailContent:_securityPassWordRe];
        singleCell.textField.tag = 2001;
        singleCell.tag = 2001;
        singleCell.textField.secureTextEntry = YES;
        singleCell.textField.clearsOnBeginEditing = YES;
    }
    else if (indexPath.section == 1 && indexPath.row == 2) {
        //  显示图片验证码
        [checkCodeCell.checkCodeBtn addTarget:self action:@selector(changeCheckCode:) forControlEvents:UIControlEventTouchUpInside];
        checkCodeCell.textField.text = _Code;
        checkCodeCell.textField.tag = 2002;
        checkCodeCell.tag = 2002;
        checkCodeCell.textField.delegate = self;
        checkCodeCell.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        
        if (_checkCodeImage) {
            [checkCodeCell.checkCodeBtn setBackgroundImage:_checkCodeImage forState:UIControlStateNormal];
        }else{
            [self getCheckCodeImage];
        }
        
        return checkCodeCell;
    }
    
    // section == 2
    else if (indexPath.section == 2 && indexPath.row == 0) {
        [singleCell setTitleContent:@"注册手机号" andDetailContent:_Mobile];
        singleCell.textField.tag = 3000;
        singleCell.tag = 3000;
        singleCell.textField.enabled = YES;
        singleCell.textField.secureTextEntry = NO;
        singleCell.textField.keyboardType = UIKeyboardTypeNamePhonePad;
    }else if (indexPath.section == 2 && indexPath.row == 1){
        
        //短信验证码填写cell
        smsCell.textField.delegate = self;
        smsCell.textField.text = _mobileCode;
        smsCell.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        [smsCell.sendMsgBtn setTitle:@"" forState:UIControlStateNormal];
        [smsCell.sendMsgBtn setTitle:@"验证短信验证码" forState:UIControlStateNormal];
        [smsCell.sendMsgBtn addTarget:self action:@selector(sendSMSVerify:) forControlEvents:UIControlEventTouchUpInside];
        smsCell.sendMsgBtn.tag = 2001;
        smsCell.textField.tag = 3001;
        smsCell.tag = 3001;
        if (!_mobileCoverLabel) {
            _mobileCoverLabel = [[UILabel alloc]initWithFrame:smsCell.sendMsgBtn.frame];
            _mobileCoverLabel.font = [UIFont systemFontOfSize:16];
            _mobileCoverLabel.backgroundColor = [UIColor lightGrayColor];
            _mobileCoverLabel.layer.masksToBounds = YES;
            _mobileCoverLabel.layer.cornerRadius = 5.0f;
            _mobileCoverLabel.textColor = [UIColor blackColor];
            _mobileCoverLabel.textAlignment = NSTextAlignmentCenter;
            _mobileCoverLabel.hidden = YES;
            
        }
        if (_mobileCoverLabel.hidden) {
            smsCell.sendMsgBtn.enabled = YES;
        }else{
            smsCell.sendMsgBtn.enabled = NO;
        }
        _sendSMSBtn = smsCell.sendMsgBtn;
        [smsCell addSubview:_mobileCoverLabel];
        return smsCell;
    }
    
    // section == 3
    else if (indexPath.section == 3 && indexPath.row == 0) {
        [singleCell setTitleContent:@"注册邮箱" andDetailContent:_Email];
        singleCell.textField.enabled = YES;
        singleCell.textField.tag = 4000;
        singleCell.tag = 4000;
        singleCell.textField.secureTextEntry = NO;
        singleCell.textField.keyboardType = UIKeyboardTypeDefault;
        
    }else if (indexPath.section == 3 && indexPath.row == 1){
        
        //邮箱验证码填写cell
        smsCell.textField.delegate = self;
        NSString *title = [NSString stringWithFormat:@"验证邮箱验证码"];
        
        if (!_emailCoverLabel) {
            _emailCoverLabel = [[UILabel alloc]initWithFrame:smsCell.sendMsgBtn.frame];
            _emailCoverLabel.font = [UIFont systemFontOfSize:16];
            _emailCoverLabel.backgroundColor = [UIColor lightGrayColor];
            _emailCoverLabel.layer.masksToBounds = YES;
            _emailCoverLabel.layer.cornerRadius = 5.0f;
            _emailCoverLabel.textColor = [UIColor blackColor];
            _emailCoverLabel.textAlignment = NSTextAlignmentCenter;
            _emailCoverLabel.hidden = YES;
            
        }
        if (_emailCoverLabel.hidden) {
            smsCell.sendMsgBtn.enabled = YES;
        }else{
            smsCell.sendMsgBtn.enabled = NO;
        }
        [smsCell addSubview:_emailCoverLabel];
        [smsCell.sendMsgBtn addTarget:self action:@selector(sendEmailVerify:) forControlEvents:UIControlEventTouchUpInside];
        [smsCell.sendMsgBtn setTitle:@"" forState:UIControlStateNormal];
        [smsCell.sendMsgBtn setTitle:title forState:UIControlStateNormal];
        smsCell.textField.placeholder = @"邮箱验证码";
        _sendEmailBtn = smsCell.sendMsgBtn;
        smsCell.sendMsgBtn.tag = 2002;
        smsCell.textField.tag = 4001;
        smsCell.tag = 4001;
        smsCell.textField.text = _emailcode;
        smsCell.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        return smsCell;
    }else if (indexPath.section == 3 && indexPath.row == 2){
        
        //  邮箱验证开关cell
        UISwitch *emailVerifySwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
        emailVerifySwitch.on = _issetverifyemail;
        [emailVerifySwitch addTarget:self action:@selector(isSetVerifyEmail:) forControlEvents:UIControlEventValueChanged];
        switchCell.textLabel.text = @"邮箱是否验证: ";
        switchCell.accessoryView = emailVerifySwitch;
        return switchCell;
    }
    
    singleCell.textField.delegate = self;
    return singleCell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 160;
    } else {
        return 50;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3 && _isShowEmail) {
        return 80;
    }else if (section == 1 && !_issetquestion &&_QuestionVerify==0 ){
        _answer1=_answer2=_answer3=_question1=_question2=_question3=nil;
        return 50;
    }else if (section == 1 && _issetquestion){
        return 290;
    }else if (section==2 && !_isShowEmail){
        return 80;
    }
    else {
        return 1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view;
    if (section == 0) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100+50+10)];
        MMMHeaderView *topView = [[MMMHeaderView alloc]initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 100) andNumOfLabel:3];
        topView.backgroundColor = [UIColor clearColor];
        
    
        
        NSString *title1 = [NSString stringWithFormat:@"注册人: %@",[_theParams objectForKey:@"RealName"]];
        NSString *title2 = [NSString stringWithFormat:@"%@: %@",[_theParams objectForKey:@"IdentificationNoTitle"],[_theParams objectForKey:@"IdentificationNo"]];
        NSString *title3 = [NSString stringWithFormat:@"您在平台的用户名: %@",[_theParams objectForKey:@"LoanPlatformAccount"]];
        
        [topView setContext:title1 headerLabel2:title2 hederLabel3:title3];
        
        MMMTableTitleView *bottomView = [[MMMTableTitleView alloc]initWithFrame:CGRectMake(0, 100+10, [UIScreen mainScreen].bounds.size.width,50)];
        [bottomView setHeaderViewContentText:@"设置登陆密码" andDetailContent:@"登陆时需验证,保护账户信息" ];
        bottomView.backgroundColor = self.backgroundColor;
        
        [view addSubview:topView];
        [view addSubview:bottomView];
    }else if (section == 1) {
        view = [[MMMTableTitleView alloc]initWithFrame:self.frame];
        [(MMMTableTitleView *)view setHeaderViewContentText:@"设置支付密码" andDetailContent:@"付款时需验证,保护资金安全" ];
    }else if (section == 2) {
        view = [[MMMTableTitleView alloc]initWithFrame:self.frame];
        [(MMMTableTitleView *)view setHeaderViewContentText:@"设置注册手机号" andDetailContent:@"可用于登陆" ];
    }else if (section == 3 && _isShowEmail) {
        view = [[MMMTableTitleView alloc]initWithFrame:self.frame];
        [(MMMTableTitleView *)view setHeaderViewContentText:@"设置注册邮箱" andDetailContent:@"可用于登陆" ];
    }
    
    view.backgroundColor = self.backgroundColor;
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if ((section == 3 && _isShowEmail )|| (section ==2 && !_isShowEmail)) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
        view.backgroundColor = [UIColor clearColor];
        
        if (!_registerBtn) {
            _registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width-20, 50)];
            _registerBtn.backgroundColor = [UIColor colorWithRed:58.0f/255.0f green:108.0f/255.0f blue:241.0f/255.0f alpha:1];
            [_registerBtn setTitle:@"确认注册" forState:UIControlStateNormal];
            [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            _registerBtn.layer.masksToBounds = YES;
            _registerBtn.layer.cornerRadius = 5.0f;
            
            [_registerBtn addTarget:self action:@selector(registerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [view addSubview:_registerBtn];
        return view;
    }else if (section ==1){
        return [self createQuestionView];
    }
    else {
        return nil;
    }
}

#pragma mark ---------------------------------------
// 配置安保问题View
-(UIView *)createQuestionView{
    //  服务器要求不验证安保问题,直接返回空
    if (_QuestionVerify == 2) {
        return nil;
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 290)];
    view.backgroundColor = [UIColor clearColor];
    MMMTableTitleView *setQuestinonHeaderView = [[MMMTableTitleView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    setQuestinonHeaderView.backgroundColor = self.backgroundColor;
    [setQuestinonHeaderView setHeaderViewContentText:@"设置安保问题" andDetailContent:@"可用于查找密码" ];
    [view addSubview:setQuestinonHeaderView];
    
    
    IdBlock setQuestionBtnBLock = (id)^{
        UIButton *setQuestionBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        NSString *title = _issetquestion?@"收起":@"设置";
        [setQuestionBtn setTitle:title forState:UIControlStateNormal];
        [setQuestionBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        setQuestionBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [setQuestionBtn sizeToFit];
        setQuestionBtn.backgroundColor = self.backgroundColor;
        setQuestionBtn.center = CGPointMake(setQuestinonHeaderView.frame.size.width/2, setQuestinonHeaderView.frame.size.height/2);
        CGPoint btnOrigin = setQuestionBtn.frame.origin;
        CGSize btnSize = setQuestionBtn.frame.size;
        setQuestionBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-10-btnSize.width, btnOrigin.y,btnSize.width,btnSize.height);
        [setQuestionBtn addTarget:self action:@selector(showQuestionList:) forControlEvents:UIControlEventTouchUpInside];
        return setQuestionBtn;
    };
    
    Block setQuestionViewBlock = ^{
        MMMQuestionView *questionview_1 = [[MMMQuestionView alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 80)];
        questionview_1.backgroundColor = self.backgroundColor;
        questionview_1.questionTitleLabel.text = @"问题1: ";
        questionview_1.answerTitleLabel.text = @"答案1: ";
        questionview_1.answerTextField.delegate = self;
        questionview_1.answerTextField.tag = 6000;
        questionview_1.questionSwitchBtn.tag = 4001;
        questionview_1.questionCustomBtn.tag = 4001;
        questionview_1.answerTextField.text = _answer1;
        questionview_1.questionTitleTextField.tag = 5000;
        questionview_1.questionTitleTextField.delegate = self;
        questionview_1.questionTitleTextField.text = _question1;
        questionview_1.questionTitleTextField.hidden = !_isCustomQuestion_1;
        [questionview_1.questionSwitchBtn addTarget:self action:@selector(setQuestion:) forControlEvents:UIControlEventTouchUpInside];
        [questionview_1.questionCustomBtn addTarget:self action:@selector(setCustomQuestion:) forControlEvents:UIControlEventTouchUpInside];
        [questionview_1 setquestionTitle:_question1];
        
        MMMQuestionView *questionview_2 = [[MMMQuestionView alloc]initWithFrame:CGRectMake(0, 50+80, [UIScreen mainScreen].bounds.size.width, 80)];
        questionview_2.backgroundColor = self.backgroundColor;
        questionview_2.questionTitleLabel.text = @"问题2: ";
        questionview_2.answerTitleLabel.text = @"答案2: ";
        questionview_2.answerTextField.delegate = self;
        questionview_2.answerTextField.tag = 6001;
        questionview_2.questionSwitchBtn.tag = 4002;
        questionview_2.questionCustomBtn.tag = 4002;
        questionview_2.answerTextField.text = _answer2;
        questionview_2.questionTitleTextField.tag = 5001;
        questionview_2.questionTitleTextField.delegate = self;
        questionview_2.questionTitleTextField.text = _question2;
        questionview_2.questionTitleTextField.hidden = !_isCustomQuestion_2;
        [questionview_2.questionSwitchBtn addTarget:self action:@selector(setQuestion:) forControlEvents:UIControlEventTouchUpInside];
        [questionview_2.questionCustomBtn addTarget:self action:@selector(setCustomQuestion:) forControlEvents:UIControlEventTouchUpInside];
        [questionview_2 setquestionTitle:_question2];
        
        MMMQuestionView *questionview_3 = [[MMMQuestionView alloc]initWithFrame:CGRectMake(0, 50+80+80, [UIScreen mainScreen].bounds.size.width, 80)];
        questionview_3.backgroundColor = self.backgroundColor;
        questionview_3.questionTitleLabel.text = @"问题3: ";
        questionview_3.answerTitleLabel.text = @"答案3: ";
        questionview_3.answerTextField.delegate = self;
        questionview_3.answerTextField.tag = 6002;
        questionview_3.questionSwitchBtn.tag = 4003;
        questionview_3.questionCustomBtn.tag = 4003;
        questionview_3.answerTextField.text = _answer3;
        questionview_3.questionTitleTextField.tag = 5002;
        questionview_3.questionTitleTextField.delegate = self;
        questionview_3.questionTitleTextField.text = _question3;
        questionview_3.questionTitleTextField.hidden = !_isCustomQuestion_3;
        [questionview_3.questionSwitchBtn addTarget:self action:@selector(setQuestion:) forControlEvents:UIControlEventTouchUpInside];
        [questionview_3.questionCustomBtn addTarget:self action:@selector(setCustomQuestion:) forControlEvents:UIControlEventTouchUpInside];
        [questionview_3 setquestionTitle:_question3];
        
        [view addSubview:questionview_1];
        [view addSubview:questionview_2];
        [view addSubview:questionview_3];
    };
    
    //  服务器要求安全安保认证可选
    if (_QuestionVerify == 0) {
        // 添加 安保问题显示按钮
        [setQuestinonHeaderView addSubview:setQuestionBtnBLock()];
        if (_issetquestion) {
            setQuestionViewBlock();
            return view;
        }
        
        if (!_issetquestion) {
            return setQuestinonHeaderView;
        }
        
    }
    
    //  必须认证安保问题
    if (_QuestionVerify == 1) {
        setQuestionViewBlock();
        return view;
    }
    
    return nil;
}

-(void)setCustomQuestion:(UIButton *)sender {
    if (sender.tag == 4001) {
        _isCustomQuestion_1 = !_isCustomQuestion_1;
        _question1 = nil;
        _answer1 = nil;
    }else if (sender.tag == 4002){
        _isCustomQuestion_2 = !_isCustomQuestion_2;
        _question2 = nil;
        _answer2 = nil;
    }else if (sender.tag == 4003){
        _isCustomQuestion_3 = !_isCustomQuestion_3;
        _question3 = nil;
        _answer3 = nil;
    }
    
    [self reloadData];
}
//  安保问题的问题list
-(void)setQuestion:(UIButton *)sender{
    _isSetQuestion = YES;
    CGRect frame = sender.frame;
    if (!_backgroundBtn) {
        _backgroundBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
        
        _backgroundBtn.backgroundColor = [UIColor clearColor];
        _backgroundBtn.alpha = 0.5f;
        [_backgroundBtn addTarget:self action:@selector(clearWindows:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backgroundBtn];
        [self bringSubviewToFront:_backgroundBtn];
    }
    
    CGRect rect = [sender convertRect:self.frame toView:self];
    if (!_tableListView) {
        _tableListView = [[UIView alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y-20, frame.size.width, 300)];
        
        _tableListView.backgroundColor = [UIColor whiteColor];
        
        _tableListView.layer.masksToBounds = YES;
        [_tableListView.layer setBorderColor:sender.backgroundColor.CGColor];
        _tableListView.layer.borderWidth = 1.0f;
        [self addSubview:_tableListView];
        [self bringSubviewToFront:_tableListView];
        
        MMMOptionTableView *questionListTableView = [[MMMOptionTableView alloc]
                                                     initWithFrame:CGRectMake(0, 0, _tableListView.frame.size.width, _tableListView.frame.size.height)
                                                     style:UITableViewStylePlain
                                                     params:@[@"--请选择安保问题--",
                                                              @"我爸爸的名字是?",
                                                              @"我妈妈的名字是?",
                                                              @"我爸爸的生日是?",
                                                              @"我妈妈的生日是?",
                                                              @"我妻子的名字是?",
                                                              @"我丈夫的名字是?",
                                                              @"我女儿的名字是?",
                                                              @"我的大学学号?",
                                                              @"我的大学校名?",
                                                              @"我的高中校名?",
                                                              @"我的初中校名?"]];
        questionListTableView.optionDelegate = (id)self;
        questionListTableView.tag = sender.tag;
        [_tableListView addSubview:questionListTableView];
    }

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (_isBeginWriteToTextField) {
//        _isBeginWriteToTextField = NO;
//        return;
//    }
//    
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_currentObj != nil) {
        [_currentObj resignFirstResponder];
        _currentObj = nil;
    }
}

//
-(void)clearWindows:(id)sender {
    
    if (_isSetQuestion) {
        [_tableListView removeFromSuperview];
        _tableListView = nil;
        [_backgroundBtn removeFromSuperview];
        _backgroundBtn = nil;
        _isSetQuestion = NO;
    }
    
}

// 安保问题 footerView 中的按钮事件
-(void)showQuestionList:(UIButton *)sender {
    _issetquestion = !_issetquestion;
    _isCustomQuestion_1 = _isCustomQuestion_2 = _isCustomQuestion_3 = NO;
    [self reloadData];
}

-(BOOL)compareFirstValue:(NSString *)firstValue secrondValue:(NSString *)secValue {
    if ([firstValue isEqualToString:secValue]) {
        return YES;
    }
    return NO;
}

//  注册按钮点击
-(void)registerBtnPressed:(id)sender {
    
    if (_currentObj) {
        if ([_currentObj isKindOfClass:[UITextField class]]) {
            [_currentObj resignFirstResponder];
            _currentObj = nil;
        }
    }
    
    if (![self checkAllpasswordExist]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"密码设置不完整" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    if (![self compareFirstValue:_loginPassword secrondValue:_loginPasswordRe]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"两次登陆密码不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    if (![self compareFirstValue:_securityPassWord secrondValue:_securityPassWordRe]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"两次支付密码不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (![self checkLoginPasswordFormat]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"登陆密码密码格式不正确,必须大于6位且由英文与数字组合" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (![self checkSecurityPasswordFormat]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"支付密码密码格式不正确,必须大于6位且由英文与数字组合" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    if ([_loginPassword isEqualToString:_securityPassWord]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"登陆密码与支付密码一致,请重新设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (![self checkQuestion]&&_issetquestion) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"安保问题设置不全,请填写完整" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return ;
    }
    
    
    
    __block NSString *params = [NSString stringWithFormat:@"Phone=1&loginPassword=%@&loginPasswordRe=%@&securityPassword=%@&securityPasswordRe=%@&Mobile=%@&mobilecode=%@&tempid=%@&Code=%@",
                                _loginPassword,
                                _loginPasswordRe,
                                _securityPassWord,
                                _securityPassWordRe,
                                _Mobile,
                                _mobileCode,
                                _tempid,_Code];
    
    //  如果用户初始输入有邮箱, 则添加改字段
    if (_isShowEmail){
        params = [NSString stringWithFormat:@"%@&Email=%@",params,_Email];
    }
    
    
    // 不验证邮箱
    if (!_issetverifyemail) {
        params = [NSString stringWithFormat:@"%@&issetverifyemail=1",params];
    }
    
    // 验证邮箱
    if (_issetverifyemail && (!_emailcode||[_emailcode isEqualToString:@""])) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请输入邮箱验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }else if (_issetverifyemail){
        params = [NSString stringWithFormat:@"%@&emailcode=%@",params,_emailcode];
    }
    
    BoolBlock questionBlock = ^{
        //  安保问题
        if (_question1 && _question2 && _question3) {
            params = [NSString stringWithFormat:@"%@&question1=%@&question2=%@&question3=%@",
                      params,
                      _question1,
                      _question2,
                      _question3];
            return YES;
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"安保问题个数不足" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return NO;
        }
    };
    
    BoolBlock answerBlock = ^{
        //  安保问题回答
        if (_answer1 && _answer2 && _answer2){
            params = [NSString stringWithFormat:@"%@&answer1=%@&answer2=%@&answer3=%@",
                      params,
                      _answer1,
                      _answer2,
                      _answer3];
            return YES;
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请填写完整安保问题答案" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return NO;
        }
    };
    
    
    if (!_mobileCode || [[_mobileCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请填写短信验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return ;
    }
    
    
    // 不验证安保问题
    if (!_issetquestion) {
        params = [NSString stringWithFormat:@"%@&issetquestion=1",params];
    }
    // 验证安保问题
    if (_issetquestion) {
        if (!questionBlock()) {
            return;
        }
        
        if (!answerBlock()) {
            return;
        }
    }
    
    _registerBtn.enabled = NO;
    
    [MMMConfigUtil sharedConfigUtil].toRegisterBind(params,^(NSData *data, NSError *error){
        _registerBtn.enabled = YES;
        if (!error) {
            [self callbackOfRegisterBind:data];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[error localizedDescription] delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
            [alert show];
        }
    });
    
}

-(void)callbackOfRegisterBind:(NSData *)data{
    
    __weak MMMRegisterController *vc;
    if (self.ownerDelegate && [self.ownerDelegate isKindOfClass:[MMMRegisterController class]]) {
        vc = self.ownerDelegate;
    }
    
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
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
    if (vc.resultBlock)
        vc.resultBlock(resultDic, MMMRegisterEvent);
    
    //////////////
    
    if ([[dict objectForKey:@"ResultCode"]isEqualToString:@"88"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
        alert.tag = 1001;
        [alert show];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册提示" message:[dict objectForKey:@"Message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1001) {
        self.completeBlock();
        
//        if (self.ownerDelegate && [self.ownerDelegate isKindOfClass:[MMMRegisterController class]]) {
//            [self.ownerDelegate back:nil];
//        }
    }
}


#pragma mark - UITextField delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    int tag = (int)textField.tag;
    _isBeginWriteToTextField = YES;
    
    NSInteger section = (NSInteger)(tag/1000 - 1);
    NSInteger row = tag - 1000*(section+1);
    
    _indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    _currentObj = nil;
    _currentObj = textField;
//    _lastTextField = [textField copy];
    [self clearWindows:nil];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    [textField resignFirstResponder];
    int tag = (int)textField.tag;
    
    
    if (tag == 1000){
        _loginPassword = textField.text;
    }else if (tag == 1001){
        _loginPasswordRe = textField.text;
    }else if (tag == 2000){
        _securityPassWord = textField.text;
    }else if (tag == 2001){
        _securityPassWordRe = textField.text;
    }else if (tag == 2002) {
        _Code =textField.text;
    }else if (tag == 3000){
        _Mobile = textField.text;
    }else if (tag == 3001){
        _mobileCode = textField.text;
    }else if (tag == 4000){
        _Email = textField.text;
    }else if (tag == 4001){
        _emailcode = textField.text;
    }
    
    
    
    else if (tag == 5000){
        _question1 = textField.text;
    }else if (tag == 5001){
        _question2 = textField.text;
    }else if (tag == 5002){
        _question3 = textField.text;
    }
    else if (tag == 6000){
        _answer1 = textField.text;
    }else if (tag == 6001){
        _answer2 = textField.text;
    }else if (tag == 6002){
        _answer3 = textField.text;
    }
    
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    _currentObj = nil;
    return YES;
}

#pragma mark - sendVerify

-(void)timerFireMethod:(NSTimer *)theTimer {
    NSDictionary *dict = theTimer.userInfo;
    UIButton *btn = [dict objectForKey:@"button"];
    NSUInteger tag = btn.tag;
    
    Block smsMessageBlock = ^{
        int remainTime = 60- ++_countDown_1;
        if (remainTime == 0) {
            _mobileCoverLabel.hidden = YES;
            _countDown_1 = 0;
            _sendSMSBtn.enabled = YES;
        }else{
            _mobileCoverLabel.text = [NSString stringWithFormat:@"%is后重新发送",remainTime];
        }
    };
    
    Block emailMessageBlock = ^{
        int remainTime = 60- ++_countDown_2;
        if (remainTime == 0) {
            _emailCoverLabel.hidden = YES;
            _countDown_2 = 0;
            _sendEmailBtn.enabled = YES;
        }else{
            _emailCoverLabel.text = [NSString stringWithFormat:@"%is后重新发送",remainTime];
        }
    };
    
    
    if (tag == 2001) {
        smsMessageBlock();
    }else if (tag == 2002){
        emailMessageBlock();
    }
    
}

-(void)sendSMSVerify:(UIButton *)sender {
    
    
    
    if (_currentObj) {
        if ([_currentObj isKindOfClass:[UITextField class]]) {
            [_currentObj resignFirstResponder];
        }
    }
    
    if (![self checkMobileFormat]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"手机号不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (!_Code || [[_Code stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请输入验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSString *params = [NSString stringWithFormat:@"accountName=%@&msg=2&Code=%@&phone=1",_Mobile,_Code];
    
    [MMMConfigUtil sharedConfigUtil].toSendMessage(params,^(NSData *data, NSError *error){
        if (!error) {
            NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        }
    });
    
    NSTimer *theTimer  = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:@{@"button":sender} repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:theTimer forMode:NSRunLoopCommonModes];
    _mobileCoverLabel.hidden = NO;
    _mobileCoverLabel.text = @"60s后重新发送";
    sender.enabled = NO;
}

-(void)sendEmailVerify:(UIButton *)sender {
    
    if (_currentObj) {
        if ([_currentObj isKindOfClass:[UITextField class]]) {
            [_currentObj resignFirstResponder];
        }
    }
    
    if (![self checkEmailFormat]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"邮箱格式不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    if (!_Code || [[_Code stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请输入验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    
    NSString *params = [NSString stringWithFormat:@"accountName=%@&msg=2&Code=%@&phone=1",_Email,_Code];
    [MMMConfigUtil sharedConfigUtil].toSendMessage(params,^(NSData *data, NSError *error){
        if (!error) {
            NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        }
    });
    
    
    //    NSLog(@"已发送短信验证码");
//    NSString *urlString = [MMMConfigUtil sharedConfigUtil].getSendMessageURL();
//    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//        if (!connectionError) {
//            NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//            //            if (![result isEqualToString:@""]){
//            //                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发送邮件失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            //                [alert show];
//            //            }
//        }
//    }];
    
    NSTimer *theTimer  = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:@{@"button":sender} repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:theTimer forMode:NSRunLoopCommonModes];
    _emailCoverLabel.hidden = NO;
    _emailCoverLabel.text = @"60s后重新发送";
    sender.enabled = NO;
}

-(void)changeCheckCode:(UIButton *)sender {
    //    NSLog(@"改变checkCode");
    
    [self getCheckCodeImage];
}

-(void)isSetVerifyEmail:(UISwitch *)sender {
    _issetverifyemail = !_issetverifyemail;
}

-(void)getCheckCodeImage {
    [MMMConfigUtil sharedConfigUtil].toCheckCode(@"",^(NSData *data, NSError *error){
        if (!error) {
            _checkCodeImage = [UIImage imageWithData:data];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
            MMMCheckCodeCell *cell = (MMMCheckCodeCell *)[self cellForRowAtIndexPath:indexPath];
            [cell.checkCodeBtn setBackgroundImage:_checkCodeImage forState:UIControlStateNormal];
            _Code = nil;
            [self reloadData];
        }
    });
    
//    NSString *urlString = [MMMConfigUtil sharedConfigUtil].getCheckCodeURL();
//    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//        if (!connectionError) {
//            _checkCodeImage = [UIImage imageWithData:data];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
//            MMMCheckCodeCell *cell = (MMMCheckCodeCell *)[self cellForRowAtIndexPath:indexPath];
//            [cell.checkCodeBtn setBackgroundImage:_checkCodeImage forState:UIControlStateNormal];
//            _Code = nil;
//            [self reloadData];
//        }
//    }];
}

#pragma mark - MDDOptionTableView delegate

-(void)didSelectIndexPath:(NSIndexPath *)indexPath withContext:(NSString *)context {
    
}

-(void)didSelectIndexPath:(NSIndexPath *)indexPath withContext:(NSString *)context withTag:(NSUInteger)tag {
    if (tag == 4001) {
        _question1 = context;
    }else if (tag == 4002){
        _question2 = context;
    }else if (tag == 4003){
        _question3 = context;
    }
    
    [self clearWindows:nil];
    [self reloadData];
}
#pragma mark - check upload data

-(BOOL)checkAllpasswordExist {
    if (_loginPassword && _loginPasswordRe && _securityPassWord && _securityPassWordRe) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)checkLoginPasswordFormat {
    //  检测登陆密码格式, 大于6位, 必须包含英文和数字
    
    NSString *regex1 = @".*[0-9]+.*";
    
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    
    BOOL isMatch1 = [pred1 evaluateWithObject:_loginPassword];
    NSString *regex2 = @".*[A-Za-z]+.*";
    
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    
    BOOL isMatch2 = [pred2 evaluateWithObject:_loginPassword];
    
    NSString *regex3 = @"^[A-Za-z0-9]{6,}$";
    
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex3];
    
    BOOL isMatch3= [pred3 evaluateWithObject:_loginPassword];
    
    return isMatch1&&isMatch2&&isMatch3;
}
-(BOOL)checkSecurityPasswordFormat {
    //  检测支付密码格式, 大于6位, 必须包含英文和数字
    NSString *regex1 = @".*[0-9]+.*";
    
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    
    BOOL isMatch1 = [pred1 evaluateWithObject:_securityPassWord];
    NSString *regex2 = @".*[A-Za-z]+.*";
    
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    
    BOOL isMatch2 = [pred2 evaluateWithObject:_securityPassWord];
    
    NSString *regex3 = @"^[A-Za-z0-9]{6,}$";
    
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex3];
    
    BOOL isMatch3= [pred3 evaluateWithObject:_securityPassWord];
    
    return isMatch1&&isMatch2&&isMatch3;
}

-(BOOL)compareLoginPsdWith{
    //  比较登陆密码与支付密码是否雷同
    return YES;
}

-(BOOL)checkQuestion {
    // 检测安保问题是否完整
    if (_question1&&_question2&&_question3&&_answer1&&_answer2&&_answer3){
        return YES;
    }else
        return YES;
}

-(BOOL)checkMobileFormat {
    // 检测手机格式
    
    if (!_Mobile || [_Mobile isEqualToString:@""]) {
        return NO;
    }
    
    //    NSLog(@"开始验证手机号");
    //
    //    NSString * phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    //    BOOL isMatch = [self isMobileNumber:phoneRegex];
    //    return isMatch;
    
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:_Mobile];
}

/*手机号码验证*/
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10 * 中国移动：China Mobile
     11 * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12 */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15 * 中国联通：China Unicom
     16 * 130,131,132,152,155,156,185,186
     17 */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20 * 中国电信：China Telecom
     21 * 133,1349,153,180,189
     22 */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25 * 大陆地区固话及小灵通
     26 * 区号：010,020,021,022,023,024,025,027,028,029
     27 * 号码：七位或八位
     28 */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSString * ALL = @"^1[0-9]\\d{10}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestALL = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ALL];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestALL evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

-(BOOL)checkEmailFormat {
    // 检测邮箱格式
    
    if (!_Email) {
        return NO;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:_Email];
}

@end
