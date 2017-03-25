//
//  MMMAuthorizeObject.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/21.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMAuthorizeObject.h"

@implementation MMMAuthorizeObject

-(id)init {
    self = [super init];
    if (self) {
//        self.MoneymoremoreId = [[NSString alloc]initWithFormat:@""];
//        self.PlatformMoneymoremore = [[NSString alloc]initWithFormat:@""];
        self.AuthorizeTypeOpen = [[NSString alloc]initWithFormat:@""];
        self.AuthorizeTypeClose = [[NSString alloc]initWithFormat:@""];
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
-(void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues{
    if ([[keyedValues allKeys] containsObject:@"MoneymoremoreId"]) {
        self.MoneymoremoreId = [keyedValues objectForKey:@"MoneymoremoreId"];
    }
    if ([[keyedValues allKeys] containsObject:@"PlatformMoneymoremore"]) {
        self.PlatformMoneymoremore = [keyedValues objectForKey:@"PlatformMoneymoremore"];
    }
    if ([[keyedValues allKeys] containsObject:@"AuthorizeTypeOpen"]) {
        self.AuthorizeTypeOpen = [keyedValues objectForKey:@"AuthorizeTypeOpen"];
    }
    if ([[keyedValues allKeys] containsObject:@"AuthorizeTypeClose"]) {
        self.AuthorizeTypeClose = [keyedValues objectForKey:@"AuthorizeTypeClose"];
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
