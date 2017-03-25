//
//  MMMConfigUtil.h
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMMEventEnum.h"

typedef void (^CallbackBlock)(NSData *data, NSError *error);

typedef struct _url_util{
    NSString* (*setPostString)(NSDictionary *);
    NSString* (*getBanklistByType)();
    void (*enableTestServiceURL)(BOOL isEnable);
//    void (*setServiceURL)(NSString *serviceURL);
    void (*beginService)(MMMEventType event, NSString *paramsString,NSString *signString, CallbackBlock);
    void (*beginServiceWithDict)(MMMEventType event, NSDictionary *paramsDic,NSString *signString, CallbackBlock);
    
    void (*toRegisterBind)(NSString *paramsString, CallbackBlock);  //注册
    void (*toLoanBind)(NSString *paramsString, CallbackBlock);      //重新绑定
    void (*toRegisterExtraBind)(NSString *paramsString, CallbackBlock);// 注册模块 平台采集
    
    void (*toRechargeFastPay)(NSString *paramsString, CallbackBlock);//充值
    void (*toRechargeFastPayWithDic)(NSDictionary *params, CallbackBlock);
    
    void (*toLoanWithdraws)(NSString *paramsString, CallbackBlock); //提现
    void (*toAuthorize)(NSString *paramsString, CallbackBlock);     //授权
    void (*toLoanact)(NSString *paramsString, CallbackBlock);       //转账
    void (*toLoanfastpay)(NSString *paramString,CallbackBlock);
    
    void(*toSendDKPhoneCode)(NSString *paramsString, CallbackBlock);//充值模块 发送短信验证码
    void(*toSendDKPhoneCodeFor3in1)(NSString *paramsString, CallbackBlock);
    void(*toSendMessage)(NSString *paramsString, CallbackBlock);     //注册页面发送短信验证码
    void(*toCheckCode)(NSString *paramsString, CallbackBlock);//注册页面发送邮箱验证码
    
    void(*toGetProvince)(CallbackBlock);
    void(*toGetCityWithProvince)(NSString *provinceCode,CallbackBlock);
    
    void (*setMainDomain)(MMMEventType event,NSString *newMainDomain);
}MMMConfigUtil_t;

#define _MMMConfigUtil ([MMMConfigUtil sharedConfigUtil])
@interface MMMConfigUtil : NSObject
+(MMMConfigUtil_t)sharedConfigUtil;

@end
