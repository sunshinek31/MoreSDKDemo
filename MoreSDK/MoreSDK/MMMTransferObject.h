//
//  MMMTransferObject.h
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/21.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MMMTransferObject : NSObject

@property (nonatomic, copy) NSString *LoanJsonList;
@property (nonatomic, copy) NSString *PlatformMoneymoremore;
@property (nonatomic, copy) NSString *TransferAction;
@property (nonatomic, copy) NSString *Action;
@property (nonatomic, copy) NSString *TransferType;
@property (nonatomic, copy) NSString *NeedAudit;
@property (nonatomic, copy) NSString *RandomTimeStamp;
@property (nonatomic, copy) NSString *Remark1;
@property (nonatomic, copy) NSString *Remark2;
@property (nonatomic, copy) NSString *Remark3;
@property (nonatomic, copy) NSString *ReturnURL;
@property (nonatomic, copy) NSString *NotifyURL;

@property (nonatomic, copy) NSString *Phone;
@end
