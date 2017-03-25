//
//  MMMConfigUtil.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMConfigUtil.h"
#import "MMMRequestUtil.h"
#import "MMMUrlUtil.h"

//#define MDD_Test_Host_Domain @"http://218.4.234.150:8089/main"
#define MDD_Test_Host_Domain @"http://218.4.234.150:88/main"
#define MDD_Host_Domain @"https://www.moneymoremore.com"

static NSString *SERVICEURL = MDD_Host_Domain;
static BOOL isEnableTestURL = NO;

/////////////////////
static void enableTestServiceURL(BOOL isEnable) {
    isEnableTestURL = isEnable;
    
    if (isEnable) {
        SERVICEURL = MDD_Test_Host_Domain;
    }else{
        SERVICEURL = MDD_Host_Domain;
    }
    
}

static void setMainDomain(MMMEventType event,NSString *newMainDomain){
    [MMMUrlUtil share].setMainDomain(event, newMainDomain);
}

static void beginService(MMMEventType event, NSString *paramsString,NSString *signString, CallbackBlock block) {
    NSString *URL;
    
    NSString *host = isEnableTestURL ?  MDD_Test_Host_Domain : [MMMUrlUtil share].getMainDomain(event) ;
    NSString *requestURL = [MMMUrlUtil share].getServiceURL(event);
    
    URL = [NSString stringWithFormat:@"%@%@",host,requestURL];
    
    NSString *finalStr = [NSString stringWithFormat:@"%@&SignInfo=%@",paramsString,signString];
//    NSLog(@"===============\n%@\nURL=%@",finalStr,URL);
    NSData *postData = [finalStr dataUsingEncoding:NSUTF8StringEncoding];
    [MMMRequestUtil sendRequest:URL withPostData:postData callbackBlock:block];
    
}

static void beginServiceWithDic(MMMEventType event, NSDictionary *paramsDic,NSString *signString, CallbackBlock block) {
    NSString *URL;
    
    NSString *host = isEnableTestURL ?  MDD_Test_Host_Domain : [MMMUrlUtil share].getMainDomain(event) ;
    NSString *requestURL = [MMMUrlUtil share].getServiceURL(event);
    
    URL = [NSString stringWithFormat:@"%@%@",host,requestURL];
    NSLog(@"%@",URL);
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:paramsDic];
    [newDict setObject:signString forKey:@"SignInfo"];
    [MMMRequestUtil sendRequest:URL withPostDic:newDict callbackBlock:block];
}

#pragma mark - 注册

static void toSendMessage(NSString *paramsString, CallbackBlock block) {
    
    NSString *host = isEnableTestURL ?  MDD_Test_Host_Domain : [MMMUrlUtil share].getMainDomain(MMMRegisterEvent) ;
    NSString *URL = [NSString stringWithFormat:@"%@%@",host,@"/loan/egister/sendMessage.action"];
    
    NSString *finalStr = [NSString stringWithFormat:@"%@",paramsString];
    NSData *postData = [finalStr dataUsingEncoding:NSUTF8StringEncoding];
    [MMMRequestUtil sendRequest:URL withPostData:postData callbackBlock:block];
}

static void toCheckCode(NSString *paramsString, CallbackBlock block){
    
    NSString *host = isEnableTestURL ?  MDD_Test_Host_Domain : [MMMUrlUtil share].getMainDomain(MMMRegisterEvent) ;
    NSString *URL = [NSString stringWithFormat:@"%@%@",host,@"/merchant/checkCode.jsp"];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
    
    block(imageData,nil);
    
//    NSString *URL = [NSString stringWithFormat:@"%@%@",SERVICEURL,@"/merchant/checkCode.jsp"];
//    NSString *finalStr = [NSString stringWithFormat:@"%@",paramsString];
//    NSData *postData = [finalStr dataUsingEncoding:NSUTF8StringEncoding];
//    [MMMRequestUtil sendRequest:URL withPostData:postData callbackBlock:block];
}

//  注册
static void toRegisterBind(NSString *paramsString, CallbackBlock block) {
    
    NSString *host = isEnableTestURL ?  MDD_Test_Host_Domain : [MMMUrlUtil share].getMainDomain(MMMRegisterEvent) ;
    NSString *URL = [NSString stringWithFormat:@"%@%@",host,@"/loan/loanregisterbind.action"];
    
    NSString *finalStr = [NSString stringWithFormat:@"%@",paramsString];
    NSData *postData = [finalStr dataUsingEncoding:NSUTF8StringEncoding];
    [MMMRequestUtil sendRequest:URL withPostData:postData callbackBlock:block];
}

//  重新绑定
static void toLoanBind(NSString *paramsString, CallbackBlock block) {
    
    NSString *host = isEnableTestURL ?  MDD_Test_Host_Domain : [MMMUrlUtil share].getMainDomain(MMMRegisterEvent) ;
    NSString *URL = [NSString stringWithFormat:@"%@%@",host,@"/loan/loanbind.action"];
    
    NSString *finalStr = [NSString stringWithFormat:@"%@",paramsString];
    NSData *postData = [finalStr dataUsingEncoding:NSUTF8StringEncoding];
    [MMMRequestUtil sendRequest:URL withPostData:postData callbackBlock:block];
}

// 平台采集
static void toRegisterExtraBind(NSString *paramsString, CallbackBlock block){
    
    
    NSString *host = isEnableTestURL ?  MDD_Test_Host_Domain : [MMMUrlUtil share].getMainDomain(MMMRegisterEvent) ;
    NSString *URL = [NSString stringWithFormat:@"%@%@",host,[MMMUrlUtil share].getServiceURL(MMMRegisterEvent)];
    
    NSString *finalStr = [NSString stringWithFormat:@"%@",paramsString];
    NSData *postData = [finalStr dataUsingEncoding:NSUTF8StringEncoding];
    [MMMRequestUtil sendRequest:URL withPostData:postData callbackBlock:block];
}

#pragma mark - 充值

//  可用银行列表接口
static NSString* getBanklistByType() {
    
    NSString *host = isEnableTestURL ?  MDD_Test_Host_Domain : [MMMUrlUtil share].getMainDomain(MMMLoanEvent) ;
    NSString *URL = [NSString stringWithFormat:@"%@%@",host,@"/loan/loangetbanklistbytype.action"];
    
    return URL;
}

//  充值模块 发送短信验证码
static void toSendDKPhoneCode(NSString *paramsString, CallbackBlock block) {
    
    NSString *host = isEnableTestURL ?  MDD_Test_Host_Domain : [MMMUrlUtil share].getMainDomain(MMMLoanEvent) ;
    NSString *URL = [NSString stringWithFormat:@"%@%@",host,@"/loan/sendDKPhoneCode.action"];
    
    NSString *finalStr = [NSString stringWithFormat:@"%@",paramsString];
    NSData *postData = [finalStr dataUsingEncoding:NSUTF8StringEncoding];
    [MMMRequestUtil sendRequest:URL withPostData:postData callbackBlock:block];
}

static void toSendDKPhoneCodeFor3in1(NSString *paramsString, CallbackBlock block) {
    
    NSString *host = isEnableTestURL ?  MDD_Test_Host_Domain : [MMMUrlUtil share].getMainDomain(MMMThreeInOneEvent) ;
    NSString *URL = [NSString stringWithFormat:@"%@%@",host,@"/loan/sendDKPhoneCode.action"];
    
    NSString *finalStr = [NSString stringWithFormat:@"%@",paramsString];
    NSData *postData = [finalStr dataUsingEncoding:NSUTF8StringEncoding];
    [MMMRequestUtil sendRequest:URL withPostData:postData callbackBlock:block];
}

//  充值
static void toRechargeFastPay(NSString *paramsString, CallbackBlock block){
    
    NSString *host = isEnableTestURL ?  MDD_Test_Host_Domain : [MMMUrlUtil share].getMainDomain(MMMLoanEvent) ;
    NSString *URL = [NSString stringWithFormat:@"%@%@",host,@"/loan/loanrechargefastpay.action"];
    
    NSString *finalStr = [NSString stringWithFormat:@"%@",paramsString];
    NSData *postData = [finalStr dataUsingEncoding:NSUTF8StringEncoding];
    [MMMRequestUtil sendRequest:URL withPostData:postData callbackBlock:block];
}

static void toRechargeFastPayWithDic(NSDictionary *params, CallbackBlock block){
    
    NSString *host = isEnableTestURL ?  MDD_Test_Host_Domain : [MMMUrlUtil share].getMainDomain(MMMLoanEvent) ;
    NSString *URL = [NSString stringWithFormat:@"%@%@",host,@"/loan/loanrechargefastpay.action"];
    
    [MMMRequestUtil sendRequest:URL withPostDic:params callbackBlock:block];
}

#pragma mark - 提现

// 提现
static void toLoanWithdraws(NSString *paramsString, CallbackBlock block) {
    
    NSString *host = isEnableTestURL ?  MDD_Test_Host_Domain : [MMMUrlUtil share].getMainDomain(MMMWithdrawEvent) ;
    NSString *URL = [NSString stringWithFormat:@"%@%@",host,@"/loan/loanwithdraws.action"];
    
    NSString *finalStr = [NSString stringWithFormat:@"%@",paramsString];
    NSData *postData = [finalStr dataUsingEncoding:NSUTF8StringEncoding];
    [MMMRequestUtil sendRequest:URL withPostData:postData callbackBlock:block];
}

#pragma mark - 转账

//  转账
static void toLoanact(NSString *paramsString, CallbackBlock block) {
    
    NSString *host = isEnableTestURL ?  MDD_Test_Host_Domain : [MMMUrlUtil share].getMainDomain(MMMTransferEvent) ;
    NSString *URL = [NSString stringWithFormat:@"%@%@",host,@"/loan/loanact.action"];
    
    NSString *finalStr = [NSString stringWithFormat:@"%@",paramsString];
    NSData *postData = [finalStr dataUsingEncoding:NSUTF8StringEncoding];
    [MMMRequestUtil sendRequest:URL withPostData:postData callbackBlock:block];
}

#pragma mark - 授权

// 授权
static void toAuthorize(NSString *paramsString, CallbackBlock block) {
    
    NSString *host = isEnableTestURL ?  MDD_Test_Host_Domain : [MMMUrlUtil share].getMainDomain(MMMAuthorizationEvent) ;
    NSString *URL = [NSString stringWithFormat:@"%@%@",host,@"/loan/loanauthorize.action"];
    
    NSString *finalStr = [NSString stringWithFormat:@"%@",paramsString];
    NSData *postData = [finalStr dataUsingEncoding:NSUTF8StringEncoding];
    [MMMRequestUtil sendRequest:URL withPostData:postData callbackBlock:block];
}

#pragma mark - 3in1

//三合一
static void toLoanfastpay(NSString *paramsString,CallbackBlock block){
    
    NSString *host = isEnableTestURL ?  MDD_Test_Host_Domain : [MMMUrlUtil share].getMainDomain(MMMThreeInOneEvent) ;
    NSString *URL = [NSString stringWithFormat:@"%@%@",host,@"/loan/loanfastpay.action"];
    
    NSString *finalStr = [NSString stringWithFormat:@"%@",paramsString];
    NSData *postData = [finalStr dataUsingEncoding:NSUTF8StringEncoding];
    [MMMRequestUtil sendRequest:URL withPostData:postData callbackBlock:block];

}

//获得市代码
static void toGetCityWithProvince(NSString *paramsString,CallbackBlock block){
    
    NSString *host = isEnableTestURL ?  MDD_Test_Host_Domain : [MMMUrlUtil share].getMainDomain(MMMThreeInOneEvent) ;
    NSString *URL = [NSString stringWithFormat:@"%@%@",host,@"/register/cityInfo.action"];
    
    NSString *finalStr = [NSString stringWithFormat:@"%@",paramsString];
    NSData *postData = [finalStr dataUsingEncoding:NSUTF8StringEncoding];
    [MMMRequestUtil sendRequest:URL withPostData:postData callbackBlock:block];
}
//获得省代码
static void toGetProvince(CallbackBlock block){
    NSString *host = isEnableTestURL ?  MDD_Test_Host_Domain : [MMMUrlUtil share].getMainDomain(MMMThreeInOneEvent) ;
    NSString *URL = [NSString stringWithFormat:@"%@%@",host,@"/register/provinceInfo.action"];
    
    [MMMRequestUtil sendRequest:URL withPostData:nil callbackBlock:block];
}

static NSString* setPostString(NSDictionary *dic) {
    NSMutableString *string = [NSMutableString stringWithString:@""];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString *obj, BOOL *stop) {
        NSString *str = @"";
        str = [NSString stringWithFormat:@"%@=%@",key,obj];
        [arr addObject:str];
    }];
    
    NSUInteger count = [arr count];
    for (int i = 0; i<count; i++) {
        if (i == 0) {
            [string appendString:arr[i]];
        }else{
            [string appendString:[NSString stringWithFormat:@"&%@",arr[i]]];
        }
    }
    
//    NSLog(@"%@",string);
    return string;
}


static MMMConfigUtil_t * util = NULL;

@implementation MMMConfigUtil

+(MMMConfigUtil_t)sharedConfigUtil{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = malloc(sizeof(MMMConfigUtil_t));
        util->setPostString = setPostString;
        util->getBanklistByType = getBanklistByType;
//        util->setServiceURL = setServiceURL;
        util->enableTestServiceURL = enableTestServiceURL;
        util->beginService = beginService;
        util->beginServiceWithDict = beginServiceWithDic;
        
        util->toLoanfastpay = toLoanfastpay;
        util->toRegisterBind = toRegisterBind;
        util->toLoanBind = toLoanBind;
        util->toRegisterExtraBind = toRegisterExtraBind;
        util->toRechargeFastPay = toRechargeFastPay;
        util->toRechargeFastPayWithDic = toRechargeFastPayWithDic;
        
        util->toLoanWithdraws = toLoanWithdraws;
        util->toAuthorize = toAuthorize;
        util->toLoanact = toLoanact;
        util->toSendDKPhoneCode = toSendDKPhoneCode;
        util->toSendDKPhoneCodeFor3in1 = toSendDKPhoneCodeFor3in1;
        util->toSendMessage = toSendMessage;
        util->toCheckCode = toCheckCode;
        
        util->toGetProvince = toGetProvince;
        util->toGetCityWithProvince = toGetCityWithProvince;
        
        util->setMainDomain = setMainDomain;
    });
    return *util;
}
@end
