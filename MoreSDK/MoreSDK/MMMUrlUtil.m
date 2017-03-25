//
//  MMMUrlUtil.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/7/23.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMUrlUtil.h"

static NSString *Register_Domain;
static NSString *Recharge_Domain;
static NSString *Transfer_Domain;
static NSString *Withdraw_Domain;
static NSString *ThreeInOne_Domain;
static NSString *Authorize_Domain;

typedef void (^SetMainDomain)();
static SetMainDomain setmainDomain = ^{
    Register_Domain = @"https://register.moneymoremore.com";
    Authorize_Domain = @"https://www.moneymoremore.com";
    Transfer_Domain = @"https://transfer.moneymoremore.com";
    ThreeInOne_Domain = @"https://www.moneymoremore.com";
    Recharge_Domain = @"https://recharge.moneymoremore.com";
    Withdraw_Domain = @"https://www.moneymoremore.com";
};

static NSString * getMainDomain(MMMEventType event){
    NSString *mainDomain = @"";
    switch (event) {
        case MMMRegisterEvent:
            mainDomain = Register_Domain;
            break;
        case MMMAuthorizationEvent:
            mainDomain = Authorize_Domain;
            break;
        case MMMLoanEvent:
            mainDomain = Recharge_Domain;
            break;
        case MMMThreeInOneEvent:
            mainDomain = ThreeInOne_Domain;
            break;
        case MMMTransferEvent:
            mainDomain = Transfer_Domain;
            break;
        case MMMWithdrawEvent:
            mainDomain = Withdraw_Domain;
        default:
            break;
    }
    return mainDomain;
}

static void setMainDomain(MMMEventType event,NSString *newMainDomain){
    switch (event) {
        case MMMRegisterEvent:
            Register_Domain = newMainDomain;
            break;
        case MMMAuthorizationEvent:
            Authorize_Domain = newMainDomain;
            break;
        case MMMLoanEvent:
            Recharge_Domain = newMainDomain;
            break;
        case MMMThreeInOneEvent:
            ThreeInOne_Domain = newMainDomain;
            break;
        case MMMTransferEvent:
            Transfer_Domain = newMainDomain;
            break;
        case MMMWithdrawEvent:
            Withdraw_Domain = newMainDomain;
        default:
            break;
    }
}

static NSString * getServiceURL(MMMEventType event){
    static NSString *mainDomain = @"";
    switch (event) {
        case MMMRegisterEvent:
            mainDomain = @"/loan/toloanregisterbind.action";
            break;
        case MMMAuthorizationEvent:
            mainDomain = @"/loan/toloanauthorize.action";
            break;
        case MMMLoanEvent:
            mainDomain = @"/loan/toloanrecharge.action";
            break;
        case MMMThreeInOneEvent:
            mainDomain = @"/loan/toloanfastpay.action";
            break;
        case MMMTransferEvent:
            mainDomain = @"/loan/loan.action";
            break;
        case MMMWithdrawEvent:
            mainDomain = @"/loan/toloanwithdraws.action";
        default:
            break;
    }
    return mainDomain;
}


static MMMUrlUtil_t * util = NULL;
@implementation MMMUrlUtil
+(MMMUrlUtil_t)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = malloc(sizeof(MMMUrlUtil_t));
        util->setMainDomain = setMainDomain;
        util->getMainDomain = getMainDomain;
        util->getServiceURL = getServiceURL;
        
        setmainDomain();
        
    });
    return *util;
}
@end
