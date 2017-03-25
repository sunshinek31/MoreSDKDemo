//
//  MMMTransferObject.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/21.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMTransferObject.h"

@implementation MMMTransferObject
-(instancetype)init {
    self = [super init];
    if (self) {
//        self.LoanJsonList = [[NSString alloc]initWithFormat:@""];
//        self.PlatformMoneymoremore = [[NSString alloc]initWithFormat:@""];
//        self.TransferAction = [[NSString alloc]initWithFormat:@""];
//        self.Action = [[NSString alloc]initWithFormat:@""];
//        self.TransferType = [[NSString alloc]initWithFormat:@""];
        self.NeedAudit = [[NSString alloc]initWithFormat:@""];
        self.RandomTimeStamp = [[NSString alloc]initWithFormat:@""];
        self.Remark1 = [[NSString alloc]initWithFormat:@""];
        self.Remark2 = [[NSString alloc]initWithFormat:@""];
        self.Remark3 = [[NSString alloc]initWithFormat:@""];
        self.ReturnURL = [[NSString alloc]initWithFormat:@""];
//        self.NotifyURL = [[NSString alloc]initWithFormat:@""];
        
        self.Phone = [[NSString alloc]initWithFormat:@""];
    }
    return self;
}

-(void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues {
    if ([[keyedValues allKeys] containsObject:@"LoanJsonList"]) {
        self.LoanJsonList = [keyedValues objectForKey:@"LoanJsonList"];
    }
    if ([[keyedValues allKeys] containsObject:@"PlatformMoneymoremore"]) {
        self.PlatformMoneymoremore = [keyedValues objectForKey:@"PlatformMoneymoremore"];
    }
    if ([[keyedValues allKeys] containsObject:@"TransferAction"]) {
        self.TransferAction = [keyedValues objectForKey:@"TransferAction"];
    }
    if ([[keyedValues allKeys] containsObject:@"Action"]) {
        self.Action = [keyedValues objectForKey:@"Action"];
    }
    if ([[keyedValues allKeys] containsObject:@"TransferType"]) {
        self.TransferType = [keyedValues objectForKey:@"TransferType"];
    }
    if ([[keyedValues allKeys] containsObject:@"NeedAudit"]) {
        self.NeedAudit = [keyedValues objectForKey:@"NeedAudit"];
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
