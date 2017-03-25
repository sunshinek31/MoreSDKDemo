//
//  MMMLoanObject.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/20.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMLoanObject.h"

@implementation MMMLoanObject
-(id)init {
    self = [super init];
    if (self) {
//        self.RechargeMoneymoremore = [[NSString alloc]initWithFormat:@""];
//        self.PlatformMoneymoremore = [[NSString alloc]initWithFormat:@""];
//        self.OrderNo = [[NSString alloc]initWithFormat:@""];
//        self.Amount = [[NSString alloc]initWithFormat:@""];
        self.RechargeType = [[NSString alloc]initWithFormat:@""];
//        self.FeeType = [[NSString alloc]initWithFormat:@""];
        self.CardNo = [[NSString alloc]initWithFormat:@""];
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
    
    if ([[keyedValues allKeys] containsObject:@"RechargeMoneymoremore"]) {
        self.RechargeMoneymoremore = [keyedValues objectForKey:@"RechargeMoneymoremore"];
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
    if ([[keyedValues allKeys] containsObject:@"RechargeType"]) {
        self.RechargeType = [keyedValues objectForKey:@"RechargeType"];
    }
    if ([[keyedValues allKeys] containsObject:@"FeeType"]) {
        self.FeeType = [keyedValues objectForKey:@"FeeType"];
    }
    if ([[keyedValues allKeys] containsObject:@"CardNo"]) {
        self.CardNo = [keyedValues objectForKey:@"CardNo"];
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
