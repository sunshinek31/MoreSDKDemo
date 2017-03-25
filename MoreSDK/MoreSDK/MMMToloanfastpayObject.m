//
//  MMMToloanfastpayObject.m
//  MoreSDK
//
//  Created by immortal on 15/7/17.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMToloanfastpayObject.h"

@implementation MMMToloanfastpayObject


-(id)init {
    self = [super init];
    if (self) {
        //        self.MoneymoremoreId = [[NSString alloc]initWithFormat:@""];
        //        self.PlatformMoneymoremore = [[NSString alloc]initWithFormat:@""];
        self.CardNo = [[NSString alloc]initWithFormat:@""];
        self.WithholdBeginDate = [[NSString alloc]initWithFormat:@""];
        self.WithholdEndDate = [[NSString alloc]initWithFormat:@""];
        self.SingleWithholdLimit = [[NSString alloc]initWithFormat:@""];
        self.TotalWithholdLimit = [[NSString alloc]initWithFormat:@""];
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
    
    if ([[keyedValues allKeys] containsObject:@"MoneymoremoreId"]) {
        self.MoneymoremoreId = [keyedValues objectForKey:@"MoneymoremoreId"];
    }
    if ([[keyedValues allKeys] containsObject:@"PlatformMoneymoremore"]) {
        self.PlatformMoneymoremore = [keyedValues objectForKey:@"PlatformMoneymoremore"];
    }
    if ([[keyedValues allKeys] containsObject:@"Action"]) {
        self.Action = [keyedValues objectForKey:@"Action"];
    }
    if ([[keyedValues allKeys] containsObject:@"CardNo"]) {
        self.CardNo = [keyedValues objectForKey:@"CardNo"];
    }
    if ([[keyedValues allKeys] containsObject:@"WithholdBeginDate"]) {
        self.WithholdBeginDate = [keyedValues objectForKey:@"WithholdBeginDate"];
    }
    if ([[keyedValues allKeys] containsObject:@"WithholdEndDate"]) {
        self.WithholdEndDate = [keyedValues objectForKey:@"WithholdEndDate"];
    }
    if ([[keyedValues allKeys] containsObject:@"SingleWithholdLimit"]) {
        self.SingleWithholdLimit = [keyedValues objectForKey:@"SingleWithholdLimit"];
    }
    if ([[keyedValues allKeys] containsObject:@"TotalWithholdLimit"]) {
        self.TotalWithholdLimit = [keyedValues objectForKey:@"TotalWithholdLimit"];
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
