//
//  MMMUserBindTableView.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMUserBindTableView.h"
#import "MMMSendMessageCell.h"
#import "MMMRegisterBindInfoCell.h"
#import "MMMPasswordInputCell.h"
#import "MMMHeaderView.h"

@interface MMMUserBindTableView()
<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *cellInfoArr;
@property (nonatomic, strong) NSMutableDictionary *cellInfoDic;
@end

@implementation MMMUserBindTableView
{
@private
    int _flag;
    NSString *_modifytype1;
    NSString *_mid;
    NSString *_password;
    NSString *_paymentCode;
    NSString *_answer1;
    NSString *_answer2;
    NSString *_answer3;
    NSString *_tempid;
    
    NSString *_realName;
    NSString *_identificationNo;
    NSString *_loanPlatfromAccount;
    
    NSString *_infoMessage;
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _flag = 0;
    }
    return self;
}

-(void)setParams:(NSDictionary *)params {
    _identificationNo = [params objectForKey:@"IdentificationNo"];
    _loanPlatfromAccount = [params objectForKey:@"LoanPlatformAccount"];
    _realName = [params objectForKey:@"RealName"];
    _answer1 = [params objectForKey:@"answer1"];
    _answer2 = [params objectForKey:@"answer2"];
    _answer3 = [params objectForKey:@"answer3"];
    _flag = [[params objectForKey:@"flag"]intValue];
    _tempid = [params objectForKey:@"tempid"];
    _infoMessage = [self getInfoMessage:_flag];
    
    [self configCellInfoArr];
}

-(NSString *)getInfoMessage:(NSUInteger)flag {
    switch (flag) {
        case 1:case 2:case 3:
            
            return @"系统检测到您的手机号和邮箱均已注册过乾多多账户";
        case 4:
            return @"系统检测到您的手机号已注册过乾多多账户";
        case 5:
            return @"系统检测到您的邮箱已注册过乾多多账号";
        default:
            return @"";
    }
}

-(void)configCellInfoArr {
    if (!_cellInfoArr) {
        _cellInfoArr = [[NSMutableArray alloc]init];
    }
    
    if (_flag == 4) {
        
        NSArray *section_1 = @[@{@"title":@"手机注册人: "}];
        [_cellInfoArr addObject:section_1];
    }else if (_flag == 1){
        NSArray *section_1 = @[@{@"title":@"手机注册人: "}];
        [_cellInfoArr addObject:section_1];
    }else if (_flag == 2){
        NSArray *section_1 = @[@{@"title":@"手机注册人: "}];
        [_cellInfoArr addObject:section_1];
    }else if (_flag == 5){
        NSArray *section_1 = @[@{@"title":@"邮箱注册人: "}];
        [_cellInfoArr addObject:section_1];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 120;
    }else if (section == 1){
        return 20;
    }else if (section == 2){
        return 10;
    }
    else {
        return 50;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == _cellInfoArr.count-1) {
        return 80;
    }else{
        return 0;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"选择绑定作为托管账户的乾多多账户";
    }else {
        return @"";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return 70;
    }
    return 50;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_cellInfoArr count];;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_cellInfoArr[section] count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MDDCompanyRegisterInfoCellIdentifier = @"MDDCompanyRegisterInfoCellIdentifier";
    
    MMMRegisterBindInfoCell *infoCell;
    MMMPasswordInputCell *passwordCell;
    MMMSendMessageCell *smsCell;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        if(!infoCell) {
            infoCell = [[MMMRegisterBindInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else if (indexPath.section == 1){
        if(!infoCell) {
            infoCell = [[MMMRegisterBindInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MDDCompanyRegisterInfoCellIdentifier];
            infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else if (indexPath.section == 2){
        if(!passwordCell) {
            passwordCell = [[MMMPasswordInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            passwordCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else if (indexPath.section == 3 && _flag == 0){
        if (!smsCell) {
            smsCell = [[MMMSendMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            smsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSString *nameTitle = [NSString stringWithFormat:@"姓名 : %@",_realName];
        NSString *identifierId = [NSString stringWithFormat:@"身份证 : %@",_identificationNo];
        NSString *title = [[_cellInfoArr[indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
        [infoCell setRegisterInfo:title registerName:nameTitle certificateID:identifierId];
        return infoCell;
    }else if (indexPath.section == 1){
        [infoCell setContentText:@"姓名 : 金晨 身份证 : 320586199107317810"];
        return infoCell;
    }else if(indexPath.section == 2){
        return passwordCell;
    }else if(indexPath.section == 3 && _flag == 0){
        return smsCell;
    }else {
        return nil;
    }
}

#pragma mark - View for Header/Footer In Section

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view;
    if (section == 0) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100+20)];
        MMMHeaderView *topView = [[MMMHeaderView alloc]initWithFrame:CGRectMake(5, 10, [UIScreen mainScreen].bounds.size.width-10, 100)];
        topView.backgroundColor = [UIColor clearColor];
        //        [topView setInformation:@"金晨" personalID:@"320586199107317810" platformID:@"320586199107317810"];
        
        
        //        MDDTableView_HeaderView *bottomView = [[MDDTableView_HeaderView alloc]initWithFrame:CGRectMake(0, 100+10, [UIScreen mainScreen].bounds.size.width,50)];
        //        [bottomView setHeaderViewContentText:@"设置登陆密码" andDetailContent:@"登陆时需验证,保护账户信息" ];
        //        bottomView.backgroundColor = self.backgroundColor;
        
        NSString *title1 = @"平台名称: 乾多多";
        NSString *title2 = [NSString stringWithFormat:@"您在平台的用户名: %@",_loanPlatfromAccount];
        NSString *title3 = [NSString stringWithFormat:@"温馨提示: %@",_infoMessage];
        [topView setContext:title1 headerLabel2:title2 hederLabel3:title3];
        
        [view addSubview:topView];
        //        [view addSubview:bottomView];
    }else if (section == 3){
//        view = [[MDDCompanyBindStyleHeadView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        //        return view;
    }
    
    
    //    else if (section == 1) {
    //        view = [[MDDTableView_HeaderView alloc]initWithFrame:self.frame];
    //        [(MDDTableView_HeaderView *)view setHeaderViewContentText:@"设置支付密码" andDetailContent:@"付款时需验证,保护资金安全" ];
    //    }else if (section == 2) {
    //        view = [[MDDTableView_HeaderView alloc]initWithFrame:self.frame];
    //        [(MDDTableView_HeaderView *)view setHeaderViewContentText:@"设置注册手机号" andDetailContent:@"可用于登陆" ];
    //    }else if (section == 3) {
    //        view = [[MDDTableView_HeaderView alloc]initWithFrame:self.frame];
    //        [(MDDTableView_HeaderView *)view setHeaderViewContentText:@"设置注册邮箱" andDetailContent:@"可用于登陆" ];
    //    }
    
    view.backgroundColor = self.backgroundColor;
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    //    if (section == _cellInfoArr.count-1) {
    //
    //    }
    
    
    if (section == _cellInfoArr.count-1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
        view.backgroundColor = [UIColor clearColor];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width-20, 50)];
        btn.backgroundColor = [UIColor colorWithRed:58.0f/255.0f green:108.0f/255.0f blue:241.0f/255.0f alpha:1];
        [btn setTitle:@"确认" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5.0f;
        
        [btn addTarget:self action:@selector(confirmBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:btn];
        return view;
    }else if (section == 1){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        view.backgroundColor = [UIColor clearColor];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 30)];
        [btn setTitle:@"我还没有乾多多账户,注册一个?" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:149.0f/255.0f blue:237.0f/255.0f alpha:1] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        
        [view addSubview:btn];
        return view;
    }
    else {
        return nil;
    }
}

-(void)confirmBtnPressed:(UIButton *)sender {
    if (_flag == 4) {
//        if (self.ownerDelegate && [self.ownerDelegate isKindOfClass:[MDDRegisterController class]]) {
//            [self.ownerDelegate back:nil];
//        }
    }
}

@end
