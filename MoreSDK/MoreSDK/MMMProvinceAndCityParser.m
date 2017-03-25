//
//  MMMProvinceAndCityParser.m
//  MoreSDK
//
//  Created by immortal on 15/7/22.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMProvinceAndCityParser.h"

@implementation MMMProvinceAndCityParser

+ (NSArray *)ProvinceCityParser:(NSData *)data{

   // NSMutableDictionary *dic = [NSMutableDictionary dictionary];
   // NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//    if ([obj isKindOfClass:[NSArray class]]) {
//        
//        for (NSArray *arr in obj) {
//            NSString *value = [arr[1] stringValue];
//            dic[arr[0]] = value;
//        }
//    }
    return obj;
}
@end
