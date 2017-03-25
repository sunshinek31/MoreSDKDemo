//
//  MMMRequestUtil.h
//  MoreSDK
//
//  Created by sunshinek31 on 15/4/14.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMMRequestUtil : NSObject

+(void)sendRequest:(NSString *)URLString
      withPostData:(NSData *)data
     callbackBlock:(void(^)(NSData *data,NSError *error))callbackBlock;

+(void)sendRequest:(NSString *)URLString
       withPostDic:(NSDictionary *)dic
     callbackBlock:(void (^)(NSData *, NSError *))callbackBlock;
@end
