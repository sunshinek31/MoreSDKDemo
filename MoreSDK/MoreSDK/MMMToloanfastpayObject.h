//
//  MMMToloanfastpayObject.h
//  MoreSDK
//
//  Created by immortal on 15/7/17.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMMToloanfastpayObject : NSObject

@property (nonatomic, copy) NSString *MoneymoremoreId;
@property (nonatomic, copy) NSString *PlatformMoneymoremore;
@property (nonatomic, copy) NSString *Action;
@property (nonatomic, copy) NSString *CardNo;
@property (nonatomic, copy) NSString *WithholdBeginDate;
@property (nonatomic, copy) NSString *WithholdEndDate;
@property (nonatomic, copy) NSString *SingleWithholdLimit;
@property (nonatomic, copy) NSString *TotalWithholdLimit;
@property (nonatomic, copy) NSString *RandomTimeStamp;

@property (nonatomic, copy) NSString *Remark1;
@property (nonatomic, copy) NSString *Remark2;
@property (nonatomic, copy) NSString *Remark3;
@property (nonatomic, copy) NSString *ReturnURL;
@property (nonatomic, copy) NSString *NotifyURL;

@property (nonatomic, copy) NSString *Phone;


-(void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues;

@end
