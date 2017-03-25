//
//  MMMBankObject.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/23.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMBankObject.h"

@implementation MMMBankObject

-(instancetype)init{
    self = [super init];
    if (self){
        self.BankCode = [[NSString alloc]initWithFormat:@""];
        self.BankName = [[NSString alloc]initWithFormat:@""];
        self.BankBrand = [[NSString alloc]initWithFormat:@""];
        self.BankId = [[NSString alloc]initWithFormat:@""];
        self.BankPicCode = [[NSString alloc]initWithFormat:@""];
        self.Id = [[NSString alloc]initWithFormat:@""];
        self.CardNo = [[NSString alloc]initWithFormat:@""];
        self.Mobile = [[NSString alloc]initWithFormat:@""];
        self.TailNo = [[NSString alloc]initWithFormat:@""];
    }
    return self;
}

-(void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues {
    if ([[keyedValues allKeys] containsObject:@"bankCode"]) {
        self.BankCode = [keyedValues objectForKey:@"bankCode"];
    }
    if ([[keyedValues allKeys] containsObject:@"bankName"]) {
        self.BankName = [keyedValues objectForKey:@"bankName"];
    }
    if ([[keyedValues allKeys] containsObject:@"bankBrand"]) {
        self.BankBrand = [keyedValues objectForKey:@"bankBrand"];
    }
    if ([[keyedValues allKeys] containsObject:@"bankId"]) {
        self.BankId = [keyedValues objectForKey:@"bankId"];
    }
    if ([[keyedValues allKeys] containsObject:@"bankPicCode"]) {
        self.BankPicCode = [keyedValues objectForKey:@"bankPicCode"];
    }
    if ([[keyedValues allKeys] containsObject:@"id"]) {
        self.Id = [keyedValues objectForKey:@"id"];
    }
    if ([[keyedValues allKeys] containsObject:@"cardNo"]) {
        self.CardNo = [keyedValues objectForKey:@"cardNo"];
    }
    if ([[keyedValues allKeys] containsObject:@"mobile"]) {
        self.Mobile = [keyedValues objectForKey:@"mobile"];
    }
    if ([[keyedValues allKeys] containsObject:@"tailNo"]) {
        self.TailNo = [keyedValues objectForKey:@"tailNo"];
    }
}
@end
