//
//  TimeUtil.m
//  MoreSDKDemo
//
//  Created by sunshinek31 on 15/1/26.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "TimeUtil.h"

@implementation TimeUtil
+(NSString *)getCurrentTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}
@end
