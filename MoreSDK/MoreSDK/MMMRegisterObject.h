//
//  MMMRegisterObject.h
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMMRegisterObject : NSObject
@property (nonatomic, copy) NSString *RegisterType;
@property (nonatomic, copy) NSString *AccountType;
@property (nonatomic, copy) NSString *Mobile;
@property (nonatomic, copy) NSString *Email;
@property (nonatomic, copy) NSString *RealName;
@property (nonatomic, copy) NSString *IdentificationNo;
@property (nonatomic, copy) NSString *Image1;
@property (nonatomic, copy) NSString *Image2;
@property (nonatomic, copy) NSString *LoanPlatformAccount;
@property (nonatomic, copy) NSString *PlatformMoneymoremore;
@property (nonatomic, copy) NSString *RandomTimeStamp;
@property (nonatomic, copy) NSString *Remark1;
@property (nonatomic, copy) NSString *Remark2;
@property (nonatomic, copy) NSString *Remark3;
@property (nonatomic, copy) NSString *ReturnURL;
@property (nonatomic, copy) NSString *NotifyURL;

@property (nonatomic, copy) NSString *Phone;
@end
