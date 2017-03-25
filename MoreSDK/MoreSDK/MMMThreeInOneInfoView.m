//
//  MMMThreeInOneInfoView.m
//  MoreSDK
//
//  Created by immortal on 15/7/17.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMThreeInOneInfoView.h"

#define kHeight 25
@implementation MMMThreeInOneInfoView

+ (MMMThreeInOneInfoView *)infoViewWithInfos:(NSDictionary *)dic{
    MMMThreeInOneInfoView *infoView = [[MMMThreeInOneInfoView alloc]init];
    infoView.frame = CGRectMake(10,5,ScSize.width - 10, kHeight*dic.count);
    CGFloat y = 0;
    
    NSArray *arr = [self orderInfo:dic];
    
    for (NSDictionary *dict in arr) {
        NSString *str = [NSString stringWithFormat:@"%@:%@",[dict allKeys][0],[dict allValues][0]];
        
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:16];
        label.text = str;
        label.textColor = [UIColor colorWithRed:105/255.0 green:152/255.0 blue:237/255.0 alpha:1];
        label.frame = CGRectMake(0, y, ScSize.width, kHeight);
        y += kHeight;
        
        [infoView addSubview:label];
    }
    
    
    return infoView;
}

+ (NSArray *)orderInfo:(NSDictionary *)dic{
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *keyArr = @[@"公司名",@"平台名",@"平台用户名",@"亁多多账户",@"开户名",@"证件类型",@"身份证号",@"绑卡类型",@"开户行",@"银行账户",@"开户省市",@"开户支行"];
    for (NSString *key in keyArr) {
        NSString *value = [dic objectForKey:key];
        if (value) {
            [arr addObject:@{key:value}];
        }
    }
    return arr;
}

//showInfoDic[@"公司名"] = _CompanyName;
//showInfoDic[@"平台名"] = _PlatformName;
//showInfoDic[@"平台用户名"] = _LoanPlatformAccount;
//showInfoDic[@"亁多多账户"] = _MoneymoremoreAccount;
//showInfoDic[@"开户名"] = _RealName;
//
//if ([_flag isEqualToString:@"1"]) {
//    
//    if ([_AccountType isEqualToString:@""]) {
//        showInfoDic[@"证件类型"] = @"身份证";
//    }
//    if ([_AccountType isEqualToString:@"1"]) {
//        showInfoDic[@"证件类型"] = @"营业执照";
//    }
//    if ([_AccountType isEqualToString:@"2"]) {
//        showInfoDic[@"证件类型"] = @"护照";
//    }
//    showInfoDic[@"身份证号"] = _IdentificationNo;
//}
//if ([_flag isEqualToString:@"2"]) {
//    showInfoDic[@"身份证号"] = _IdentificationNo;
//    
//    if ([_AccountType isEqualToString:@""]) {
//        showInfoDic[@"证件类型"] = @"身份证";
//    }
//    if ([_AccountType isEqualToString:@"1"]) {
//        showInfoDic[@"证件类型"] = @"营业执照";
//    }
//    if ([_AccountType isEqualToString:@"2"]) {
//        showInfoDic[@"证件类型"] = @"护照";
//    }
//    
//    if ([_CardBindType isEqualToString:@""]) {
//        showInfoDic[@"绑卡类型"] = @"快捷支付、汇款";
//    }
//    if ([_CardBindType isEqualToString:@"1"]) {
//        showInfoDic[@"绑卡类型"] = @"快捷支付";
//    }
//    if ([_CardBindType isEqualToString:@"2"]) {
//        showInfoDic[@"绑卡类型"] = @"汇款";
//    }
//    _modifytype2 = @"1";
//}
//if ([_flag isEqualToString:@"5"]) {
//    showInfoDic[@"开户行"] = _BankName;
//    showInfoDic[@"银行账户"] = _CardNo;
//    showInfoDic[@"开户省市"] = _CityInfo;
//    showInfoDic[@"开户支行"] = _BranchBankName;
//}


@end
