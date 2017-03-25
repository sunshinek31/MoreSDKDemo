//
//  MMMBankUtil.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/23.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMBankUtil.h"
#import "MMMBankObject.h"

@implementation MMMBankUtil

-(NSArray *)parseBankListString:(NSString *)bankListString {
    
    if (bankListString == nil || [bankListString isEqualToString:@""]) {
        return [NSArray array];
    }
    
//    NSLog(@"开始解析Banklist");
    NSMutableArray *result = [NSMutableArray array];
    
    NSArray *arr = [bankListString componentsSeparatedByString:@"|"];
    NSDictionary *bankName = @{@"中国银行":@"BOC",     //1
                               @"工商银行":@"ICBC",    //2
                               @"农业银行":@"ABC",     //3
                               @"交通银行":@"BCM",     //4
                               @"广发银行":@"CGB",     //5
                               @"深发银行":@"SDB",     //6 无图
                               @"建设银行":@"CCB",     //7
                               @"上海浦发银行":@"SPDB", //8
                               @"浙江泰隆商业银行":@"TLCB",    //9
                               @"招商银行":@"CMB",     //10
                               @"中国邮政储蓄银行":@"PSBC",    //11
                               @"中国民生银行":@"CMBC",  //12
                               @"兴业银行":@"CIB",     //13
                               @"广东发展银行":@"GDB",      //14
                               @"东莞银行":@"DGB",     //15 无图(缩写可能有误)
                               @"深圳发展银行":@"SDB",   //16 同深发
                               @"中信银行":@"CITIC",   //17
                               @"华夏银行":@"HXB",     //18
                               @"中国光大银行":@"CEB",   //19
                               @"北京银行":@"BCCB",    //20
                               @"上海银行":@"BOS",     //21
                               @"天津银行":@"TCCB",    //22
                               @"大连银行":@"DLCB",    //23
                               @"杭州银行":@"HZB",     //24
                               @"宁波银行":@"NBCB",    //25
                               @"厦门银行":@"XMCB",    //26
                               @"广州银行":@"GZCB",   //27
                               @"平安银行":@"PAB",    //28
                               @"浙商银行":@"CZSB",    //29
                               @"上海农村商业银行":@"SBCB",    //30
                               @"重庆银行":@"CQCB",    //31
                               @"江苏银行":@"JSBC",    //32
                               };

    for (NSString *param in arr) {
        NSArray *bankParams = [param componentsSeparatedByString:@","];
        MMMBankObject *bankObject = [[MMMBankObject alloc]init];
        if (bankParams.count>2) {
            bankObject.BankCode = [bankParams objectAtIndex:2];
        }else
        {   
            bankObject.BankCode = bankName[[bankParams objectAtIndex:1]];
        }
        bankObject.BankName = [bankParams objectAtIndex:1];
        bankObject.BankId = [bankParams objectAtIndex:0];
        [result addObject:bankObject];
    }
    
    return result;
}
@end
