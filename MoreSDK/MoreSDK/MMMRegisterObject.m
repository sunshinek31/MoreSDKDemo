//
//  MMMRegisterObject.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMRegisterObject.h"

@implementation MMMRegisterObject
-(id)init {
    self = [super init];
    if (self) {
//        self.RegisterType = [[NSString alloc]initWithFormat:@""];
        self.PlatformMoneymoremore = [[NSString alloc]initWithFormat:@""];
        self.AccountType = [[NSString alloc]initWithFormat:@""];
        ///////
        self.Mobile = [[NSString alloc]initWithFormat:@""];
        self.Email = [[NSString alloc]initWithFormat:@""];
        self.RealName = [[NSString alloc]initWithFormat:@""];
        self.IdentificationNo = [[NSString alloc]initWithFormat:@""];
        ///////
        self.Image1 = [[NSString alloc]initWithFormat:@""];
        self.Image2 = [[NSString alloc]initWithFormat:@""];
//        self.LoanPlatformAccount = [[NSString alloc]initWithFormat:@""];
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
    
    if ([[keyedValues allKeys] containsObject:@"RegisterType"]) {
        self.RegisterType = [keyedValues objectForKey:@"RegisterType"];
    }
    if ([[keyedValues allKeys] containsObject:@"PlatformMoneymoremore"]) {
        self.PlatformMoneymoremore = [keyedValues objectForKey:@"PlatformMoneymoremore"];
    }
    if ([[keyedValues allKeys] containsObject:@"AccountType"]) {
        self.AccountType = [keyedValues objectForKey:@"AccountType"];
    }
    if ([[keyedValues allKeys] containsObject:@"Mobile"]) {
        self.Mobile = [keyedValues objectForKey:@"Mobile"];
    }
    if ([[keyedValues allKeys] containsObject:@"Email"]) {
        self.Email = [keyedValues objectForKey:@"Email"];
    }
    if ([[keyedValues allKeys] containsObject:@"RealName"]) {
        self.RealName = [keyedValues objectForKey:@"RealName"];
    }
    if ([[keyedValues allKeys] containsObject:@"IdentificationNo"]) {
        self.IdentificationNo = [keyedValues objectForKey:@"IdentificationNo"];
    }
    if ([[keyedValues allKeys] containsObject:@"Image1"]) {
        self.Image1 = [keyedValues objectForKey:@"Image1"];
    }
    if ([[keyedValues allKeys] containsObject:@"Image2"]) {
        self.Image2 = [keyedValues objectForKey:@"Image2"];
    }
    if ([[keyedValues allKeys] containsObject:@"LoanPlatformAccount"]) {
        self.LoanPlatformAccount = [keyedValues objectForKey:@"LoanPlatformAccount"];
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
