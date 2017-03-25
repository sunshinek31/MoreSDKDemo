//
//  MMMAuthorizeObject.h
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/21.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMMAuthorizeObject : NSObject

@property (nonatomic, copy) NSString *MoneymoremoreId;
@property (nonatomic, copy) NSString *PlatformMoneymoremore;
@property (nonatomic, copy) NSString *AuthorizeTypeOpen;
@property (nonatomic, copy) NSString *AuthorizeTypeClose;
@property (nonatomic, copy) NSString *RandomTimeStamp;
@property (nonatomic, copy) NSString *Remark1;
@property (nonatomic, copy) NSString *Remark2;
@property (nonatomic, copy) NSString *Remark3;
@property (nonatomic, copy) NSString *ReturnURL;
@property (nonatomic, copy) NSString *NotifyURL;

@property (nonatomic, copy) NSString *Phone;

-(void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues;
@end
