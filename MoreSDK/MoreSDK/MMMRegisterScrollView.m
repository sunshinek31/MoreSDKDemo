//
//  MMMRegisterScrollView.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/4/17.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMRegisterScrollView.h"
#import "MMMConfigUtil.h"
#import "MMMTableTitleView.h"
#import "MMMHeaderView.h"
#import "MMMSingleInputView.h"
#import "MMMOptionTableView.h"
#import "MMMQuestionView.h"
#import "MMMCheckCodeView.h"
#import "MMMSendMessageView.h"
#import "MMMActivityIndicatorView.h"

typedef void(^Block)(void);
typedef BOOL(^BoolBlock)(void);
typedef id (^IdBlock) (void);

@interface MMMRegisterScrollView ()
<UITextFieldDelegate,UIAlertViewDelegate,UIScrollViewDelegate,UIScrollViewAccessibilityDelegate>

@property (nonatomic, strong) NSDictionary *theParams;
@property (nonatomic, assign) int QuestionVerify;
@property (nonatomic, assign) int EmailVerify;          //邮箱验证0,1,2 3个值
@property (nonatomic, weak) id currentObj;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIView *tableListView;
@property (nonatomic, strong) UIButton *backgroundBtn;
@property (nonatomic, assign) BOOL isSetQuestion;
@property (nonatomic, assign) BOOL isCustomQuestion_1;  //  自定义安保问题开关
@property (nonatomic, assign) BOOL isCustomQuestion_2;
@property (nonatomic, assign) BOOL isCustomQuestion_3;
@property (nonatomic, assign) CGRect registerViewFrame; // tableview的frame记录备份
//////////////////////
@property (nonatomic, strong) NSMutableArray *originY_Of_each;
@property (nonatomic, strong) NSMutableArray *views_that_maybeChangeFrame;
@property (nonatomic, strong) MMMSingleInputView *loginPasswordInputView;
@property (nonatomic, strong) MMMSingleInputView *reLoginPasswordInputView;
@property (nonatomic, strong) MMMSingleInputView *securityPasswordInputView;
@property (nonatomic, strong) MMMSingleInputView *reSecurityPasswordInputView;
@property (nonatomic, strong) MMMCheckCodeView *checkCodeView;
@property (nonatomic, strong) MMMTableTitleView *questionTitleView;
@property (nonatomic, strong) UIButton *showQuestionsBtn;
@property (nonatomic, strong) MMMQuestionView *questionView_1;
@property (nonatomic, strong) MMMQuestionView *questionView_2;
@property (nonatomic, strong) MMMQuestionView *questionView_3;
@property (nonatomic, strong) MMMTableTitleView *phoneTitleView;
@property (nonatomic, strong) MMMSingleInputView *phoneInputView;
@property (nonatomic, strong) MMMSendMessageView *sendSmsView;
@property (nonatomic, strong) MMMTableTitleView *emailTitleView;
@property (nonatomic, strong) MMMSingleInputView *emailInputView;
@property (nonatomic, strong) MMMSendMessageView *sendEmailView;
@property (nonatomic, strong) UIButton *isVerifyEmailBtn;
@property (nonatomic, assign) CGSize currentSize;
@property (nonatomic, copy) NSString *loginPassword;
@property (nonatomic, copy) NSString *loginPasswordRe;
@property (nonatomic, copy) NSString *securityPassWord;
@property (nonatomic, copy) NSString *securityPassWordRe;
@property (nonatomic, copy) NSString *question1;
@property (nonatomic, copy) NSString *question2;
@property (nonatomic, copy) NSString *question3;
@property (nonatomic, copy) NSString *answer1;
@property (nonatomic, copy) NSString *answer2;
@property (nonatomic, copy) NSString *answer3;
@property (nonatomic, copy) NSString *Mobile;
@property (nonatomic, copy) NSString *mobileCode;
@property (nonatomic, copy) NSString *Email;
@property (nonatomic, copy) NSString *emailcode;
@property (nonatomic, copy) NSString *tempid;
@property (nonatomic, copy) NSString *Code;
@end

@implementation MMMRegisterScrollView
{

@private
    NSIndexPath *_indexPath;
    CGRect _currentRect;
    NSString *_loginPassword;
    //  内部显示控件逻辑开关
    BOOL _issetquestion;
    BOOL _issetverifyemail; // 是否显示邮箱验证码输入栏
//    BOOL _isShowEmail;  // 是否显示整个邮箱模块
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate =  self;
        _loginPassword=_loginPasswordRe=_securityPassWord=_securityPassWordRe=_question1=_question2=_question3=
        _answer1=_answer2=_answer3=_Mobile=_mobileCode=_Email=_emailcode=_tempid=_Code = @"";
        
        self.clipsToBounds = YES;
        _originY_Of_each = [NSMutableArray array];
        _views_that_maybeChangeFrame = [NSMutableArray array];
        [_originY_Of_each addObject:@0.0f];
        
        _registerViewFrame = self.frame;
        
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
            
            CGRect rect = _currentRect;
            [self scrollRectToVisible:rect animated:YES];
    }
}

////////////
-(void)setParams:(NSDictionary *)params {
    
    self.theParams = [params copy];
    self.QuestionVerify = [[self.theParams objectForKey:@"QuestionVerify"]intValue];
    self.EmailVerify = [[self.theParams objectForKey:@"EmailVerify"]intValue];  // 验证邮箱判断
    
    _tempid = [_theParams objectForKey:@"tempid"];
    _Email = [_theParams objectForKey:@"Email"];
    _Mobile = [_theParams objectForKey:@"Mobile"];
    
//    if (_Email == nil || [_Email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]) {
//        _isShowEmail = NO;
//    }else{
//        _isShowEmail = YES;
//    }
    
    _issetverifyemail =  self.EmailVerify==0?YES:NO;    //  是否验证邮箱
    _issetquestion = self.QuestionVerify==1?YES:NO;     //  是否验证安保问题
    
    //  显示邮箱模块 则默认初始验证,则显示邮箱输入栏
//    if (!_isShowEmail) {
//        _issetverifyemail = NO;
//    }else {
//        _issetverifyemail = YES;
//    }
    [self configContentOfView];
}

-(void)configContentOfView {
    [self firstArea];
    [self secondArea];
    [self thirdArea];
    [self fourthArea];
    [self fifthArea];
    [self sixthArea];

    self.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,[_originY_Of_each.lastObject floatValue]+50);
    _currentSize = self.contentSize;
}

#pragma mark - 基础页面

-(void)firstArea {
    
    MMMHeaderView *headerView = [[MMMHeaderView alloc]initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 100) andNumOfLabel:3];
    headerView.backgroundColor = [UIColor clearColor];
    
    NSString *title1 = [NSString stringWithFormat:@"注册人: %@",[_theParams objectForKey:@"RealName"]];
    NSString *title2 = [NSString stringWithFormat:@"%@: %@",[_theParams objectForKey:@"IdentificationNoTitle"],[_theParams objectForKey:@"IdentificationNo"]];
    NSString *title3 = [NSString stringWithFormat:@"您在平台的用户名: %@",[_theParams objectForKey:@"LoanPlatformAccount"]];
    [headerView setContext:title1 headerLabel2:title2 hederLabel3:title3];
    
    MMMTableTitleView *titleView_1 = [[MMMTableTitleView alloc]initWithFrame:CGRectMake(0, 105, [UIScreen mainScreen].bounds.size.width, 50)];
    [titleView_1 setHeaderViewContentText:@"设置登陆密码" andDetailContent:@"登陆时需验证,保护账户信息" ];
    titleView_1.backgroundColor = self.backgroundColor;
    
    ///////////////
    _loginPasswordInputView = [[MMMSingleInputView alloc] initWithFrame:CGRectMake(0, 155, [UIScreen mainScreen].bounds.size.width, 60)];
    [_loginPasswordInputView setTitleContent:@"登陆密码" andDetailContent:_loginPassword];
    _loginPasswordInputView.textField.tag = 1000;
    _loginPasswordInputView.textField.secureTextEntry = YES;
    _loginPasswordInputView.textField.clearsOnBeginEditing = YES;
    _loginPasswordInputView.textField.delegate = self;
    _loginPasswordInputView.textField.placeholder = @"请输入大于6位且由英文与数字组合";
    _loginPasswordInputView.textField.font = [UIFont systemFontOfSize:14];
    /////////////
    _reLoginPasswordInputView =
    [[MMMSingleInputView alloc]
     initWithFrame:
     CGRectMake(0,
                _loginPasswordInputView.frame.origin.y+_loginPasswordInputView.frame.size.height,
                [UIScreen mainScreen].bounds.size.width,
                60)];
    
    [_reLoginPasswordInputView setTitleContent:@"再输入一次" andDetailContent:_loginPasswordRe];
    _reLoginPasswordInputView.textField.tag = 1001;
    _reLoginPasswordInputView.textField.secureTextEntry = YES;
    _reLoginPasswordInputView.textField.clearsOnBeginEditing = YES;
    _reLoginPasswordInputView.textField.delegate = self;
    _reLoginPasswordInputView.textField.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:headerView];
    [self addSubview:titleView_1];
    [self addSubview:_loginPasswordInputView];
    [self addSubview:_reLoginPasswordInputView];
    [_originY_Of_each addObject:@(_reLoginPasswordInputView.frame.origin.y + _reLoginPasswordInputView.frame.size.height)];
}

-(void)secondArea {
    float beginOriginY = [_originY_Of_each.lastObject floatValue];
    
    MMMTableTitleView *titleView_2 = [[MMMTableTitleView alloc]initWithFrame:CGRectMake(0, beginOriginY, [UIScreen mainScreen].bounds.size.width, 50)];
    [titleView_2 setHeaderViewContentText:@"设置支付密码" andDetailContent:@"付款时需验证,保护资金安全" ];
    titleView_2.backgroundColor = self.backgroundColor;
    
    ////////////////
    _securityPasswordInputView = [[MMMSingleInputView alloc] initWithFrame:CGRectMake(0, beginOriginY+ titleView_2.frame.size.height, [UIScreen mainScreen].bounds.size.width, 60)];
    [_securityPasswordInputView setTitleContent:@"支付密码" andDetailContent:_securityPassWord];
    _securityPasswordInputView.textField.tag = 2000;
    _securityPasswordInputView.textField.secureTextEntry = YES;
    _securityPasswordInputView.textField.clearsOnBeginEditing = YES;
    _securityPasswordInputView.textField.delegate = self;
    _securityPasswordInputView.textField.placeholder = @"请输入大于6位且由英文与数字组合";
    _securityPasswordInputView.textField.font = [UIFont systemFontOfSize:14];
    
    ////////////////
    _reSecurityPasswordInputView =
    [[MMMSingleInputView alloc]
     initWithFrame:
     CGRectMake(0,
                _securityPasswordInputView.frame.origin.y+_securityPasswordInputView.frame.size.height,
                [UIScreen mainScreen].bounds.size.width,
                60)];
    
    [_reSecurityPasswordInputView setTitleContent:@"再输入一次" andDetailContent:_securityPassWordRe];
    _reSecurityPasswordInputView.textField.tag = 2001;
    _reSecurityPasswordInputView.textField.secureTextEntry = YES;
    _reSecurityPasswordInputView.textField.clearsOnBeginEditing = YES;
    _reSecurityPasswordInputView.textField.delegate = self;
    _reSecurityPasswordInputView.textField.font = [UIFont systemFontOfSize:14];
    
    ////////////////
    if (!_checkCodeView) {
        _checkCodeView = [[MMMCheckCodeView alloc]initWithFrame:CGRectMake(0,
                                                                          _reSecurityPasswordInputView.frame.origin.y+_reSecurityPasswordInputView.frame.size.height,
                                                                          [UIScreen mainScreen].bounds.size.width,
                                                                          60)];
        _checkCodeView.textField.text = _Code;
        _checkCodeView.textField.tag = 2002;
        _checkCodeView.textField.delegate = self;
        _checkCodeView.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    
    [self addSubview:titleView_2];
    [self addSubview:_securityPasswordInputView];
    [self addSubview:_reSecurityPasswordInputView];
    [self addSubview:_checkCodeView];
    [_originY_Of_each addObject:@(_checkCodeView.frame.origin.y + _checkCodeView.frame.size.height)];
}

-(void)thirdArea {
    
    float beginOriginY = [_originY_Of_each.lastObject floatValue];
    
    //  服务器要求不验证安保问题,直接返回空
    if (_QuestionVerify == 2) {
        return;
    }
    
    if (!_questionTitleView) {
        _questionTitleView = [[MMMTableTitleView alloc]initWithFrame:CGRectMake(0, beginOriginY, [UIScreen mainScreen].bounds.size.width, 50)];
        [_questionTitleView setHeaderViewContentText:@"设置安保问题" andDetailContent:@"可用于查找密码" ];
        _questionTitleView.backgroundColor = self.backgroundColor;
        
        [self addSubview:_questionTitleView];
    }
    
    Block showQuestionViewBlock = ^{
        if (!_questionView_1) {
            _questionView_1 = [[MMMQuestionView alloc]initWithFrame:CGRectMake(0, _questionTitleView.frame.size.height + _questionTitleView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, 80)];
            _questionView_1.backgroundColor = self.backgroundColor;
            _questionView_1.questionTitleLabel.text = @"问题1: ";
            _questionView_1.answerTitleLabel.text = @"答案1: ";
            _questionView_1.answerTextField.delegate = self;
            _questionView_1.answerTextField.tag = 3000;
            _questionView_1.questionSwitchBtn.tag = 3000;
            _questionView_1.questionCustomBtn.tag = 3000;
            _questionView_1.answerTextField.text = _answer1;
            _questionView_1.questionTitleTextField.tag = 3010;
            _questionView_1.questionTitleTextField.delegate = self;
            _questionView_1.questionTitleTextField.text = _question1;
            _questionView_1.questionTitleTextField.hidden = !_isCustomQuestion_1;
            [_questionView_1.questionSwitchBtn addTarget:self action:@selector(setQuestion:) forControlEvents:UIControlEventTouchUpInside];
            [_questionView_1.questionCustomBtn addTarget:self action:@selector(setCustomQuestion:) forControlEvents:UIControlEventTouchUpInside];
            [_questionView_1 setquestionTitle:_question1];
            [self addSubview:_questionView_1];
        }
        
        if (!_questionView_2) {
            _questionView_2 = [[MMMQuestionView alloc]initWithFrame:CGRectMake(0,  _questionView_1.frame.size.height + _questionView_1.frame.origin.y, [UIScreen mainScreen].bounds.size.width, 80)];
            _questionView_2.backgroundColor = self.backgroundColor;
            _questionView_2.questionTitleLabel.text = @"问题2: ";
            _questionView_2.answerTitleLabel.text = @"答案2: ";
            _questionView_2.answerTextField.delegate = self;
            _questionView_2.answerTextField.tag = 3001;
            _questionView_2.questionSwitchBtn.tag = 3001;
            _questionView_2.questionCustomBtn.tag = 3001;
            _questionView_2.answerTextField.text = _answer2;
            _questionView_2.questionTitleTextField.tag = 3011;
            _questionView_2.questionTitleTextField.delegate = self;
            _questionView_2.questionTitleTextField.text = _question2;
            _questionView_2.questionTitleTextField.hidden = !_isCustomQuestion_2;
            [_questionView_2.questionSwitchBtn addTarget:self action:@selector(setQuestion:) forControlEvents:UIControlEventTouchUpInside];
            [_questionView_2.questionCustomBtn addTarget:self action:@selector(setCustomQuestion:) forControlEvents:UIControlEventTouchUpInside];
            [_questionView_2 setquestionTitle:_question2];
            [self addSubview:_questionView_2];
        }
        
        if (!_questionView_3) {
            _questionView_3 = [[MMMQuestionView alloc]initWithFrame:CGRectMake(0,  _questionView_2.frame.size.height + _questionView_2.frame.origin.y, [UIScreen mainScreen].bounds.size.width, 80)];
            _questionView_3.backgroundColor = self.backgroundColor;
            _questionView_3.questionTitleLabel.text = @"问题3: ";
            _questionView_3.answerTitleLabel.text = @"答案3: ";
            _questionView_3.answerTextField.delegate = self;
            _questionView_3.answerTextField.tag = 3002;
            _questionView_3.questionSwitchBtn.tag = 3002;
            _questionView_3.questionCustomBtn.tag = 3002;
            _questionView_3.answerTextField.text = _answer3;
            _questionView_3.questionTitleTextField.tag = 3012;
            _questionView_3.questionTitleTextField.delegate = self;
            _questionView_3.questionTitleTextField.text = _question3;
            _questionView_3.questionTitleTextField.hidden = !_isCustomQuestion_3;
            [_questionView_3.questionSwitchBtn addTarget:self action:@selector(setQuestion:) forControlEvents:UIControlEventTouchUpInside];
            [_questionView_3.questionCustomBtn addTarget:self action:@selector(setCustomQuestion:) forControlEvents:UIControlEventTouchUpInside];
            [_questionView_3 setquestionTitle:_question3];
            [self addSubview:_questionView_3];
        }
        
    };
    
    //  服务器要求安全安保认证可选
    if (_QuestionVerify == 0) {
        
        if (!_showQuestionsBtn) {
            _showQuestionsBtn = [[UIButton alloc] initWithFrame:CGRectZero];
            NSString *title = _issetquestion?@"收起":@"设置";
            [_showQuestionsBtn setTitle:title forState:UIControlStateNormal];
            [_showQuestionsBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _showQuestionsBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [_showQuestionsBtn sizeToFit];
            _showQuestionsBtn.backgroundColor = self.backgroundColor;
            _showQuestionsBtn.center = CGPointMake(_questionTitleView.frame.size.width/2, _questionTitleView.frame.size.height/2);
            CGPoint btnOrigin = _showQuestionsBtn.frame.origin;
            CGSize btnSize = _showQuestionsBtn.frame.size;
            _showQuestionsBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-10-btnSize.width, btnOrigin.y,btnSize.width,btnSize.height);
            [_showQuestionsBtn addTarget:self action:@selector(showQuestionList:) forControlEvents:UIControlEventTouchUpInside];
            [_questionTitleView addSubview:_showQuestionsBtn];
        }
        
        NSString *title = _issetquestion?@"收起":@"设置";
        [_showQuestionsBtn setTitle:title forState:UIControlStateNormal];
        
        if (_issetquestion) {
            
            showQuestionViewBlock();
            
            [_originY_Of_each addObject:@(_questionView_3.frame.size.height + _questionView_3.frame.origin.y)];
            
            return;
        }
        
        if (!_issetquestion) {
            [_questionView_1 removeFromSuperview];
            [_questionView_2 removeFromSuperview];
            [_questionView_3 removeFromSuperview];
            _questionView_1 = nil;
            _questionView_2 = nil;
            _questionView_3 = nil;
            [_originY_Of_each addObject:@(_questionTitleView.frame.size.height + _questionTitleView.frame.origin.y)];
            return;
        }
    }
    
    //  必须认证安保问题
    if (_QuestionVerify == 1) {
        showQuestionViewBlock();
        [_originY_Of_each addObject:@(_questionView_3.frame.size.height + _questionView_3.frame.origin.y)];
        return;
    }
    
}

// 安保问题 footerView 中的按钮事件
-(void)showQuestionList:(UIButton *)sender {
    float changeHeight = 80 * 3;
    _isCustomQuestion_1 = _isCustomQuestion_2 = _isCustomQuestion_3 = NO;
    
    if (_issetquestion) {
        
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [_views_that_maybeChangeFrame enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
                view.center = CGPointMake(view.center.x, view.center.y - changeHeight);
                _issetquestion = NO;
                _question1=_question2=_question3=
                _answer1=_answer2=_answer3=@"";
                [self thirdArea];
            }];
            
        }completion:^(BOOL finished) {
            self.contentSize = CGSizeMake(_currentSize.width, _currentSize.height - changeHeight);
            _currentSize = self.contentSize;
            
        }];
    }else{
        
        // xianshi
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_views_that_maybeChangeFrame enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
                view.center = CGPointMake(view.center.x, view.center.y + changeHeight);
                _issetquestion = YES;
                [self thirdArea];
                
            }];
            
        }completion:^(BOOL finished) {
            self.contentSize = CGSizeMake(_currentSize.width, _currentSize.height + changeHeight);
            _currentSize = self.contentSize;
        }];
    }
}

-(void)setCustomQuestion:(UIButton *)sender {
    if (sender.tag == 3000) {
        _isCustomQuestion_1 = !_isCustomQuestion_1;
        _questionView_1.questionTitleTextField.hidden = !_isCustomQuestion_1;
        _question1 = @"";
        _answer1 = @"";
    }else if (sender.tag == 3001){
        _isCustomQuestion_2 = !_isCustomQuestion_2;
        _questionView_2.questionTitleTextField.hidden = !_isCustomQuestion_2;
        _question2 = @"";
        _answer2 = @"";
    }else if (sender.tag == 3002){
        _isCustomQuestion_3 = !_isCustomQuestion_3;
        _questionView_3.questionTitleTextField.hidden = !_isCustomQuestion_3;
        _question3 = @"";
        _answer3 = @"";
    }
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
        _tableListView = [[UIView alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y+25, frame.size.width, 300)];
        
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
        [questionListTableView didSelectIndexPath:^(NSIndexPath *indexPath, NSString *context, NSInteger tag) {
            if (tag == 3000) {
                _question1 = context;
                [_questionView_1 setquestionTitle:_question1];
            }else if (tag == 3001){
                _question2 = context;
                [_questionView_2 setquestionTitle:_question2];
            }else if (tag == 3002){
                _question3 = context;
                [_questionView_3 setquestionTitle:_question3];
            }
            
            [self clearWindows:nil];
        }];
        questionListTableView.tag = sender.tag;
        [_tableListView addSubview:questionListTableView];
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

#pragma mark - phone section

-(void)fourthArea {
    
    float beginOriginY = [_originY_Of_each.lastObject floatValue];
    if (!_phoneTitleView) {
        _phoneTitleView = [[MMMTableTitleView alloc]initWithFrame:CGRectMake(0, beginOriginY, [UIScreen mainScreen].bounds.size.width, 50)];
        [_phoneTitleView setHeaderViewContentText:@"设置注册手机号" andDetailContent:@"可用于登陆" ];
        _phoneTitleView.backgroundColor = self.backgroundColor;
        [_views_that_maybeChangeFrame addObject:_phoneTitleView];
        [self addSubview:_phoneTitleView];
    }
    
    if (!_phoneInputView) {
        _phoneInputView = [[MMMSingleInputView alloc]
                           initWithFrame:
                           CGRectMake(0,
                                      _phoneTitleView.frame.origin.y+_phoneTitleView.frame.size.height,
                                      [UIScreen mainScreen].bounds.size.width,
                                      60)];
        [_phoneInputView setTitleContent:@"注册手机号" andDetailContent:_Mobile];
        _phoneInputView.textField.delegate = self;
        _phoneInputView.textField.tag = 4000;
        _phoneInputView.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [_views_that_maybeChangeFrame addObject:_phoneInputView];
        [self addSubview:_phoneInputView];
    }
    
    if (!_sendSmsView) {
        _sendSmsView = [[MMMSendMessageView alloc]initWithFrame:CGRectMake(0, _phoneInputView.frame.size.height + _phoneInputView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, 60)];
        _sendSmsView.textField.text = _mobileCode;
        _sendSmsView.textField.placeholder = @"短信验证码";
        [_sendSmsView.sendMsgBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        _sendSmsView.textField.delegate = self;
        _sendSmsView.textField.tag = 4001;
        _sendSmsView.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        ///////////////////
        [_sendSmsView sendMessageBtnPressed:^BOOL{
            [self hiddenKeyboard];
            if (!_Code || [[_Code stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请输入验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return NO;
            }
            if (!_Mobile || [[_Mobile stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请输入手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return NO;
            }
            NSString *params = [NSString stringWithFormat:@"accountName=%@&msg=2&Code=%@&phone=1",_Mobile,_Code];
            [MMMConfigUtil sharedConfigUtil].toSendMessage(params,^(NSData *data, NSError *error){
                if (!error) {
                    NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"%@",result);
                }
            });
            return YES;
        }];
        [_views_that_maybeChangeFrame addObject:_sendSmsView];
        [self addSubview:_sendSmsView];
    }
    
    [_originY_Of_each addObject:@(_sendSmsView.frame.origin.y + _sendSmsView.frame.size.height)];
}

#pragma mark - email section

-(void)fifthArea {
    float beginOriginY = [_originY_Of_each.lastObject floatValue];
    
    if (_isShowEmail) {
        
        if (!_emailTitleView) {
            _emailTitleView = [[MMMTableTitleView alloc]initWithFrame:CGRectMake(0, beginOriginY, [UIScreen mainScreen].bounds.size.width, 50)];
            [_emailTitleView setHeaderViewContentText:@"设置注册邮箱" andDetailContent:@"可用于登陆" ];
            _emailTitleView.backgroundColor = self.backgroundColor;
            [_views_that_maybeChangeFrame addObject:_emailTitleView];
            [self addSubview:_emailTitleView];
            
            if (!_emailInputView) {
                _emailInputView = [[MMMSingleInputView alloc]
                                   initWithFrame:
                                   CGRectMake(0,
                                              _emailTitleView.frame.origin.y+_emailTitleView.frame.size.height,
                                              [UIScreen mainScreen].bounds.size.width,
                                              60)];
                [_emailInputView setTitleContent:@"注册邮箱" andDetailContent:_Email];
                _emailInputView.textField.delegate = self;
                _emailInputView.textField.tag = 5000;
                _emailInputView.textField.keyboardType = UIKeyboardTypeEmailAddress;
                [_views_that_maybeChangeFrame addObject:_emailInputView];
                
                [self addSubview:_emailInputView];
            }
        }
        
        if (self.EmailVerify == 2) {
            
            if (!_isVerifyEmailBtn) {
                _isVerifyEmailBtn = [[UIButton alloc] initWithFrame:CGRectZero];
                NSString *title = _issetverifyemail?@"收起":@"验证";
                [_isVerifyEmailBtn setTitle:title forState:UIControlStateNormal];
                [_isVerifyEmailBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                _isVerifyEmailBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                [_isVerifyEmailBtn sizeToFit];
                _isVerifyEmailBtn.backgroundColor = self.backgroundColor;
                _isVerifyEmailBtn.center = CGPointMake(_emailTitleView.frame.size.width/2, _emailTitleView.frame.size.height/2);
                CGPoint btnOrigin = _isVerifyEmailBtn.frame.origin;
                CGSize btnSize = _isVerifyEmailBtn.frame.size;
                _isVerifyEmailBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-10-btnSize.width, btnOrigin.y,btnSize.width,btnSize.height);
                [_isVerifyEmailBtn addTarget:self action:@selector(showEmailInputView:) forControlEvents:UIControlEventTouchUpInside];
                [_emailTitleView addSubview:_isVerifyEmailBtn];
            }
            NSString *title = _issetverifyemail?@"收起":@"验证";
            [_isVerifyEmailBtn setTitle:title forState:UIControlStateNormal];
            
        }
        
        //  处于验证状态
        if (_issetverifyemail){
            
            
            if (!_sendEmailView) {
                _sendEmailView = [[MMMSendMessageView alloc]initWithFrame:CGRectMake(0, _emailInputView.frame.size.height + _emailInputView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, 60)];
                _sendEmailView.textField.text = _emailcode;
                _sendEmailView.textField.placeholder = @"邮箱验证码";
                [_sendEmailView.sendMsgBtn setTitle:@"发送邮箱验证码" forState:UIControlStateNormal];
                _sendEmailView.textField.delegate = self;
                _sendEmailView.textField.tag = 5001;
                _sendEmailView.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                [_views_that_maybeChangeFrame addObject:_sendEmailView];
                
                ///////////////////////
                [_sendEmailView sendMessageBtnPressed:^BOOL{
                    [self hiddenKeyboard];
                    
                    if (!_Code || [[_Code stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请输入验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alert show];
                        return NO;
                    }
                    if (!_Email || [[_Email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请输入邮箱" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alert show];
                        return NO;
                    }
                    
                    NSString *params = [NSString stringWithFormat:@"accountName=%@&msg=2&Code=%@&phone=1",_Email,_Code];
                    [MMMConfigUtil sharedConfigUtil].toSendMessage(params,^(NSData *data, NSError *error){
                                            if (!error) {
                                                NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//                                                NSLog(@"%@",result);
                                            }
                    });
                    return YES;
                }];
                [_originY_Of_each addObject:@(_sendEmailView.frame.origin.y + _sendEmailView.frame.size.height)];
                [self addSubview:_sendEmailView];
            }
        }else{
//            [_emailInputView removeFromSuperview];
//            [_sendEmailView removeFromSuperview];
            [_originY_Of_each addObject:@(_emailInputView.frame.origin.y + _emailInputView.frame.size.height)];
        }
    }
}

-(void)showEmailInputView:(UIButton *)sender {
    float changeHeight = 60*2;
    changeHeight = 60.0f;
    
    //  从验证到不验证
    if (_issetverifyemail) {
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            _sendEmailView.center = CGPointMake(_sendEmailView.center.x, _sendEmailView.center.y - changeHeight);
            _sendEmailView.transform = CGAffineTransformMakeScale(1, 0);
            _sendEmailView.alpha = 0;
            _registerBtn.center = CGPointMake(_registerBtn.center.x, _registerBtn.center.y - changeHeight);
                _issetverifyemail = NO;
            
                [self fifthArea];
            
        }completion:^(BOOL finished) {
            self.contentSize = CGSizeMake(_currentSize.width, _currentSize.height - changeHeight);
            _currentSize = self.contentSize;
        }];
    }else{
        [UIView animateWithDuration:0.05 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            _sendEmailView.center = CGPointMake(_sendEmailView.center.x, _sendEmailView.center.y + changeHeight);
            _sendEmailView.transform = CGAffineTransformMakeScale(1, 1);
            _sendEmailView.alpha = 1;
            _registerBtn.center = CGPointMake(_registerBtn.center.x, _registerBtn.center.y + changeHeight);
                _issetverifyemail = YES;
                [self fifthArea];
            
        }completion:^(BOOL finished) {
//            [self addSubview:_sendEmailView];
//            [self addSubview:_emailInputView];
            self.contentSize = CGSizeMake(_currentSize.width, _currentSize.height + changeHeight);
            _currentSize = self.contentSize;
        }];
    }
}

-(void)sixthArea {
    float beginOriginY = [_originY_Of_each.lastObject floatValue];
    if (!_registerBtn) {
        _registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, beginOriginY + 20, [UIScreen mainScreen].bounds.size.width-20, 50)];
        _registerBtn.backgroundColor = [UIColor colorWithRed:58.0f/255.0f green:108.0f/255.0f blue:241.0f/255.0f alpha:1];
        [_registerBtn setTitle:@"确认注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _registerBtn.layer.masksToBounds = YES;
        _registerBtn.layer.cornerRadius = 5.0f;
        
        [_registerBtn addTarget:self action:@selector(registerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_views_that_maybeChangeFrame addObject:_registerBtn];
        [self addSubview:_registerBtn];
    }
    
    [_originY_Of_each addObject:@(_registerBtn.frame.origin.y + _registerBtn.frame.size.height)];
}

-(void)registerBtnPressed:(UIButton *)sender{
    [self hiddenKeyboard];
    
    if ([[_loginPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] || !_loginPassword) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"密码不能为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if ([[_loginPasswordRe stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] || !_loginPasswordRe) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"密码不能为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if ([[_securityPassWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] || !_securityPassWord) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"密码不能为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if ([[_securityPassWordRe stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] || !_securityPassWordRe) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"密码不能为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if ([[_mobileCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] || !_mobileCode) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"短信验证码不能为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (!_Mobile || [[_Mobile stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"手机号不能为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
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
        // 判断邮箱存在
        if (!_Email || [[_Email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"邮箱不能为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        params = [NSString stringWithFormat:@"%@&Email=%@",params,_Email];
        
        // 判断是否验证
        if (_issetverifyemail) {
            // 验证邮箱.  输入邮箱验证码
            if (!_emailcode||[_emailcode isEqualToString:@""]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"邮箱验证码为空!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return;
            }
            
            params = [NSString stringWithFormat:@"%@&emailcode=%@",params,_emailcode];
        }else{
            // 不验证邮箱
            params = [NSString stringWithFormat:@"%@&issetverifyemail=1",params];
        }
        
    }
    // 不显示邮箱. 亦不验证邮箱
    else{
        params = [NSString stringWithFormat:@"%@&issetverifyemail=1",params];
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
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"安保问题个数不足" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alert show];
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
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请填写完整安保问题答案" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alert show];
            return NO;
        }
    };
    
    
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
    
    [MMMActivityIndicatorView show];
    [MMMConfigUtil sharedConfigUtil].toRegisterBind(params,^(NSData *data, NSError *error){
        _registerBtn.enabled = YES;
        [MMMActivityIndicatorView remove];
        if (!error) {
            
//            NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",str);
            
            [self callbackOfRegisterBind:data];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[error localizedDescription] delegate:nil cancelButtonTitle:@"返回" otherButtonTitles: nil];
            [alert show];
        }
    });
}
-(void)callbackOfRegisterBind:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    
//    NSLog(@"%@",dict);
    
    if ([[dict allKeys] containsObject:@"Message"]) {
        [resultDic setObject:[dict objectForKey:@"Message"] forKey:@"Message"];
    }
    if ([[dict allKeys] containsObject:@"AccountNumber"]) {
        [resultDic setObject:[dict objectForKey:@"AccountNumber"] forKey:@"AccountNumber"];
    }
    if ([[dict allKeys] containsObject:@"MoneymoremoreId"]) {
        [resultDic setObject:[dict objectForKey:@"MoneymoremoreId"] forKey:@"MoneymoremoreId"];
    }
    if ([[dict allKeys] containsObject:@"ResultCode"]) {
        [resultDic setObject:[dict objectForKey:@"ResultCode"] forKey:@"ResultCode"];
    }
    
    
    if (self.resultBlock)
        self.resultBlock(resultDic, MMMRegisterEvent);
    
    //////////////
    
        if ([[dict objectForKey:@"ResultCode"]isEqualToString:@"88"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
            alert.tag = 1001;
            if (!self.window) alert.delegate = nil;
            [alert show];
            return;
        }
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册提示" message:[dict objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1001) {
        if (self.completeBlock) {
            self.completeBlock();
        }
    }
}

#pragma mark - UITextField delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _currentObj = textField;
    _currentRect = [self convertRect:textField.frame fromView:textField];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSInteger tag = textField.tag;
    if (tag == 1000) {
        _loginPassword = textField.text;
    }else if (tag == 1001){
        _loginPasswordRe = textField.text;
    }else if (tag == 2000){
        _securityPassWord = textField.text;
    }else if (tag == 2001){
        _securityPassWordRe = textField.text;
    }else if (tag == 2002){
        _Code = textField.text;
    }else if (tag == 3000){
        _answer1 = textField.text;
    }else if (tag == 3001){
        _answer2 = textField.text;
    }else if (tag == 3002){
        _answer3 = textField.text;
    }else if (tag == 3010){
        _question1 = textField.text;
    }else if (tag == 3011){
        _question2 = textField.text;
    }else if (tag == 3012){
        _question3 = textField.text;
    }else if (tag == 4000){
        _Mobile = textField.text;
    }else if (tag == 4001){
        _mobileCode = textField.text;
    }else if (tag == 5000){
        _Email = textField.text;
    }else if (tag == 5001){
        _emailcode = textField.text;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)hiddenKeyboard {
    if (_currentObj) {
        [_currentObj resignFirstResponder];
        _currentObj = nil;
    }
}

@end
