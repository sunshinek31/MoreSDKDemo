//
//  MMMWithdrawObject.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/20.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMWithdrawObject.h"

@implementation MMMWithdrawObject
-(id)init {
    self = [super init];
    if (self) {
//        self.WithdrawMoneymoremore = [[NSString alloc]initWithFormat:@""];
//        self.PlatformMoneymoremore = [[NSString alloc]initWithFormat:@""];
//        self.OrderNo = [[NSString alloc]initWithFormat:@""];
//        self.Amount = [[NSString alloc]initWithFormat:@""];
        self.FeePercent = [[NSString alloc]initWithFormat:@""];
        self.FeeMax = [[NSString alloc]initWithFormat:@""];
        self.FeeRate = [[NSString alloc]initWithFormat:@""];
//        self.CardNo = [[NSString alloc]initWithFormat:@""];
//        self.CardType = [[NSString alloc]initWithFormat:@""];
//        self.BankCode = [[NSString alloc]initWithFormat:@""];
        self.BranchBankName = [[NSString alloc]initWithFormat:@""];
        self.Province = [[NSString alloc]initWithFormat:@""];
        self.City = [[NSString alloc]initWithFormat:@""];
        self.RandomTimeStamp = [[NSString alloc]initWithFormat:@""];
        self.Remark1 = [[NSString alloc]initWithFormat:@""];
        self.Remark2 = [[NSString alloc]initWithFormat:@""];
        self.Remark3 = [[NSString alloc]initWithFormat:@""];
        self.ReturnURL = [[NSString alloc]initWithFormat:@""];
//        self.NotifyURL = [[NSString alloc]initWithFormat:@""];
        
        self.Phone = [[NSString alloc]initWithFormat:@"1"];
    }
    return self;
}

-(void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues {
    if ([[keyedValues allKeys] containsObject:@"WithdrawMoneymoremore"]) {
        self.WithdrawMoneymoremore = [keyedValues objectForKey:@"WithdrawMoneymoremore"];
    }
    if ([[keyedValues allKeys] containsObject:@"PlatformMoneymoremore"]) {
        self.PlatformMoneymoremore = [keyedValues objectForKey:@"PlatformMoneymoremore"];
    }
    if ([[keyedValues allKeys] containsObject:@"OrderNo"]) {
        self.OrderNo = [keyedValues objectForKey:@"OrderNo"];
    }
    if ([[keyedValues allKeys] containsObject:@"Amount"]) {
        self.Amount = [keyedValues objectForKey:@"Amount"];
    }
    if ([[keyedValues allKeys] containsObject:@"FeePercent"]) {
        self.FeePercent = [keyedValues objectForKey:@"FeePercent"];
    }
    if ([[keyedValues allKeys] containsObject:@"FeeMax"]) {
        self.FeeMax = [keyedValues objectForKey:@"FeeMax"];
    }
    if ([[keyedValues allKeys] containsObject:@"FeeRate"]) {
        self.FeeRate = [keyedValues objectForKey:@"FeeRate"];
    }
    if ([[keyedValues allKeys] containsObject:@"CardNo"]) {
        self.CardNo = [keyedValues objectForKey:@"CardNo"];
    }
    if ([[keyedValues allKeys] containsObject:@"CardType"]) {
        self.CardType = [keyedValues objectForKey:@"CardType"];
    }
    if ([[keyedValues allKeys] containsObject:@"BankCode"]) {
        self.BankCode = [keyedValues objectForKey:@"BankCode"];
    }
    if ([[keyedValues allKeys] containsObject:@"BranchBankName"]) {
        self.BranchBankName = [keyedValues objectForKey:@"BranchBankName"];
    }
    if ([[keyedValues allKeys] containsObject:@"Province"]) {
        self.Province = [keyedValues objectForKey:@"Province"];
    }
    if ([[keyedValues allKeys] containsObject:@"City"]) {
        self.City = [keyedValues objectForKey:@"City"];
    }
    if ([[keyedValues allKeys] containsObject:@"RandomTimeStamp"]) {
        self.RandomTimeStamp = [keyedValues objectForKey:@"RandomTimeStamp"];
    }
    if ([[keyedValues allKeys] containsObject:@"Remark1"]) {
        self.Remark1 = [keyedValues objectForKey:@"Remark1"];
    }
    if ([[keyedValues allKeys] containsObject:@"Remark2"]) {
        self.Remark2 = [keyedValues objectForKey:@"Remark2"];
    }
    if ([[keyedValues allKeys] containsObject:@"Remark3"]) {
        self.Remark3 = [keyedValues objectForKey:@"Remark3"];
    }
    if ([[keyedValues allKeys] containsObject:@"ReturnURL"]) {
        self.ReturnURL = [keyedValues objectForKey:@"ReturnURL"];
    }
    if ([[keyedValues allKeys] containsObject:@"NotifyURL"]) {
        self.NotifyURL = [keyedValues objectForKey:@"NotifyURL"];
    }
}


@end
